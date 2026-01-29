package wyqy.agriculture.mapper;

import java.util.List;
import wyqy.agriculture.domain.FarmingManagement;

/**
 * 种植管理Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public interface FarmingManagementMapper 
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
     * 删除种植管理
     * 
     * @param farmingId 种植管理主键
     * @return 结果
     */
    public int deleteFarmingManagementByFarmingId(Long farmingId);

    /**
     * 批量删除种植管理
     * 
     * @param farmingIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteFarmingManagementByFarmingIds(Long[] farmingIds);

    /**
     * 根据种植记录ID批量删除种植管理
     * 
     * @param plantingIds 种植记录ID数组
     * @return 结果
     */
    public int deleteFarmingManagementByPlantingIds(Long[] plantingIds);
}
