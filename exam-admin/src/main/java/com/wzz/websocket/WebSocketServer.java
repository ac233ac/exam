//package com.wzz.websocket;
//
//
//import com.wzz.config.GetHttpSessionConfig;
//import org.springframework.stereotype.Component;
//import javax.servlet.http.HttpSession;
//import javax.websocket.*;
//import javax.websocket.server.ServerEndpoint;
//import java.io.IOException;
//import java.util.Map;
//import java.util.Set;
//import java.util.concurrent.ConcurrentHashMap;
//
//@Component
//@ServerEndpoint(value = "/video",configurator = GetHttpSessionConfig.class)
//public class WebSocketServer {
//
//    //存储客户端的连接对象,每个客户端连接都会产生一个连接对象
//    private static ConcurrentHashMap<String,WebSocketServer> map = new ConcurrentHashMap();
//    //每个连接都会有自己的会话
//    private Session session;
//    private String account;
//
//    @OnOpen
//    public void open(Session session,EndpointConfig config){
//
//        HttpSession httpSession = (HttpSession) config.getUserProperties().get(HttpSession.class.getName());
//        String account = String.valueOf(httpSession.getAttribute("account"));
//
//        map.put(account,this);
//
//        this.session = session;
//        this.account = account;
//    }
//
//    @OnClose
//    public void close(){
//        map.remove(account);
//    }
//
//    @OnError
//    public void error(Throwable error){
//        error.printStackTrace();
//    }
//
//    @OnMessage
//    public void getMessage(String message) throws IOException {
//
//        Set<Map.Entry<String, WebSocketServer>> entries = map.entrySet();
//        for (Map.Entry<String, WebSocketServer> entry : entries) {
//            if(!entry.getKey().equals(account)){//将消息转发到其他非自身客户端
//                entry.getValue().send(message);
//            }
//        }
//    }
//
//    public void send(String message) throws IOException {
//        if(session.isOpen()){
//            session.getBasicRemote().sendText(message);
//        }
//    }
//
//    public int  getConnetNum(){
//        return map.size();
//    }
//}
//
