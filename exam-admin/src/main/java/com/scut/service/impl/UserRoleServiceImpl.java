package com.scut.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.scut.annotation.Cache;
import com.scut.entity.UserRole;
import com.scut.mapper.UserRoleMapper;
import com.scut.service.UserRoleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * @Date 2024/10/20 19:50
 * @created by scut
 */
@Service
@RequiredArgsConstructor
public class UserRoleServiceImpl extends ServiceImpl<UserRoleMapper, UserRole> implements UserRoleService {

    private final UserRoleMapper userRoleMapper;

    @Override
    @Cache(prefix = "menu", suffix = "#roleId", ttl = 60 * 60 * 24, randomTime = 60 * 60 * 10)
    public String getMenuInfo(Integer roleId) {
        return userRoleMapper.selectOne(new QueryWrapper<UserRole>().eq("role_id", roleId)).getMenuInfo();
    }

    @Override
    @Cache(prefix = "userRoles", ttl = 30, randomTime = 10, timeUnit = TimeUnit.DAYS)
    public List<UserRole> getUserRole() {
        return userRoleMapper.selectList(null);
    }
}
