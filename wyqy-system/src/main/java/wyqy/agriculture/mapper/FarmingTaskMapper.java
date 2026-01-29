package wyqy.agriculture.mapper;

import java.util.List;
import wyqy.agriculture.domain.FarmingTask;

public interface FarmingTaskMapper
{
    public FarmingTask selectFarmingTaskByTaskId(Long taskId);

    public List<FarmingTask> selectFarmingTaskList(FarmingTask farmingTask);

    public int insertFarmingTask(FarmingTask farmingTask);

    public int updateFarmingTask(FarmingTask farmingTask);

    public int deleteFarmingTaskByTaskId(Long taskId);

    public int deleteFarmingTaskByTaskIds(Long[] taskIds);

    /**
     * 根据种植记录ID批量删除农事任务
     * 
     * @param plantingIds 种植记录ID数组
     * @return 结果
     */
    public int deleteFarmingTaskByPlantingIds(Long[] plantingIds);
}
