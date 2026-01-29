package wyqy.system.domain.vo;

import java.util.List;

/**
 * 翻译响应对象
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public class TranslationResponse
{
    /** 请求ID */
    private String requestId;

    /** 原文 */
    private String sourceText;

    /** 译文 */
    private String targetText;

    /** 源语言 */
    private String sourceLanguage;

    /** 目标语言 */
    private String targetLanguage;

    /** 置信度评分 */
    private Double confidenceScore;

    /** 处理时间（毫秒） */
    private Long processingTime;

    /** 使用的语料库片段 */
    private List<CorpusMatch> corpusMatches;

    /** 语料库命中率 */
    private Double corpusHitRate;

    /** 状态 */
    private String status;

    /** 错误信息 */
    private String errorMessage;

    public static class CorpusMatch {
        /** 语料库ID */
        private Long corpusId;
        
        /** 匹配的原文 */
        private String sourceText;
        
        /** 对应的译文 */
        private String targetText;
        
        /** 匹配度 */
        private Double matchScore;

        public Long getCorpusId() {
            return corpusId;
        }

        public void setCorpusId(Long corpusId) {
            this.corpusId = corpusId;
        }

        public String getSourceText() {
            return sourceText;
        }

        public void setSourceText(String sourceText) {
            this.sourceText = sourceText;
        }

        public String getTargetText() {
            return targetText;
        }

        public void setTargetText(String targetText) {
            this.targetText = targetText;
        }

        public Double getMatchScore() {
            return matchScore;
        }

        public void setMatchScore(Double matchScore) {
            this.matchScore = matchScore;
        }
    }

    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }

    public String getSourceText() {
        return sourceText;
    }

    public void setSourceText(String sourceText) {
        this.sourceText = sourceText;
    }

    public String getTargetText() {
        return targetText;
    }

    public void setTargetText(String targetText) {
        this.targetText = targetText;
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

    public Double getConfidenceScore() {
        return confidenceScore;
    }

    public void setConfidenceScore(Double confidenceScore) {
        this.confidenceScore = confidenceScore;
    }

    public Long getProcessingTime() {
        return processingTime;
    }

    public void setProcessingTime(Long processingTime) {
        this.processingTime = processingTime;
    }

    public List<CorpusMatch> getCorpusMatches() {
        return corpusMatches;
    }

    public void setCorpusMatches(List<CorpusMatch> corpusMatches) {
        this.corpusMatches = corpusMatches;
    }

    public Double getCorpusHitRate() {
        return corpusHitRate;
    }

    public void setCorpusHitRate(Double corpusHitRate) {
        this.corpusHitRate = corpusHitRate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
}
