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

  // 使用箭头函数绑定上下文
  this.connection.onmessage = async (message) => {
    const data = JSON.parse(message.data);

    console.log("处理 WebSocket 消息:", data);
    if (data.type === "roomUsers") {
      // 确保 handleRoomUsers 可以被调用
      await this.handleRoomUsers(data.users, data.newJoiner);
    } else if (["offer", "answer", "candidate"].includes(data.type)) {
      await this.handleSignal(data);
    }
  };
}

,


    // 更新远程用户的视频元素
    updateRemoteVideos() {
      const videoContainer = document.querySelector(".video-container");

      // 获取当前房间所需的视频元素 ID 列表
      const requiredVideos = ["localVideo", ...this.roomUsers.map((user) => `video-${user}`)];

      console.log("Current required videos:", requiredVideos);

      // 移除多余的重复视频元素
      Array.from(videoContainer.querySelectorAll(".video-wrapper")).forEach((wrapper) => {
        const videoId = wrapper.querySelector("video").id;
        if (!requiredVideos.includes(videoId)) {
          console.log(`Removing extra video element: ${videoId}`);
          wrapper.remove();
        }
      });

      // 创建缺失的视频元素
      this.roomUsers.forEach((username) => {
        const videoId = `video-${username}`;
        if (!document.getElementById(videoId)) {
          console.log(`Creating video element for user: ${username} with ID: ${videoId}`);

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
        } else {
          console.log(`Video element already exists for user: ${username} with ID: ${videoId}`);
        }
      });

      console.log("Updated video container elements.");
    }
    ,


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
    async handleRoomUsers(users, newJoiner) {
    // 更新房间用户列表，排除当前用户
      const newRoomUsers = users.filter((name) => name !== this.username);

      // 更新用户列表
      this.roomUsers = newRoomUsers;

      // 如果房间中没有其他用户（第一个用户），不发送 offer
      if (this.roomUsers.length === 0) {
        console.log(`${this.username} is the first user in the room. No offer needed.`);
        return;
      }
      // 检查是否需要发送 Offer
      if (this.username !== newJoiner) {
        console.log(`${this.username} is not the new joiner. Skipping offer creation.`);
        return;
      }

      console.log("I am the new joiner, sending offers to existing users.");

      // 仅对已有用户发送 offer
      this.roomUsers.forEach((username) => {
        if (!this.peerConnections[username]) {
          console.log(`Creating connection and sending offer to: ${username}`);
          this.createPeerConnection(username);
          this.createAndSendOffer(username);
        }
      });

      //this.updateRemoteVideos();
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
      const username = data.senderId;

      if (!this.peerConnections[username]) {
        this.createPeerConnection(username);
      }

      const peerConnection = this.peerConnections[username];

      if (data.type === "offer") {
        if (peerConnection.signalingState !== "stable") return;

        await peerConnection.setRemoteDescription(
          new RTCSessionDescription(data.offer)
        );
        const answer = await peerConnection.createAnswer();
        await peerConnection.setLocalDescription(answer);

        this.connection.send(
          JSON.stringify({
            type: "answer",
            answer,
            senderId: this.username,
            targetId: username,
            roomId: this.roomId,
          })
        );
      } else if (data.type === "answer") {
        if (peerConnection.signalingState === "have-local-offer") {
          await peerConnection.setRemoteDescription(
            new RTCSessionDescription(data.answer)
          );
        }
      } else if (data.type === "candidate") {
        if (peerConnection.remoteDescription) {
          await peerConnection.addIceCandidate(data.candidate);
        } else {
          if (!this.pendingCandidates[username]) {
            this.pendingCandidates[username] = [];
          }
          this.pendingCandidates[username].push(data.candidate);
        }
      }
    },
  },
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