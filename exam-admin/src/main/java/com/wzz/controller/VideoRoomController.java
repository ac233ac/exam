package com.wzz.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import javax.websocket.Session;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

@RestController
public class VideoRoomController {

    @GetMapping("/video/{roomId}/users")
    public List<String> getRoomUsers(@PathVariable String roomId) {
        // 获取房间用户列表
        ConcurrentHashMap<String, ConcurrentHashMap<String, Session>> rooms = VideoWebSocketServer.getRooms();
        ConcurrentHashMap<String, Session> room = rooms.get(roomId);
        if (room != null) {
            return new ArrayList<>(room.keySet()); // 将用户列表返回为 ArrayList<String>
        }
        return new ArrayList<>(); // 如果房间为空，返回空列表
    }
}
