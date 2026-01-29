package wyqy.agriculture.mapper;

import java.util.List;
import wyqy.agriculture.domain.WeatherInfo;

/**
 * 天气信息Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public interface WeatherInfoMapper 
{
    /**
     * 查询天气信息
     * 
     * @param weatherId 天气信息主键
     * @return 天气信息
     */
    public WeatherInfo selectWeatherInfoByWeatherId(Long weatherId);

    /**
     * 查询天气信息列表
     * 
     * @param weatherInfo 天气信息
     * @return 天气信息集合
     */
    public List<WeatherInfo> selectWeatherInfoList(WeatherInfo weatherInfo);

    /**
     * 新增天气信息
     * 
     * @param weatherInfo 天气信息
     * @return 结果
     */
    public int insertWeatherInfo(WeatherInfo weatherInfo);

    /**
     * 修改天气信息
     * 
     * @param weatherInfo 天气信息
     * @return 结果
     */
    public int updateWeatherInfo(WeatherInfo weatherInfo);

    /**
     * 删除天气信息
     * 
     * @param weatherId 天气信息主键
     * @return 结果
     */
    public int deleteWeatherInfoByWeatherId(Long weatherId);

    /**
     * 批量删除天气信息
     * 
     * @param weatherIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteWeatherInfoByWeatherIds(Long[] weatherIds);

    /**
     * 获取最新天气信息
     * 
     * @return 最新天气信息
     */
    public WeatherInfo selectLatestWeather();
}
