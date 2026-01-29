package wyqy.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import wyqy.common.annotation.Excel;
import wyqy.common.core.domain.BaseEntity;

/**
 * 翻译记录对象 translation_record
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public class TranslationRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 记录ID */
    private Long recordId;

    /** 请求ID */
    @Excel(name = "请求ID")
    private String requestId;

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

    /** 翻译类型（auto自动 manual手动） */
    @Excel(name = "翻译类型", readConverterExp = "auto=自动,manual=手动")
    private String translationType;

    /** 使用的语料库片段（JSON格式） */
    @Excel(name = "使用的语料库片段")
    private String corpusUsed;

    /** 处理时间（毫秒） */
    @Excel(name = "处理时间")
    private Long processingTime;

    /** 置信度评分 */
    @Excel(name = "置信度评分")
    private Double confidenceScore;

    /** 用户ID */
    private Long userId;

    /** 用户名 */
    @Excel(name = "用户名")
    private String userName;

    /** IP地址 */
    @Excel(name = "IP地址")
    private String ipAddress;

    /** 浏览器 */
    @Excel(name = "浏览器")
    private String browser;

    /** 操作系统 */
    @Excel(name = "操作系统")
    private String os;

    /** 状态（0成功 1失败） */
    @Excel(name = "状态", readConverterExp = "0=成功,1=失败")
    private String status;

    /** 错误信息 */
    @Excel(name = "错误信息")
    private String errorMessage;

    /** 删除标志（0代表存在 2代表删除） */
    private String delFlag;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "创建时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    public void setRecordId(Long recordId) 
    {
        this.recordId = recordId;
    }

    public Long getRecordId() 
    {
        return recordId;
    }
    public void setRequestId(String requestId) 
    {
        this.requestId = requestId;
    }

    public String getRequestId() 
    {
        return requestId;
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
    public void setTranslationType(String translationType) 
    {
        this.translationType = translationType;
    }

    public String getTranslationType() 
    {
        return translationType;
    }
    public void setCorpusUsed(String corpusUsed) 
    {
        this.corpusUsed = corpusUsed;
    }

    public String getCorpusUsed() 
    {
        return corpusUsed;
    }
    public void setProcessingTime(Long processingTime) 
    {
        this.processingTime = processingTime;
    }

    public Long getProcessingTime() 
    {
        return processingTime;
    }
    public void setConfidenceScore(Double confidenceScore) 
    {
        this.confidenceScore = confidenceScore;
    }

    public Double getConfidenceScore() 
    {
        return confidenceScore;
    }
    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }
    public void setUserName(String userName) 
    {
        this.userName = userName;
    }

    public String getUserName() 
    {
        return userName;
    }
    public void setIpAddress(String ipAddress) 
    {
        this.ipAddress = ipAddress;
    }

    public String getIpAddress() 
    {
        return ipAddress;
    }
    public void setBrowser(String browser) 
    {
        this.browser = browser;
    }

    public String getBrowser() 
    {
        return browser;
    }
    public void setOs(String os) 
    {
        this.os = os;
    }

    public String getOs() 
    {
        return os;
    }
    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }
    public void setErrorMessage(String errorMessage) 
    {
        this.errorMessage = errorMessage;
    }

    public String getErrorMessage() 
    {
        return errorMessage;
    }
    public void setDelFlag(String delFlag) 
    {
        this.delFlag = delFlag;
    }

    public String getDelFlag() 
    {
        return delFlag;
    }
    public void setCreateTime(Date createTime) 
    {
        this.createTime = createTime;
    }

    public Date getCreateTime() 
    {
        return createTime;
    }
}
