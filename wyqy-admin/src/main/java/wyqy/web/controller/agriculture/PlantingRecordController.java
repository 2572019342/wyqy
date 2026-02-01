package wyqy.web.controller.agriculture;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import wyqy.common.core.redis.RedisCache;
import wyqy.common.enums.BusinessType;
import wyqy.agriculture.domain.PlantingRecord;
import wyqy.agriculture.service.IPlantingRecordService;
import wyqy.web.service.LightAlarmService;
import wyqy.common.utils.poi.ExcelUtil;
import wyqy.common.core.page.TableDataInfo;

/**
 * 种植记录Controller
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
@RestController
@RequestMapping("/agriculture/planting")
public class PlantingRecordController extends BaseController
{
    @Autowired
    private IPlantingRecordService plantingRecordService;
    
    @Autowired
    private RedisCache redisCache;

    @Autowired
    private LightAlarmService lightAlarmService;
    
    // Redis中存储报警信息的key
    private static final String PEST_ALERT_KEY = "agriculture:pest:alert";

    /**
     * 查询种植记录列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:planting:list')")
    @GetMapping("/list")
    public TableDataInfo list(PlantingRecord plantingRecord)
    {
        startPage();
        List<PlantingRecord> list = plantingRecordService.selectPlantingRecordList(plantingRecord);
        return getDataTable(list);
    }

    /**
     * 导出种植记录列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:planting:export')")
    @Log(title = "种植记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, PlantingRecord plantingRecord)
    {
        List<PlantingRecord> list = plantingRecordService.selectPlantingRecordList(plantingRecord);
        ExcelUtil<PlantingRecord> util = new ExcelUtil<PlantingRecord>(PlantingRecord.class);
        util.exportExcel(response, list, "种植记录数据");
    }

    /**
     * 获取种植记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:planting:query')")
    @GetMapping(value = "/{plantingId}")
    public AjaxResult getInfo(@PathVariable("plantingId") Long plantingId)
    {
        return success(plantingRecordService.selectPlantingRecordByPlantingId(plantingId));
    }

    /**
     * 新增种植记录
     */
    @PreAuthorize("@ss.hasPermi('agriculture:planting:add')")
    @Log(title = "种植记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody PlantingRecord plantingRecord)
    {
        return toAjax(plantingRecordService.insertPlantingRecord(plantingRecord));
    }

    /**
     * 修改种植记录
     */
    @PreAuthorize("@ss.hasPermi('agriculture:planting:edit')")
    @Log(title = "种植记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody PlantingRecord plantingRecord)
    {
        return toAjax(plantingRecordService.updatePlantingRecord(plantingRecord));
    }

    /**
     * 删除种植记录
     */
    @PreAuthorize("@ss.hasPermi('agriculture:planting:remove')")
    @Log(title = "种植记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{plantingIds}")
    public AjaxResult remove(@PathVariable Long[] plantingIds)
    {
        return toAjax(plantingRecordService.deletePlantingRecordByPlantingIds(plantingIds));
    }

    /**
     * 获取种植统计信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:planting:query')")
    @GetMapping("/stats")
    public AjaxResult getPlantingStats()
    {
        return success(plantingRecordService.getPlantingStats());
    }

    /**
     * 获取地块种植信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:planting:query')")
    @GetMapping("/land/{landId}")
    public AjaxResult getLandPlantingInfo(@PathVariable("landId") Long landId)
    {
        return success(plantingRecordService.getLandPlantingInfo(landId));
    }

    /**
     * 更新生长状态
     */
    @PreAuthorize("@ss.hasPermi('agriculture:planting:edit')")
    @Log(title = "种植记录", businessType = BusinessType.UPDATE)
    @PutMapping("/updateStatus")
    public AjaxResult updateGrowthStatus(@RequestBody PlantingRecord plantingRecord)
    {
        return toAjax(plantingRecordService.updateGrowthStatus(plantingRecord));
    }
    
    /**
     * 创建虫害报警（保存到Redis，供所有用户查看）
     */
    @PreAuthorize("@ss.hasPermi('agriculture:planting:edit')")
    @Log(title = "种植记录", businessType = BusinessType.UPDATE)
    @PostMapping("/createPestAlert")
    public AjaxResult createPestAlert(@RequestBody Map<String, Object> params)
    {
        try {
            Long plantingId = params.get("plantingId") != null ? 
                Long.valueOf(params.get("plantingId").toString()) : null;
            String landName = params.get("landName") != null ? 
                params.get("landName").toString() : "未知地块";
            String speciesName = params.get("speciesName") != null ? 
                params.get("speciesName").toString() : "未知作物";
            
            // 创建报警信息
            Map<String, Object> alertInfo = new HashMap<>();
            alertInfo.put("alertId", System.currentTimeMillis()); // 使用时间戳作为唯一ID
            alertInfo.put("plantingId", plantingId);
            alertInfo.put("landName", landName);
            alertInfo.put("speciesName", speciesName);
            alertInfo.put("alertTime", System.currentTimeMillis());
            alertInfo.put("type", "pest"); // 报警类型：虫害
            alertInfo.put("message", "检测到虫害，请前往农事管理处理");
            
            // 保存到Redis，设置24小时过期
            redisCache.setCacheObject(PEST_ALERT_KEY, alertInfo, 24 * 60 * 60, java.util.concurrent.TimeUnit.SECONDS);
            
            // 小灯黄灯常亮（光照不足报警）
            lightAlarmService.yellowSteady();
            
            return success("报警已创建并同步到所有用户");
        } catch (Exception e) {
            return error("创建报警失败：" + e.getMessage());
        }
    }
    
    /**
     * 获取未读的虫害报警
     */
    @PreAuthorize("@ss.hasPermi('agriculture:planting:query')")
    @GetMapping("/getPestAlert")
    public AjaxResult getPestAlert()
    {
        try {
            // 从Redis获取报警信息
            Map<String, Object> alertInfo = redisCache.getCacheObject(PEST_ALERT_KEY);
            
            if (alertInfo == null) {
                // 没有报警信息（可能已被其他用户处理）
                return success(null);
            }
            
            // 直接返回报警信息（如果存在说明还没有被处理）
            return success(alertInfo);
        } catch (Exception e) {
            return error("获取报警信息失败：" + e.getMessage());
        }
    }
    
    /**
     * 标记报警为已读（任何用户处理后会删除报警，所有用户都不再显示）
     */
    @PreAuthorize("@ss.hasPermi('agriculture:planting:query')")
    @PostMapping("/markPestAlertRead")
    public AjaxResult markPestAlertRead(@RequestBody Map<String, Object> params)
    {
        try {
            Long alertId = params.get("alertId") != null ? 
                Long.valueOf(params.get("alertId").toString()) : null;
            
            if (alertId == null) {
                return error("报警ID不能为空");
            }
            
            // 从Redis获取当前报警信息，验证报警ID是否匹配
            Map<String, Object> alertInfo = redisCache.getCacheObject(PEST_ALERT_KEY);
            if (alertInfo != null) {
                Long currentAlertId = Long.valueOf(alertInfo.get("alertId").toString());
                // 如果报警ID匹配，则删除报警信息（所有用户都不再显示）
                if (currentAlertId.equals(alertId)) {
                    redisCache.deleteObject(PEST_ALERT_KEY);
                    // 小灯熄灭（用户点击确认/取消后）
                    lightAlarmService.turnOff();
                    return success("报警已处理，所有用户将不再显示此报警");
                }
            }
            
            return success("报警已处理");
        } catch (Exception e) {
            return error("标记已读失败：" + e.getMessage());
        }
    }
    
    /**
     * 关闭小灯（Ctrl+4 快捷键调用）
     */
    @PreAuthorize("@ss.hasPermi('agriculture:planting:query')")
    @PostMapping("/turnOffLight")
    public AjaxResult turnOffLight()
    {
        try {
            boolean ok = lightAlarmService.turnOff();
            if (ok) {
                return success("小灯已关闭");
            } else {
                return success("小灯控制不可用或已关闭");
            }
        } catch (Exception e) {
            return error("关闭小灯失败：" + e.getMessage());
        }
    }
}
