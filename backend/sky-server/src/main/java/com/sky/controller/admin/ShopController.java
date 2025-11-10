package com.sky.controller.admin;

import com.sky.result.Result;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin/shop")
@Api(tags = "店舗管理API")
@Slf4j
public class ShopController {

    public static final String KEY = "SHOP_STATUS";

    @Autowired
    private RedisTemplate redisTemplate;

    /**
     * 设置店铺运营状态
     * @param status
     * @return
     */
    @PutMapping("/{status}")
    @ApiOperation("店舗営業ステータスを設定")
    public Result setStatus(@PathVariable Integer status){
        log.info("设置店铺的营业状态为：{}", status == 1 ? "营业中" : "打烊中");
        redisTemplate.opsForValue().set(KEY, status);
        return Result.success();
    }

    /**
     * 获取店铺的营业状态
     * @return
     */
    @GetMapping("/status")
    @ApiOperation("店舗営業ステータス取得")
    public Result<Integer> getStatus(){
        Integer status = (Integer) redisTemplate.opsForValue().get(KEY);
        log.info("获取店铺的营业状态为：{}", status == 1 ? "营业中" : "打烊中");
        return Result.success(status);
    }
}
