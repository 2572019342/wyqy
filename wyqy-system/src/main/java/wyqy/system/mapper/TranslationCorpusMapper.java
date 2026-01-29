package wyqy.system.mapper;

import org.apache.ibatis.annotations.Param;
import java.util.List;
import wyqy.system.domain.TranslationCorpus;

/**
 * 语料库Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public interface TranslationCorpusMapper 
{
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
     * 删除语料库
     * 
     * @param corpusId 语料库主键
     * @return 结果
     */
    public int deleteTranslationCorpusByCorpusId(Long corpusId);

    /**
     * 批量删除语料库
     * 
     * @param corpusIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteTranslationCorpusByCorpusIds(Long[] corpusIds);

    /**
     * 根据原文和语言查找匹配的语料库
     * 
     * @param sourceText 原文
     * @param sourceLanguage 源语言
     * @param targetLanguage 目标语言
     * @param domainType 领域类型
     * @return 匹配的语料库列表
     */
    public List<TranslationCorpus> selectMatchingCorpus(@Param("sourceText") String sourceText, 
                                                      @Param("sourceLanguage") String sourceLanguage, 
                                                      @Param("targetLanguage") String targetLanguage, 
                                                      @Param("domainType") String domainType);

    /**
     * 增加语料库使用次数
     * 
     * @param corpusId 语料库ID
     * @return 结果
     */
    public int increaseUsageCount(Long corpusId);
}
