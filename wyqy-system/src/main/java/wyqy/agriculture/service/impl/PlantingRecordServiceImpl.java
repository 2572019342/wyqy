package wyqy.agriculture.service.impl;

import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import wyqy.common.utils.DateUtils;
import wyqy.common.utils.SecurityUtils;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyqy.agriculture.mapper.PlantingRecordMapper;
import wyqy.agriculture.domain.PlantingRecord;
import wyqy.agriculture.mapper.FarmingTaskMapper;
import wyqy.agriculture.mapper.FarmingManagementMapper;
import wyqy.agriculture.mapper.HarvestRecordMapper;
import wyqy.agriculture.domain.FarmingTask;
import wyqy.agriculture.service.IFarmingTaskService;
import wyqy.agriculture.service.IPlantingRecordService;

/**
 * 种植记录Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
@Service
public class PlantingRecordServiceImpl implements IPlantingRecordService 
{
    @Autowired
    private PlantingRecordMapper plantingRecordMapper;

    @Autowired
    private FarmingTaskMapper farmingTaskMapper;

    @Autowired
    private IFarmingTaskService farmingTaskService;

    @Autowired
    private FarmingManagementMapper farmingManagementMapper;

    @Autowired
    private HarvestRecordMapper harvestRecordMapper;

    private static final Set<String> HEALTH_ALERT_STATUSES = new HashSet<>(Arrays.asList("disease", "pest", "serious"));

    /**
     * 查询种植记录
     * 
     * @param plantingId 种植记录主键
     * @return 种植记录
     */
    @Override
    public PlantingRecord selectPlantingRecordByPlantingId(Long plantingId)
    {
        return plantingRecordMapper.selectPlantingRecordByPlantingId(plantingId);
    }

    /**
     * 查询种植记录列表
     * 
     * @param plantingRecord 种植记录
     * @return 种植记录
     */
    @Override
    public List<PlantingRecord> selectPlantingRecordList(PlantingRecord plantingRecord)
    {
        return plantingRecordMapper.selectPlantingRecordList(plantingRecord);
    }

    /**
     * 新增种植记录
     * 
     * @param plantingRecord 种植记录
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertPlantingRecord(PlantingRecord plantingRecord)
    {
        plantingRecord.setCreateTime(DateUtils.getNowDate());
        this.applyMaturityAndHarvestFlags(plantingRecord);
        int rows = plantingRecordMapper.insertPlantingRecord(plantingRecord);
        this.tryCreatePestDiseaseFarmingTask(plantingRecord);
        return rows;
    }

    /**
     * 修改种植记录
     * 
     * @param plantingRecord 种植记录
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updatePlantingRecord(PlantingRecord plantingRecord)
    {
        plantingRecord.setUpdateTime(DateUtils.getNowDate());
        this.applyMaturityAndHarvestFlags(plantingRecord);
        int rows = plantingRecordMapper.updatePlantingRecord(plantingRecord);
        this.tryCreatePestDiseaseFarmingTask(plantingRecord);
        return rows;
    }

    /**
     * 批量删除种植记录
     * 级联删除关联数据：先删除种植管理、采摘记录、农事任务，再删除种植记录
     * 
     * @param plantingIds 需要删除的种植记录主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deletePlantingRecordByPlantingIds(Long[] plantingIds)
    {
        if (plantingIds == null || plantingIds.length == 0)
        {
            return 0;
        }
        
        // 1. 先删除关联的农事任务
        farmingTaskMapper.deleteFarmingTaskByPlantingIds(plantingIds);
        
        // 2. 删除关联的种植管理记录
        farmingManagementMapper.deleteFarmingManagementByPlantingIds(plantingIds);
        
        // 3. 删除关联的采摘记录
        harvestRecordMapper.deleteHarvestRecordByPlantingIds(plantingIds);
        
        // 4. 最后删除种植记录
        return plantingRecordMapper.deletePlantingRecordByPlantingIds(plantingIds);
    }

    /**
     * 删除种植记录信息
     * 级联删除关联数据：先删除种植管理、采摘记录、农事任务，再删除种植记录
     * 
     * @param plantingId 种植记录主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deletePlantingRecordByPlantingId(Long plantingId)
    {
        if (plantingId == null)
        {
            return 0;
        }
        
        Long[] plantingIds = new Long[]{plantingId};
        
        // 1. 先删除关联的农事任务
        farmingTaskMapper.deleteFarmingTaskByPlantingIds(plantingIds);
        
        // 2. 删除关联的种植管理记录
        farmingManagementMapper.deleteFarmingManagementByPlantingIds(plantingIds);
        
        // 3. 删除关联的采摘记录
        harvestRecordMapper.deleteHarvestRecordByPlantingIds(plantingIds);
        
        // 4. 最后删除种植记录
        return plantingRecordMapper.deletePlantingRecordByPlantingId(plantingId);
    }

    /**
     * 获取种植统计信息
     * 
     * @return 统计信息
     */
    @Override
    public Object getPlantingStats()
    {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取总种植记录数
        List<PlantingRecord> allPlantings = plantingRecordMapper.selectPlantingRecordList(new PlantingRecord());
        stats.put("totalPlantings", allPlantings.size());
        
        // 计算总种植面积
        double totalArea = allPlantings.stream()
            .filter(planting -> planting.getPlantingArea() != null)
            .mapToDouble(PlantingRecord::getPlantingArea)
            .sum();
        stats.put("totalArea", Math.round(totalArea * 100.0) / 100.0);
        
        // 计算健康作物数量（health_status = 'healthy'）
        long healthyCount = allPlantings.stream()
            .filter(planting -> "healthy".equals(planting.getHealthStatus()))
            .count();
        stats.put("healthyCount", healthyCount);
        
        // 计算成熟作物数量（is_mature = '1'）
        long matureCount = allPlantings.stream()
            .filter(planting -> "1".equals(planting.getIsMature()))
            .count();
        stats.put("matureCount", matureCount);
        
        // 按生长阶段统计
        Map<String, Long> stageCount = new HashMap<>();
        allPlantings.forEach(planting -> {
            String stage = planting.getGrowthStage();
            if (stage != null) {
                stageCount.put(stage, stageCount.getOrDefault(stage, 0L) + 1);
            }
        });
        stats.put("stageStats", stageCount);
        
        // 按健康状况统计
        Map<String, Long> healthCount = new HashMap<>();
        allPlantings.forEach(planting -> {
            String health = planting.getHealthStatus();
            if (health != null) {
                healthCount.put(health, healthCount.getOrDefault(health, 0L) + 1);
            }
        });
        stats.put("healthStats", healthCount);
        
        // 计算总预估产量
        double totalEstimatedYield = allPlantings.stream()
            .filter(planting -> planting.getEstimatedYield() != null)
            .mapToDouble(PlantingRecord::getEstimatedYield)
            .sum();
        stats.put("totalEstimatedYield", Math.round(totalEstimatedYield * 100.0) / 100.0);
        
        return stats;
    }

    /**
     * 获取地块种植信息
     * 
     * @param landId 地块ID
     * @return 种植信息
     */
    @Override
    public Object getLandPlantingInfo(Long landId)
    {
        PlantingRecord query = new PlantingRecord();
        query.setLandId(landId);
        List<PlantingRecord> landPlantings = plantingRecordMapper.selectPlantingRecordList(query);
        
        Map<String, Object> info = new HashMap<>();
        info.put("plantings", landPlantings);
        info.put("totalArea", landPlantings.stream()
            .filter(planting -> planting.getPlantingArea() != null)
            .mapToDouble(PlantingRecord::getPlantingArea)
            .sum());
        info.put("count", landPlantings.size());
        
        return info;
    }

    /**
     * 更新生长状态
     * 
     * @param plantingRecord 种植记录
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateGrowthStatus(PlantingRecord plantingRecord)
    {
        plantingRecord.setUpdateTime(DateUtils.getNowDate());
        this.applyMaturityAndHarvestFlags(plantingRecord);
        int rows = plantingRecordMapper.updatePlantingRecord(plantingRecord);
        this.tryCreatePestDiseaseFarmingTask(plantingRecord);
        return rows;
    }

    private void applyMaturityAndHarvestFlags(PlantingRecord plantingRecord)
    {
        if (plantingRecord == null)
        {
            return;
        }

        String stage = plantingRecord.getGrowthStage();
        if (stage == null || stage.trim().isEmpty())
        {
            return;
        }

        if ("成熟期".equals(stage.trim()))
        {
            plantingRecord.setIsMature("1");
            if ("healthy".equals(plantingRecord.getHealthStatus()))
            {
                plantingRecord.setCanHarvest("1");
            }
            else
            {
                plantingRecord.setCanHarvest("0");
            }
        }
        else
        {
            plantingRecord.setIsMature("0");
            plantingRecord.setCanHarvest("0");
        }
    }

    private void tryCreatePestDiseaseFarmingTask(PlantingRecord plantingRecord)
    {
        if (plantingRecord == null || plantingRecord.getPlantingId() == null)
        {
            return;
        }
        String healthStatus = normalizeHealthStatus(plantingRecord.getHealthStatus());
        boolean hasDiseaseOrPestInfo = isNotBlank(plantingRecord.getDiseaseInfo()) || isNotBlank(plantingRecord.getPestInfo());
        if (!hasDiseaseOrPestInfo && (healthStatus == null || !HEALTH_ALERT_STATUSES.contains(healthStatus)))
        {
            return;
        }

        FarmingTask query = new FarmingTask();
        query.setPlantingId(plantingRecord.getPlantingId());
        query.setTaskType("pesticide");
        query.setStatus("0");
        List<FarmingTask> existing = farmingTaskMapper.selectFarmingTaskList(query);
        if (existing != null && !existing.isEmpty())
        {
            return;
        }

        FarmingTask task = new FarmingTask();
        task.setPlantingId(plantingRecord.getPlantingId());
        task.setTaskType("pesticide");
        task.setTitle("病虫害待处理");
        task.setStatus("0");

        StringBuilder notes = new StringBuilder();
        notes.append("健康状态:").append(healthStatus != null ? healthStatus : plantingRecord.getHealthStatus());
        if (isNotBlank(plantingRecord.getDiseaseInfo()))
        {
            notes.append("; 病害信息:").append(plantingRecord.getDiseaseInfo());
        }
        if (isNotBlank(plantingRecord.getPestInfo()))
        {
            notes.append("; 虫害信息:").append(plantingRecord.getPestInfo());
        }
        task.setContent(notes.toString());
        task.setCreateBy(SecurityUtils.getUsername());
        farmingTaskService.insertFarmingTask(task);
    }

    private static boolean isNotBlank(String value)
    {
        return value != null && !value.trim().isEmpty();
    }

    private static String normalizeHealthStatus(String healthStatus)
    {
        if (healthStatus == null)
        {
            return null;
        }
        String s = healthStatus.trim();
        if (s.isEmpty())
        {
            return null;
        }
        String lower = s.toLowerCase();
        if ("病害".equals(s) || "disease".equals(lower))
        {
            return "disease";
        }
        if ("虫害".equals(s) || "pest".equals(lower))
        {
            return "pest";
        }
        if ("病重".equals(s) || "严重".equals(s) || "serious".equals(lower))
        {
            return "serious";
        }
        if ("亚健康".equals(s) || "subhealthy".equals(lower))
        {
            return "subhealthy";
        }
        if ("健康".equals(s) || "healthy".equals(lower))
        {
            return "healthy";
        }
        return lower;
    }
}
