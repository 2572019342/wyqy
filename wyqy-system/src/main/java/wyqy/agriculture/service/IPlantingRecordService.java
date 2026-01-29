package wyqy.agriculture.service;

import java.util.List;
import wyqy.agriculture.domain.PlantingRecord;

/**
 * 种植记录Service接口
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public interface IPlantingRecordService 
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
     * 批量删除种植记录
     * 
     * @param plantingIds 需要删除的种植记录主键集合
     * @return 结果
     */
    public int deletePlantingRecordByPlantingIds(Long[] plantingIds);

    /**
     * 删除种植记录信息
     * 
     * @param plantingId 种植记录主键
     * @return 结果
     */
    public int deletePlantingRecordByPlantingId(Long plantingId);

    /**
     * 获取种植统计信息
     * 
     * @return 统计信息
     */
    public Object getPlantingStats();

    /**
     * 获取地块种植信息
     * 
     * @param landId 地块ID
     * @return 种植信息
     */
    public Object getLandPlantingInfo(Long landId);

    /**
     * 更新生长状态
     * 
     * @param plantingRecord 种植记录
     * @return 结果
     */
    public int updateGrowthStatus(PlantingRecord plantingRecord);
}