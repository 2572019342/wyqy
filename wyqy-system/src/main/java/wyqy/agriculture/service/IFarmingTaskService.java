package wyqy.agriculture.service;

import java.util.List;
import wyqy.agriculture.domain.FarmingTask;

public interface IFarmingTaskService
{
    public FarmingTask selectFarmingTaskByTaskId(Long taskId);

    public List<FarmingTask> selectFarmingTaskList(FarmingTask farmingTask);

    public int insertFarmingTask(FarmingTask farmingTask);

    public int updateFarmingTask(FarmingTask farmingTask);

    public int deleteFarmingTaskByTaskIds(Long[] taskIds);

    public int deleteFarmingTaskByTaskId(Long taskId);

    public int markTaskDone(Long taskId, String handler);
}
