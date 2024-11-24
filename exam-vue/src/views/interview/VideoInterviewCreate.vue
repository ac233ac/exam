<template>
  <div class="create-room">
    <h2>创建面试房间</h2>
    <form @submit.prevent="createRoom">
      <div>
        <label for="creatorName">教师名称:</label>
        <el-input
          type="text"
          id="creatorName"
          v-model="creatorName"
          placeholder="请输入昵称"
          clearable
        ></el-input>
      </div>
      <div>
        <label for="roomName">房间名称:</label>
        <el-input
          type="text"
          id="roomName"
          v-model="roomName"
          placeholder="请输入房间名称"
          clearable
        ></el-input>
      </div>
      <el-button type="primary" @click="createRoom">创建房间</el-button>
    </form>
    <div v-if="createdRoomId">
      <el-alert
        title="房间创建成功！"
        type="success"
        :closable="false"
      >
        房间ID: {{ createdRoomId }}
      </el-alert>
    </div>
  </div>
</template>

<script>
import axios from '@/utils/request';

export default {
  name: 'CreateRoom',
  data() {
    return {
      creatorName: '', // 教师ID输入框绑定值
      roomName: '', // 房间名称输入框绑定值
      createdRoomId: null, // 创建成功后的房间ID
    };
  },
  methods: {
    async createRoom() {
      if (!this.creatorName || !this.roomName) {
        this.$message.error('请填写完整的教师名称和房间名称');
        return;
      }

      try {
        const response = await axios.post('/interview/createRoom', null, {
          params: {
            creatorName:this.creatorName,
            roomName: this.roomName,
          },
        });
        if (response.code === 200) {
          this.createdRoomId = response.data; // 保存返回的房间ID
          this.$message.success(`房间创建成功！房间ID: ${this.createdRoomId}`);
          // 跳转到面试房间页面
          this.$router.push({ name: 'videoInterview', params: this.createdRoomId });
        } else {
          this.$message.error(`房间创建失败: ${response.message}`);
        }
      } catch (error) {
        console.error('创建房间请求失败:', error);
        this.$message.error('请求失败，请检查网络或后端服务是否正常');
      }
    },
  },
};
</script>

<style scoped>
.create-room {
  max-width: 400px;
  margin: 50px auto;
  text-align: center;
}
</style>
