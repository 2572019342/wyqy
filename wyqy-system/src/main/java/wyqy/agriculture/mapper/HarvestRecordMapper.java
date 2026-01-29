package wyqy.agriculture.mapper;

import java.util.List;
import wyqy.agriculture.domain.HarvestRecord;

/**
 * 采摘记录Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public interface HarvestRecordMapper 
{
    /**
     * 查询采摘记录
     * 
     * @param harvestId 采摘记录主键
     * @return 采摘记录
     */
    public HarvestRecord selectHarvestRecordByHarvestId(Long harvestId);

    /**
     * 查询采摘记录列表
     * 
     * @param harvestRecord 采摘记录
     * @return 采摘记录集合
     */
    public List<HarvestRecord> selectHarvestRecordList(HarvestRecord harvestRecord);

    /**
     * 新增采摘记录
     * 
     * @param harvestRecord 采摘记录
     * @return 结果
     */
    public int insertHarvestRecord(HarvestRecord harvestRecord);

    /**
     * 修改采摘记录
     * 
     * @param harvestRecord 采摘记录
     * @return 结果
     */
    public int updateHarvestRecord(HarvestRecord harvestRecord);

    /**
     * 删除采摘记录
     * 
     * @param harvestId 采摘记录主键
     * @return 结果
     */
    public int deleteHarvestRecordByHarvestId(Long harvestId);

    /**
     * 批量删除采摘记录
     * 
     * @param harvestIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteHarvestRecordByHarvestIds(Long[] harvestIds);

    /**
     * 查询已采摘的种植ID列表
     * 
     * @return 已采摘的种植ID列表
     */
    public List<Long> selectHarvestedPlantingIds();

    /**
     * 根据种植记录ID批量删除采摘记录
     * 
     * @param plantingIds 种植记录ID数组
     * @return 结果
     */
    public int deleteHarvestRecordByPlantingIds(Long[] plantingIds);
}
