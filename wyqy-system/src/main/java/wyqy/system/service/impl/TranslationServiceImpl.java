package wyqy.system.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.regex.Pattern;

import wyqy.common.utils.DateUtils;
import wyqy.common.utils.SecurityUtils;
import wyqy.common.utils.StringUtils;
import wyqy.common.utils.ip.IpUtils;
import wyqy.common.utils.http.UserAgentUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyqy.system.mapper.TranslationRecordMapper;
import wyqy.system.mapper.TranslationCorpusMapper;
import wyqy.system.domain.TranslationRecord;
import wyqy.system.domain.TranslationCorpus;
import wyqy.system.domain.vo.TranslationRequest;
import wyqy.system.domain.vo.TranslationResponse;
import wyqy.system.service.ITranslationService;

/**
 * 翻译服务业务层处理
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
@Service
public class TranslationServiceImpl implements ITranslationService 
{
    @Autowired
    private TranslationRecordMapper translationRecordMapper;

    @Autowired
    private TranslationCorpusMapper translationCorpusMapper;

    /**
     * 执行翻译
     * 
     * @param request 翻译请求
     * @param ipAddress IP地址
     * @param browser 浏览器信息
     * @param os 操作系统信息
     * @return 翻译响应
     */
    @Override
    public TranslationResponse translate(TranslationRequest request, String ipAddress, String browser, String os) {
        long startTime = System.currentTimeMillis();
        TranslationResponse response = new TranslationResponse();
        String requestId = UUID.randomUUID().toString().replace("-", "");
        
        try {
            response.setRequestId(requestId);
            response.setSourceText(request.getSourceText());
            response.setSourceLanguage(request.getSourceLanguage());
            response.setTargetLanguage(request.getTargetLanguage());
            
            // 直接进行简单翻译，不查询数据库
            List<TranslationResponse.CorpusMatch> corpusMatches = new ArrayList<>();
            String translatedText = simulateAutoTranslation(request.getSourceText());
            
            response.setTargetText(translatedText);
            response.setCorpusMatches(corpusMatches);
            response.setCorpusHitRate(0.0);
            response.setConfidenceScore(0.8);
            response.setStatus("0");
            
            // 记录翻译历史
            TranslationRecord record = createTranslationRecord(request, response, startTime, ipAddress, browser, os);
            translationRecordMapper.insertTranslationRecord(record);
            
        } catch (Exception e) {
            response.setStatus("1");
            response.setErrorMessage("翻译失败: " + e.getMessage());
        }
        
        response.setProcessingTime(System.currentTimeMillis() - startTime);
        return response;
    }

    /**
     * 模拟翻译逻辑
     */
    private String simulateTranslation(String sourceText, List<TranslationCorpus> matchingCorpus, List<TranslationResponse.CorpusMatch> corpusMatches) {
        // 如果有完全匹配的语料库，直接使用
        for (TranslationCorpus corpus : matchingCorpus) {
            if (sourceText.trim().equalsIgnoreCase(corpus.getSourceText().trim())) {
                TranslationResponse.CorpusMatch match = new TranslationResponse.CorpusMatch();
                match.setCorpusId(corpus.getCorpusId());
                match.setSourceText(corpus.getSourceText());
                match.setTargetText(corpus.getTargetText());
                match.setMatchScore(1.0);
                corpusMatches.add(match);
                
                // 增加使用次数
                translationCorpusMapper.increaseUsageCount(corpus.getCorpusId());
                return corpus.getTargetText();
            }
        }
        
        // 模拟翻译（实际项目中这里会调用真实的翻译API）
        return simulateAutoTranslation(sourceText);
    }

    /**
     * 模拟自动翻译
     */
    private String simulateAutoTranslation(String sourceText) {
        // 简单的模拟翻译逻辑
        if (sourceText.toLowerCase().contains("hello")) {
            return sourceText.toLowerCase().replace("hello", "你好");
        } else if (sourceText.toLowerCase().contains("thank")) {
            return sourceText.toLowerCase().replace("thank", "谢谢");
        } else if (sourceText.toLowerCase().contains("good")) {
            return sourceText.toLowerCase().replace("good", "好的");
        } else if (sourceText.toLowerCase().contains("please")) {
            return sourceText.toLowerCase().replace("please", "请");
        } else {
            // 直接返回原文，不添加任何前缀
            return sourceText;
        }
    }

    /**
     * 计算置信度评分
     */
    private Double calculateConfidenceScore(List<TranslationResponse.CorpusMatch> corpusMatches) {
        if (corpusMatches.isEmpty()) {
            return 0.7; // 默认置信度
        }
        
        double totalScore = 0.0;
        for (TranslationResponse.CorpusMatch match : corpusMatches) {
            totalScore += match.getMatchScore();
        }
        
        return Math.min(0.99, totalScore / corpusMatches.size() + 0.2);
    }

    /**
     * 创建翻译记录
     */
    private TranslationRecord createTranslationRecord(TranslationRequest request, TranslationResponse response, long startTime, String ipAddress, String browser, String os) {
        TranslationRecord record = new TranslationRecord();
        record.setRequestId(response.getRequestId());
        record.setSourceText(request.getSourceText());
        record.setTargetText(response.getTargetText());
        record.setSourceLanguage(request.getSourceLanguage());
        record.setTargetLanguage(request.getTargetLanguage());
        record.setTranslationType(request.getTranslationType());
        record.setProcessingTime(System.currentTimeMillis() - startTime);
        record.setConfidenceScore(response.getConfidenceScore());
        record.setStatus(response.getStatus());
        record.setErrorMessage(response.getErrorMessage());
        
        // 获取用户信息
        try {
            Long userId = SecurityUtils.getUserId();
            String userName = SecurityUtils.getUsername();
            record.setUserId(userId);
            record.setUserName(userName);
        } catch (Exception e) {
            // 获取用户信息失败，使用默认值
            record.setUserId(0L);
            record.setUserName("anonymous");
        }
        
        // 设置请求信息
        record.setIpAddress(ipAddress != null ? ipAddress : "Unknown");
        record.setBrowser(browser != null ? browser : "Unknown");
        record.setOs(os != null ? os : "Unknown");
        
        record.setCreateTime(new Date());
        record.setDelFlag("0");
        
        return record;
    }

    /**
     * 查询翻译记录
     * 
     * @param recordId 翻译记录主键
     * @return 翻译记录
     */
    @Override
    public TranslationRecord selectTranslationRecordByRecordId(Long recordId)
    {
        return translationRecordMapper.selectTranslationRecordByRecordId(recordId);
    }

    /**
     * 查询翻译记录列表
     * 
     * @param translationRecord 翻译记录
     * @return 翻译记录
     */
    @Override
    public List<TranslationRecord> selectTranslationRecordList(TranslationRecord translationRecord)
    {
        return translationRecordMapper.selectTranslationRecordList(translationRecord);
    }

    /**
     * 新增翻译记录
     * 
     * @param translationRecord 翻译记录
     * @return 结果
     */
    @Override
    public int insertTranslationRecord(TranslationRecord translationRecord)
    {
        translationRecord.setCreateTime(DateUtils.getNowDate());
        return translationRecordMapper.insertTranslationRecord(translationRecord);
    }

    /**
     * 修改翻译记录
     * 
     * @param translationRecord 翻译记录
     * @return 结果
     */
    public int updateTranslationRecord(TranslationRecord translationRecord)
    {
        return translationRecordMapper.updateTranslationRecord(translationRecord);
    }

    /**
     * 批量删除翻译记录
     * 
     * @param recordIds 需要删除的翻译记录主键
     * @return 结果
     */
    @Override
    public int deleteTranslationRecordByRecordIds(Long[] recordIds)
    {
        return translationRecordMapper.deleteTranslationRecordByRecordIds(recordIds);
    }

    /**
     * 删除翻译记录信息
     * 
     * @param recordId 翻译记录主键
     * @return 结果
     */
    @Override
    public int deleteTranslationRecordByRecordId(Long recordId)
    {
        return translationRecordMapper.deleteTranslationRecordByRecordId(recordId);
    }

    /**
     * 查询语料库
     * 
     * @param corpusId 语料库主键
     * @return 语料库
     */
    @Override
    public TranslationCorpus selectTranslationCorpusByCorpusId(Long corpusId)
    {
        return translationCorpusMapper.selectTranslationCorpusByCorpusId(corpusId);
    }

    /**
     * 查询语料库列表
     * 
     * @param translationCorpus 语料库
     * @return 语料库
     */
    @Override
    public List<TranslationCorpus> selectTranslationCorpusList(TranslationCorpus translationCorpus)
    {
        return translationCorpusMapper.selectTranslationCorpusList(translationCorpus);
    }

    /**
     * 新增语料库
     * 
     * @param translationCorpus 语料库
     * @return 结果
     */
    @Override
    public int insertTranslationCorpus(TranslationCorpus translationCorpus)
    {
        translationCorpus.setCreateTime(DateUtils.getNowDate());
        return translationCorpusMapper.insertTranslationCorpus(translationCorpus);
    }

    /**
     * 修改语料库
     * 
     * @param translationCorpus 语料库
     * @return 结果
     */
    @Override
    public int updateTranslationCorpus(TranslationCorpus translationCorpus)
    {
        return translationCorpusMapper.updateTranslationCorpus(translationCorpus);
    }

    /**
     * 批量删除语料库
     * 
     * @param corpusIds 需要删除的语料库主键
     * @return 结果
     */
    @Override
    public int deleteTranslationCorpusByCorpusIds(Long[] corpusIds)
    {
        return translationCorpusMapper.deleteTranslationCorpusByCorpusIds(corpusIds);
    }

    /**
     * 根据用户ID查询翻译历史
     * 
     * @param userId 用户ID
     * @param limit 限制数量
     * @return 翻译记录列表
     */
    @Override
    public List<TranslationRecord> getTranslationHistory(Long userId, Integer limit)
    {
        return translationRecordMapper.selectTranslationRecordByUserId(userId, limit);
    }
}
