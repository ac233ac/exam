package com.scut.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ApiModel("面试参与者实体")
@TableName(value = "interview_participant")
public class InterviewParticipant implements Serializable {

    @TableId(type = IdType.AUTO)
    @ApiModelProperty(value = "主键 ID", example = "1")
    private Long id;

    @ApiModelProperty(value = "房间ID", example = "1")
    private String roomId;

    @ApiModelProperty(value = "用户ID", example = "202")
    private Integer userId; // 修改为 String，因为之前代码中 userId 是 String 类型

    @ApiModelProperty(value = "用户角色 student: 学生, teacher: 老师", example = "student")
    private Integer role;

    @ApiModelProperty(value = "用户是否被禁麦 true: 禁麦, false: 正常", example = "false")
    private Boolean isMuted; // 保持 Boolean 类型，因为禁麦状态应为布尔值

    @ApiModelProperty(value = "用户是否被禁麦 true: 被踢出, false: 正常", example = "false")
    private Boolean isKicked; // 保持 Boolean 类型，因为禁麦状态应为布尔值

    @ApiModelProperty(value = "加入时间", example = "2024-11-20 10:05:00")
    private Date joinedTime;
}
