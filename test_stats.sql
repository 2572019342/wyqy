-- 测试种植统计数据的SQL查询
-- 验证健康作物和成熟作物的统计逻辑

-- 1. 查看所有种植记录的健康状态和成熟状态
SELECT 
    planting_id,
    health_status,
    is_mature,
    CASE 
        WHEN health_status = 'healthy' THEN '健康'
        ELSE '不健康'
    END as health_desc,
    CASE 
        WHEN is_mature = '1' THEN '成熟'
        ELSE '未成熟'
    END as mature_desc
FROM planting_record
ORDER BY planting_id;

-- 2. 统计健康作物数量
SELECT 
    COUNT(*) as healthy_count
FROM planting_record 
WHERE health_status = 'healthy';

-- 3. 统计成熟作物数量
SELECT 
    COUNT(*) as mature_count
FROM planting_record 
WHERE is_mature = '1';

-- 4. 统计总种植数和总种植面积
SELECT 
    COUNT(*) as total_plantings,
    COALESCE(SUM(planting_area), 0) as total_area
FROM planting_record;

-- 5. 完整统计（模拟后端逻辑）
SELECT 
    COUNT(*) as total_plantings,
    COALESCE(SUM(planting_area), 0) as total_area,
    (SELECT COUNT(*) FROM planting_record WHERE health_status = 'healthy') as healthy_count,
    (SELECT COUNT(*) FROM planting_record WHERE is_mature = '1') as mature_count
FROM planting_record;
