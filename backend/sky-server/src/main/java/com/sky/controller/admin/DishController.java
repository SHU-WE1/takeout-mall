package com.sky.controller.admin;

import com.sky.dto.DishDTO;
import com.sky.dto.DishPageQueryDTO;
import com.sky.entity.Dish;
import com.sky.result.PageResult;
import com.sky.result.Result;
import com.sky.service.DishService;
import com.sky.vo.DishVO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import net.bytebuddy.asm.Advice;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/admin/dish")
@Api(tags = "料理管理API")
@Slf4j
public class DishController {

    @Autowired
    private DishService dishService;

    /**
     * 新增菜品
     * @param dishDTO
     * @return
     */
    @PostMapping
    @ApiOperation("料理を登録")
    public Result save(@RequestBody DishDTO dishDTO){
        log.info("新增菜品：{}", dishDTO);
        dishService.saveWithFlavor(dishDTO);

        //清理缓存数据
        String key = "dish:" + dishDTO.getCategoryId();
        cleanCache(key);
        return Result.success();

    }

    /**
     * 菜品分页查询
     * @param dishPageQueryDTO
     * @return
     */
    @GetMapping("/page")
    @ApiOperation("料理一覧取得（ページネーション）")
    public Result<PageResult> page(DishPageQueryDTO dishPageQueryDTO){
        log.info("菜品分页查询{}", dishPageQueryDTO);
        PageResult pageResult = dishService.pageQuery(dishPageQueryDTO);
        return Result.success(pageResult);
    }

    /**
     * 菜品批量删除
     * @param ids
     * @return
     */
    @DeleteMapping
    @ApiOperation("料理一括削除")
    public Result delete(@RequestParam List<Long> ids){
        log.info("菜品批量删除：{}",ids);
        dishService.deletBatch(ids);

        //将所有的彩屏缓存数据清除掉，所有以dish_开头的key
        cleanCache("dish_*");
        return Result.success();
    }

    /**
     * 根据id查询菜品信息
     * @param id
     * @return
     */
    @GetMapping("/{id}")
    @ApiOperation("IDによる料理情報取得")
    public Result<DishVO> getById(@PathVariable Long id){
        log.info("根据id查询菜品:{}",id);
        DishVO dishVO = dishService.getByIdWithFlavor(id);
        return Result.success(dishVO);
    }

    /**
     * 修改菜品
     * @param dishDTO
     * @return
     */
    @PutMapping
    @ApiOperation("料理情報を更新")
    public Result update(@RequestBody DishDTO dishDTO){
        log.info("修改菜品：{}", dishDTO);
        dishService.update(dishDTO);

        //将所有菜品缓存清除
        cleanCache("dish_*");
        return Result.success();
    }

    @PostMapping("/status/{status}")
    @ApiOperation("料理の販売開始/停止")
    public Result<String> startOrStop(@PathVariable Integer status,Long id){
        dishService.startOrStop(status, id);

        //将所有菜品缓存清除
        cleanCache("dish_*");
        return Result.success();
    }

    /**
     * 新增套餐里面的添加菜品按钮所需（根据分类id查询）
     * @param categoryId
     * @return
     */
    @GetMapping("/list")
    public Result<List<Dish>> list(Long categoryId) {
        List<Dish> list = dishService.list(categoryId);
        return Result.success(list);
    }


    @Autowired
    private RedisTemplate redisTemplate;

    /**
     * 清理缓存数据
     * @param pattern
     */
    private void cleanCache(String pattern){
        Set keys = redisTemplate.keys(pattern);
        redisTemplate.delete(keys);
    }

}
