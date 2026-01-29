package wyqy.web.controller.agriculture;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import wyqy.common.annotation.Log;
import wyqy.common.core.controller.BaseController;
import wyqy.common.core.domain.AjaxResult;
import wyqy.common.enums.BusinessType;
import wyqy.agriculture.domain.WeatherInfo;
import wyqy.agriculture.service.IWeatherInfoService;
import wyqy.common.utils.poi.ExcelUtil;
import wyqy.common.core.page.TableDataInfo;

/**
 * 天气信息Controller
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
@RestController
@RequestMapping("/agriculture/weather")
public class WeatherInfoController extends BaseController
{
    @Autowired
    private IWeatherInfoService weatherInfoService;

    /**
     * 查询天气信息列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:weather:list')")
    @GetMapping("/list")
    public TableDataInfo list(WeatherInfo weatherInfo)
    {
        startPage();
        List<WeatherInfo> list = weatherInfoService.selectWeatherInfoList(weatherInfo);
        return getDataTable(list);
    }

    /**
     * 导出天气信息列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:weather:export')")
    @Log(title = "天气信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, WeatherInfo weatherInfo)
    {
        List<WeatherInfo> list = weatherInfoService.selectWeatherInfoList(weatherInfo);
        ExcelUtil<WeatherInfo> util = new ExcelUtil<WeatherInfo>(WeatherInfo.class);
        util.exportExcel(response, list, "天气信息数据");
    }

    /**
     * 获取天气信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:weather:query')")
    @GetMapping(value = "/{weatherId}")
    public AjaxResult getInfo(@PathVariable("weatherId") Long weatherId)
    {
        return success(weatherInfoService.selectWeatherInfoByWeatherId(weatherId));
    }

    /**
     * 新增天气信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:weather:add')")
    @Log(title = "天气信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody WeatherInfo weatherInfo)
    {
        return toAjax(weatherInfoService.insertWeatherInfo(weatherInfo));
    }

    /**
     * 修改天气信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:weather:edit')")
    @Log(title = "天气信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody WeatherInfo weatherInfo)
    {
        return toAjax(weatherInfoService.updateWeatherInfo(weatherInfo));
    }

    /**
     * 删除天气信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:weather:remove')")
    @Log(title = "天气信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{weatherIds}")
    public AjaxResult remove(@PathVariable Long[] weatherIds)
    {
        return toAjax(weatherInfoService.deleteWeatherInfoByWeatherIds(weatherIds));
    }

    /**
     * 获取最新天气信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:weather:query')")
    @GetMapping("/latest")
    public AjaxResult getLatestWeather()
    {
        WeatherInfo latestWeather = weatherInfoService.selectLatestWeather();
        return success(latestWeather);
    }

    /**
     * 获取天气统计信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:weather:query')")
    @GetMapping("/stats")
    public AjaxResult getWeatherStats()
    {
        return success(weatherInfoService.getWeatherStats());
    }
}
