package com.wzz.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("解散房间请求 DTO")
public class DismissRoomDto {

    @ApiModelProperty(value = "房间 ID", required = true, example = "1")
    private Long roomId;
}
