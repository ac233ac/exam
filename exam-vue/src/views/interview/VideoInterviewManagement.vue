<template>
  <div class="video-interview-management">
    <!-- 添加顶部工具栏 -->
    <div class="toolbar">
      <h1>我的视频面试房间</h1>
      <el-button type="primary" @click="goToCreateRoom">创建房间</el-button>
    </div>
    <el-table :data="rooms" border style="width: 100%">
      <!-- 房间号 -->
      <el-table-column prop="roomId" label="房间号" width="200"></el-table-column>

      <!-- 房间名称 -->
      <el-table-column prop="roomName" label="房间名称"></el-table-column>

      <!-- 状态 -->
      <el-table-column prop="status" label="状态">
        <template slot-scope="scope">
          <span :class="{ active: scope.row.status === 'active', closed: scope.row.status === 'closed' }">
            {{ scope.row.status === 'active' ? '活跃' : '已关闭' }}
          </span>
        </template>
      </el-table-column>

      <!-- 创建时间 -->
      <el-table-column prop="createTime" label="创建时间"></el-table-column>

      <el-table-column label="操作">
        <template slot-scope="scope">
          <!-- 加入按钮 -->
          <el-button
            type="primary"
            size="mini"
            :disabled="scope.row.status === 'closed'"
            @click="joinRoom(scope.row.roomId)"
          >
            加入
          </el-button>

          <!-- 解散按钮 -->
          <el-button
            type="danger"
            size="mini"
            :disabled="scope.row.status === 'closed'"
            @click="dissolveRoom(scope.row.roomId)"
          >
            解散
          </el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
import axios from '@/utils/request';

export default {
  name: 'InterviewList',
  data() {
    return {
      rooms: [], // 用户自己创建的房间列表
    };
  },
  methods: {
    fetchMyRooms() {
      axios
        .get('/interview/myRooms') // 获取自己创建的房间
        .then((response) => {
          if (response.code === 200) {
            this.rooms = response.data; // 设置房间列表数据
          } else {
            this.$message.error(`获取房间列表失败: ${response.message}`);
          }
        })
        .catch((error) => {
          console.error('获取房间列表失败:', error);
          this.$message.error('获取房间列表失败，请检查网络');
        });
    },
    async joinRoom(roomId) {
  try {
    // 调用后端 API 检查并加入房间
    const response = await axios.post('/interview/joinRoom', null, {
      params: { roomId }, // 使用 params 传递 roomId
    });

    // 检查响应数据
    if (response.code === 200) {
      this.$message.success('成功加入房间');
      // 跳转到视频面试页面，传递 roomId
      this.$router.push({ name: 'videoInterview', params: { roomId } });
    } else {
      this.$message.error(response.data.message || '无法加入房间');
    }
  } catch (error) {
    console.error('加入房间请求失败:', error);
    this.$message.error('网络错误，请稍后重试');
  }
},

    goToCreateRoom() {
      // 跳转到创建房间页面
      this.$router.push({ name: 'videoInterviewCreate' });
    },
    dissolveRoom(roomId) {
      axios
      .post('/interview/dismissRoom', null, { // 注意第二个参数可以为空
          params: { roomId }, // 使用 params 来发送 `roomId`
        })
      .then((response) => {
        if (response.code === 200) {
          this.$message.success('房间解散成功');
          // 更新对应房间的状态为 closed
          const room = this.rooms.find((r) => r.roomId === roomId);
          if (room) {
            room.status = 'closed'; // 将状态更新为 closed
          }
        } else {
          this.$message.error(`解散房间失败: ${response.message}`);
        }
      })
      .catch((error) => {
        console.error('解散房间失败:', error);
        this.$message.error('解散房间失败，请检查网络');
      });
    },
  },
  mounted() {
    this.fetchMyRooms(); // 页面加载时获取自己的房间列表
  },
};
</script>

<style scoped>
.video-interview-management {
  margin: 20px;
}

.active {
  color: green;
}

.closed {
  color: gray;
}
</style>
