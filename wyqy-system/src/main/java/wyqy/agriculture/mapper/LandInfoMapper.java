package wyqy.agriculture.mapper;

import java.util.List;
import wyqy.agriculture.domain.LandInfo;

/**
 * 地块信息Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public interface LandInfoMapper 
{
    /**
     * 查询地块信息
     * 
     * @param landId 地块信息主键
     * @return 地块信息
     */
    public LandInfo selectLandInfoByLandId(Long landId);

    /**
     * 查询地块信息列表
     * 
     * @param landInfo 地块信息
     * @return 地块信息集合
     */
    public List<LandInfo> selectLandInfoList(LandInfo landInfo);

    /**
     * 新增地块信息
     * 
     * @param landInfo 地块信息
     * @return 结果
     */
    public int insertLandInfo(LandInfo landInfo);

    /**
     * 修改地块信息
     * 
     * @param landInfo 地块信息
     * @return 结果
     */
    public int updateLandInfo(LandInfo landInfo);

    /**
     * 删除地块信息
     * 
     * @param landId 地块信息主键
     * @return 结果
     */
    public int deleteLandInfoByLandId(Long landId);

    /**
     * 批量删除地块信息
     * 
     * @param landIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteLandInfoByLandIds(Long[] landIds);
}
