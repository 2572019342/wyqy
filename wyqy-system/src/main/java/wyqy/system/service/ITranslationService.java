package wyqy.system.service;

import wyqy.system.domain.TranslationRecord;
import wyqy.system.domain.TranslationCorpus;
import wyqy.system.domain.vo.TranslationRequest;
import wyqy.system.domain.vo.TranslationResponse;

import java.util.List;

/**
 * 翻译服务接口
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public interface ITranslationService 
{
    /**
     * 执行翻译
     * 
     * @param request 翻译请求
     * @param ipAddress IP地址
     * @param browser 浏览器信息
     * @param os 操作系统信息
     * @return 翻译响应
     */
    TranslationResponse translate(TranslationRequest request, String ipAddress, String browser, String os);

    /**
     * 查询翻译记录
     * 
     * @param recordId 翻译记录主键
     * @return 翻译记录
     */
    public TranslationRecord selectTranslationRecordByRecordId(Long recordId);

    /**
     * 查询翻译记录列表
     * 
     * @param translationRecord 翻译记录
     * @return 翻译记录集合
     */
    public List<TranslationRecord> selectTranslationRecordList(TranslationRecord translationRecord);

    /**
     * 新增翻译记录
     * 
     * @param translationRecord 翻译记录
     * @return 结果
     */
    public int insertTranslationRecord(TranslationRecord translationRecord);

    /**
     * 删除翻译记录
     * 
     * @param recordId 翻译记录主键
     * @return 结果
     */
    public int deleteTranslationRecordByRecordId(Long recordId);

    /**
     * 批量删除翻译记录
     * 
     * @param recordIds 需要删除的翻译记录主键
     * @return 结果
     */
    public int deleteTranslationRecordByRecordIds(Long[] recordIds);

    /**
     * 查询语料库
     * 
     * @param corpusId 语料库主键
     * @return 语料库
     */
    public TranslationCorpus selectTranslationCorpusByCorpusId(Long corpusId);

    /**
     * 查询语料库列表
     * 
     * @param translationCorpus 语料库
     * @return 语料库集合
     */
    public List<TranslationCorpus> selectTranslationCorpusList(TranslationCorpus translationCorpus);

    /**
     * 新增语料库
     * 
     * @param translationCorpus 语料库
     * @return 结果
     */
    public int insertTranslationCorpus(TranslationCorpus translationCorpus);

    /**
     * 修改语料库
     * 
     * @param translationCorpus 语料库
     * @return 结果
     */
    public int updateTranslationCorpus(TranslationCorpus translationCorpus);

    /**
     * 批量删除语料库
     * 
     * @param corpusIds 需要删除的语料库主键
     * @return 结果
     */
    public int deleteTranslationCorpusByCorpusIds(Long[] corpusIds);

    /**
     * 根据用户ID查询翻译历史
     * 
     * @param userId 用户ID
     * @param limit 限制数量
     * @return 翻译记录列表
     */
    public List<TranslationRecord> getTranslationHistory(Long userId, Integer limit);
}
