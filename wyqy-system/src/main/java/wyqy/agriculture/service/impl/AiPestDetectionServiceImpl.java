package wyqy.agriculture.service.impl;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import wyqy.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyqy.agriculture.mapper.AiPestDetectionMapper;
import wyqy.agriculture.domain.AiPestDetection;
import wyqy.agriculture.service.IAiPestDetectionService;

/**
 * AI病虫害识别Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-01-30
 */
@Service
public class AiPestDetectionServiceImpl implements IAiPestDetectionService 
{
    @Autowired
    private AiPestDetectionMapper aiPestDetectionMapper;

    /**
     * 查询AI病虫害识别
     * 
     * @param detectionId AI病虫害识别主键
     * @return AI病虫害识别
     */
    @Override
    public AiPestDetection selectAiPestDetectionByDetectionId(Long detectionId)
    {
        return aiPestDetectionMapper.selectAiPestDetectionByDetectionId(detectionId);
    }

    /**
     * 查询AI病虫害识别列表
     * 
     * @param aiPestDetection AI病虫害识别
     * @return AI病虫害识别
     */
    @Override
    public List<AiPestDetection> selectAiPestDetectionList(AiPestDetection aiPestDetection)
    {
        return aiPestDetectionMapper.selectAiPestDetectionList(aiPestDetection);
    }

    /**
     * 新增AI病虫害识别
     * 
     * @param aiPestDetection AI病虫害识别
     * @return 结果
     */
    @Override
    public int insertAiPestDetection(AiPestDetection aiPestDetection)
    {
        aiPestDetection.setCreateTime(DateUtils.getNowDate());
        return aiPestDetectionMapper.insertAiPestDetection(aiPestDetection);
    }

    /**
     * 修改AI病虫害识别
     * 
     * @param aiPestDetection AI病虫害识别
     * @return 结果
     */
    @Override
    public int updateAiPestDetection(AiPestDetection aiPestDetection)
    {
        aiPestDetection.setUpdateTime(DateUtils.getNowDate());
        return aiPestDetectionMapper.updateAiPestDetection(aiPestDetection);
    }

    /**
     * 批量删除AI病虫害识别
     * 
     * @param detectionIds 需要删除的AI病虫害识别主键
     * @return 结果
     */
    @Override
    public int deleteAiPestDetectionByDetectionIds(Long[] detectionIds)
    {
        return aiPestDetectionMapper.deleteAiPestDetectionByDetectionIds(detectionIds);
    }

    /**
     * 删除AI病虫害识别信息
     * 
     * @param detectionId AI病虫害识别主键
     * @return 结果
     */
    @Override
    public int deleteAiPestDetectionByDetectionId(Long detectionId)
    {
        return aiPestDetectionMapper.deleteAiPestDetectionByDetectionId(detectionId);
    }
    
    /**
     * 获取识别统计信息
     * 
     * @return 统计信息
     */
    @Override
    public Map<String, Object> getDetectionStats()
    {
        Map<String, Object> stats = new HashMap<>();
        
        // 总识别次数
        int totalDetections = aiPestDetectionMapper.countTotalDetections();
        stats.put("totalDetections", totalDetections);
        
        // 病害识别次数
        int diseaseDetections = aiPestDetectionMapper.countDetectionsByType("disease");
        stats.put("diseaseDetections", diseaseDetections);
        
        // 虫害识别次数
        int pestDetections = aiPestDetectionMapper.countDetectionsByType("pest");
        stats.put("pestDetections", pestDetections);
        
        // 健康识别次数
        int healthyDetections = aiPestDetectionMapper.countDetectionsByType("healthy");
        stats.put("healthyDetections", healthyDetections);
        
        // 待处理数量
        int pendingCount = aiPestDetectionMapper.countDetectionsByStatus("pending");
        stats.put("pendingCount", pendingCount);
        
        // 已处理数量
        int processedCount = aiPestDetectionMapper.countProcessedDetections();
        stats.put("processedCount", processedCount);
        
        // 今日识别数量
        int todayCount = aiPestDetectionMapper.countTodayDetections();
        stats.put("todayCount", todayCount);
        
        return stats;
    }
    
    /**
     * 标记为已处理
     * 
     * @param detectionId 识别ID
     * @return 结果
     */
    @Override
    public int markAsProcessed(Long detectionId)
    {
        return aiPestDetectionMapper.markAsProcessed(detectionId);
    }
}
