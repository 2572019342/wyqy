package wyqy.agriculture.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import wyqy.common.annotation.Excel;
import wyqy.common.core.domain.BaseEntity;

/**
 * 种植管理对象 farming_management
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public class FarmingManagement extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 管理ID */
    private Long farmingId;

    /** 种植ID */
    @Excel(name = "种植ID")
    private Long plantingId;

    private String landName;

    private String speciesName;

    /** 管理类型 */
    @Excel(name = "管理类型")
    private String managementType;

    /** 管理时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "管理时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date managementDate;

    /** 物料名称 */
    @Excel(name = "物料名称")
    private String materialName;

    /** 物料类型 */
    @Excel(name = "物料类型")
    private String materialType;

    /** 用量 */
    @Excel(name = "用量")
    private Double dosage;

    /** 单位 */
    @Excel(name = "单位")
    private String unit;

    /** 使用方法 */
    @Excel(name = "使用方法")
    private String method;

    /** 目的 */
    @Excel(name = "目的")
    private String purpose;

    /** 效果 */
    @Excel(name = "效果")
    private String effect;

    /** 成本(元) */
    @Excel(name = "成本", readConverterExp = "元=")
    private Double cost;

    /** 操作人员 */
    @Excel(name = "操作人员")
    private String operator;

    /** 天气状况 */
    @Excel(name = "天气状况")
    private String weatherCondition;

    /** 下次管理时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "下次管理时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date nextManagementDate;

    /** 备注 */
    @Excel(name = "备注")
    private String notes;

    public void setFarmingId(Long farmingId) 
    {
        this.farmingId = farmingId;
    }

    public Long getFarmingId() 
    {
        return farmingId;
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
    public void setManagementType(String managementType) 
    {
        this.managementType = managementType;
    }

    public String getManagementType() 
    {
        return managementType;
    }
    public void setManagementDate(Date managementDate) 
    {
        this.managementDate = managementDate;
    }

    public Date getManagementDate() 
    {
        return managementDate;
    }
    public void setMaterialName(String materialName) 
    {
        this.materialName = materialName;
    }

    public String getMaterialName() 
    {
        return materialName;
    }
    public void setMaterialType(String materialType) 
    {
        this.materialType = materialType;
    }

    public String getMaterialType() 
    {
        return materialType;
    }
    public void setDosage(Double dosage) 
    {
        this.dosage = dosage;
    }

    public Double getDosage() 
    {
        return dosage;
    }
    public void setUnit(String unit) 
    {
        this.unit = unit;
    }

    public String getUnit() 
    {
        return unit;
    }
    public void setMethod(String method) 
    {
        this.method = method;
    }

    public String getMethod() 
    {
        return method;
    }
    public void setPurpose(String purpose) 
    {
        this.purpose = purpose;
    }

    public String getPurpose() 
    {
        return purpose;
    }
    public void setEffect(String effect) 
    {
        this.effect = effect;
    }

    public String getEffect() 
    {
        return effect;
    }
    public void setCost(Double cost) 
    {
        this.cost = cost;
    }

    public Double getCost() 
    {
        return cost;
    }
    public void setOperator(String operator) 
    {
        this.operator = operator;
    }

    public String getOperator() 
    {
        return operator;
    }
    public void setWeatherCondition(String weatherCondition) 
    {
        this.weatherCondition = weatherCondition;
    }

    public String getWeatherCondition() 
    {
        return weatherCondition;
    }
    public void setNextManagementDate(Date nextManagementDate) 
    {
        this.nextManagementDate = nextManagementDate;
    }

    public Date getNextManagementDate() 
    {
        return nextManagementDate;
    }
    public void setNotes(String notes) 
    {
        this.notes = notes;
    }

    public String getNotes() 
    {
        return notes;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("farmingId", getFarmingId())
            .append("plantingId", getPlantingId())
            .append("landName", getLandName())
            .append("speciesName", getSpeciesName())
            .append("managementType", getManagementType())
            .append("managementDate", getManagementDate())
            .append("materialName", getMaterialName())
            .append("materialType", getMaterialType())
            .append("dosage", getDosage())
            .append("unit", getUnit())
            .append("method", getMethod())
            .append("purpose", getPurpose())
            .append("effect", getEffect())
            .append("cost", getCost())
            .append("operator", getOperator())
            .append("weatherCondition", getWeatherCondition())
            .append("nextManagementDate", getNextManagementDate())
            .append("notes", getNotes())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
