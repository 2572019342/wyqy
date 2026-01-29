package wyqy.agriculture.service;

import java.util.List;
import wyqy.agriculture.domain.FarmingManagement;

/**
 * 种植管理Service接口
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public interface IFarmingManagementService 
{
    /**
     * 查询种植管理
     * 
     * @param farmingId 种植管理主键
     * @return 种植管理
     */
    public FarmingManagement selectFarmingManagementByFarmingId(Long farmingId);

    /**
     * 查询种植管理列表
     * 
     * @param farmingManagement 种植管理
     * @return 种植管理集合
     */
    public List<FarmingManagement> selectFarmingManagementList(FarmingManagement farmingManagement);

    /**
     * 新增种植管理
     * 
     * @param farmingManagement 种植管理
     * @return 结果
     */
    public int insertFarmingManagement(FarmingManagement farmingManagement);

    /**
     * 修改种植管理
     * 
     * @param farmingManagement 种植管理
     * @return 结果
     */
    public int updateFarmingManagement(FarmingManagement farmingManagement);

    /**
     * 批量删除种植管理
     * 
     * @param farmingIds 需要删除的种植管理主键集合
     * @return 结果
     */
    public int deleteFarmingManagementByFarmingIds(Long[] farmingIds);

    /**
     * 删除种植管理信息
     * 
     * @param farmingId 种植管理主键
     * @return 结果
     */
    public int deleteFarmingManagementByFarmingId(Long farmingId);

    /**
     * 获取种植管理统计信息
     * 
     * @return 统计信息
     */
    public Object getFarmingStats();

    /**
     * 获取种植农事历史
     * 
     * @param plantingId 种植ID
     * @return 农事历史
     */
    public List<FarmingManagement> getPlantingFarmingHistory(Long plantingId);
}
