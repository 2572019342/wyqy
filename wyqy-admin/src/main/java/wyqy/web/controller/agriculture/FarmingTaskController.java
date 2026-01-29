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
import wyqy.common.core.page.TableDataInfo;
import wyqy.common.enums.BusinessType;
import wyqy.common.utils.SecurityUtils;
import wyqy.common.utils.poi.ExcelUtil;
import wyqy.agriculture.domain.FarmingTask;
import wyqy.agriculture.service.IFarmingTaskService;

@RestController
@RequestMapping("/agriculture/task")
public class FarmingTaskController extends BaseController
{
    @Autowired
    private IFarmingTaskService farmingTaskService;

    @PreAuthorize("@ss.hasPermi('agriculture:task:list')")
    @GetMapping("/list")
    public TableDataInfo list(FarmingTask farmingTask)
    {
        startPage();
        List<FarmingTask> list = farmingTaskService.selectFarmingTaskList(farmingTask);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('agriculture:task:export')")
    @Log(title = "农事待办", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, FarmingTask farmingTask)
    {
        List<FarmingTask> list = farmingTaskService.selectFarmingTaskList(farmingTask);
        ExcelUtil<FarmingTask> util = new ExcelUtil<FarmingTask>(FarmingTask.class);
        util.exportExcel(response, list, "农事待办数据");
    }

    @PreAuthorize("@ss.hasPermi('agriculture:task:query')")
    @GetMapping(value = "/{taskId}")
    public AjaxResult getInfo(@PathVariable("taskId") Long taskId)
    {
        return success(farmingTaskService.selectFarmingTaskByTaskId(taskId));
    }

    @PreAuthorize("@ss.hasPermi('agriculture:task:add')")
    @Log(title = "农事待办", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody FarmingTask farmingTask)
    {
        return toAjax(farmingTaskService.insertFarmingTask(farmingTask));
    }

    @PreAuthorize("@ss.hasPermi('agriculture:task:edit')")
    @Log(title = "农事待办", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody FarmingTask farmingTask)
    {
        return toAjax(farmingTaskService.updateFarmingTask(farmingTask));
    }

    @PreAuthorize("@ss.hasPermi('agriculture:task:edit')")
    @Log(title = "农事待办", businessType = BusinessType.UPDATE)
    @PutMapping("/done/{taskId}")
    public AjaxResult markDone(@PathVariable("taskId") Long taskId)
    {
        return toAjax(farmingTaskService.markTaskDone(taskId, SecurityUtils.getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('agriculture:task:remove')")
    @Log(title = "农事待办", businessType = BusinessType.DELETE)
    @DeleteMapping("/{taskIds}")
    public AjaxResult remove(@PathVariable Long[] taskIds)
    {
        return toAjax(farmingTaskService.deleteFarmingTaskByTaskIds(taskIds));
    }
}
