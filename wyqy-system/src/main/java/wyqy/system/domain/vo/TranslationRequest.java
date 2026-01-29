package wyqy.system.domain.vo;

import javax.validation.constraints.NotBlank;

/**
 * 翻译请求对象
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public class TranslationRequest
{
    /** 原文 */
    @NotBlank(message = "原文不能为空")
    private String sourceText;

    /** 源语言 */
    private String sourceLanguage = "auto";

    /** 目标语言 */
    private String targetLanguage = "zh";

    /** 领域类型 */
    private String domainType = "general";

    /** 翻译类型（auto自动 manual手动） */
    private String translationType = "auto";

    public String getSourceText() {
        return sourceText;
    }

    public void setSourceText(String sourceText) {
        this.sourceText = sourceText;
    }

    public String getSourceLanguage() {
        return sourceLanguage;
    }

    public void setSourceLanguage(String sourceLanguage) {
        this.sourceLanguage = sourceLanguage;
    }

    public String getTargetLanguage() {
        return targetLanguage;
    }

    public void setTargetLanguage(String targetLanguage) {
        this.targetLanguage = targetLanguage;
    }

    public String getDomainType() {
        return domainType;
    }

    public void setDomainType(String domainType) {
        this.domainType = domainType;
    }

    public String getTranslationType() {
        return translationType;
    }

    public void setTranslationType(String translationType) {
        this.translationType = translationType;
    }
}
