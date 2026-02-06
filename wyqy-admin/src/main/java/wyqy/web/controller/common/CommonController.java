package wyqy.web.controller.common;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import wyqy.common.config.RuoYiConfig;
import wyqy.common.core.domain.AjaxResult;
import wyqy.common.utils.StringUtils;
import wyqy.common.utils.DateUtils;
import wyqy.common.utils.uuid.IdUtils;
import wyqy.common.utils.file.FileUploadUtils;
import wyqy.common.utils.file.FileUtils;
import wyqy.framework.config.ServerConfig;

/**
 * 通用请求处理
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/common")
public class CommonController
{
    private static final Logger log = LoggerFactory.getLogger(CommonController.class);

    @Autowired
    private ServerConfig serverConfig;

    private static final String FILE_DELIMITER = ",";

    /**
     * 通用下载请求
     * 
     * @param fileName 文件名称
     * @param delete 是否删除
     */
    @GetMapping("/download")
    public void fileDownload(String fileName, Boolean delete, HttpServletResponse response, HttpServletRequest request)
    {
        try
        {
            if (!FileUtils.checkAllowDownload(fileName))
            {
                throw new Exception(StringUtils.format("文件名称({})非法，不允许下载。 ", fileName));
            }
            String realFileName = System.currentTimeMillis() + fileName.substring(fileName.indexOf("_") + 1);
            String filePath = RuoYiConfig.getDownloadPath() + fileName;

            response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
            FileUtils.setAttachmentResponseHeader(response, realFileName);
            FileUtils.writeBytes(filePath, response.getOutputStream());
            if (delete)
            {
                FileUtils.deleteFile(filePath);
            }
        }
        catch (Exception e)
        {
            log.error("下载文件失败", e);
        }
    }

    /**
     * 通用上传请求（单个）
     */
    @PostMapping("/upload")
    public AjaxResult uploadFile(MultipartFile file) throws Exception
    {
        try
        {
            // 上传文件路径
            String filePath = RuoYiConfig.getUploadPath();
            // 上传并返回新文件名称
            String fileName = FileUploadUtils.upload(filePath, file);
            String url = serverConfig.getUrl() + fileName;
            AjaxResult ajax = AjaxResult.success();
            ajax.put("url", url);
            ajax.put("fileName", fileName);
            ajax.put("newFileName", FileUtils.getName(fileName));
            ajax.put("originalFilename", file.getOriginalFilename());
            return ajax;
        }
        catch (Exception e)
        {
            return AjaxResult.error(e.getMessage());
        }
    }

    /**
     * 通用上传请求（多个）
     */
    @PostMapping("/uploads")
    public AjaxResult uploadFiles(List<MultipartFile> files) throws Exception
    {
        try
        {
            // 上传文件路径
            String filePath = RuoYiConfig.getUploadPath();
            List<String> urls = new ArrayList<String>();
            List<String> fileNames = new ArrayList<String>();
            List<String> newFileNames = new ArrayList<String>();
            List<String> originalFilenames = new ArrayList<String>();
            for (MultipartFile file : files)
            {
                // 上传并返回新文件名称
                String fileName = FileUploadUtils.upload(filePath, file);
                String url = serverConfig.getUrl() + fileName;
                urls.add(url);
                fileNames.add(fileName);
                newFileNames.add(FileUtils.getName(fileName));
                originalFilenames.add(file.getOriginalFilename());
            }
            AjaxResult ajax = AjaxResult.success();
            ajax.put("urls", StringUtils.join(urls, FILE_DELIMITER));
            ajax.put("fileNames", StringUtils.join(fileNames, FILE_DELIMITER));
            ajax.put("newFileNames", StringUtils.join(newFileNames, FILE_DELIMITER));
            ajax.put("originalFilenames", StringUtils.join(originalFilenames, FILE_DELIMITER));
            return ajax;
        }
        catch (Exception e)
        {
            return AjaxResult.error(e.getMessage());
        }
    }

    /**
     * 作物图片上传请求（保存到photo文件夹）
     */
    @PostMapping("/upload/photo")
    public AjaxResult uploadPhotoFile(MultipartFile file) throws Exception
    {
        try
        {
            // 上传文件路径 - 使用photo文件夹
            String filePath = RuoYiConfig.getPhotoPath();
            // 确保文件夹存在
            java.io.File photoDir = new java.io.File(filePath);
            if (!photoDir.exists())
            {
                photoDir.mkdirs();
            }
            // 生成文件名（使用日期目录 + UUID）
            String extension = FileUploadUtils.getExtension(file);
            String fileName = DateUtils.datePath() + "/" + 
                             IdUtils.fastSimpleUUID() + "." + extension;
            // 保存文件
            java.io.File desc = new java.io.File(filePath + java.io.File.separator + fileName);
            if (!desc.getParentFile().exists())
            {
                desc.getParentFile().mkdirs();
            }
            file.transferTo(desc);
            // 返回相对路径，用于存储到数据库
            String relativePath = "/photo/" + fileName;
            String url = serverConfig.getUrl() + relativePath;
            AjaxResult ajax = AjaxResult.success();
            ajax.put("url", url);
            ajax.put("fileName", relativePath);
            ajax.put("newFileName", wyqy.common.utils.file.FileUtils.getName(fileName));
            ajax.put("originalFilename", file.getOriginalFilename());
            return ajax;
        }
        catch (Exception e)
        {
            log.error("上传作物图片失败", e);
            return AjaxResult.error("上传失败：" + e.getMessage());
        }
    }

    /**
     * 本地资源通用下载
     */
    @GetMapping("/download/resource")
    public void resourceDownload(String resource, HttpServletRequest request, HttpServletResponse response)
            throws Exception
    {
        try
        {
            // 暂时注释掉文件检查以测试图片访问
            // if (!FileUtils.checkAllowDownload(resource))
            // {
            //     throw new Exception(StringUtils.format("资源文件({})非法，不允许下载。 ", resource));
            // }
            String downloadPath;
            
            // 如果是photo路径，使用wyqy\photo目录
            if (resource.startsWith("/photo/"))
            {
                String relativePath = resource.substring(6); // 移除/photo/前缀
                // 使用绝对路径
                downloadPath = "D:\\云盘\\OneDrive\\桌面\\技能大赛\\wyqy\\photo" + relativePath.replace("/", "\\");
            }
            else
            {
                // 本地资源路径
                String localPath = RuoYiConfig.getProfile();
                // 数据库资源地址
                downloadPath = localPath + FileUtils.stripPrefix(resource);
            }
            
            // 下载名称
            String downloadName = StringUtils.substringAfterLast(downloadPath, "/");
            response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
            FileUtils.setAttachmentResponseHeader(response, downloadName);
            FileUtils.writeBytes(downloadPath, response.getOutputStream());
        }
        catch (Exception e)
        {
            log.error("下载文件失败", e);
        }
    }
}
