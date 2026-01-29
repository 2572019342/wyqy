package wyqy.agriculture.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import wyqy.common.annotation.Excel;
import wyqy.common.core.domain.BaseEntity;

/**
 * 采摘记录对象 harvest_record
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public class HarvestRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 采摘ID */
    private Long harvestId;

    /** 种植ID */
    @Excel(name = "种植ID")
    private Long plantingId;

    /** 地块名称 */
    @Excel(name = "地块名称")
    private String landName;

    /** 作物名称 */
    @Excel(name = "作物名称")
    private String speciesName;

    /** 采摘时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "采摘时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date harvestDate;

    /** 采摘面积(亩) */
    @Excel(name = "采摘面积", readConverterExp = "亩=")
    private Double harvestArea;

    /** 采摘数量(kg) */
    @Excel(name = "采摘数量", readConverterExp = "kg=")
    private Double harvestQuantity;

    /** 质量等级 */
    @Excel(name = "质量等级")
    private String qualityGrade;

    /** 单价(元/kg) */
    @Excel(name = "单价", readConverterExp = "元/kg=")
    private Double unitPrice;

    /** 总价(元) */
    @Excel(name = "总价", readConverterExp = "元=")
    private Double totalPrice;

    /** 采摘方式 */
    @Excel(name = "采摘方式")
    private String harvestMethod;

    /** 操作人员 */
    @Excel(name = "操作人员")
    private String operator;

    /** 存储位置 */
    @Excel(name = "存储位置")
    private String storageLocation;

    /** 存储条件 */
    @Excel(name = "存储条件")
    private String storageConditions;

    /** 收购方 */
    @Excel(name = "收购方")
    private String buyer;

    /** 运输方式 */
    @Excel(name = "运输方式")
    private String transportMethod;

    /** 检验结果 */
    @Excel(name = "检验结果")
    private String inspectionResult;

    /** 检验人员 */
    @Excel(name = "检验人员")
    private String inspector;

    /** 检验时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "检验时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date inspectionTime;

    /** 备注 */
    @Excel(name = "备注")
    private String notes;

    /** 状态 */
    @Excel(name = "状态")
    private String status;

    public void setHarvestId(Long harvestId) 
    {
        this.harvestId = harvestId;
    }

    public Long getHarvestId() 
    {
        return harvestId;
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
    public void setHarvestDate(Date harvestDate) 
    {
        this.harvestDate = harvestDate;
    }

    public Date getHarvestDate() 
    {
        return harvestDate;
    }
    public void setHarvestArea(Double harvestArea) 
    {
        this.harvestArea = harvestArea;
    }

    public Double getHarvestArea() 
    {
        return harvestArea;
    }
    public void setHarvestQuantity(Double harvestQuantity) 
    {
        this.harvestQuantity = harvestQuantity;
    }

    public Double getHarvestQuantity() 
    {
        return harvestQuantity;
    }
    public void setQualityGrade(String qualityGrade) 
    {
        this.qualityGrade = qualityGrade;
    }

    public String getQualityGrade() 
    {
        return qualityGrade;
    }
    public void setUnitPrice(Double unitPrice) 
    {
        this.unitPrice = unitPrice;
    }

    public Double getUnitPrice() 
    {
        return unitPrice;
    }
    public void setTotalPrice(Double totalPrice) 
    {
        this.totalPrice = totalPrice;
    }

    public Double getTotalPrice() 
    {
        return totalPrice;
    }
    public void setHarvestMethod(String harvestMethod) 
    {
        this.harvestMethod = harvestMethod;
    }

    public String getHarvestMethod() 
    {
        return harvestMethod;
    }
    public void setOperator(String operator) 
    {
        this.operator = operator;
    }

    public String getOperator() 
    {
        return operator;
    }
    public void setStorageLocation(String storageLocation) 
    {
        this.storageLocation = storageLocation;
    }

    public String getStorageLocation() 
    {
        return storageLocation;
    }
    public void setStorageConditions(String storageConditions) 
    {
        this.storageConditions = storageConditions;
    }

    public String getStorageConditions() 
    {
        return storageConditions;
    }
    public void setBuyer(String buyer) 
    {
        this.buyer = buyer;
    }

    public String getBuyer() 
    {
        return buyer;
    }
    public void setTransportMethod(String transportMethod) 
    {
        this.transportMethod = transportMethod;
    }

    public String getTransportMethod() 
    {
        return transportMethod;
    }
    public void setInspectionResult(String inspectionResult) 
    {
        this.inspectionResult = inspectionResult;
    }

    public String getInspectionResult() 
    {
        return inspectionResult;
    }
    public void setInspector(String inspector) 
    {
        this.inspector = inspector;
    }

    public String getInspector() 
    {
        return inspector;
    }
    public void setInspectionTime(Date inspectionTime) 
    {
        this.inspectionTime = inspectionTime;
    }

    public Date getInspectionTime() 
    {
        return inspectionTime;
    }
    public void setNotes(String notes) 
    {
        this.notes = notes;
    }

    public String getNotes() 
    {
        return notes;
    }
    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("harvestId", getHarvestId())
            .append("plantingId", getPlantingId())
            .append("landName", getLandName())
            .append("speciesName", getSpeciesName())
            .append("harvestDate", getHarvestDate())
            .append("harvestArea", getHarvestArea())
            .append("harvestQuantity", getHarvestQuantity())
            .append("qualityGrade", getQualityGrade())
            .append("unitPrice", getUnitPrice())
            .append("totalPrice", getTotalPrice())
            .append("harvestMethod", getHarvestMethod())
            .append("operator", getOperator())
            .append("storageLocation", getStorageLocation())
            .append("storageConditions", getStorageConditions())
            .append("buyer", getBuyer())
            .append("transportMethod", getTransportMethod())
            .append("inspectionResult", getInspectionResult())
            .append("inspector", getInspector())
            .append("inspectionTime", getInspectionTime())
            .append("notes", getNotes())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
