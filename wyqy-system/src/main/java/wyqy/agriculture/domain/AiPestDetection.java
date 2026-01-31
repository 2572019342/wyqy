package wyqy.agriculture.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import wyqy.common.annotation.Excel;
import wyqy.common.core.domain.BaseEntity;

/**
 * AI病虫害识别对象 ai_pest_detection
 *
 * @author ruoyi
 * @date 2025-01-30
 */
public class AiPestDetection extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 识别ID */
    private Long detectionId;

    /** 地块ID */
    @Excel(name = "地块ID")
    private Long landId;

    /** 地块名称 */
    @Excel(name = "地块名称")
    private String landName;

    /** 作物ID */
    @Excel(name = "作物ID")
    private Long speciesId;

    /** 作物名称 */
    @Excel(name = "作物名称")
    private String speciesName;

    /** 识别类型 */
    @Excel(name = "识别类型", readConverterExp = "disease=病害,pest=虫害,healthy=健康")
    private String detectionType;

    /** 病虫害名称 */
    @Excel(name = "病虫害名称")
    private String pestName;

    /** 置信度 */
    @Excel(name = "置信度")
    private Double confidence;

    /** 图片路径 */
    @Excel(name = "图片路径")
    private String imagePath;

    /** 视频帧时间戳 */
    @Excel(name = "视频帧时间戳")
    private Long frameTimestamp;

    /** 处理状态 */
    @Excel(name = "处理状态", readConverterExp = "pending=待处理,processing=处理中,completed=已处理")
    private String processStatus;

    /** 推荐处理方案 */
    @Excel(name = "推荐处理方案")
    private String recommendation;

    /** 是否已处理 */
    @Excel(name = "是否已处理", readConverterExp = "0=未处理,1=已处理")
    private String isProcessed;

    /** 处理时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "处理时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date processTime;

    /** 处理人 */
    @Excel(name = "处理人")
    private String processBy;

    /** 识别时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "识别时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date detectionTime;

    public void setDetectionId(Long detectionId)
    {
        this.detectionId = detectionId;
    }

    public Long getDetectionId()
    {
        return detectionId;
    }
    public void setLandId(Long landId)
    {
        this.landId = landId;
    }

    public Long getLandId()
    {
        return landId;
    }
    public void setLandName(String landName)
    {
        this.landName = landName;
    }

    public String getLandName()
    {
        return landName;
    }
    public void setSpeciesId(Long speciesId)
    {
        this.speciesId = speciesId;
    }

    public Long getSpeciesId()
    {
        return speciesId;
    }
    public void setSpeciesName(String speciesName)
    {
        this.speciesName = speciesName;
    }

    public String getSpeciesName()
    {
        return speciesName;
    }
    public void setDetectionType(String detectionType)
    {
        this.detectionType = detectionType;
    }

    public String getDetectionType()
    {
        return detectionType;
    }
    public void setPestName(String pestName)
    {
        this.pestName = pestName;
    }

    public String getPestName()
    {
        return pestName;
    }
    public void setConfidence(Double confidence)
    {
        this.confidence = confidence;
    }

    public Double getConfidence()
    {
        return confidence;
    }
    public void setImagePath(String imagePath)
    {
        this.imagePath = imagePath;
    }

    public String getImagePath()
    {
        return imagePath;
    }
    public void setFrameTimestamp(Long frameTimestamp)
    {
        this.frameTimestamp = frameTimestamp;
    }

    public Long getFrameTimestamp()
    {
        return frameTimestamp;
    }
    public void setProcessStatus(String processStatus)
    {
        this.processStatus = processStatus;
    }

    public String getProcessStatus()
    {
        return processStatus;
    }
    public void setRecommendation(String recommendation)
    {
        this.recommendation = recommendation;
    }

    public String getRecommendation()
    {
        return recommendation;
    }
    public void setIsProcessed(String isProcessed)
    {
        this.isProcessed = isProcessed;
    }

    public String getIsProcessed()
    {
        return isProcessed;
    }
    public void setProcessTime(Date processTime)
    {
        this.processTime = processTime;
    }

    public Date getProcessTime()
    {
        return processTime;
    }
    public void setProcessBy(String processBy)
    {
        this.processBy = processBy;
    }

    public String getProcessBy()
    {
        return processBy;
    }
    public void setDetectionTime(Date detectionTime)
    {
        this.detectionTime = detectionTime;
    }

    public Date getDetectionTime()
    {
        return detectionTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("detectionId", getDetectionId())
            .append("landId", getLandId())
            .append("landName", getLandName())
            .append("speciesId", getSpeciesId())
            .append("speciesName", getSpeciesName())
            .append("detectionType", getDetectionType())
            .append("pestName", getPestName())
            .append("confidence", getConfidence())
            .append("imagePath", getImagePath())
            .append("frameTimestamp", getFrameTimestamp())
            .append("processStatus", getProcessStatus())
            .append("recommendation", getRecommendation())
            .append("isProcessed", getIsProcessed())
            .append("processTime", getProcessTime())
            .append("processBy", getProcessBy())
            .append("detectionTime", getDetectionTime())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
