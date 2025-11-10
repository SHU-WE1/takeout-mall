package com.sky.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;

@Data
@ApiModel(description = "従業員ログイン時渡されるデータモデル")
public class EmployeeLoginDTO implements Serializable {

    @ApiModelProperty("ユーザー名")
    private String username;

    @ApiModelProperty("パスワード")
    private String password;

}
