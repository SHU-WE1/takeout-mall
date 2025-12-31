package com.sky.utils;

import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;

import java.util.Collections;
import java.util.concurrent.TimeUnit;

/**
 * Redis分布式锁工具类
 * 用于实现缓存击穿防护（キャッシュ撃穿対策）
 */
@Slf4j
public class RedisLockUtil {

    // Lua脚本：释放锁（确保只能释放自己持有的锁）
    private static final String UNLOCK_SCRIPT =
            "if redis.call('get', KEYS[1]) == ARGV[1] then " +
            "    return redis.call('del', KEYS[1]) " +
            "else " +
            "    return 0 " +
            "end";

    /**
     * 尝试获取分布式锁
     *
     * @param redisTemplate Redis模板
     * @param lockKey       锁的key
     * @param lockValue     锁的值（用于标识锁的持有者）
     * @param expireTime    锁的过期时间（秒）
     * @return true: 获取成功, false: 获取失败
     */
    public static boolean tryLock(RedisTemplate<Object, Object> redisTemplate,
                                   String lockKey,
                                   String lockValue,
                                   long expireTime) {
        try {
            // 使用 SET key value NX EX expireTime 实现原子性加锁
            // NX: 只有当key不存在时才设置
            // EX: 设置过期时间（秒）
            Boolean result = redisTemplate.opsForValue().setIfAbsent(
                    lockKey,
                    lockValue,
                    expireTime,
                    TimeUnit.SECONDS
            );
            
            return Boolean.TRUE.equals(result);
        } catch (Exception e) {
            log.error("获取分布式锁失败, lockKey: {}", lockKey, e);
            return false;
        }
    }

    /**
     * 释放分布式锁
     *
     * @param redisTemplate Redis模板
     * @param lockKey       锁的key
     * @param lockValue     锁的值（必须与加锁时的值一致）
     * @return true: 释放成功, false: 释放失败
     */
    public static boolean unlock(RedisTemplate<Object, Object> redisTemplate,
                                  String lockKey,
                                  String lockValue) {
        try {
            // 使用Lua脚本确保原子性：只能释放自己持有的锁
            DefaultRedisScript<Long> script = new DefaultRedisScript<>();
            script.setScriptText(UNLOCK_SCRIPT);
            script.setResultType(Long.class);
            
            Long result = redisTemplate.execute(
                    script,
                    Collections.singletonList(lockKey),
                    lockValue
            );
            
            return result != null && result > 0;
        } catch (Exception e) {
            log.error("释放分布式锁失败, lockKey: {}", lockKey, e);
            return false;
        }
    }

    /**
     * 尝试获取分布式锁（带重试机制）
     *
     * @param redisTemplate Redis模板
     * @param lockKey       锁的key
     * @param lockValue     锁的值
     * @param expireTime    锁的过期时间（秒）
     * @param retryTimes    重试次数
     * @param retryInterval 重试间隔（毫秒）
     * @return true: 获取成功, false: 获取失败
     */
    public static boolean tryLockWithRetry(RedisTemplate<Object, Object> redisTemplate,
                                            String lockKey,
                                            String lockValue,
                                            long expireTime,
                                            int retryTimes,
                                            long retryInterval) {
        for (int i = 0; i < retryTimes; i++) {
            if (tryLock(redisTemplate, lockKey, lockValue, expireTime)) {
                return true;
            }
            
            // 等待后重试
            try {
                Thread.sleep(retryInterval);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return false;
            }
        }
        return false;
    }
}

