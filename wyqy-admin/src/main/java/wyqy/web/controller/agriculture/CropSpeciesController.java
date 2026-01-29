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
import wyqy.agriculture.domain.CropSpecies;
import wyqy.agriculture.service.ICropSpeciesService;
import wyqy.common.utils.poi.ExcelUtil;
import wyqy.common.core.page.TableDataInfo;

/**
 * 作物种类Controller
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
@RestController
@RequestMapping("/agriculture/crop")
public class CropSpeciesController extends BaseController
{
    @Autowired
    private ICropSpeciesService cropSpeciesService;

    /**
     * 查询作物种类列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:crop:list')")
    @GetMapping("/list")
    public TableDataInfo list(CropSpecies cropSpecies)
    {
        startPage();
        List<CropSpecies> list = cropSpeciesService.selectCropSpeciesList(cropSpecies);
        return getDataTable(list);
    }

    /**
     * 导出作物种类列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:crop:export')")
    @Log(title = "作物种类", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CropSpecies cropSpecies)
    {
        List<CropSpecies> list = cropSpeciesService.selectCropSpeciesList(cropSpecies);
        ExcelUtil<CropSpecies> util = new ExcelUtil<CropSpecies>(CropSpecies.class);
        util.exportExcel(response, list, "作物种类数据");
    }

    /**
     * 获取作物种类详细信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:crop:query')")
    @GetMapping(value = "/{speciesId}")
    public AjaxResult getInfo(@PathVariable("speciesId") Long speciesId)
    {
        return success(cropSpeciesService.selectCropSpeciesBySpeciesId(speciesId));
    }

    /**
     * 新增作物种类
     */
    @PreAuthorize("@ss.hasPermi('agriculture:crop:add')")
    @Log(title = "作物种类", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody CropSpecies cropSpecies)
    {
        return toAjax(cropSpeciesService.insertCropSpecies(cropSpecies));
    }

    /**
     * 修改作物种类
     */
    @PreAuthorize("@ss.hasPermi('agriculture:crop:edit')")
    @Log(title = "作物种类", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody CropSpecies cropSpecies)
    {
        return toAjax(cropSpeciesService.updateCropSpecies(cropSpecies));
    }

    /**
     * 删除作物种类
     */
    @PreAuthorize("@ss.hasPermi('agriculture:crop:remove')")
    @Log(title = "作物种类", businessType = BusinessType.DELETE)
	@DeleteMapping("/{speciesIds}")
    public AjaxResult remove(@PathVariable Long[] speciesIds)
    {
        try {
            return toAjax(cropSpeciesService.deleteCropSpeciesBySpeciesIds(speciesIds));
        } catch (RuntimeException e) {
            return error(e.getMessage());
        } catch (Exception e) {
            // 捕获外键约束异常
            if (e.getCause() instanceof java.sql.SQLIntegrityConstraintViolationException) {
                return error("无法删除该作物种类，该作物种类已被种植记录引用，请先删除相关的种植记录");
            }
            return error("删除失败：" + e.getMessage());
        }
    }

    /**
     * 获取作物分类统计信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:crop:query')")
    @GetMapping("/category-stats")
    public AjaxResult getCategoryStats()
    {
        return success(cropSpeciesService.getCategoryStats());
    }

    /**
     * 获取作物种类统计信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:crop:query')")
    @GetMapping("/stats")
    public AjaxResult getCropStats()
    {
        return success(cropSpeciesService.getCropStats());
    }

    /**
     * 获取可用作物种类列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:crop:query')")
    @GetMapping("/available")
    public AjaxResult getAvailableCrops()
    {
        CropSpecies query = new CropSpecies();
        query.setStatus("0"); // 0表示可用
        List<CropSpecies> list = cropSpeciesService.selectCropSpeciesList(query);
        return success(list);
    }
}
