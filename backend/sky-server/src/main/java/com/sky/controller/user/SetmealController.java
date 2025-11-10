package com.sky.controller.user;

import com.sky.constant.StatusConstant;
import com.sky.entity.Setmeal;
import com.sky.result.Result;
import com.sky.service.SetmealService;
import com.sky.vo.DishItemVO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController("userSetmealController")
@RequestMapping("/user/setmeal")
@Api(tags = "ユーザー側-セットメニュー閲覧API")
public class SetmealController {
    @Autowired
    private SetmealService setmealService;

    /**
     * 条件查询
     * @param categoryId
     * @return
     */
    @GetMapping("/list")
    @ApiOperation("カテゴリIDによるセットメニュー一覧取得")
    @Cacheable(cacheNames = "setmealCache",key = "#categoryId")
    public Result<List<Setmeal>> list(Long categoryId) {
        Setmeal setmeal = new Setmeal();
        setmeal.setCategoryId(categoryId);
        setmeal.setStatus(StatusConstant.ENABLE);

        List<Setmeal> list = setmealService.list(setmeal);
        return Result.success(list);
    }
    @GetMapping("/dish/{id}")
    @ApiOperation("セットメニューIDによる料理リスト取得")
    public Result<List<DishItemVO>> dishList(@PathVariable("id")Long id) {
        List<DishItemVO> list = setmealService.getByItemById(id);
        return Result.success(list);

    }
}
