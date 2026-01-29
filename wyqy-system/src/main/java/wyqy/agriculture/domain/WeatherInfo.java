package wyqy.agriculture.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import wyqy.common.annotation.Excel;
import wyqy.common.core.domain.BaseEntity;

/**
 * 天气信息对象 weather_info
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public class WeatherInfo extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 天气ID */
    private Long weatherId;

    /** 温度(℃) */
    @Excel(name = "温度", readConverterExp = "℃=")
    private Double temperature;

    /** 湿度(%) */
    @Excel(name = "湿度", readConverterExp = "%=")
    private Double humidity;

    /** 气压(hPa) */
    @Excel(name = "气压", readConverterExp = "hPa=")
    private Double pressure;

    /** 风速(m/s) */
    @Excel(name = "风速", readConverterExp = "m/s=")
    private Double windSpeed;

    /** 风向 */
    @Excel(name = "风向")
    private String windDirection;

    /** 降雨量(mm) */
    @Excel(name = "降雨量", readConverterExp = "mm=")
    private Double rainfall;

    /** 光照强度(lux) */
    @Excel(name = "光照强度", readConverterExp = "lux=")
    private Double lightIntensity;

    /** 土壤温度(℃) */
    @Excel(name = "土壤温度", readConverterExp = "℃=")
    private Double soilTemperature;

    /** 土壤湿度(%) */
    @Excel(name = "土壤湿度", readConverterExp = "%=")
    private Double soilHumidity;

    /** 监测位置 */
    @Excel(name = "监测位置")
    private String location;

    /** 空气质量指数 */
    @Excel(name = "空气质量指数")
    private Integer airQualityIndex;

    /** 天气状况 */
    @Excel(name = "天气状况")
    private String weatherCondition;

    /** 记录时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "记录时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date recordTime;

    /** 数据来源 */
    @Excel(name = "数据来源")
    private String dataSource;

    /** 备注 */
    @Excel(name = "备注")
    private String notes;

    public void setWeatherId(Long weatherId) 
    {
        this.weatherId = weatherId;
    }

    public Long getWeatherId() 
    {
        return weatherId;
    }
    public void setTemperature(Double temperature) 
    {
        this.temperature = temperature;
    }

    public Double getTemperature() 
    {
        return temperature;
    }
    public void setHumidity(Double humidity) 
    {
        this.humidity = humidity;
    }

    public Double getHumidity() 
    {
        return humidity;
    }
    public void setPressure(Double pressure) 
    {
        this.pressure = pressure;
    }

    public Double getPressure() 
    {
        return pressure;
    }
    public void setWindSpeed(Double windSpeed) 
    {
        this.windSpeed = windSpeed;
    }

    public Double getWindSpeed() 
    {
        return windSpeed;
    }
    public void setWindDirection(String windDirection) 
    {
        this.windDirection = windDirection;
    }

    public String getWindDirection() 
    {
        return windDirection;
    }
    public void setRainfall(Double rainfall) 
    {
        this.rainfall = rainfall;
    }

    public Double getRainfall() 
    {
        return rainfall;
    }
    public void setLightIntensity(Double lightIntensity) 
    {
        this.lightIntensity = lightIntensity;
    }

    public Double getLightIntensity() 
    {
        return lightIntensity;
    }
    public void setSoilTemperature(Double soilTemperature) 
    {
        this.soilTemperature = soilTemperature;
    }

    public Double getSoilTemperature() 
    {
        return soilTemperature;
    }
    public void setSoilHumidity(Double soilHumidity) 
    {
        this.soilHumidity = soilHumidity;
    }

    public Double getSoilHumidity() 
    {
        return soilHumidity;
    }
    public void setLocation(String location) 
    {
        this.location = location;
    }

    public String getLocation() 
    {
        return location;
    }
    public void setAirQualityIndex(Integer airQualityIndex) 
    {
        this.airQualityIndex = airQualityIndex;
    }

    public Integer getAirQualityIndex() 
    {
        return airQualityIndex;
    }
    public void setWeatherCondition(String weatherCondition) 
    {
        this.weatherCondition = weatherCondition;
    }

    public String getWeatherCondition() 
    {
        return weatherCondition;
    }
    public void setRecordTime(Date recordTime) 
    {
        this.recordTime = recordTime;
    }

    public Date getRecordTime() 
    {
        return recordTime;
    }
    public void setDataSource(String dataSource) 
    {
        this.dataSource = dataSource;
    }

    public String getDataSource() 
    {
        return dataSource;
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
            .append("weatherId", getWeatherId())
            .append("temperature", getTemperature())
            .append("humidity", getHumidity())
            .append("pressure", getPressure())
            .append("windSpeed", getWindSpeed())
            .append("windDirection", getWindDirection())
            .append("rainfall", getRainfall())
            .append("lightIntensity", getLightIntensity())
            .append("soilTemperature", getSoilTemperature())
            .append("soilHumidity", getSoilHumidity())
            .append("location", getLocation())
            .append("airQualityIndex", getAirQualityIndex())
            .append("weatherCondition", getWeatherCondition())
            .append("recordTime", getRecordTime())
            .append("dataSource", getDataSource())
            .append("notes", getNotes())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
