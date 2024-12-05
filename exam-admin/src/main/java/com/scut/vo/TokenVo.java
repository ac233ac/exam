package com.scut.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author by scut
 * @implNote 2024/11/1 17:09
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TokenVo {

    private Integer roleId;

    private String username;

    private String password;

}
