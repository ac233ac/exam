package com.scut.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.scut.entity.UserRole;

import java.util.List;

/**
 * @author by scut
 * @implNote 2024/11/4 10:09
 */
public interface UserRoleService extends IService<UserRole> {

    String getMenuInfo(Integer roleId);

    List<UserRole> getUserRole();
}
