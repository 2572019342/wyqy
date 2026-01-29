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
import wyqy.agriculture.domain.FarmingManagement;
import wyqy.agriculture.service.IFarmingManagementService;
import wyqy.common.utils.poi.ExcelUtil;
import wyqy.common.core.page.TableDataInfo;

/**
 * 种植管理Controller
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
@RestController
@RequestMapping("/agriculture/farming")
public class FarmingManagementController extends BaseController
{
    @Autowired
    private IFarmingManagementService farmingManagementService;

    /**
     * 查询种植管理列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:farming:list')")
    @GetMapping("/list")
    public TableDataInfo list(FarmingManagement farmingManagement)
    {
        startPage();
        List<FarmingManagement> list = farmingManagementService.selectFarmingManagementList(farmingManagement);
        return getDataTable(list);
    }

    /**
     * 导出种植管理列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:farming:export')")
    @Log(title = "种植管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, FarmingManagement farmingManagement)
    {
        List<FarmingManagement> list = farmingManagementService.selectFarmingManagementList(farmingManagement);
        ExcelUtil<FarmingManagement> util = new ExcelUtil<FarmingManagement>(FarmingManagement.class);
        util.exportExcel(response, list, "种植管理数据");
    }

    /**
     * 获取种植管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:farming:query')")
    @GetMapping(value = "/{farmingId}")
    public AjaxResult getInfo(@PathVariable("farmingId") Long farmingId)
    {
        return success(farmingManagementService.selectFarmingManagementByFarmingId(farmingId));
    }

    /**
     * 新增种植管理
     */
    @PreAuthorize("@ss.hasPermi('agriculture:farming:add')")
    @Log(title = "种植管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody FarmingManagement farmingManagement)
    {
        return toAjax(farmingManagementService.insertFarmingManagement(farmingManagement));
    }

    /**
     * 修改种植管理
     */
    @PreAuthorize("@ss.hasPermi('agriculture:farming:edit')")
    @Log(title = "种植管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody FarmingManagement farmingManagement)
    {
        return toAjax(farmingManagementService.updateFarmingManagement(farmingManagement));
    }

    /**
     * 删除种植管理
     */
    @PreAuthorize("@ss.hasPermi('agriculture:farming:remove')")
    @Log(title = "种植管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{farmingIds}")
    public AjaxResult remove(@PathVariable Long[] farmingIds)
    {
        return toAjax(farmingManagementService.deleteFarmingManagementByFarmingIds(farmingIds));
    }

    /**
     * 获取种植管理统计信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:farming:query')")
    @GetMapping("/stats")
    public AjaxResult getFarmingStats()
    {
        return success(farmingManagementService.getFarmingStats());
    }

    /**
     * 获取种植农事历史
     */
    @PreAuthorize("@ss.hasPermi('agriculture:farming:query')")
    @GetMapping("/history/{plantingId}")
    public AjaxResult getPlantingFarmingHistory(@PathVariable("plantingId") Long plantingId)
    {
        return success(farmingManagementService.getPlantingFarmingHistory(plantingId));
    }
}
