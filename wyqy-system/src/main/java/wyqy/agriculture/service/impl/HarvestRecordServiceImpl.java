package wyqy.agriculture.service.impl;

import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.HashSet;
import wyqy.common.utils.DateUtils;
import wyqy.common.exception.ServiceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyqy.agriculture.mapper.HarvestRecordMapper;
import wyqy.agriculture.mapper.PlantingRecordMapper;
import wyqy.agriculture.domain.HarvestRecord;
import wyqy.agriculture.domain.PlantingRecord;
import wyqy.agriculture.service.IHarvestRecordService;

/**
 * 采摘记录Service业务层处理
 *
 * @author ruoyi
 * @date 2025-01-22
 */
@Service
public class HarvestRecordServiceImpl implements IHarvestRecordService
{
    @Autowired
    private HarvestRecordMapper harvestRecordMapper;

    @Autowired
    private PlantingRecordMapper plantingRecordMapper;

    /**
     * 查询采摘记录1
     *
     * @param harvestId 采摘记录主键
     * @return 采摘记录1
     */
    @Override
    public HarvestRecord selectHarvestRecordByHarvestId(Long harvestId)
    {
        return harvestRecordMapper.selectHarvestRecordByHarvestId(harvestId);
    }

    /**
     * 查询采摘记录列表
     *
     * @param harvestRecord 采摘记录
     * @return 采摘记录
     */
    @Override
    public List<HarvestRecord> selectHarvestRecordList(HarvestRecord harvestRecord)
    {
        return harvestRecordMapper.selectHarvestRecordList(harvestRecord);
    }

    /**
     * 新增采摘记录
     *
     * @param harvestRecord 采摘记录
     * @return 结果
     */
    @Override
    public int insertHarvestRecord(HarvestRecord harvestRecord)
    {
        if (harvestRecord != null && harvestRecord.getPlantingId() != null)
        {
            HarvestRecord query = new HarvestRecord();
            query.setPlantingId(harvestRecord.getPlantingId());
            List<HarvestRecord> existing = harvestRecordMapper.selectHarvestRecordList(query);
            if (existing != null && !existing.isEmpty())
            {
                throw new ServiceException("该种植记录已存在采摘记录，不能重复采摘");
            }
        }
        harvestRecord.setCreateTime(DateUtils.getNowDate());
        return harvestRecordMapper.insertHarvestRecord(harvestRecord);
    }

    /**
     * 修改采摘记录
     *
     * @param harvestRecord 采摘记录
     * @return 结果
     */
    @Override
    public int updateHarvestRecord(HarvestRecord harvestRecord)
    {
        harvestRecord.setUpdateTime(DateUtils.getNowDate());
        return harvestRecordMapper.updateHarvestRecord(harvestRecord);
    }

    /**
     * 批量删除采摘记录
     *
     * @param harvestIds 需要删除的采摘记录主键
     * @return 结果
     */
    @Override
    public int deleteHarvestRecordByHarvestIds(Long[] harvestIds)
    {
        return harvestRecordMapper.deleteHarvestRecordByHarvestIds(harvestIds);
    }

    /**
     * 删除采摘记录信息
     *
     * @param harvestId 采摘记录主键
     * @return 结果
     */
    @Override
    public int deleteHarvestRecordByHarvestId(Long harvestId)
    {
        return harvestRecordMapper.deleteHarvestRecordByHarvestId(harvestId);
    }

    /**
     * 获取可采摘的种植记录
     *
     * @return 可采摘的种植记录
     */
    @Override
    public List<Object> getHarvestablePlantings()
    {
        List<PlantingRecord> allPlantings = plantingRecordMapper.selectPlantingRecordList(new PlantingRecord());
        List<Object> harvestablePlantings = new ArrayList<>();

        List<Long> harvestedPlantingIds = harvestRecordMapper.selectHarvestedPlantingIds();
        Set<Long> harvestedSet = new HashSet<>();
        if (harvestedPlantingIds != null)
        {
            harvestedSet.addAll(harvestedPlantingIds);
        }

        for (PlantingRecord planting : allPlantings) {
            if (planting == null || planting.getPlantingId() == null)
            {
                continue;
            }
            if (harvestedSet.contains(planting.getPlantingId()))
            {
                continue;
            }
            // 检查是否可以采摘
            if (isHarvestable(planting)) {
                Map<String, Object> plantingInfo = new HashMap<>();
                plantingInfo.put("plantingId", planting.getPlantingId());
                plantingInfo.put("landId", planting.getLandId());
                plantingInfo.put("landName", planting.getLandName());
                plantingInfo.put("speciesName", planting.getSpeciesName());
                plantingInfo.put("plantingDate", planting.getPlantingDate());
                plantingInfo.put("plantingArea", planting.getPlantingArea());
                plantingInfo.put("growthStage", planting.getGrowthStage());
                plantingInfo.put("healthStatus", planting.getHealthStatus());
                plantingInfo.put("maturity", planting.getMaturity());
                plantingInfo.put("canHarvest", planting.getCanHarvest());
                plantingInfo.put("isMature", planting.getIsMature());
                harvestablePlantings.add(plantingInfo);
            }
        }

        return harvestablePlantings;
    }

