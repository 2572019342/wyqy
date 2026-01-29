package wyqy.agriculture.service.impl;

import java.util.List;
import java.util.HashMap;
import java.util.Map;
import wyqy.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyqy.agriculture.mapper.CropSpeciesMapper;
import wyqy.agriculture.domain.CropSpecies;
import wyqy.agriculture.service.ICropSpeciesService;

/**
 * 作物种类Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
@Service
public class CropSpeciesServiceImpl implements ICropSpeciesService 
{
    @Autowired
    private CropSpeciesMapper cropSpeciesMapper;

    /**
     * 查询作物种类
     * 
     * @param speciesId 作物种类主键
     * @return 作物种类
     */
    @Override
    public CropSpecies selectCropSpeciesBySpeciesId(Long speciesId)
    {
        return cropSpeciesMapper.selectCropSpeciesBySpeciesId(speciesId);
    }

    /**
     * 查询作物种类列表
     * 
     * @param cropSpecies 作物种类
     * @return 作物种类
     */
    @Override
    public List<CropSpecies> selectCropSpeciesList(CropSpecies cropSpecies)
    {
        return cropSpeciesMapper.selectCropSpeciesList(cropSpecies);
    }

    /**
     * 新增作物种类
     * 
     * @param cropSpecies 作物种类
     * @return 结果
     */
    @Override
    public int insertCropSpecies(CropSpecies cropSpecies)
    {
        cropSpecies.setCreateTime(DateUtils.getNowDate());
        return cropSpeciesMapper.insertCropSpecies(cropSpecies);
    }

    /**
     * 修改作物种类
     * 
     * @param cropSpecies 作物种类
     * @return 结果
     */
    @Override
    public int updateCropSpecies(CropSpecies cropSpecies)
    {
        cropSpecies.setUpdateTime(DateUtils.getNowDate());
        return cropSpeciesMapper.updateCropSpecies(cropSpecies);
    }

    /**
     * 批量删除作物种类
     * 
     * @param speciesIds 需要删除的作物种类主键
     * @return 结果
     */
    @Override
    public int deleteCropSpeciesBySpeciesIds(Long[] speciesIds)
    {
        // 检查是否有种植记录引用这些作物种类
        for (Long speciesId : speciesIds) {
            int count = cropSpeciesMapper.countPlantingRecordsBySpeciesId(speciesId);
            if (count > 0) {
                CropSpecies crop = cropSpeciesMapper.selectCropSpeciesBySpeciesId(speciesId);
                String cropName = crop != null ? crop.getSpeciesName() : "ID:" + speciesId;
                throw new RuntimeException("无法删除作物种类【" + cropName + "】，该作物种类已被 " + count + " 条种植记录引用，请先删除相关的种植记录");
            }
        }
        return cropSpeciesMapper.deleteCropSpeciesBySpeciesIds(speciesIds);
    }

    /**
     * 删除作物种类信息
     * 
     * @param speciesId 作物种类主键
     * @return 结果
     */
    @Override
    public int deleteCropSpeciesBySpeciesId(Long speciesId)
    {
        return cropSpeciesMapper.deleteCropSpeciesBySpeciesId(speciesId);
    }

    /**
     * 获取作物分类统计信息
     * 
     * @return 分类统计信息
     */
    @Override
    public Object getCategoryStats()
    {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取所有作物种类
        List<CropSpecies> allCrops = cropSpeciesMapper.selectCropSpeciesList(new CropSpecies());
        
        // 按类别统计
        Map<String, Long> categoryCount = new HashMap<>();
        allCrops.forEach(crop -> {
            String category = crop.getCategory();
            if (category != null) {
                categoryCount.put(category, categoryCount.getOrDefault(category, 0L) + 1);
            }
        });
        stats.put("categoryCount", categoryCount);
        
        // 计算总数
        stats.put("total", allCrops.size());
        
        return stats;
    }

    /**
     * 获取作物种类统计信息
     * 
     * @return 统计信息
     */
    @Override
    public Object getCropStats()
    {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取总作物种类数
        List<CropSpecies> allCrops = cropSpeciesMapper.selectCropSpeciesList(new CropSpecies());
        stats.put("totalSpecies", allCrops.size());
        
        // 按类别统计
        Map<String, Long> categoryCount = new HashMap<>();
        allCrops.forEach(crop -> {
            String category = crop.getCategory();
            if (category != null) {
                categoryCount.put(category, categoryCount.getOrDefault(category, 0L) + 1);
            }
        });
        stats.put("categoryStats", categoryCount);
        
        // 计算平均生长周期
        double avgGrowthCycle = allCrops.stream()
            .filter(crop -> crop.getGrowthCycle() != null)
            .mapToInt(CropSpecies::getGrowthCycle)
            .average()
            .orElse(0.0);
        stats.put("avgGrowthCycle", Math.round(avgGrowthCycle));
        
        // 计算平均预估产量
        double avgYield = allCrops.stream()
            .filter(crop -> crop.getEstimatedYield() != null)
            .mapToDouble(CropSpecies::getEstimatedYield)
            .average()
            .orElse(0.0);
        stats.put("avgYield", Math.round(avgYield * 100.0) / 100.0);
        
        return stats;
    }
}
