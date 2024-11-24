<template>
  <div class="video-interview">
    <h1>视频面试房间 - {{ roomId }}</h1>
    <div class="video-container">
      <!-- 本地视频 -->
      <div class="video-wrapper">
        <span class="username-label">{{ username }}</span>
        <video id="localVideo" autoplay muted></video>
      </div>
      <!-- 远程用户的视频 -->
      <div v-for="user in roomUsers" :key="user" class="video-wrapper">
        <span class="username-label">{{ user }}</span>
        <video :id="'video-' + user" autoplay></video>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      roomId: this.$route.params.roomId, // 当前房间 ID
      localStream: null, // 本地视频流
      connection: null, // WebSocket 连接
      peerConnections: {}, // 存储与每个用户的 WebRTC 连接
      pendingCandidates: {}, // 缓存 ICE 候选者信息
      roomUsers: [], // 房间用户列表
      remoteVideos: [], // 远程用户的视频 ID 列表
      username: null, // 当前用户的用户名
    };
  },
  methods: {
    // 初始化本地视频流
    async initLocalStream() {
      try {
        this.localStream = await navigator.mediaDevices.getUserMedia({
          video: true,
          audio: true,
        });
        document.getElementById("localVideo").srcObject = this.localStream;
      } catch (error) {
        console.error("Error accessing local media:", error);
      }
    },

    // 初始化 WebSocket 连接
    async initWebSocket() {
      const token = localStorage.getItem("authorization");
      this.connection = new WebSocket(
        `ws://localhost:8888/video/${this.roomId}?token=${token}`
      );

      this.connection.onopen = () => {
        console.log("WebSocket connected");
        this.connection.send(
          JSON.stringify({
            type: "join",
            roomId: this.roomId,
            username: this.username,
          })
        );
      };

      // 处理 WebSocket 消息
      this.connection.onmessage = async (message) => {
        const data = JSON.parse(message.data);

        console.log(" 处理 WebSocket 消息")
        if (data.type === "roomUsers") {
          this.handleRoomUsers(data.users);
        } else if (["offer", "answer", "candidate"].includes(data.type)) {
          await this.handleSignal(data);
        }
      };
    },

    // 处理房间用户列表
    async handleRoomUsers(users) {
      // 更新房间用户列表，排除当前用户
      const newRoomUsers = users.filter((name) => name !== this.username);

      // 如果没有其他用户，则退出
      if (newRoomUsers.length === 0) {
        console.log("I am the first user in the room. No offer needed.");
        return;
      }

      console.log("Current users in the room:", newRoomUsers);

      // 仅对新加入的用户发送 offer
      newRoomUsers.forEach((username) => {
        if (!this.peerConnections[username]) {
          console.log(`Creating connection and sending offer to: ${username}`);
          this.createPeerConnection(username);
          this.createAndSendOffer(username);
        }
      });

      // 更新远程用户列表
      this.roomUsers = newRoomUsers;
      this.updateRemoteVideos();
    },


    // 更新远程用户的视频元素
    updateRemoteVideos() {
      const videoContainer = document.querySelector(".video-container");

      // 获取当前房间需要的视频元素 ID 列表
      const requiredVideos = ["localVideo", ...this.roomUsers.map((user) => `video-${user}`)];

      // 移除多余的重复视频元素
      Array.from(videoContainer.children).forEach((wrapper) => {
        const videoId = wrapper.querySelector("video").id;
        if (!requiredVideos.includes(videoId)) {
          wrapper.remove();
        }
      });

      // 创建缺失的视频元素
      this.roomUsers.forEach((username) => {
        const videoId = `video-${username}`;
        if (!document.getElementById(videoId)) {
          // 创建容器
          const wrapper = document.createElement("div");
          wrapper.classList.add("video-wrapper");

          // 添加用户名标签
          const label = document.createElement("span");
          label.classList.add("username-label");
          label.innerText = username;

          // 创建视频元素
          const videoElement = document.createElement("video");
          videoElement.id = videoId;
          videoElement.autoplay = true;

          wrapper.appendChild(label);
          wrapper.appendChild(videoElement);

          videoContainer.appendChild(wrapper);
        }
      });
    },


    // 创建 WebRTC PeerConnection
    createPeerConnection(username) {
      if (this.peerConnections[username]) return;

      const peerConnection = new RTCPeerConnection({
        iceServers: [{ urls: "stun:stun.l.google.com:19302" }],
      });

      peerConnection.onicecandidate = (event) => {
        if (event.candidate) {
          this.connection.send(
            JSON.stringify({
              type: "candidate",
              candidate: event.candidate,
              senderId: this.username,
              targetId: username,
              roomId: this.roomId,
            })
          );
        }
      };

      peerConnection.ontrack = (event) => {
        const videoElement = document.getElementById(`video-${username}`);
        if (videoElement) videoElement.srcObject = event.streams[0];
      };

      this.localStream.getTracks().forEach((track) =>
        peerConnection.addTrack(track, this.localStream)
      );

      this.peerConnections[username] = peerConnection;
    },

    async createAndSendOffer(username) {
      const peerConnection = this.peerConnections[username];
      const offer = await peerConnection.createOffer();
      await peerConnection.setLocalDescription(offer);

      this.connection.send(
        JSON.stringify({
          type: "offer",
          offer,
          senderId: this.username,
          targetId: username,
          roomId: this.roomId,
        })
      );
    },

    async handleSignal(data) {
      const { senderId, targetId } = data;

      // 如果信令消息不是针对当前用户的，直接忽略
      if (targetId !== this.username) {
        console.log(`Signal from ${senderId} ignored (not for me).`);
        return;
      }

      if (!this.peerConnections[senderId]) {
        this.createPeerConnection(senderId);
      }

      const peerConnection = this.peerConnections[senderId];

      if (data.type === "offer") {
        if (peerConnection.signalingState !== "stable") {
          console.warn(`PeerConnection for ${senderId} is not stable. Ignoring offer.`);
          return;
        }

        await peerConnection.setRemoteDescription(new RTCSessionDescription(data.offer));
        const answer = await peerConnection.createAnswer();
        await peerConnection.setLocalDescription(answer);

        this.connection.send(
          JSON.stringify({
            type: "answer",
            answer,
            senderId: this.username,
            targetId: senderId,
            roomId: this.roomId,
          })
        );

        console.log(`Answer sent to ${senderId}`);
      } else if (data.type === "answer") {
        if (peerConnection.signalingState === "have-local-offer") {
          await peerConnection.setRemoteDescription(new RTCSessionDescription(data.answer));
          console.log(`Answer from ${senderId} applied.`);
        }
      } else if (data.type === "candidate") {
        if (peerConnection.remoteDescription) {
          await peerConnection.addIceCandidate(data.candidate);
          console.log(`ICE candidate from ${senderId} added.`);
        } else {
          console.warn(`ICE candidate received before remote description is set for ${senderId}.`);
        }
      }
    }},


  async mounted() {
    await this.initLocalStream();

    try {
      const response = await axios.get(
        "http://localhost:8888/common/getCurrentUser"
      );
      this.username = response.data.data.username;
      this.initWebSocket();
    } catch (error) {
      console.error("Failed to fetch user info:", error);
    }
  },
};
</script>

<style>
.video-container {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 20px;
}

.video-wrapper {
  position: relative;
  display: inline-block;
}

.username-label {
  position: absolute;
  top: 5px;
  left: 10px;
  background-color: rgba(0, 0, 0, 0.5);
  color: white;
  padding: 2px 5px;
  border-radius: 5px;
  font-size: 14px;
  z-index: 10;
}

video {
  border: 2px solid #ccc;
  border-radius: 10px;
  max-width: 300px;
  max-height: 300px;
  display: block;
}
</style>