package com.wzz.websocket;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wzz.config.SpringConfigurator;
import com.wzz.entity.User;
import com.wzz.exception.BusinessException;
import com.wzz.exception.CommonErrorCode;
import com.wzz.mapper.UserMapper;
import com.wzz.utils.JwtUtils;
import io.swagger.models.auth.In;
import org.json.JSONObject;
import org.springframework.stereotype.Component;

import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

@Component
@ServerEndpoint(value = "/video/{roomId}", configurator = SpringConfigurator.class)
public class VideoWebSocketServer {

    private static final ConcurrentHashMap<String, ConcurrentHashMap<String, Session>> rooms = new ConcurrentHashMap<>();
    private UserMapper userMapper;
    private String roomId; // 当前房间 ID
    private Integer userId; // 当前用户 ID
    private String username; // 当前用户名

    public VideoWebSocketServer(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    @OnOpen
    public void onOpen(Session session, @PathParam("roomId") String roomId) {
        logRoomState();
        this.roomId = roomId;
        System.out.println("WebSocket connected to room: " + roomId);

        try {
            // 验证用户
            String token = session.getRequestParameterMap().get("token").get(0);
            this.username = JwtUtils.getUserInfoByToken(token).getUsername();
            User user = Optional.ofNullable(userMapper.selectOne(new QueryWrapper<User>().eq("username", username)))
                    .orElseThrow(() -> new BusinessException(CommonErrorCode.E_100102));
            this.userId = user.getId();

            // 将用户加入房间
            rooms.computeIfAbsent(roomId, k -> new ConcurrentHashMap<>()).put(username, session);
            System.out.println("User " + username + " (ID: " + userId + ") joined room " + roomId);

            // 检查房间用户列表是否更新正确
            List<String> currentUsers = new ArrayList<>(rooms.get(roomId).keySet());
            System.out.println("Current users in room " + roomId + ": " + currentUsers);

            // 广播更新房间用户列表
            broadcastRoomUsers(roomId);
        } catch (Exception e) {
            System.err.println("Error during WebSocket connection establishment: " + e.getMessage());
            e.printStackTrace();
            try {
                session.close();
            } catch (Exception closeException) {
                System.err.println("Failed to close WebSocket session: " + closeException.getMessage());
            }
        }
    }


    @OnMessage
    public void onMessage(String message, Session session) {
        logRoomState();
        try {
            JSONObject json = new JSONObject(message);
            String type = json.getString("type");
            System.out.println("Received WebSocket message: " + message);

            switch (type) {
                case "join":
                   // handleJoinMessage(json, session);
                    break;
                case "offer":
                case "answer":
                case "candidate":
                    forwardSignal(json);
                    break;
                default:
                    System.out.println("Unsupported message type: " + type);
            }
        } catch (Exception e) {
            System.err.println("Error processing message: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session) {
        logRoomState();
        try {
            if (rooms.containsKey(roomId)) {
                rooms.get(roomId).remove(username);
                if (rooms.get(roomId).isEmpty()) {
                    rooms.remove(roomId);
                    System.out.println("Room " + roomId + " is now empty and has been removed.");
                } else {
                    // 广播更新房间用户列表
                    broadcastRoomUsers(roomId);
                }
            }

            System.out.println("User " + username + " left room " + roomId);
        } catch (Exception e) {
            System.err.println("Error during WebSocket close: " + e.getMessage());
            e.printStackTrace();
        }
    }


    @OnError
    public void onError(Session session, Throwable error) {
        logRoomState();
        System.err.println("Error in WebSocket session: " + error.getMessage());
        error.printStackTrace();
    }

    /**
     * 广播房间内的用户列表
     */
    private void broadcastRoomUsers(String roomId) {
        logRoomState();
        ConcurrentHashMap<String, Session> room = rooms.get(roomId);
        if (room == null || room.isEmpty()) {
            System.out.println("Room " + roomId + " is empty, no users to broadcast.");
            return;
        }

        List<String> usernames = new ArrayList<>(room.keySet());
        System.out.println("Broadcasting users in room " + roomId + ": " + usernames);

        String message = String.format("{\"type\":\"roomUsers\", \"users\":%s}", new org.json.JSONArray(usernames).toString());

        room.values().forEach(session -> {
            try {
                session.getBasicRemote().sendText(message);
            } catch (Exception e) {
                System.err.println("Error broadcasting to session: " + e.getMessage());
                e.printStackTrace();
            }
        });
    }



    /**
     * 转发 WebRTC 信令消息
     */
    private void forwardSignal(JSONObject json) {
        String roomId = json.getString("roomId");
        String targetUsername = json.getString("targetId"); // 获取目标用户名

        // 从房间中获取目标用户的会话
        ConcurrentHashMap<String, Session> room = rooms.get(roomId);
        if (room != null) {
            Session targetSession = room.get(targetUsername);
            if (targetSession != null) {
                try {
                    targetSession.getBasicRemote().sendText(json.toString());
                } catch (Exception e) {
                    System.err.println("Error forwarding signal to user " + targetUsername + ": " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
                System.out.println("Target session not found for username: " + targetUsername);
            }
        } else {
            System.out.println("Room not found: " + roomId);
        }
    }

    private void logRoomState() {
        System.out.println("Current room states:");
        rooms.forEach((roomId, users) -> {
            System.out.println("Room " + roomId + ": " + users.keySet());
        });
    }


    /**
     * 处理 "join" 消息
     */
    private void handleJoinMessage(JSONObject json, Session session) {
        try {
            String roomId = json.getString("roomId");
            String token = session.getRequestParameterMap().get("token").get(0);
            this.username = JwtUtils.getUserInfoByToken(token).getUsername();
            User user = Optional.ofNullable(userMapper.selectOne(new QueryWrapper<User>().eq("username", username)))
                    .orElseThrow(() -> new BusinessException(CommonErrorCode.E_100102));
            this.userId = user.getId();

            rooms.computeIfAbsent(roomId, k -> new ConcurrentHashMap<>()).put(username, session);

            System.out.println("User " + userId + " joined room " + roomId);

            broadcastRoomUsers(roomId);
        } catch (Exception e) {
            System.err.println("Error handling join message: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
