package com.scut.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("管理房间请求 DTO")
public class ManageRoomDto {

    @ApiModelProperty(value = "房间 ID", required = true, example = "1")
    private Long roomId;

    @ApiModelProperty(value = "目标用户 ID (被踢/被禁麦的用户)", required = true, example = "102")
    private Long targetId;

    @ApiModelProperty(value = "管理操作 (kick: 踢人, mute: 禁麦, unmute: 解除禁麦)", required = true, example = "mute")
    private String action;
}
