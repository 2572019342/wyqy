package wyqy.agriculture.mapper;

import java.util.List;
import wyqy.agriculture.domain.CropSpecies;

/**
 * 作物种类Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public interface CropSpeciesMapper 
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
     * 删除作物种类
     * 
     * @param speciesId 作物种类主键
     * @return 结果
     */
    public int deleteCropSpeciesBySpeciesId(Long speciesId);

    /**
     * 批量删除作物种类
     * 
     * @param speciesIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCropSpeciesBySpeciesIds(Long[] speciesIds);

    /**
     * 检查作物种类是否被种植记录引用
     * 
     * @param speciesId 作物种类主键
     * @return 引用数量
     */
    public int countPlantingRecordsBySpeciesId(Long speciesId);
}
