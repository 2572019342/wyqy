package wyqy.agriculture.service.impl;

import java.util.List;
import java.util.HashMap;
import java.util.Map;
import wyqy.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyqy.agriculture.mapper.FarmingManagementMapper;
import wyqy.agriculture.domain.FarmingManagement;
import wyqy.agriculture.service.IFarmingManagementService;

/**
 * 种植管理Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
@Service
public class FarmingManagementServiceImpl implements IFarmingManagementService 
{
    @Autowired
    private FarmingManagementMapper farmingManagementMapper;

    /**
     * 查询种植管理
     * 
     * @param farmingId 种植管理主键
     * @return 种植管理
     */
    @Override
    public FarmingManagement selectFarmingManagementByFarmingId(Long farmingId)
    {
        return farmingManagementMapper.selectFarmingManagementByFarmingId(farmingId);
    }

    /**
     * 查询种植管理列表
     * 
     * @param farmingManagement 种植管理
     * @return 种植管理
     */
    @Override
    public List<FarmingManagement> selectFarmingManagementList(FarmingManagement farmingManagement)
    {
        return farmingManagementMapper.selectFarmingManagementList(farmingManagement);
    }

    /**
     * 新增种植管理
     * 
     * @param farmingManagement 种植管理
     * @return 结果
     */
    @Override
    public int insertFarmingManagement(FarmingManagement farmingManagement)
    {
        farmingManagement.setCreateTime(DateUtils.getNowDate());
        return farmingManagementMapper.insertFarmingManagement(farmingManagement);
    }

    /**
     * 修改种植管理
     * 
     * @param farmingManagement 种植管理
     * @return 结果
     */
    @Override
    public int updateFarmingManagement(FarmingManagement farmingManagement)
    {
        farmingManagement.setUpdateTime(DateUtils.getNowDate());
        return farmingManagementMapper.updateFarmingManagement(farmingManagement);
    }

    /**
     * 批量删除种植管理
     * 
     * @param farmingIds 需要删除的种植管理主键
     * @return 结果
     */
    @Override
    public int deleteFarmingManagementByFarmingIds(Long[] farmingIds)
    {
        return farmingManagementMapper.deleteFarmingManagementByFarmingIds(farmingIds);
    }

    /**
     * 删除种植管理信息
     * 
     * @param farmingId 种植管理主键
     * @return 结果
     */
    @Override
    public int deleteFarmingManagementByFarmingId(Long farmingId)
    {
        return farmingManagementMapper.deleteFarmingManagementByFarmingId(farmingId);
    }

    /**
     * 获取种植管理统计信息
     * 
     * @return 统计信息
     */
    @Override
    public Object getFarmingStats()
    {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取总管理记录数
        List<FarmingManagement> allFarmings = farmingManagementMapper.selectFarmingManagementList(new FarmingManagement());
        stats.put("totalOperations", allFarmings.size());
        
        // 按管理类型统计
        Map<String, Long> managementTypeCount = new HashMap<>();
        allFarmings.forEach(farming -> {
            String type = farming.getManagementType();
            if (type != null) {
                managementTypeCount.put(type, managementTypeCount.getOrDefault(type, 0L) + 1);
            }
        });
        stats.put("managementTypeStats", managementTypeCount);
        
        // 计算总成本
        double totalCost = allFarmings.stream()
            .filter(farming -> farming.getCost() != null)
            .mapToDouble(FarmingManagement::getCost)
            .sum();
        stats.put("totalCost", Math.round(totalCost * 100.0) / 100.0);
        
        // 按物料类型统计
        Map<String, Long> materialTypeCount = new HashMap<>();
        allFarmings.forEach(farming -> {
            String materialType = farming.getMaterialType();
            if (materialType != null) {
                materialTypeCount.put(materialType, materialTypeCount.getOrDefault(materialType, 0L) + 1);
            }
        });
        stats.put("materialTypeStats", materialTypeCount);
        
        return stats;
    }

    /**
     * 获取种植农事历史
     * 
     * @param plantingId 种植ID
     * @return 农事历史
     */
    @Override
    public List<FarmingManagement> getPlantingFarmingHistory(Long plantingId)
    {
        FarmingManagement query = new FarmingManagement();
        query.setPlantingId(plantingId);
        return farmingManagementMapper.selectFarmingManagementList(query);
    }
}
