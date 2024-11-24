package com.wzz.service;



import java.util.Set;

public interface RoomService {
    void createRoom(String roomId);

    void removeRoom(String roomId);

    Set<String> getRooms();
}
