package com.sky.service;

import com.sky.dto.DishDTO;
import com.sky.dto.DishPageQueryDTO;
import com.sky.entity.Dish;
import com.sky.result.PageResult;
import com.sky.vo.DishVO;

import java.util.List;

public interface DishService {
    /**
     * 新增菜品和对应的口味
     * @param dishDTO
     */
    void saveWithFlavor(DishDTO dishDTO);

    PageResult pageQuery(DishPageQueryDTO dishPageQueryDTO);

    void deletBatch(List<Long> ids);

    DishVO getByIdWithFlavor(Long id);

    void update(DishDTO dishDTO);

    List<DishVO> listWithFlavor(Dish dish);

    void startOrStop(Integer status, Long id);

    List<Dish> list(Long categoryId);

    /**
     * 在庫を減少させる（楽観ロック使用）
     *
     * @param dishId    菜品ID
     * @param quantity  購入数量（減少させる在庫数）
     */
    void reduceStock(Long dishId, Integer quantity);
}
