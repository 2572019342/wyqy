package wyqy.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import wyqy.common.annotation.Excel;
import wyqy.common.core.domain.BaseEntity;

/**
 * 语料库对象 translation_corpus
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public class TranslationCorpus extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 语料库ID */
    private Long corpusId;

    /** 原文 */
    @Excel(name = "原文")
    private String sourceText;

    /** 译文 */
    @Excel(name = "译文")
    private String targetText;

    /** 源语言 */
    @Excel(name = "源语言")
    private String sourceLanguage;

    /** 目标语言 */
    @Excel(name = "目标语言")
    private String targetLanguage;

    /** 领域类型 */
    @Excel(name = "领域类型")
    private String domainType;

    /** 使用次数 */
    @Excel(name = "使用次数")
    private Long usageCount;

    /** 准确度评分 */
    @Excel(name = "准确度评分")
    private Double accuracyScore;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    /** 删除标志（0代表存在 2代表删除） */
    private String delFlag;

    public void setCorpusId(Long corpusId) 
    {
        this.corpusId = corpusId;
    }

    public Long getCorpusId() 
    {
        return corpusId;
    }
    public void setSourceText(String sourceText) 
    {
        this.sourceText = sourceText;
    }

    public String getSourceText() 
    {
        return sourceText;
    }
    public void setTargetText(String targetText) 
    {
        this.targetText = targetText;
    }

    public String getTargetText() 
    {
        return targetText;
    }
    public void setSourceLanguage(String sourceLanguage) 
    {
        this.sourceLanguage = sourceLanguage;
    }

    public String getSourceLanguage() 
    {
        return sourceLanguage;
    }
    public void setTargetLanguage(String targetLanguage) 
    {
        this.targetLanguage = targetLanguage;
    }

    public String getTargetLanguage() 
    {
        return targetLanguage;
    }
    public void setDomainType(String domainType) 
    {
        this.domainType = domainType;
    }

    public String getDomainType() 
    {
        return domainType;
    }
    public void setUsageCount(Long usageCount) 
    {
        this.usageCount = usageCount;
    }

    public Long getUsageCount() 
    {
        return usageCount;
    }
    public void setAccuracyScore(Double accuracyScore) 
    {
        this.accuracyScore = accuracyScore;
    }

    public Double getAccuracyScore() 
    {
        return accuracyScore;
    }
    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }
    public void setDelFlag(String delFlag) 
    {
        this.delFlag = delFlag;
    }

    public String getDelFlag() 
    {
        return delFlag;
    }
}
