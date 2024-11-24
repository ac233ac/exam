package com.wzz;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import springfox.documentation.swagger2.annotations.EnableSwagger2;
import com.wzz.config.SpringConfigurator;

@EnableSwagger2
@SpringBootApplication
public class ExamAdminApplication {

    public static void main(String[] args) {
        // 启动 Spring Boot 应用程序并获取 ApplicationContext
        ApplicationContext context = SpringApplication.run(ExamAdminApplication.class, args);

        // 将 ApplicationContext 设置到自定义 SpringConfigurator 中
        SpringConfigurator.setApplicationContext(context);
    }
}
