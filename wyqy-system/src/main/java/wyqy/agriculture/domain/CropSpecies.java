package wyqy.agriculture.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import wyqy.common.annotation.Excel;
import wyqy.common.core.domain.BaseEntity;

/**
 * 作物种类对象 crop_species
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public class CropSpecies extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 作物ID */
    private Long speciesId;

    /** 作物名称 */
    @Excel(name = "作物名称")
    private String speciesName;

    /** 作物编号 */
    @Excel(name = "作物编号")
    private String speciesCode;

    /** 学名 */
    @Excel(name = "学名")
    private String scientificName;

    /** 作物类别 */
    @Excel(name = "作物类别")
    private String category;

    /** 生长周期(天) */
    @Excel(name = "生长周期", readConverterExp = "天=")
    private Integer growthCycle;

    /** 最适温度最低值(℃) */
    @Excel(name = "最适温度最低值")
    private Double suitableTempMin;

    /** 最适温度最高值(℃) */
    @Excel(name = "最适温度最高值")
    private Double suitableTempMax;

    /** 最适湿度最低值(%) */
    @Excel(name = "最适湿度最低值")
    private Double suitableHumidityMin;

    /** 最适湿度最高值(%) */
    @Excel(name = "最适湿度最高值")
    private Double suitableHumidityMax;

    /** 水分需求 */
    @Excel(name = "水分需求")
    private String waterRequirement;

    /** 肥料需求 */
    @Excel(name = "肥料需求")
    private String fertilizerRequirement;

    /** 光照需求 */
    @Excel(name = "光照需求")
    private String lightRequirement;

    /** 土壤要求 */
    @Excel(name = "土壤要求")
    private String soilRequirement;

    /** 种植密度(株/亩) */
    @Excel(name = "种植密度", readConverterExp = "株/亩=")
    private Double plantingDensity;

    /** 预期产量(kg/亩) */
    @Excel(name = "预期产量", readConverterExp = "kg/亩=")
    private Double estimatedYield;

    /** 抗病性 */
    @Excel(name = "抗病性")
    private String diseaseResistance;

    /** 抗虫性 */
    @Excel(name = "抗虫性")
    private String pestResistance;

    /** 描述 */
    @Excel(name = "描述")
    private String description;

    /** 图片URL */
    @Excel(name = "图片URL")
    private String imageUrl;

    /** 状态 */
    @Excel(name = "状态")
    private String status;

    /** 备注 */
    @Excel(name = "备注")
    private String notes;

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
    public void setSpeciesCode(String speciesCode) 
    {
        this.speciesCode = speciesCode;
    }

    public String getSpeciesCode() 
    {
        return speciesCode;
    }
    public void setCategory(String category) 
    {
        this.category = category;
    }

    public String getCategory() 
    {
        return category;
    }
    public void setGrowthCycle(Integer growthCycle) 
    {
        this.growthCycle = growthCycle;
    }

    public Integer getGrowthCycle() 
    {
        return growthCycle;
    }
    public void setScientificName(String scientificName) 
    {
        this.scientificName = scientificName;
    }

    public String getScientificName() 
    {
        return scientificName;
    }
    public void setSuitableTempMin(Double suitableTempMin) 
    {
        this.suitableTempMin = suitableTempMin;
    }

    public Double getSuitableTempMin() 
    {
        return suitableTempMin;
    }
    public void setSuitableTempMax(Double suitableTempMax) 
    {
        this.suitableTempMax = suitableTempMax;
    }

    public Double getSuitableTempMax() 
    {
        return suitableTempMax;
    }
    public void setSuitableHumidityMin(Double suitableHumidityMin) 
    {
        this.suitableHumidityMin = suitableHumidityMin;
    }

    public Double getSuitableHumidityMin() 
    {
        return suitableHumidityMin;
    }
    public void setSuitableHumidityMax(Double suitableHumidityMax) 
    {
        this.suitableHumidityMax = suitableHumidityMax;
    }

    public Double getSuitableHumidityMax() 
    {
        return suitableHumidityMax;
    }
    public void setWaterRequirement(String waterRequirement) 
    {
        this.waterRequirement = waterRequirement;
    }

    public String getWaterRequirement() 
    {
        return waterRequirement;
    }
    public void setFertilizerRequirement(String fertilizerRequirement) 
    {
        this.fertilizerRequirement = fertilizerRequirement;
    }

    public String getFertilizerRequirement() 
    {
        return fertilizerRequirement;
    }
    public void setLightRequirement(String lightRequirement) 
    {
        this.lightRequirement = lightRequirement;
    }

    public String getLightRequirement() 
    {
        return lightRequirement;
    }
    public void setSoilRequirement(String soilRequirement) 
    {
        this.soilRequirement = soilRequirement;
    }

    public String getSoilRequirement() 
    {
        return soilRequirement;
    }
    public void setPlantingDensity(Double plantingDensity) 
    {
        this.plantingDensity = plantingDensity;
    }

    public Double getPlantingDensity() 
    {
        return plantingDensity;
    }
    public void setEstimatedYield(Double estimatedYield) 
    {
        this.estimatedYield = estimatedYield;
    }

    public Double getEstimatedYield() 
    {
        return estimatedYield;
    }
    public void setDiseaseResistance(String diseaseResistance) 
    {
        this.diseaseResistance = diseaseResistance;
    }

    public String getDiseaseResistance() 
    {
        return diseaseResistance;
    }
    public void setPestResistance(String pestResistance) 
    {
        this.pestResistance = pestResistance;
    }

    public String getPestResistance() 
    {
        return pestResistance;
    }
    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }
    public void setImageUrl(String imageUrl) 
    {
        this.imageUrl = imageUrl;
    }

    public String getImageUrl() 
    {
        return imageUrl;
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
            .append("speciesId", getSpeciesId())
            .append("speciesName", getSpeciesName())
            .append("speciesCode", getSpeciesCode())
            .append("scientificName", getScientificName())
            .append("category", getCategory())
            .append("growthCycle", getGrowthCycle())
            .append("suitableTempMin", getSuitableTempMin())
            .append("suitableTempMax", getSuitableTempMax())
            .append("suitableHumidityMin", getSuitableHumidityMin())
            .append("suitableHumidityMax", getSuitableHumidityMax())
            .append("waterRequirement", getWaterRequirement())
            .append("fertilizerRequirement", getFertilizerRequirement())
            .append("lightRequirement", getLightRequirement())
            .append("soilRequirement", getSoilRequirement())
            .append("plantingDensity", getPlantingDensity())
            .append("estimatedYield", getEstimatedYield())
            .append("diseaseResistance", getDiseaseResistance())
            .append("pestResistance", getPestResistance())
            .append("description", getDescription())
            .append("imageUrl", getImageUrl())
            .append("status", getStatus())
            .append("notes", getNotes())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
