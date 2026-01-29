package wyqy.agriculture.service;

import java.util.List;
import wyqy.agriculture.domain.HarvestRecord;

/**
 * 采摘记录Service接口
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public interface IHarvestRecordService 
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
     * 批量删除采摘记录
     * 
     * @param harvestIds 需要删除的采摘记录主键集合
     * @return 结果
     */
    public int deleteHarvestRecordByHarvestIds(Long[] harvestIds);

    /**
     * 删除采摘记录信息
     * 
     * @param harvestId 采摘记录主键
     * @return 结果
     */
    public int deleteHarvestRecordByHarvestId(Long harvestId);

    /**
     * 获取采摘统计信息
     * 
     * @return 统计信息
     */
    public Object getHarvestStats();

    /**
     * 获取可采摘的种植记录
     * 
     * @return 可采摘的种植记录
     */
    public List<Object> getHarvestablePlantings();

    /**
     * 检查种植记录是否可以采摘
     * 
     * @param plantingId 种植ID
     * @return 检查结果
     */
    public Object checkHarvestable(Long plantingId);
}
