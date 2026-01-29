package wyqy.agriculture.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import wyqy.common.annotation.Excel;
import wyqy.common.core.domain.BaseEntity;

/**
 * 种植记录对象 planting_record
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public class PlantingRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 种植ID */
    private Long plantingId;

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

    /** 种植面积(亩) */
    @Excel(name = "种植面积", readConverterExp = "亩=")
    private Double plantingArea;

    /** 种植数量 */
    @Excel(name = "种植数量")
    private Integer plantingQuantity;

    /** 种植日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "种植日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date plantingDate;

    /** 预计收获日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "预计收获日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date expectedHarvestDate;

    /** 实际收获日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "实际收获日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date actualHarvestDate;

    /** 生长阶段 */
    @Excel(name = "生长阶段")
    private String growthStage;

    /** 健康状况 */
    @Excel(name = "健康状况")
    private String healthStatus;

    /** 成熟度 */
    @Excel(name = "成熟度")
    private String maturity;

    /** 是否成熟(0未成熟 1成熟) */
    private String isMature;

    /** 可采摘(0不可 1可) */
    private String canHarvest;

    /** 病害信息 */
    @Excel(name = "病害信息")
    private String diseaseInfo;

    /** 虫害信息 */
    @Excel(name = "虫害信息")
    private String pestInfo;

    /** 种植方式 */
    @Excel(name = "种植方式")
    private String plantingMethod;

    /** 种植密度 */
    @Excel(name = "种植密度")
    private Integer plantingDensity;

    /** 种子来源 */
    @Excel(name = "种子来源")
    private String seedSource;

    /** 种子批次号 */
    @Excel(name = "种子批次号")
    private String seedBatch;

    /** 操作人员 */
    @Excel(name = "操作人员")
    private String operator;

    /** 预估产量(kg) */
    @Excel(name = "预估产量", readConverterExp = "kg=")
    private Double estimatedYield;

    /** 实际产量(kg) */
    @Excel(name = "实际产量", readConverterExp = "kg=")
    private Double actualYield;

    /** 状态 */
    @Excel(name = "状态")
    private String status;

    /** 备注 */
    @Excel(name = "备注")
    private String notes;

    public void setPlantingId(Long plantingId) 
    {
        this.plantingId = plantingId;
    }

    public Long getPlantingId() 
    {
        return plantingId;
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
    public void setPlantingArea(Double plantingArea) 
    {
        this.plantingArea = plantingArea;
    }

    public Double getPlantingArea() 
    {
        return plantingArea;
    }
    public void setPlantingQuantity(Integer plantingQuantity) 
    {
        this.plantingQuantity = plantingQuantity;
    }

    public Integer getPlantingQuantity() 
    {
        return plantingQuantity;
    }
    public void setPlantingDate(Date plantingDate) 
    {
        this.plantingDate = plantingDate;
    }

    public Date getPlantingDate() 
    {
        return plantingDate;
    }
    public void setExpectedHarvestDate(Date expectedHarvestDate) 
    {
        this.expectedHarvestDate = expectedHarvestDate;
    }

    public Date getExpectedHarvestDate() 
    {
        return expectedHarvestDate;
    }
    public void setActualHarvestDate(Date actualHarvestDate) 
    {
        this.actualHarvestDate = actualHarvestDate;
    }

    public Date getActualHarvestDate() 
    {
        return actualHarvestDate;
    }
    public void setGrowthStage(String growthStage) 
    {
        this.growthStage = growthStage;
    }

    public String getGrowthStage() 
    {
        return growthStage;
    }
    public void setHealthStatus(String healthStatus) 
    {
        this.healthStatus = healthStatus;
    }

    public String getHealthStatus() 
    {
        return healthStatus;
    }
    public void setMaturity(String maturity) 
    {
        this.maturity = maturity;
    }

    public String getMaturity() 
    {
        return maturity;
    }

    public void setIsMature(String isMature)
    {
        this.isMature = isMature;
    }

    public String getIsMature()
    {
        return isMature;
    }

    public void setCanHarvest(String canHarvest)
    {
        this.canHarvest = canHarvest;
    }

    public String getCanHarvest()
    {
        return canHarvest;
    }
    public void setDiseaseInfo(String diseaseInfo) 
    {
        this.diseaseInfo = diseaseInfo;
    }

    public String getDiseaseInfo() 
    {
        return diseaseInfo;
    }
    public void setPestInfo(String pestInfo) 
    {
        this.pestInfo = pestInfo;
    }

    public String getPestInfo() 
    {
        return pestInfo;
    }
    public void setPlantingMethod(String plantingMethod) 
    {
        this.plantingMethod = plantingMethod;
    }

    public String getPlantingMethod() 
    {
        return plantingMethod;
    }
    public void setPlantingDensity(Integer plantingDensity) 
    {
        this.plantingDensity = plantingDensity;
    }

    public Integer getPlantingDensity() 
    {
        return plantingDensity;
    }
    public void setSeedSource(String seedSource) 
    {
        this.seedSource = seedSource;
    }

    public String getSeedSource() 
    {
        return seedSource;
    }
    public void setSeedBatch(String seedBatch) 
    {
        this.seedBatch = seedBatch;
    }

    public String getSeedBatch() 
    {
        return seedBatch;
    }
    public void setOperator(String operator) 
    {
        this.operator = operator;
    }

    public String getOperator() 
    {
        return operator;
    }
    public void setEstimatedYield(Double estimatedYield) 
    {
        this.estimatedYield = estimatedYield;
    }

    public Double getEstimatedYield() 
    {
        return estimatedYield;
    }
    public void setActualYield(Double actualYield) 
    {
        this.actualYield = actualYield;
    }

    public Double getActualYield() 
    {
        return actualYield;
    }
    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
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
            .append("plantingId", getPlantingId())
            .append("landId", getLandId())
            .append("landName", getLandName())
            .append("speciesId", getSpeciesId())
            .append("speciesName", getSpeciesName())
            .append("plantingArea", getPlantingArea())
            .append("plantingQuantity", getPlantingQuantity())
            .append("plantingDate", getPlantingDate())
            .append("expectedHarvestDate", getExpectedHarvestDate())
            .append("actualHarvestDate", getActualHarvestDate())
            .append("growthStage", getGrowthStage())
            .append("healthStatus", getHealthStatus())
            .append("maturity", getMaturity())
            .append("isMature", getIsMature())
            .append("canHarvest", getCanHarvest())
            .append("diseaseInfo", getDiseaseInfo())
            .append("pestInfo", getPestInfo())
            .append("plantingMethod", getPlantingMethod())
            .append("plantingDensity", getPlantingDensity())
            .append("seedSource", getSeedSource())
            .append("seedBatch", getSeedBatch())
            .append("operator", getOperator())
            .append("estimatedYield", getEstimatedYield())
            .append("actualYield", getActualYield())
            .append("status", getStatus())
            .append("notes", getNotes())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
