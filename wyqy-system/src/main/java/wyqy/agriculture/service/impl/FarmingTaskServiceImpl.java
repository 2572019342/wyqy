package wyqy.agriculture.service.impl;

import java.util.List;
import wyqy.common.utils.DateUtils;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import wyqy.agriculture.mapper.PlantingRecordMapper;
import wyqy.agriculture.mapper.FarmingTaskMapper;
import wyqy.agriculture.domain.FarmingTask;
import wyqy.agriculture.domain.PlantingRecord;
import wyqy.agriculture.service.IFarmingTaskService;

@Service
public class FarmingTaskServiceImpl implements IFarmingTaskService
{
    @Autowired
    private FarmingTaskMapper farmingTaskMapper;

    @Autowired
    private PlantingRecordMapper plantingRecordMapper;

    @Override
    public FarmingTask selectFarmingTaskByTaskId(Long taskId)
    {
        return farmingTaskMapper.selectFarmingTaskByTaskId(taskId);
    }

    @Override
    public List<FarmingTask> selectFarmingTaskList(FarmingTask farmingTask)
    {
        return farmingTaskMapper.selectFarmingTaskList(farmingTask);
    }

    @Override
    public int insertFarmingTask(FarmingTask farmingTask)
    {
        farmingTask.setCreateTime(DateUtils.getNowDate());
        return farmingTaskMapper.insertFarmingTask(farmingTask);
    }

    @Override
    public int updateFarmingTask(FarmingTask farmingTask)
    {
        farmingTask.setUpdateTime(DateUtils.getNowDate());
        return farmingTaskMapper.updateFarmingTask(farmingTask);
    }

    @Override
    public int deleteFarmingTaskByTaskIds(Long[] taskIds)
    {
        return farmingTaskMapper.deleteFarmingTaskByTaskIds(taskIds);
    }

    @Override
    public int deleteFarmingTaskByTaskId(Long taskId)
    {
        return farmingTaskMapper.deleteFarmingTaskByTaskId(taskId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int markTaskDone(Long taskId, String handler)
    {
        FarmingTask task = farmingTaskMapper.selectFarmingTaskByTaskId(taskId);
        if (task == null)
        {
            return 0;
        }

        FarmingTask update = new FarmingTask();
        update.setTaskId(taskId);
        update.setStatus("1");
        update.setHandler(handler);
        update.setHandledTime(DateUtils.getNowDate());
        update.setUpdateBy(handler);
        update.setUpdateTime(DateUtils.getNowDate());
        int rows = farmingTaskMapper.updateFarmingTask(update);

        if (rows > 0 && task.getPlantingId() != null && "pesticide".equals(task.getTaskType()))
        {
            PlantingRecord plantingUpdate = new PlantingRecord();
            plantingUpdate.setPlantingId(task.getPlantingId());
            plantingUpdate.setHealthStatus("healthy");
            plantingUpdate.setUpdateBy(handler);
            plantingUpdate.setUpdateTime(DateUtils.getNowDate());
            plantingRecordMapper.updatePlantingRecord(plantingUpdate);
        }

        return rows;
    }
}
