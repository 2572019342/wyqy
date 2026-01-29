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
import wyqy.agriculture.domain.HarvestRecord;
import wyqy.agriculture.service.IHarvestRecordService;
import wyqy.common.utils.poi.ExcelUtil;
import wyqy.common.core.page.TableDataInfo;

/**
 * 采摘记录Controller
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
@RestController
@RequestMapping("/agriculture/harvest")
public class HarvestRecordController extends BaseController
{
    @Autowired
    private IHarvestRecordService harvestRecordService;

    /**
     * 查询采摘记录列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:harvest:list')")
    @GetMapping("/list")
    public TableDataInfo list(HarvestRecord harvestRecord)
    {
        startPage();
        List<HarvestRecord> list = harvestRecordService.selectHarvestRecordList(harvestRecord);
        return getDataTable(list);
    }

    /**
     * 导出采摘记录列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:harvest:export')")
    @Log(title = "采摘记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, HarvestRecord harvestRecord)
    {
        List<HarvestRecord> list = harvestRecordService.selectHarvestRecordList(harvestRecord);
        ExcelUtil<HarvestRecord> util = new ExcelUtil<HarvestRecord>(HarvestRecord.class);
        util.exportExcel(response, list, "采摘记录数据");
    }

    /**
     * 获取采摘记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:harvest:query')")
    @GetMapping(value = "/{harvestId}")
    public AjaxResult getInfo(@PathVariable("harvestId") Long harvestId)
    {
        return success(harvestRecordService.selectHarvestRecordByHarvestId(harvestId));
    }

    /**
     * 新增采摘记录
     */
    @PreAuthorize("@ss.hasPermi('agriculture:harvest:add')")
    @Log(title = "采摘记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody HarvestRecord harvestRecord)
    {
        return toAjax(harvestRecordService.insertHarvestRecord(harvestRecord));
    }

    /**
     * 修改采摘记录
     */
    @PreAuthorize("@ss.hasPermi('agriculture:harvest:edit')")
    @Log(title = "采摘记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody HarvestRecord harvestRecord)
    {
        return toAjax(harvestRecordService.updateHarvestRecord(harvestRecord));
    }

    /**
     * 删除采摘记录
     */
    @PreAuthorize("@ss.hasPermi('agriculture:harvest:remove')")
    @Log(title = "采摘记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{harvestIds}")
    public AjaxResult remove(@PathVariable Long[] harvestIds)
    {
        return toAjax(harvestRecordService.deleteHarvestRecordByHarvestIds(harvestIds));
    }

    /**
     * 获取可采摘的种植记录
     */
    @PreAuthorize("@ss.hasPermi('agriculture:harvest:query')")
    @GetMapping("/harvestable")
    public AjaxResult getHarvestablePlantings()
    {
        return success(harvestRecordService.getHarvestablePlantings());
    }

    /**
     * 检查种植记录是否可以采摘
     */
    @PreAuthorize("@ss.hasPermi('agriculture:harvest:query')")
    @GetMapping("/check/{plantingId}")
    public AjaxResult checkHarvestable(@PathVariable("plantingId") Long plantingId)
    {
        return success(harvestRecordService.checkHarvestable(plantingId));
    }

    /**
     * 获取采摘统计
     */
    @PreAuthorize("@ss.hasPermi('agriculture:harvest:query')")
    @GetMapping("/stats")
    public AjaxResult getHarvestStats()
    {
        return success(harvestRecordService.getHarvestStats());
    }
}
