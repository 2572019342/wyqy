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
import wyqy.agriculture.domain.LandInfo;
import wyqy.agriculture.service.ILandInfoService;
import wyqy.common.utils.poi.ExcelUtil;
import wyqy.common.core.page.TableDataInfo;

/**
 * 地块信息Controller
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
@RestController
@RequestMapping("/agriculture/land")
public class LandInfoController extends BaseController
{
    @Autowired
    private ILandInfoService landInfoService;

    /**
     * 查询地块信息列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:land:list')")
    @GetMapping("/list")
    public TableDataInfo list(LandInfo landInfo)
    {
        startPage();
        List<LandInfo> list = landInfoService.selectLandInfoList(landInfo);
        return getDataTable(list);
    }

    /**
     * 导出地块信息列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:land:export')")
    @Log(title = "地块信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, LandInfo landInfo)
    {
        List<LandInfo> list = landInfoService.selectLandInfoList(landInfo);
        ExcelUtil<LandInfo> util = new ExcelUtil<LandInfo>(LandInfo.class);
        util.exportExcel(response, list, "地块信息数据");
    }

    /**
     * 获取地块信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:land:query')")
    @GetMapping(value = "/{landId}")
    public AjaxResult getInfo(@PathVariable("landId") Long landId)
    {
        return success(landInfoService.selectLandInfoByLandId(landId));
    }

    /**
     * 新增地块信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:land:add')")
    @Log(title = "地块信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody LandInfo landInfo)
    {
        return toAjax(landInfoService.insertLandInfo(landInfo));
    }

    /**
     * 修改地块信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:land:edit')")
    @Log(title = "地块信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody LandInfo landInfo)
    {
        return toAjax(landInfoService.updateLandInfo(landInfo));
    }

    /**
     * 删除地块信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:land:remove')")
    @Log(title = "地块信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{landIds}")
    public AjaxResult remove(@PathVariable Long[] landIds)
    {
        return toAjax(landInfoService.deleteLandInfoByLandIds(landIds));
    }

    /**
     * 获取地块统计信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:land:query')")
    @GetMapping("/stats")
    public AjaxResult getLandStats()
    {
        return success(landInfoService.getLandStats());
    }

    /**
     * 获取可用地块列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:land:query')")
    @GetMapping("/available")
    public AjaxResult getAvailableLands()
    {
        LandInfo query = new LandInfo();
        query.setStatus("0"); // 0表示可用
        List<LandInfo> list = landInfoService.selectLandInfoList(query);
        return success(list);
    }

    /**
     * 获取地块土壤信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:land:query')")
    @GetMapping("/soil/{landId}")
    public AjaxResult getSoilInfo(@PathVariable Long landId)
    {
        LandInfo landInfo = landInfoService.selectLandInfoByLandId(landId);
        if (landInfo == null) {
            return error("地块信息不存在");
        }
        
        // 构建土壤信息响应
        return success(landInfo);
    }

    /**
     * 更新地块土壤信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:land:edit')")
    @Log(title = "更新地块土壤信息", businessType = BusinessType.UPDATE)
    @PutMapping("/soil")
    public AjaxResult updateSoilInfo(@RequestBody LandInfo landInfo)
    {
        return toAjax(landInfoService.updateLandInfo(landInfo));
    }
}
