package com.scut.config;

import com.scut.utils.JwtUtils;
import com.scut.exception.BusinessException;
import com.scut.exception.CommonErrorCode;
import org.springframework.stereotype.Component;

import javax.websocket.HandshakeResponse;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpointConfig;
import java.util.List;

@Component
public class TokenConfigurator extends ServerEndpointConfig.Configurator {

    @Override
    public void modifyHandshake(ServerEndpointConfig config, HandshakeRequest request, HandshakeResponse response) {
        try {
            // 从 HTTP 请求头中获取 Authorization
            List<String> authHeader = request.getHeaders().get("Authorization");
            if (authHeader == null || authHeader.isEmpty()) {
                throw new BusinessException(CommonErrorCode.UNAUTHORIZED, "Missing Authorization header");
            }

            String token = authHeader.get(0); // 获取 Token
            if (token == null || token.isEmpty()) {
                throw new BusinessException(CommonErrorCode.UNAUTHORIZED, "Empty Authorization token");
            }

            // 解析 Token 获取用户名
            String username = JwtUtils.getUserInfoByToken(token).getUsername();
            if (username == null) {
                throw new BusinessException(CommonErrorCode.UNAUTHORIZED, "Invalid token");
            }

            // 将用户名存入 WebSocket 的 UserProperties
            config.getUserProperties().put("username", username);

        } catch (BusinessException e) {
            throw new RuntimeException("WebSocket handshake failed: " + e.getMessage(), e);
        } catch (Exception e) {
            throw new RuntimeException("Unexpected error during WebSocket handshake", e);
        }
    }
}
