<template>
    <div class="video-interview-join">
      <h1>加入面试房间</h1>
      <form @submit.prevent="joinRoom">
        <div>
          <label for="roomId">房间号:</label>
          <input
            type="text"
            id="roomId"
            v-model="roomId"
            placeholder="请输入房间号"
            required
          />
        </div>
        <button type="submit" :disabled="loading">加入房间</button>
      </form>
      <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
    </div>
  </template>
  
  
  <script>
  import axios from '@/utils/request';
  
  export default {
    name: 'VideoInterviewJoin',
    data() {
      return {
        roomId: '', // 房间号，绑定输入框
        loading: false, // 加载状态，防止重复提交
        errorMessage: null, // 错误消息
      };
    },
    methods: {
      async joinRoom() {
        if (!this.roomId) {
          this.errorMessage = '请输入房间号';
          return;
        }
  
        try {
          this.loading = true; // 开启加载状态
          this.errorMessage = null; // 清空之前的错误消息
  
          // 调用后端 API 检查并加入房间
          const response = await axios.post('/interview/joinRoom', null, {
            params: { roomId: this.roomId }, // 使用 roomId 作为参数
          });
  
          // 检查响应数据
          if (response.code === 200) {
            this.$message.success('成功加入房间');
            // 跳转到视频面试页面，传递 roomId
            this.$router.push({ name: 'videoInterview', params: { roomId: this.roomId } });
          } else {
            this.errorMessage = response.data.message || '无法加入房间';
            this.$message.error(this.errorMessage);
          }
        } catch (error) {
          console.error('加入房间请求失败:', error);
          this.errorMessage = '网络错误，请稍后重试';
          this.$message.error(this.errorMessage);
        } finally {
          this.loading = false; // 关闭加载状态
        }
      },
    },
  };
  </script>
  
  <style scoped>
.video-interview-join {
  text-align: center;
  margin: 20px;
}

form {
  display: inline-block;
  text-align: left;
  margin-bottom: 20px;
}

form div {
  margin-bottom: 10px;
}

button {
  padding: 10px 20px;
}

.error {
  color: red;
  margin-top: 10px;
}
</style>
