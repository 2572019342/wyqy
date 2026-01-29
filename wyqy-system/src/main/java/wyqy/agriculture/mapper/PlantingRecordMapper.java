package wyqy.agriculture.mapper;

import java.util.List;
import wyqy.agriculture.domain.PlantingRecord;

/**
 * 种植记录Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public interface PlantingRecordMapper 
{
    /**
     * 查询种植记录
     * 
     * @param plantingId 种植记录主键
     * @return 种植记录
     */
    public PlantingRecord selectPlantingRecordByPlantingId(Long plantingId);

    /**
     * 查询种植记录列表
     * 
     * @param plantingRecord 种植记录
     * @return 种植记录集合
     */
    public List<PlantingRecord> selectPlantingRecordList(PlantingRecord plantingRecord);

    /**
     * 新增种植记录
     * 
     * @param plantingRecord 种植记录
     * @return 结果
     */
    public int insertPlantingRecord(PlantingRecord plantingRecord);

    /**
     * 修改种植记录
     * 
     * @param plantingRecord 种植记录
     * @return 结果
     */
    public int updatePlantingRecord(PlantingRecord plantingRecord);

    /**
     * 删除种植记录
     * 
     * @param plantingId 种植记录主键
     * @return 结果
     */
    public int deletePlantingRecordByPlantingId(Long plantingId);

    /**
     * 批量删除种植记录
     * 
     * @param plantingIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deletePlantingRecordByPlantingIds(Long[] plantingIds);
}
