package wyqy.agriculture.service;

import java.util.List;
import wyqy.agriculture.domain.CropSpecies;

/**
 * 作物种类Service接口
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public interface ICropSpeciesService 
{
    /**
     * 查询作物种类
     * 
     * @param speciesId 作物种类主键
     * @return 作物种类
     */
    public CropSpecies selectCropSpeciesBySpeciesId(Long speciesId);

    /**
     * 查询作物种类列表
     * 
     * @param cropSpecies 作物种类
     * @return 作物种类集合
     */
    public List<CropSpecies> selectCropSpeciesList(CropSpecies cropSpecies);

    /**
     * 新增作物种类
     * 
     * @param cropSpecies 作物种类
     * @return 结果
     */
    public int insertCropSpecies(CropSpecies cropSpecies);

    /**
     * 修改作物种类
     * 
     * @param cropSpecies 作物种类
     * @return 结果
     */
    public int updateCropSpecies(CropSpecies cropSpecies);

    /**
     * 批量删除作物种类
     * 
     * @param speciesIds 需要删除的作物种类主键集合
     * @return 结果
     */
    public int deleteCropSpeciesBySpeciesIds(Long[] speciesIds);

    /**
     * 删除作物种类信息
     * 
     * @param speciesId 作物种类主键
     * @return 结果
     */
    public int deleteCropSpeciesBySpeciesId(Long speciesId);

    /**
     * 获取作物分类统计信息
     * 
     * @return 分类统计信息
     */
    public Object getCategoryStats();

    /**
     * 获取作物统计信息
     * 
     * @return 统计信息
     */
    public Object getCropStats();
}