package com.wzz.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serializable;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ApiModel("面试房间实体")
@TableName(value = "interview_room")
public class InterviewRoom implements Serializable {

    @TableId(value = "id", type = IdType.INPUT) // 数据库主键为 'id'
    @ApiModelProperty(value = "主键 房间ID", example = "123e4567-e89b-12d3-a456-426614174000")
    private String roomId; // 使用 String 类型存储 UUID

    @ApiModelProperty(value = "房间名称", example = "Java面试房间")
    private String roomName;

    @ApiModelProperty(value = "房间创建者用户名 (一般为教师)", example = "teacher123")
    @TableField("creator_id")
    private Integer creatorId;

    @ApiModelProperty(value = "房间创建者昵称 (一般为教师)", example = "张老师")
    @TableField("creator_name")
    private String creatorName;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @ApiModelProperty(value = "房间创建时间", example = "2024-11-20 10:00:00")
    private Date createTime;

    @ApiModelProperty(value = "房间状态 1: 活跃 2: 解散", example = "1")
    @TableField(value = "status", fill = FieldFill.INSERT)
    private String status;

}
