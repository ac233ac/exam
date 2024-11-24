package com.wzz.config;
import javax.websocket.server.ServerEndpointConfig;
import org.springframework.stereotype.Component;
import org.springframework.context.ApplicationContext;

@Component
public class SpringConfigurator extends ServerEndpointConfig.Configurator {
    private static ApplicationContext context;

    public static void setApplicationContext(ApplicationContext applicationContext) {
        context = applicationContext;
    }

    @Override
    public <T> T getEndpointInstance(Class<T> clazz) throws InstantiationException {
        return context.getBean(clazz);
    }
}
