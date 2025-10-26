package com.sky.mapper;

import com.sky.entity.SetmealDish;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface SetmealDishMapper {
    /**
     * 根据菜品id查询对应的套餐id
     * @param dishIds
     * @return
     */
    List<Long> getSetmealIdsByDishIds(List<Long> dishIds);


    void insertBatch(List<SetmealDish> setmealDishes);

    @Delete("delete from setmeal_dish where setmeal_id = #{id}")
    void deletBySetmealId(Long id);

    @Select("SELECT * FROM setmeal_dish WHERE setmeal_id = #{id}")
    List<SetmealDish> getBySetmealId(Long id);
}
