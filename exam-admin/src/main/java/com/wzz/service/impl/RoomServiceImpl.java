package com.wzz.service.impl;


import com.wzz.service.RoomService;
import org.springframework.stereotype.Service;

import java.util.concurrent.ConcurrentHashMap;
import java.util.Set;

@Service
public class RoomServiceImpl implements RoomService {
    private final ConcurrentHashMap<String, Set<String>> rooms = new ConcurrentHashMap<>();

    @Override
    public void createRoom(String roomId) {
        rooms.putIfAbsent(roomId, ConcurrentHashMap.newKeySet());
    }

    @Override
    public void removeRoom(String roomId) {
        rooms.remove(roomId);
    }

    @Override
    public Set<String> getRooms() {
        return rooms.keySet();
    }
}
