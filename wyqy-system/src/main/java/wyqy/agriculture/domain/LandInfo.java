package wyqy.agriculture.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import wyqy.common.annotation.Excel;
import wyqy.common.core.domain.BaseEntity;

/**
 * 地块信息对象 land_info
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public class LandInfo extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 地块ID */
    private Long landId;

    /** 地块名称 */
    @Excel(name = "地块名称")
    private String landName;

    /** 地块编号 */
    @Excel(name = "地块编号")
    private String landCode;

    /** 地块面积(亩) */
    @Excel(name = "地块面积", readConverterExp = "亩=")
    private Double landArea;

    /** 地块位置 */
    @Excel(name = "地块位置")
    private String location;

    /** 土壤类型 */
    @Excel(name = "土壤类型")
    private String soilType;

    /** 土壤pH值 */
    @Excel(name = "土壤pH值")
    private Double soilPh;

    /** 有机质含量(%) */
    @Excel(name = "有机质含量", readConverterExp = "%=")
    private Double organicMatter;

    /** 氮含量(mg/kg) */
    @Excel(name = "氮含量", readConverterExp = "mg/kg=")
    private Double nitrogenContent;

    /** 磷含量(mg/kg) */
    @Excel(name = "磷含量", readConverterExp = "mg/kg=")
    private Double phosphorusContent;

    /** 钾含量(mg/kg) */
    @Excel(name = "钾含量", readConverterExp = "mg/kg=")
    private Double potassiumContent;

    /** 灌溉方式 */
    @Excel(name = "灌溉方式")
    private String irrigationMethod;

    /** 排水条件 */
    @Excel(name = "排水条件")
    private String drainageCondition;

    /** 地块状态 */
    @Excel(name = "地块状态")
    private String status;

    /** 负责人 */
    @Excel(name = "负责人")
    private String responsiblePerson;

    /** 联系电话 */
    @Excel(name = "联系电话")
    private String contactPhone;

    /** 备注 */
    @Excel(name = "备注")
    private String notes;

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
    public void setLandCode(String landCode) 
    {
        this.landCode = landCode;
    }

    public String getLandCode() 
    {
        return landCode;
    }
    public void setLandArea(Double landArea) 
    {
        this.landArea = landArea;
    }

    public Double getLandArea() 
    {
        return landArea;
    }
    public void setLocation(String location) 
    {
        this.location = location;
    }

    public String getLocation() 
    {
        return location;
    }
    public void setSoilType(String soilType) 
    {
        this.soilType = soilType;
    }

    public String getSoilType() 
    {
        return soilType;
    }
    public void setSoilPh(Double soilPh) 
    {
        this.soilPh = soilPh;
    }

    public Double getSoilPh() 
    {
        return soilPh;
    }
    public void setOrganicMatter(Double organicMatter) 
    {
        this.organicMatter = organicMatter;
    }

    public Double getOrganicMatter() 
    {
        return organicMatter;
    }
    public void setNitrogenContent(Double nitrogenContent) 
    {
        this.nitrogenContent = nitrogenContent;
    }

    public Double getNitrogenContent() 
    {
        return nitrogenContent;
    }
    public void setPhosphorusContent(Double phosphorusContent) 
    {
        this.phosphorusContent = phosphorusContent;
    }

    public Double getPhosphorusContent() 
    {
        return phosphorusContent;
    }
    public void setPotassiumContent(Double potassiumContent) 
    {
        this.potassiumContent = potassiumContent;
    }

    public Double getPotassiumContent() 
    {
        return potassiumContent;
    }
    public void setIrrigationMethod(String irrigationMethod) 
    {
        this.irrigationMethod = irrigationMethod;
    }

    public String getIrrigationMethod() 
    {
        return irrigationMethod;
    }
    public void setDrainageCondition(String drainageCondition) 
    {
        this.drainageCondition = drainageCondition;
    }

    public String getDrainageCondition() 
    {
        return drainageCondition;
    }
    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }
    public void setResponsiblePerson(String responsiblePerson) 
    {
        this.responsiblePerson = responsiblePerson;
    }

    public String getResponsiblePerson() 
    {
        return responsiblePerson;
    }
    public void setContactPhone(String contactPhone) 
    {
        this.contactPhone = contactPhone;
    }

    public String getContactPhone() 
    {
        return contactPhone;
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
            .append("landId", getLandId())
            .append("landName", getLandName())
            .append("landCode", getLandCode())
            .append("landArea", getLandArea())
            .append("location", getLocation())
            .append("soilType", getSoilType())
            .append("soilPh", getSoilPh())
            .append("organicMatter", getOrganicMatter())
            .append("nitrogenContent", getNitrogenContent())
            .append("phosphorusContent", getPhosphorusContent())
            .append("potassiumContent", getPotassiumContent())
            .append("irrigationMethod", getIrrigationMethod())
            .append("drainageCondition", getDrainageCondition())
            .append("status", getStatus())
            .append("responsiblePerson", getResponsiblePerson())
            .append("contactPhone", getContactPhone())
            .append("notes", getNotes())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
