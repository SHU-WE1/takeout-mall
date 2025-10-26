package com.sky.service;

import com.sky.dto.SetmealDTO;
import com.sky.dto.SetmealPageQueryDTO;
import com.sky.entity.Setmeal;
import com.sky.result.PageResult;
import com.sky.vo.DishItemVO;
import com.sky.vo.SetmealVO;

import java.util.List;

public interface SetmealService {
    List<Setmeal> list(Setmeal setmeal);

    List<DishItemVO> getByItemById(Long id);

    void save(SetmealDTO setmealDTO);

    PageResult pageQuery(SetmealPageQueryDTO setmealPageQueryDTO);

    void delete(List<Long> ids);

    void update(SetmealDTO setmealDTO);

    SetmealVO getByIdWithDish(Long id);

    void startOrStop(Integer status, Long id);
}
