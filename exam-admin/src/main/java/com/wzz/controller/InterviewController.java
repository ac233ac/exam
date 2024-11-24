package com.wzz.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wzz.dto.JoinRoomDto;
import com.wzz.dto.ManageRoomDto;
import com.wzz.entity.InterviewParticipant;
import com.wzz.entity.InterviewRoom;

import com.wzz.service.InterviewService;
import com.wzz.utils.JwtUtils;
import com.wzz.vo.CommonResult;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 面试相关接口
 * @author wzz
 */
@RestController
@RequiredArgsConstructor
@Api(tags = "面试相关接口")
@RequestMapping("/interview")
public class InterviewController {

    private final InterviewService interviewService;

    @ApiOperation("老师创建面试房间")
    @PostMapping("/createRoom")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "creatorName", value = "教师昵称", required = true, dataType = "String", paramType = "query"),
            @ApiImplicitParam(name = "roomName", value = "房间名称", required = true, dataType = "String", paramType = "query")
    })
    public CommonResult<String > createRoom(HttpServletRequest request,
                                         @RequestParam String creatorName,
                                         @RequestParam String roomName) {
        // 从 Token 获取用户信息
        String username = JwtUtils.getUserInfoByToken(request).getUsername();

        // 调用服务层创建房间
        String roomId = interviewService.createRoom(username, creatorName, roomName);

        return CommonResult.<String >builder()
                .data(roomId)
                .message("房间创建成功")
                .build();
    }


    @ApiOperation("学生和老师加入面试房间")
    @PostMapping("/joinRoom")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "roomId", value = "房间ID", required = true, dataType = "String", paramType = "query"),
    })
    public CommonResult<String> joinRoom(HttpServletRequest request,
                                         @RequestParam String roomId) {
        // 从 Token 获取用户信息
        String username = JwtUtils.getUserInfoByToken(request).getUsername();
        String result = interviewService.joinRoom(roomId, username);
        return CommonResult.<String>builder()
                .data(result)
                .build();
    }

    @ApiOperation("学生和老师退出面试房间")
    @PostMapping("/exitRoom")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "roomId", value = "房间ID", required = true, dataType = "String", paramType = "query")
    })
    public CommonResult<String> exitRoom(HttpServletRequest request, @RequestParam String roomId) {
        // 从 Token 获取用户信息
        String username = JwtUtils.getUserInfoByToken(request).getUsername();
        String result = interviewService.exitRoom(roomId, username);
        return CommonResult.<String>builder()
                .data(result)
                .build();
    }

    @ApiOperation("老师解散面试房间")
    @PostMapping("/dismissRoom")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "roomId", value = "房间ID", required = true, dataType = "String", paramType = "query")
    })
    public CommonResult<String> dismissRoom(HttpServletRequest request, @RequestParam String roomId) {
        // 从 Token 获取用户信息
        String username = JwtUtils.getUserInfoByToken(request).getUsername();
        String result = interviewService.dismissRoom(roomId, username);
        return CommonResult.<String>builder()
                .data(result)
                .build();
    }

    @ApiOperation("获取面试房间信息")
    @GetMapping("/getRoomInfo/{roomId}")
    @ApiImplicitParam(name = "roomId", value = "房间ID", required = true, dataType = "String", paramType = "path")
    public CommonResult<InterviewRoom> getRoomInfo(@PathVariable Long roomId) {
        InterviewRoom roomInfo = interviewService.getRoomInfo(roomId);
        return CommonResult.<InterviewRoom>builder()
                .data(roomInfo)
                .build();
    }

    @ApiOperation("老师管理面试房间(禁麦、踢人等)")
    @PostMapping("/manage")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "roomId", value = "房间ID", required = true, dataType = "Long", paramType = "query"),
            @ApiImplicitParam(name = "username", value = "操作人用户名", required = true, dataType = "String", paramType = "query"),
            @ApiImplicitParam(name = "targetUsername", value = "目标用户名", required = true, dataType = "String", paramType = "query"),
            @ApiImplicitParam(name = "action", value = "动作(kick/mute)", required = true, dataType = "String", paramType = "query")
    })
    public CommonResult<String> manageRoom(@RequestParam Long roomId,
                                           @RequestParam String username,
                                           @RequestParam String targetUsername,
                                           @RequestParam String action) {
        String result = interviewService.manageRoom(roomId, username, targetUsername, action);
        return CommonResult.<String>builder()
                .data(result)
                .build();
    }

    @ApiOperation("获取房间内的参与者列表")
    @GetMapping("/getParticipants/{roomId}")
    @ApiImplicitParam(name = "roomId", value = "房间ID", required = true, dataType = "Long", paramType = "path")
    public CommonResult<List<InterviewParticipant>> getRoomParticipants(@PathVariable Long roomId) {
        List<InterviewParticipant> participants = interviewService.getRoomParticipants(roomId);
        return CommonResult.<List<InterviewParticipant>>builder()
                .data(participants)
                .build();
    }

    @ApiOperation("获取当前用户创建的房间列表")
    @GetMapping("/myRooms")
    public CommonResult<List<InterviewRoom>> getMyRooms(HttpServletRequest request) {
        // 从 token 中获取用户 ID
        // 从 Token 获取用户信息
        String username = JwtUtils.getUserInfoByToken(request).getUsername();
        List<InterviewRoom> rooms = interviewService.getRoomsByCreator(username);
        return CommonResult.<List<InterviewRoom>>builder()
                .data(rooms)
                .message("获取用户创建的房间列表成功")
                .build();
    }


}
