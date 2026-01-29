package wyqy.agriculture.service.impl;

import java.util.List;
import java.util.HashMap;
import java.util.Map;
import wyqy.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyqy.agriculture.mapper.LandInfoMapper;
import wyqy.agriculture.domain.LandInfo;
import wyqy.agriculture.service.ILandInfoService;

/**
 * 地块信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
@Service
public class LandInfoServiceImpl implements ILandInfoService 
{
    @Autowired
    private LandInfoMapper landInfoMapper;

    /**
     * 查询地块信息
     * 
     * @param landId 地块信息主键
     * @return 地块信息
     */
    @Override
    public LandInfo selectLandInfoByLandId(Long landId)
    {
        return landInfoMapper.selectLandInfoByLandId(landId);
    }

    /**
     * 查询地块信息列表
     * 
     * @param landInfo 地块信息
     * @return 地块信息
     */
    @Override
    public List<LandInfo> selectLandInfoList(LandInfo landInfo)
    {
        return landInfoMapper.selectLandInfoList(landInfo);
    }

    /**
     * 新增地块信息
     * 
     * @param landInfo 地块信息
     * @return 结果
     */
    @Override
    public int insertLandInfo(LandInfo landInfo)
    {
        landInfo.setCreateTime(DateUtils.getNowDate());
        return landInfoMapper.insertLandInfo(landInfo);
    }

    /**
     * 修改地块信息
     * 
     * @param landInfo 地块信息
     * @return 结果
     */
    @Override
    public int updateLandInfo(LandInfo landInfo)
    {
        landInfo.setUpdateTime(DateUtils.getNowDate());
        return landInfoMapper.updateLandInfo(landInfo);
    }

    /**
     * 批量删除地块信息
     * 
     * @param landIds 需要删除的地块信息主键
     * @return 结果
     */
    @Override
    public int deleteLandInfoByLandIds(Long[] landIds)
    {
        return landInfoMapper.deleteLandInfoByLandIds(landIds);
    }

    /**
     * 删除地块信息信息
     * 
     * @param landId 地块信息主键
     * @return 结果
     */
    @Override
    public int deleteLandInfoByLandId(Long landId)
    {
        return landInfoMapper.deleteLandInfoByLandId(landId);
    }

    /**
     * 获取地块统计信息
     * 
     * @return 统计信息
     */
    @Override
    public Object getLandStats()
    {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取总地块数
        List<LandInfo> allLands = landInfoMapper.selectLandInfoList(new LandInfo());
        stats.put("totalLands", allLands.size());
        
        // 计算总面积
        double totalArea = allLands.stream()
            .mapToDouble(LandInfo::getLandArea)
            .sum();
        stats.put("totalArea", Math.round(totalArea * 100.0) / 100.0);
        
        // 按状态统计
        Map<String, Long> statusCount = new HashMap<>();
        statusCount.put("available", allLands.stream().filter(land -> "0".equals(land.getStatus())).count());
        statusCount.put("occupied", allLands.stream().filter(land -> "1".equals(land.getStatus())).count());
        statusCount.put("maintenance", allLands.stream().filter(land -> "2".equals(land.getStatus())).count());
        stats.put("statusStats", statusCount);
        
        // 按土壤类型统计
        Map<String, Long> soilTypeCount = new HashMap<>();
        allLands.forEach(land -> {
            String soilType = land.getSoilType();
            if (soilType != null) {
                soilTypeCount.put(soilType, soilTypeCount.getOrDefault(soilType, 0L) + 1);
            }
        });
        stats.put("soilTypeStats", soilTypeCount);
        
        return stats;
    }
}
