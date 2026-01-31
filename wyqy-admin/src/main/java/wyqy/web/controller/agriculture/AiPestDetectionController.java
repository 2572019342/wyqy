package wyqy.web.controller.agriculture;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
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
import wyqy.agriculture.domain.AiPestDetection;
import wyqy.agriculture.service.IAiPestDetectionService;
import wyqy.common.utils.poi.ExcelUtil;
import wyqy.common.core.page.TableDataInfo;

/**
 * AI病虫害识别Controller
 * 
 * @author ruoyi
 * @date 2025-01-30
 */
@RestController
@RequestMapping("/agriculture/ai-pest-detection")
public class AiPestDetectionController extends BaseController
{
    @Autowired
    private IAiPestDetectionService aiPestDetectionService;

    /**
     * 查询AI病虫害识别列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:ai-pest-detection:list')")
    @GetMapping("/list")
    public TableDataInfo list(AiPestDetection aiPestDetection)
    {
        startPage();
        List<AiPestDetection> list = aiPestDetectionService.selectAiPestDetectionList(aiPestDetection);
        return getDataTable(list);
    }

    /**
     * 导出AI病虫害识别列表
     */
    @PreAuthorize("@ss.hasPermi('agriculture:ai-pest-detection:export')")
    @Log(title = "AI病虫害识别", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, AiPestDetection aiPestDetection)
    {
        List<AiPestDetection> list = aiPestDetectionService.selectAiPestDetectionList(aiPestDetection);
        ExcelUtil<AiPestDetection> util = new ExcelUtil<AiPestDetection>(AiPestDetection.class);
        util.exportExcel(response, list, "AI病虫害识别数据");
    }

    /**
     * 获取AI病虫害识别详细信息
     */
    @PreAuthorize("@ss.hasPermi('agriculture:ai-pest-detection:query')")
    @GetMapping(value = "/{detectionId}")
    public AjaxResult getInfo(@PathVariable("detectionId") Long detectionId)
    {
        return success(aiPestDetectionService.selectAiPestDetectionByDetectionId(detectionId));
    }

    /**
     * 新增AI病虫害识别
     */
    @PreAuthorize("@ss.hasPermi('agriculture:ai-pest-detection:add')")
    @Log(title = "AI病虫害识别", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody AiPestDetection aiPestDetection)
    {
        return toAjax(aiPestDetectionService.insertAiPestDetection(aiPestDetection));
    }

    /**
     * 修改AI病虫害识别
     */
    @PreAuthorize("@ss.hasPermi('agriculture:ai-pest-detection:edit')")
    @Log(title = "AI病虫害识别", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody AiPestDetection aiPestDetection)
    {
        return toAjax(aiPestDetectionService.updateAiPestDetection(aiPestDetection));
    }

    /**
     * 删除AI病虫害识别
     */
    @PreAuthorize("@ss.hasPermi('agriculture:ai-pest-detection:remove')")
    @Log(title = "AI病虫害识别", businessType = BusinessType.DELETE)
	@DeleteMapping("/{detectionIds}")
    public AjaxResult remove(@PathVariable Long[] detectionIds)
    {
        return toAjax(aiPestDetectionService.deleteAiPestDetectionByDetectionIds(detectionIds));
    }
    
    /**
     * AI病虫害识别 - 模拟识别接口
     */
    @PreAuthorize("@ss.hasPermi('agriculture:ai-pest-detection:add')")
    @Log(title = "AI病虫害识别", businessType = BusinessType.INSERT)
    @PostMapping("/detect")
    public AjaxResult detect(@RequestBody Map<String, Object> params)
    {
        try {
            Long landId = params.get("landId") != null ? 
                Long.valueOf(params.get("landId").toString()) : null;
            Long speciesId = params.get("speciesId") != null ? 
                Long.valueOf(params.get("speciesId").toString()) : null;
            String landName = params.get("landName") != null ? 
                params.get("landName").toString() : "未知地块";
            String speciesName = params.get("speciesName") != null ? 
                params.get("speciesName").toString() : "未知作物";
            

            Random random = new Random();
            String[] pestTypes = {"pest", "disease"};
            String[] pestNames = {
                 
                "菜青虫"
            };
            String[] recommendations = {
                "建议使用生物农药防治，及时清除受害叶片",
                "建议增加通风，降低湿度，使用专用杀菌剂",
                "建议立即隔离病株，防止扩散，使用系统性杀菌剂",
                "建议人工捕捉，使用天敌防治，保持田间清洁",
                "建议加强水肥管理，提高植株抗性，使用保护性杀菌剂"
            };
            
            // 随机选择病虫害类型和名称
            String detectionType = pestTypes[random.nextInt(pestTypes.length)];
            String pestName = pestNames[random.nextInt(pestNames.length)];
            String recommendation = recommendations[random.nextInt(recommendations.length)];
            Double confidence = 0.75 + random.nextDouble() * 0.24; // 0.75-0.99的置信度
            
            // 创建识别记录
            AiPestDetection detection = new AiPestDetection();
            detection.setLandId(landId);
            detection.setLandName(landName);
            detection.setSpeciesId(speciesId);
            detection.setSpeciesName(speciesName);
            detection.setDetectionType(detectionType);
            detection.setPestName(pestName);
            detection.setConfidence(confidence);
            detection.setFrameTimestamp(System.currentTimeMillis());
            detection.setProcessStatus("pending");
            detection.setRecommendation(recommendation);
            detection.setIsProcessed("0");
            detection.setDetectionTime(new java.util.Date());
            
            // 保存到数据库
            int result = aiPestDetectionService.insertAiPestDetection(detection);
            
            if (result > 0) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("detectionId", detection.getDetectionId());
                response.put("detectionType", detectionType);
                response.put("pestName", pestName);
                response.put("confidence", confidence);
                response.put("recommendation", recommendation);
                response.put("message", "识别到" + (detectionType.equals("pest") ? "虫害" : "病害") + "：" + pestName);
                
                return success(response);
            } else {
                return error("识别失败，请重试");
            }
        } catch (Exception e) {
            return error("识别失败：" + e.getMessage());
        }
    }
    
    /**
     * 获取视频流地址
     */
    @PreAuthorize("@ss.hasPermi('agriculture:ai-pest-detection:query')")
    @GetMapping("/video-stream")
    public AjaxResult getVideoStream()
    {
        Map<String, Object> result = new HashMap<>();
        result.put("videoUrl", "http://192.168.1.103:1145/play_drone.html");
        result.put("streamUrl", "http://192.168.1.103:1145/play_drone.html");
        result.put("snapshotUrl", "http://192.168.1.103:1145/play_drone.html");
        return success(result);
    }
    
    /**
     * 获取识别统计
     */
    @PreAuthorize("@ss.hasPermi('agriculture:ai-pest-detection:query')")
    @GetMapping("/stats")
    public AjaxResult getDetectionStats()
    {
        return success(aiPestDetectionService.getDetectionStats());
    }
    
    /**
     * 标记为已处理
     */
    @PreAuthorize("@ss.hasPermi('agriculture:ai-pest-detection:edit')")
    @Log(title = "AI病虫害识别", businessType = BusinessType.UPDATE)
    @PutMapping("/markProcessed/{detectionId}")
    public AjaxResult markProcessed(@PathVariable Long detectionId)
    {
        return toAjax(aiPestDetectionService.markAsProcessed(detectionId));
    }
}
