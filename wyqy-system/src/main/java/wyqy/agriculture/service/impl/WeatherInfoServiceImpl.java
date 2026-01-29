package wyqy.agriculture.service.impl;

import java.util.List;
import java.util.HashMap;
import java.util.Map;
import wyqy.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyqy.agriculture.mapper.WeatherInfoMapper;
import wyqy.agriculture.domain.WeatherInfo;
import wyqy.agriculture.service.IWeatherInfoService;

/**
 * 天气信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
@Service
public class WeatherInfoServiceImpl implements IWeatherInfoService 
{
    @Autowired
    private WeatherInfoMapper weatherInfoMapper;

    /**
     * 查询天气信息
     * 
     * @param weatherId 天气信息主键
     * @return 天气信息
     */
    @Override
    public WeatherInfo selectWeatherInfoByWeatherId(Long weatherId)
    {
        return weatherInfoMapper.selectWeatherInfoByWeatherId(weatherId);
    }

    /**
     * 查询天气信息列表
     * 
     * @param weatherInfo 天气信息
     * @return 天气信息
     */
    @Override
    public List<WeatherInfo> selectWeatherInfoList(WeatherInfo weatherInfo)
    {
        return weatherInfoMapper.selectWeatherInfoList(weatherInfo);
    }

    /**
     * 新增天气信息
     * 
     * @param weatherInfo 天气信息
     * @return 结果
     */
    @Override
    public int insertWeatherInfo(WeatherInfo weatherInfo)
    {
        weatherInfo.setCreateTime(DateUtils.getNowDate());
        return weatherInfoMapper.insertWeatherInfo(weatherInfo);
    }

    /**
     * 修改天气信息
     * 
     * @param weatherInfo 天气信息
     * @return 结果
     */
    @Override
    public int updateWeatherInfo(WeatherInfo weatherInfo)
    {
        weatherInfo.setUpdateTime(DateUtils.getNowDate());
        return weatherInfoMapper.updateWeatherInfo(weatherInfo);
    }

    /**
     * 批量删除天气信息
     * 
     * @param weatherIds 需要删除的天气信息主键
     * @return 结果
     */
    @Override
    public int deleteWeatherInfoByWeatherIds(Long[] weatherIds)
    {
        return weatherInfoMapper.deleteWeatherInfoByWeatherIds(weatherIds);
    }

    /**
     * 删除天气信息信息
     * 
     * @param weatherId 天气信息主键
     * @return 结果
     */
    @Override
    public int deleteWeatherInfoByWeatherId(Long weatherId)
    {
        return weatherInfoMapper.deleteWeatherInfoByWeatherId(weatherId);
    }

    /**
     * 获取最新天气信息
     * 
     * @return 最新天气信息
     */
    @Override
    public WeatherInfo selectLatestWeather()
    {
        return weatherInfoMapper.selectLatestWeather();
    }

    /**
     * 获取天气统计信息
     * 
     * @return 统计信息
     */
    @Override
    public Object getWeatherStats()
    {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取今日天气记录数
        WeatherInfo todayQuery = new WeatherInfo();
        todayQuery.setParams(new HashMap<>());
        todayQuery.getParams().put("beginTime", DateUtils.getNowDate());
        todayQuery.getParams().put("endTime", DateUtils.getNowDate());
        List<WeatherInfo> todayList = weatherInfoMapper.selectWeatherInfoList(todayQuery);
        stats.put("todayCount", todayList.size());
        
        // 获取总记录数
        List<WeatherInfo> allList = weatherInfoMapper.selectWeatherInfoList(new WeatherInfo());
        stats.put("totalCount", allList.size());
        
        // 计算平均温度
        if (!allList.isEmpty()) {
            double avgTemp = allList.stream()
                .mapToDouble(WeatherInfo::getTemperature)
                .average()
                .orElse(0.0);
            stats.put("avgTemperature", Math.round(avgTemp * 10.0) / 10.0);
        } else {
            stats.put("avgTemperature", 0.0);
        }
        
        // 获取最新天气状况
        WeatherInfo latest = selectLatestWeather();
        if (latest != null) {
            stats.put("latestCondition", latest.getWeatherCondition());
            stats.put("latestTemp", latest.getTemperature());
            stats.put("latestHumidity", latest.getHumidity());
        }
        
        return stats;
    }
}
