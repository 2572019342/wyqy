package wyqy.web.controller.system;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
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
import wyqy.common.utils.http.UserAgentUtils;
import wyqy.common.utils.ip.IpUtils;
import wyqy.system.domain.TranslationRecord;
import wyqy.system.domain.TranslationCorpus;
import wyqy.system.domain.vo.TranslationRequest;
import wyqy.system.domain.vo.TranslationResponse;
import wyqy.system.service.ITranslationService;
import wyqy.common.utils.poi.ExcelUtil;
import wyqy.common.core.page.TableDataInfo;

/**
 * 翻译管理Controller
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
@RestController
@RequestMapping("/system/translation")
public class TranslationController extends BaseController
{
    @Autowired
    private ITranslationService translationService;

    /**
     * 执行翻译
     */
    @PostMapping("/translate")
    public AjaxResult translate(@RequestBody TranslationRequest request, HttpServletRequest httpRequest)
    {
        // 获取User-Agent信息
        String userAgent = httpRequest.getHeader("User-Agent");
        String browser = UserAgentUtils.getBrowser(userAgent);
        String os = UserAgentUtils.getOperatingSystem(userAgent);
        String ipAddress = IpUtils.getIpAddr(httpRequest);
        
        TranslationResponse response = translationService.translate(request, ipAddress, browser, os);
        return AjaxResult.success(response);
    }

    /**
     * 查询翻译记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:translation:list')")
    @GetMapping("/record/list")
    public TableDataInfo list(TranslationRecord translationRecord)
    {
        startPage();
        List<TranslationRecord> list = translationService.selectTranslationRecordList(translationRecord);
        return getDataTable(list);
    }

    /**
     * 导出翻译记录列表
     */
    @PreAuthorize("@ss.hasPermi('system:translation:export')")
    @Log(title = "翻译记录", businessType = BusinessType.EXPORT)
    @PostMapping("/record/export")
    public void export(HttpServletResponse response, TranslationRecord translationRecord)
    {
        List<TranslationRecord> list = translationService.selectTranslationRecordList(translationRecord);
        ExcelUtil<TranslationRecord> util = new ExcelUtil<TranslationRecord>(TranslationRecord.class);
        util.exportExcel(response, list, "翻译记录数据");
    }

    /**
     * 获取翻译记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:translation:query')")
    @GetMapping("/record/{recordId}")
    public AjaxResult getInfo(@PathVariable("recordId") Long recordId)
    {
        return AjaxResult.success(translationService.selectTranslationRecordByRecordId(recordId));
    }

    /**
     * 删除翻译记录
     */
    @PreAuthorize("@ss.hasPermi('system:translation:remove')")
    @Log(title = "翻译记录", businessType = BusinessType.DELETE)
    @DeleteMapping("/record/{recordIds}")
    public AjaxResult remove(@PathVariable Long[] recordIds)
    {
        return toAjax(translationService.deleteTranslationRecordByRecordIds(recordIds));
    }

    /**
     * 获取用户翻译历史
     */
    @GetMapping("/history")
    public AjaxResult getHistory(Integer limit)
    {
        if (limit == null || limit <= 0) {
            limit = 10;
        }
        Long userId = getUserId();
        List<TranslationRecord> history = translationService.getTranslationHistory(userId, limit);
        return AjaxResult.success(history);
    }

    /**
     * 查询语料库列表
     */
    @PreAuthorize("@ss.hasPermi('system:corpus:list')")
    @GetMapping("/corpus/list")
    public TableDataInfo corpusList(TranslationCorpus translationCorpus)
    {
        startPage();
        List<TranslationCorpus> list = translationService.selectTranslationCorpusList(translationCorpus);
        return getDataTable(list);
    }

    /**
     * 获取语料库详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:corpus:query')")
    @GetMapping("/corpus/{corpusId}")
    public AjaxResult getCorpusInfo(@PathVariable("corpusId") Long corpusId)
    {
        return AjaxResult.success(translationService.selectTranslationCorpusByCorpusId(corpusId));
    }

    /**
     * 新增语料库
     */
    @PreAuthorize("@ss.hasPermi('system:corpus:add')")
    @Log(title = "语料库", businessType = BusinessType.INSERT)
    @PostMapping("/corpus")
    public AjaxResult addCorpus(@RequestBody TranslationCorpus translationCorpus)
    {
        return toAjax(translationService.insertTranslationCorpus(translationCorpus));
    }

    /**
     * 修改语料库
     */
    @PreAuthorize("@ss.hasPermi('system:corpus:edit')")
    @Log(title = "语料库", businessType = BusinessType.UPDATE)
    @PutMapping("/corpus")
    public AjaxResult editCorpus(@RequestBody TranslationCorpus translationCorpus)
    {
        return toAjax(translationService.updateTranslationCorpus(translationCorpus));
    }

    /**
     * 删除语料库
     */
    @PreAuthorize("@ss.hasPermi('system:corpus:remove')")
    @Log(title = "语料库", businessType = BusinessType.DELETE)
    @DeleteMapping("/corpus/{corpusIds}")
    public AjaxResult removeCorpus(@PathVariable Long[] corpusIds)
    {
        return toAjax(translationService.deleteTranslationCorpusByCorpusIds(corpusIds));
    }
}
