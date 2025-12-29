package com.sky.controller.user;

import com.sky.constant.StatusConstant;
import com.sky.entity.Dish;
import com.sky.result.Result;
import com.sky.service.DishService;
import com.sky.vo.DishVO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

@RestController("userDishController")
@RequestMapping("/user/dish")
@Slf4j
@Api(tags = "ユーザー側-料理閲覧API")
public class DishController {

    // キャッシュペネトレーション対策：空値マーカー
    private static final String CACHE_NULL_VALUE = "NULL_VALUE";
    // 空値キャッシュの有効期限（秒）
    private static final long NULL_CACHE_TTL = 60L;
    // キャッシュアバランシェ対策：通常データキャッシュの基礎有効期限（秒）
    private static final long CACHE_TTL_BASE = 7200L; // 2時間 = 7200秒
    // キャッシュアバランシェ対策：ランダムオフセット（秒）
    private static final long CACHE_TTL_RANDOM = 300L; // ±5分 = 300秒

    @Autowired
    private DishService dishService;
    @Autowired
    private RedisTemplate<Object, Object> redisTemplate;

    /**
     * キャッシュアバランシェ対策：ランダムTTLを生成する
     * 基礎時間 + ランダムオフセット（-300秒 ～ +300秒）
     * 結果：6900秒（約1.92時間）～ 7500秒（約2.08時間）
     *
     * @return ランダムなTTL（秒）
     */
    private long getRandomTTL() {
        // 基礎時間 + ランダムオフセット（-300 から +300 秒）
        long randomOffset = (long) (Math.random() * CACHE_TTL_RANDOM * 2 - CACHE_TTL_RANDOM);
        return CACHE_TTL_BASE + randomOffset;
    }

    /**
     * 根据分类id查询菜品
     *
     * @param categoryId
     * @return
     */
    @GetMapping("/list")
    @ApiOperation("カテゴリIDによる料理一覧取得")
    public Result<List<DishVO>> list(long categoryId){

        //构建redis中的key，规则：dish_分类id
        String key = "dish_" + categoryId;

        //查询redis中是否存在菜品数据
        Object cacheData = redisTemplate.opsForValue().get(key);
        
        // キャッシュヒット時の処理
        if (cacheData != null) {
            // 空値マーカーの場合、空リストを返す（キャッシュペネトレーション対策）
            if (CACHE_NULL_VALUE.equals(cacheData)) {
                return Result.success(new ArrayList<>());
            }
            // 通常データの場合、そのまま返す
            @SuppressWarnings("unchecked")
            List<DishVO> cachedList = (List<DishVO>) cacheData;
            return Result.success(cachedList);
        }

        // キャッシュ未ヒット時、データベースをクエリ
        Dish dish = new Dish();
        dish.setCategoryId(categoryId);
        dish.setStatus(StatusConstant.ENABLE);//查询起售中的菜品
        List<DishVO> list = dishService.listWithFlavor(dish);

        // クエリ結果をキャッシュに保存
        if (list == null || list.isEmpty()) {
            // キャッシュペネトレーション対策：空値マーカーを短期間キャッシュ
            redisTemplate.opsForValue().set(key, CACHE_NULL_VALUE, NULL_CACHE_TTL, TimeUnit.SECONDS);
        } else {
            // キャッシュアバランシェ対策：通常データをランダムTTLでキャッシュ
            long randomTTL = getRandomTTL();
            redisTemplate.opsForValue().set(key, list, randomTTL, TimeUnit.SECONDS);
        }

        return Result.success(list);
    }
}
