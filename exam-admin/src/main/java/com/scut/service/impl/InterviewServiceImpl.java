package com.scut.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.scut.entity.InterviewParticipant;
import com.scut.entity.InterviewRoom;
import com.scut.entity.User;
import com.scut.exception.BusinessException;
import com.scut.exception.CommonErrorCode;
import com.scut.mapper.InterviewParticipantMapper;
import com.scut.mapper.InterviewRoomMapper;
import com.scut.mapper.UserMapper;
import com.scut.service.InterviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class InterviewServiceImpl implements InterviewService {

    private final InterviewRoomMapper interviewRoomMapper;
    private final InterviewParticipantMapper interviewParticipantMapper;
    private final UserMapper userMapper;


    // 创建房间
    @Override
    public String createRoom(String username, String creatorName, String roomName) {
        User user = Optional.ofNullable(userMapper.selectOne(new QueryWrapper<User>().eq("username", username))).orElseThrow(() -> new BusinessException(CommonErrorCode.E_100102));
        InterviewRoom room = new InterviewRoom();
        room.setRoomId(UUID.randomUUID().toString()); // 设置随机 UUID
        room.setCreatorId(user.getId()); // 从 token 或参数获取
        room.setCreatorName(creatorName);
        room.setRoomName(roomName);
        room.setCreateTime(new Date());
        room.setStatus("active"); // 默认活跃状态
        interviewRoomMapper.insert(room);
        return room.getRoomId(); // 返回房间 ID
    }

    //获取自己创建的房间列表
    @Override
    public List<InterviewRoom> getAvailableRooms() {
        return interviewRoomMapper.selectList(new QueryWrapper<InterviewRoom>().eq("status", 1));
    }
    //获取自己创建的房间列表
    @Override
    public List<InterviewRoom> getRoomsByCreator(String username) {
        User user = Optional.ofNullable(userMapper.selectOne(new QueryWrapper<User>().eq("username", username))).orElseThrow(() -> new BusinessException(CommonErrorCode.E_100102));
        return interviewRoomMapper.selectList(new QueryWrapper<InterviewRoom>().eq("creator_id", user.getId()));
    }

    @Override
    public String joinRoom(String roomId, String username) {
        // 获取用户信息
        User user = Optional.ofNullable(userMapper.selectOne(new QueryWrapper<User>().eq("username", username)))
                .orElseThrow(() -> new BusinessException(CommonErrorCode.E_100102));

        // 检查是否已有记录
        int existingParticipant = interviewParticipantMapper.selectCount(new QueryWrapper<InterviewParticipant>()
                .eq("room_id", roomId)
                .eq("user_id", user.getId()));

        if (existingParticipant > 0) {
            return "用户已在房间中";
        }
        // 检查房间是否存在
        InterviewRoom room = interviewRoomMapper.selectById(roomId);
        if (room == null) {
            throw new BusinessException("房间不存在");
        }

        // 检查房间是否是活跃状态
        if (!"active".equalsIgnoreCase(room.getStatus())) {
            throw new BusinessException("房间已关闭，无法加入");
        }

        // 添加参与者
        InterviewParticipant participant = new InterviewParticipant();
        participant.setRoomId(roomId);
        participant.setUserId(user.getId());
        participant.setRole(user.getRoleId());
        participant.setIsMuted(false);
        participant.setIsKicked(false);
        participant.setJoinedTime(new Date());

        interviewParticipantMapper.insert(participant);

        return "成功加入房间";
    }
    // 退出房间
    @Override
    public String exitRoom(String roomId, String username) {
        User user = Optional.ofNullable(userMapper.selectOne(new QueryWrapper<User>().eq("username", username))).orElseThrow(() -> new BusinessException(CommonErrorCode.E_100102));

        int deleted = interviewParticipantMapper.delete(new QueryWrapper<InterviewParticipant>()
                .eq("room_id", roomId)
                .eq("user_id", user.getId()));
        if (deleted == 0) {
            throw new BusinessException("退出失败，用户不在房间中");
        }
        return "成功退出房间";
    }

    // 解散房间
    @Override
    public String dismissRoom(String roomId, String username) {
        User user = Optional.ofNullable(userMapper.selectOne(new QueryWrapper<User>().eq("username", username))).orElseThrow(() -> new BusinessException(CommonErrorCode.E_100102));

        InterviewRoom room = interviewRoomMapper.selectById(roomId);
        if (room == null || !room.getCreatorId().equals(user.getId())) {
            throw new BusinessException("无权限解散房间或房间不存在");
        }
        // 删除房间及其参与者
        interviewParticipantMapper.delete(new QueryWrapper<InterviewParticipant>().eq("room_id", roomId));
        room.setStatus("closed");
        interviewRoomMapper.updateById(room);
        return "成功解散房间";
    }

    // 获取房间信息
    @Override
    public InterviewRoom getRoomInfo(Long roomId) {
        InterviewRoom room = interviewRoomMapper.selectById(roomId);
        if (room == null) {
            throw new BusinessException("房间不存在");
        }
        return room;
    }

    // 获取房间内的参与者列表
    @Override
    public List<InterviewParticipant> getRoomParticipants(Long roomId) {
        return interviewParticipantMapper.selectList(new QueryWrapper<InterviewParticipant>().eq("room_id", roomId));
    }

    // 管理房间（踢人、禁麦）
    @Override
    public String manageRoom(Long roomId, String teacherId, String targetId, String action) {
        // 检查房间是否存在并验证权限
        InterviewRoom room = interviewRoomMapper.selectById(roomId);
        if (room == null || !room.getCreatorId().equals(teacherId)) {
            throw new BusinessException("无权限操作房间或房间不存在");
        }

        // 查找目标参与者
        InterviewParticipant participant = interviewParticipantMapper.selectOne(new QueryWrapper<InterviewParticipant>()
                .eq("room_id", roomId)
                .eq("user_id", targetId));
        if (participant == null) {
            throw new BusinessException("目标用户不在房间中");
        }

        // 根据动作执行操作
        if ("mute".equalsIgnoreCase(action)) {
            participant.setIsMuted(true);
            interviewParticipantMapper.updateById(participant);
            return "用户已被禁麦";
        } else if ("kick".equalsIgnoreCase(action)) {
            interviewParticipantMapper.deleteById(participant.getId());
            return "用户已被踢出房间";
        } else {
            throw new BusinessException("无效的操作");
        }
    }
}
