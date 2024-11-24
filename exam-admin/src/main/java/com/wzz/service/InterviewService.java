package com.wzz.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wzz.entity.InterviewParticipant;
import com.wzz.entity.InterviewRoom;

import java.util.List;

public interface InterviewService {

    // 创建房间
    String createRoom(String username,String creatorName, String roomName);

    List<InterviewRoom> getAvailableRooms();


    List<InterviewRoom> getRoomsByCreator(String username);

    // 加入房间
    String joinRoom(String roomId, String userId);

    // 退出房间
    String exitRoom(String roomId, String username);

    // 解散房间
    String dismissRoom(String roomId, String username);

    // 获取房间信息
    InterviewRoom getRoomInfo(Long roomId);

    // 获取房间内的参与者列表
    List<InterviewParticipant> getRoomParticipants(Long roomId);

    // 管理房间（踢人、禁麦）
    String manageRoom(Long roomId, String teacherId, String targetId, String action);
}
