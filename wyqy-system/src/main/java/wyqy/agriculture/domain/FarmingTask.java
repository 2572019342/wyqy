package wyqy.agriculture.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import wyqy.common.annotation.Excel;
import wyqy.common.core.domain.BaseEntity;

public class FarmingTask extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long taskId;

    @Excel(name = "种植ID")
    private Long plantingId;

    private String landName;

    private String speciesName;

    @Excel(name = "任务类型")
    private String taskType;

    @Excel(name = "任务标题")
    private String title;

    @Excel(name = "任务内容")
    private String content;

    @Excel(name = "状态")
    private String status;

    @Excel(name = "处理人")
    private String handler;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "处理时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date handledTime;

    public void setTaskId(Long taskId)
    {
        this.taskId = taskId;
    }

    public Long getTaskId()
    {
        return taskId;
    }

    public void setPlantingId(Long plantingId)
    {
        this.plantingId = plantingId;
    }

    public Long getPlantingId()
    {
        return plantingId;
    }

    public void setLandName(String landName)
    {
        this.landName = landName;
    }

    public String getLandName()
    {
        return landName;
    }

    public void setSpeciesName(String speciesName)
    {
        this.speciesName = speciesName;
    }

    public String getSpeciesName()
    {
        return speciesName;
    }

    public void setTaskType(String taskType)
    {
        this.taskType = taskType;
    }

    public String getTaskType()
    {
        return taskType;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public String getTitle()
    {
        return title;
    }

    public void setContent(String content)
    {
        this.content = content;
    }

    public String getContent()
    {
        return content;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getStatus()
    {
        return status;
    }

    public void setHandler(String handler)
    {
        this.handler = handler;
    }

    public String getHandler()
    {
        return handler;
    }

    public void setHandledTime(Date handledTime)
    {
        this.handledTime = handledTime;
    }

    public Date getHandledTime()
    {
        return handledTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("taskId", getTaskId())
            .append("plantingId", getPlantingId())
            .append("taskType", getTaskType())
            .append("title", getTitle())
            .append("content", getContent())
            .append("status", getStatus())
            .append("handler", getHandler())
            .append("handledTime", getHandledTime())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
