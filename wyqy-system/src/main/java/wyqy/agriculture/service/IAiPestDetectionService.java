package wyqy.agriculture.service;

import java.util.List;
import java.util.Map;
import wyqy.agriculture.domain.AiPestDetection;

/**
 * AI病虫害识别Service接口
 * 
 * @author ruoyi
 * @date 2025-01-30
 */
public interface IAiPestDetectionService 
{
    /**
     * 查询AI病虫害识别
     * 
     * @param detectionId AI病虫害识别主键
     * @return AI病虫害识别
     */
    public AiPestDetection selectAiPestDetectionByDetectionId(Long detectionId);

    /**
     * 查询AI病虫害识别列表
     * 
     * @param aiPestDetection AI病虫害识别
     * @return AI病虫害识别集合
     */
    public List<AiPestDetection> selectAiPestDetectionList(AiPestDetection aiPestDetection);

    /**
     * 新增AI病虫害识别
     * 
     * @param aiPestDetection AI病虫害识别
     * @return 结果
     */
    public int insertAiPestDetection(AiPestDetection aiPestDetection);

    /**
     * 修改AI病虫害识别
     * 
     * @param aiPestDetection AI病虫害识别
     * @return 结果
     */
    public int updateAiPestDetection(AiPestDetection aiPestDetection);

    /**
     * 批量删除AI病虫害识别
     * 
     * @param detectionIds 需要删除的AI病虫害识别主键集合
     * @return 结果
     */
    public int deleteAiPestDetectionByDetectionIds(Long[] detectionIds);

    /**
     * 删除AI病虫害识别信息
     * 
     * @param detectionId AI病虫害识别主键
     * @return 结果
     */
    public int deleteAiPestDetectionByDetectionId(Long detectionId);
    
    /**
     * 获取识别统计信息
     * 
     * @return 统计信息
     */
    public Map<String, Object> getDetectionStats();
    
    /**
     * 标记为已处理
     * 
     * @param detectionId 识别ID
     * @return 结果
     */
    public int markAsProcessed(Long detectionId);
}