    /**
     * 检查种植记录是否可以采摘
     *
     * @param plantingId 种植ID
     * @return 检查结果
     */
    @Override
    public Object checkHarvestable(Long plantingId)
    {
        PlantingRecord planting = plantingRecordMapper.selectPlantingRecordByPlantingId(plantingId);
        if (planting == null) {
            Map<String, Object> result = new HashMap<>();
            result.put("canHarvest", "0");
            result.put("reason", "种植记录不存在");
            return result;
        }

        HarvestRecord harvestedQuery = new HarvestRecord();
        harvestedQuery.setPlantingId(plantingId);
        List<HarvestRecord> harvested = harvestRecordMapper.selectHarvestRecordList(harvestedQuery);
        if (harvested != null && !harvested.isEmpty())
        {
            Map<String, Object> result = new HashMap<>();
            result.put("plantingId", planting.getPlantingId());
            result.put("landName", planting.getLandName());
            result.put("speciesName", planting.getSpeciesName());
            result.put("canHarvest", "0");
            result.put("reason", "已采摘，不能重复采摘");
            return result;
        }

        Map<String, Object> result = new HashMap<>();
        result.put("plantingId", planting.getPlantingId());
        result.put("landName", planting.getLandName());
        result.put("speciesName", planting.getSpeciesName());
        result.put("growthStage", planting.getGrowthStage());
        result.put("healthStatus", planting.getHealthStatus());
        result.put("maturity", planting.getMaturity());
        result.put("isMature", planting.getIsMature());
        result.put("canHarvest", planting.getCanHarvest());

        if (!"1".equals(planting.getIsMature())) {
            result.put("canHarvest", "0");
            result.put("reason", "作物尚未成熟");
        } else if (!"1".equals(planting.getCanHarvest())) {
            result.put("canHarvest", "0");
            result.put("reason", "作物暂不可采摘");
        } else if (!"healthy".equals(planting.getHealthStatus())) {
            result.put("canHarvest", "0");
            result.put("reason", "作物健康状况不佳，存在病虫害风险");
        } else {
            result.put("canHarvest", "1");
            result.put("reason", "可以采摘");
        }

        return result;
    }

    /**
     * 获取采摘统计
     *
     * @return 统计信息
     */
    @Override
    public Object getHarvestStats()
    {
        Map<String, Object> stats = new HashMap<>();

        // 获取总采摘记录数
        List<HarvestRecord> allHarvests = harvestRecordMapper.selectHarvestRecordList(new HarvestRecord());
        stats.put("totalCount", allHarvests.size());

        // 计算总采摘量
        double totalQuantity = allHarvests.stream()
            .filter(harvest -> harvest.getHarvestQuantity() != null)
            .mapToDouble(HarvestRecord::getHarvestQuantity)
            .sum();
        stats.put("totalQuantity", Math.round(totalQuantity * 100.0) / 100.0);

        // 计算总价值
        double totalValue = allHarvests.stream()
            .filter(harvest -> harvest.getTotalPrice() != null)
            .mapToDouble(HarvestRecord::getTotalPrice)
            .sum();
        stats.put("totalValue", Math.round(totalValue * 100.0) / 100.0);

        // 按质量等级统计
        Map<String, Long> qualityGradeCount = new HashMap<>();
        allHarvests.forEach(harvest -> {
            String grade = harvest.getQualityGrade();
            if (grade != null) {
                qualityGradeCount.put(grade, qualityGradeCount.getOrDefault(grade, 0L) + 1);
            }
        });
        stats.put("qualityGradeStats", qualityGradeCount);

        // 计算平均质量等级（保留两位小数）
        double avgQuality = calculateAverageQuality(qualityGradeCount);
        stats.put("avgQuality", Math.round(avgQuality * 100.0) / 100.0);

        return stats;
    }

    /**
     * 判断是否可以采摘
     */
    private boolean isHarvestable(PlantingRecord planting) {
        return "1".equals(planting.getIsMature()) && "1".equals(planting.getCanHarvest()) && "healthy".equals(planting.getHealthStatus());
    }

    /**
     * 计算平均质量等级
     */
    private double calculateAverageQuality(Map<String, Long> qualityGradeCount) {
        Map<String, Integer> gradeScore = new HashMap<>();
        gradeScore.put("特等", 5);
        gradeScore.put("一等", 4);
        gradeScore.put("二等", 3);
        gradeScore.put("三等", 2);
        gradeScore.put("等外", 1);

        double totalScore = 0;
        long totalCount = 0;

        for (Map.Entry<String, Long> entry : qualityGradeCount.entrySet()) {
            String grade = entry.getKey();
            Long count = entry.getValue();
            Integer score = gradeScore.get(grade);
            if (score != null) {
                totalScore += score * count;
                totalCount += count;
            }
        }

        return totalCount > 0 ? totalScore / totalCount : 0.0;
    }
}
