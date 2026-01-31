package wyqy.agriculture.mapper;

import java.util.List;
import wyqy.agriculture.domain.AiPestDetection;

/**
 * AI病虫害识别Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-30
 */
public interface AiPestDetectionMapper 
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
     * 删除AI病虫害识别
     * 
     * @param detectionId AI病虫害识别主键
     * @return 结果
     */
    public int deleteAiPestDetectionByDetectionId(Long detectionId);

    /**
     * 批量删除AI病虫害识别
     * 
     * @param detectionIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteAiPestDetectionByDetectionIds(Long[] detectionIds);
    
    /**
     * 统计总识别次数
     * 
     * @return 结果
     */
    public int countTotalDetections();
    
    /**
     * 根据类型统计识别次数
     * 
     * @param detectionType 识别类型
     * @return 结果
     */
    public int countDetectionsByType(String detectionType);
    
    /**
     * 根据状态统计识别次数
     * 
     * @param processStatus 处理状态
     * @return 结果
     */
    public int countDetectionsByStatus(String processStatus);
    
    /**
     * 统计已处理数量
     * 
     * @return 结果
     */
    public int countProcessedDetections();
    
    /**
     * 统计今日识别数量
     * 
     * @return 结果
     */
    public int countTodayDetections();
    
    /**
     * 标记为已处理
     * 
     * @param detectionId 识别ID
     * @return 结果
     */
    public int markAsProcessed(Long detectionId);
}
