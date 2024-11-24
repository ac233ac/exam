package com.wzz;

import com.wzz.utils.SaltEncryption;

public class TestEncryption {
    public static void main(String[] args) {
        String newPassword = "123456"; // 设置新的密码
        String salt = "c667d6";       // 数据库中的盐值
        String hashedPassword = SaltEncryption.saltEncryption(newPassword, salt);
        System.out.println("新的加密密码: " + hashedPassword);
    }
}
