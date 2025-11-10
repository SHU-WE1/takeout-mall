package com.sky.controller.user;

import com.sky.context.BaseContext;
import com.sky.dto.ShoppingCartDTO;
import com.sky.entity.ShoppingCart;
import com.sky.result.Result;
import com.sky.service.ShoppingCartService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 购物车
 */
@RestController
@RequestMapping("/user/shoppingCart")
@Slf4j
@Api(tags = "ユーザー側-ショッピングカートAPI")
public class ShoppingCartController {

    @Autowired
    private ShoppingCartService shoppingCartService;

    /**
     * 加入购物车
     * @param shoppingCartDTO
     * @return
     */
    @PostMapping("/add")
    @ApiOperation("ショッピングカートに追加")
    public Result add(@RequestBody ShoppingCartDTO shoppingCartDTO){
        log.info("添加购物车：{}", shoppingCartDTO);
        log.info("当前用户ID: {}", BaseContext.getCurrentId());
        shoppingCartService.add(shoppingCartDTO);
        return Result.success();
    }
    /**
     * 查看购物车
     * @return
     */
    @GetMapping("/list")
    @ApiOperation("ショッピングカート一覧取得")
    public Result<List<ShoppingCart>> list(){
        return Result.success(shoppingCartService.showShoppingCart());
    }

    /**
     * 清空购物车
     * @return
     */
    @DeleteMapping("/clean")
    @ApiOperation("ショッピングカートを空にする")
    public Result clean(){
        shoppingCartService.clean(BaseContext.getCurrentId());
        return Result.success();

    }


}
