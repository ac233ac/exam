package com.scut.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.scut.dto.AddUserDto;
import com.scut.dto.LoginDto;
import com.scut.dto.RegisterDto;
import com.scut.dto.UpdateUserInfoDto;
import com.scut.entity.User;
import com.scut.vo.PageResponse;
import com.scut.vo.UserInfoVo;

import java.util.List;

/**
 * @author by scut
 * @implNote 2024/11/4 10:09
 */
public interface UserService extends IService<User> {

    String register(RegisterDto registerDto);

    Boolean checkUsername(String username);

    String login(LoginDto loginDto);

    User getUserByUsername(String username);

    // 这里要reset cache 所以必须要有更新后的数据返回
    User updateUserInfo(UpdateUserInfoDto updateUserInfoDto);

    PageResponse<UserInfoVo> getUser(String loginName, String trueName, Integer pageNo, Integer pageSize);

    void handlerUser(Integer type, String userIds);

    void addUser(AddUserDto addUserDto);

    UserInfoVo getUserInfoById(Integer userId);

    List<UserInfoVo> getUserInfoByIds(List<Integer> userIds);
}
