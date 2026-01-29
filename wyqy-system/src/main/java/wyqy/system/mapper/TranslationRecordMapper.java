package wyqy.system.mapper;

import org.apache.ibatis.annotations.Param;
import java.util.List;
import wyqy.system.domain.TranslationRecord;

/**
 * 翻译记录Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public interface TranslationRecordMapper 
{
    /**
     * 查询翻译记录
     * 
     * @param recordId 翻译记录主键
     * @return 翻译记录
     */
    public TranslationRecord selectTranslationRecordByRecordId(Long recordId);

    /**
     * 查询翻译记录列表
     * 
     * @param translationRecord 翻译记录
     * @return 翻译记录集合
     */
    public List<TranslationRecord> selectTranslationRecordList(TranslationRecord translationRecord);

    /**
     * 新增翻译记录
     * 
     * @param translationRecord 翻译记录
     * @return 结果
     */
    public int insertTranslationRecord(TranslationRecord translationRecord);

    /**
     * 修改翻译记录
     * 
     * @param translationRecord 翻译记录
     * @return 结果
     */
    public int updateTranslationRecord(TranslationRecord translationRecord);

    /**
     * 删除翻译记录
     * 
     * @param recordId 翻译记录主键
     * @return 结果
     */
    public int deleteTranslationRecordByRecordId(Long recordId);

    /**
     * 批量删除翻译记录
     * 
     * @param recordIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteTranslationRecordByRecordIds(Long[] recordIds);

    /**
     * 根据用户ID查询翻译记录
     * 
     * @param userId 用户ID
     * @param limit 限制数量
     * @return 翻译记录列表
     */
    public List<TranslationRecord> selectTranslationRecordByUserId(@Param("userId") Long userId, @Param("limit") Integer limit);

    /**
     * 统计用户翻译次数
     * 
     * @param userId 用户ID
     * @return 翻译次数
     */
    public Long countTranslationByUserId(Long userId);
}
