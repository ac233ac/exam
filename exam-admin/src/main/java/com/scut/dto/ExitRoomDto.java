package com.scut.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("退出房间请求 DTO")
public class ExitRoomDto {

    @ApiModelProperty(value = "房间 ID", required = true, example = "1")
    private Long roomId;
}
