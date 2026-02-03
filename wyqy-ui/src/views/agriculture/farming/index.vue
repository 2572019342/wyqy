<template>
  <div class="farming-container">
    <!-- 待办任务提示卡片 -->
    <el-alert
      v-if="urgentTaskCount > 0"
      :title="`您有 ${urgentTaskCount} 个待处理的紧急任务，请及时处理！`"
      type="warning"
      :closable="false"
      show-icon
      class="urgent-alert"
    >
      <template slot="default">
        <span>发现 <strong>{{ urgentTaskCount }}</strong> 个需要紧急处理的种植管理任务，请尽快查看并处理。</span>
        <el-button type="warning" size="small" @click="scrollToTaskList" style="margin-left: 20px;">立即查看</el-button>
      </template>
    </el-alert>

    <!-- 种植管理统计 -->
    <el-row :gutter="20" class="mb20 stats-row">
      <el-col :span="6" v-for="(stat, index) in farmingStats" :key="index">
        <div class="stat-card" :class="'stat-card-' + index" @click="handleStatClick(stat, index)">
          <div class="stat-content">
            <div class="stat-icon">
              <i :class="stat.icon"></i>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stat.value }}</div>
              <div class="stat-label">{{ stat.label }}</div>
            </div>
          </div>
          <div class="stat-decoration"></div>
        </div>
      </el-col>
    </el-row>

    <!-- 待办任务列表（优先显示） -->
    <div class="task-card priority-card">
      <div class="card-header">
        <div class="header-title">
          <i class="el-icon-s-order"></i>
          <span>待办任务</span>
          <el-badge :value="pendingTaskCount" :max="99" class="task-badge" v-if="pendingTaskCount > 0">
            <span></span>
          </el-badge>
        </div>
        <div class="header-actions">
          <el-button size="small" icon="el-icon-refresh" @click="getTaskList">刷新</el-button>
        </div>
      </div>

      <!-- 查询条件和操作按钮 -->
      <div class="search-section" v-show="showTaskSearch">
        <el-form :model="taskQueryParams" ref="taskQueryForm" size="small" :inline="true" label-width="68px">
          <el-form-item label="状态" prop="status">
            <el-select v-model="taskQueryParams.status" placeholder="请选择状态" clearable class="search-select" style="width: 180px">
              <el-option label="待办" value="0" />
              <el-option label="已完成" value="1" />
            </el-select>
          </el-form-item>
          <el-form-item label="类型" prop="taskType">
            <el-select v-model="taskQueryParams.taskType" placeholder="请选择类型" clearable class="search-select" style="width: 180px">
              <el-option label="施药" value="pesticide" />
              <el-option label="施肥" value="fertilizer" />
              <el-option label="灌溉" value="irrigation" />
              <el-option label="除草" value="weeding" />
              <el-option label="其他" value="other" />
            </el-select>
          </el-form-item>
          <el-form-item label="标题" prop="title">
            <el-input v-model="taskQueryParams.title" placeholder="请输入标题" clearable class="search-input" style="width: 200px" @keyup.enter.native="handleTaskQuery" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="handleTaskQuery" class="search-btn">搜索</el-button>
            <el-button icon="el-icon-refresh" size="mini" @click="resetTaskQuery" class="reset-btn">重置</el-button>
          </el-form-item>
          <el-form-item style="margin-left: auto;">
            <right-toolbar :showSearch.sync="showTaskSearch" @queryTable="getTaskList"></right-toolbar>
          </el-form-item>
        </el-form>
      </div>

      <!-- 隐藏搜索条件时的快速操作栏 -->
      <div class="quick-actions" v-show="!showTaskSearch">
        <div class="quick-actions-left">
          <el-button size="small" icon="el-icon-search" @click="showTaskSearch = true" class="search-toggle-btn">显示搜索</el-button>
        </div>
        <div class="quick-actions-right">
          <right-toolbar :showSearch.sync="showTaskSearch" @queryTable="getTaskList"></right-toolbar>
        </div>
      </div>

      <!-- 数据表格 -->
      <div class="table-section">
        <el-table v-loading="taskLoading" :data="taskList" class="modern-table" 
                  :row-class-name="getTaskRowClassName" @row-click="handleTaskRowClick">
          <el-table-column label="地块名称" align="center" prop="landName" min-width="120" />
          <el-table-column label="作物名称" align="center" prop="speciesName" min-width="120" />
          <el-table-column label="类型" align="center" prop="taskType" min-width="100">
            <template slot-scope="scope">
              <el-tag :type="getManagementTypeTag(scope.row.taskType)" size="small">{{ getManagementTypeText(scope.row.taskType) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="标题" align="center" prop="title" min-width="150">
            <template slot-scope="scope">
              <span :class="{ 'urgent-title': scope.row.status === '0' && isUrgentTask(scope.row) }">
                <i class="el-icon-warning" v-if="scope.row.status === '0' && isUrgentTask(scope.row)" style="color: #E6A23C; margin-right: 4px;"></i>
                {{ scope.row.title }}
              </span>
            </template>
          </el-table-column>
          <el-table-column label="状态" align="center" prop="status" width="100">
            <template slot-scope="scope">
              <el-tag :type="scope.row.status === '1' ? 'success' : 'warning'" size="small">{{ scope.row.status === '1' ? '已完成' : '待办' }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="创建时间" align="center" prop="createTime" width="180">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
            </template>
          </el-table-column>
          <el-table-column label="处理人" align="center" prop="handler" min-width="100">
            <template slot-scope="scope">
              <span>{{ scope.row.handler || '--' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="处理时间" align="center" prop="handledTime" width="180">
            <template slot-scope="scope">
              <span>{{ scope.row.handledTime ? parseTime(scope.row.handledTime, '{y}-{m}-{d} {h}:{i}:{s}') : '--' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
            <template slot-scope="scope">
              <el-button size="mini" type="success" icon="el-icon-check" :disabled="scope.row.status === '1'" 
                        @click.stop="handleTaskDone(scope.row)" class="action-link">完成</el-button>
              <el-button size="mini" type="primary" icon="el-icon-view" @click.stop="handleTaskView(scope.row)" 
                        class="action-link">查看</el-button>
              <el-button size="mini" type="warning" icon="el-icon-edit" :disabled="scope.row.status === '1'" 
                        @click.stop="handleTaskProcess(scope.row)" class="action-link">处理</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 分页 -->
      <div class="pagination-section">
        <pagination v-show="taskTotal>0" :total="taskTotal" :page.sync="taskQueryParams.pageNum" 
                    :limit.sync="taskQueryParams.pageSize" @pagination="getTaskList" />
      </div>
    </div>

    <!-- 处理任务对话框 -->
    <el-dialog title="处理任务" :visible.sync="operationOpen" width="900px" append-to-body 
               class="farming-dialog" :close-on-click-modal="false">
      <el-form :model="operationForm" ref="operationForm" :rules="operationRules" label-width="100px" class="dialog-form">
        <el-row>
          <el-col :span="8">
            <el-form-item label="选择地块" prop="landId">
              <el-select v-model="operationForm.landId" placeholder="请选择地块" class="form-select" style="width: 100%" @change="handleLandChange">
                <el-option v-for="land in landOptions" :key="land.landId" :label="land.landName" :value="land.landId"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="选择种植" prop="plantingId">
              <el-select v-model="operationForm.plantingId" placeholder="请选择种植记录" class="form-select" style="width: 100%" @change="handlePlantingChange">
                <el-option v-for="planting in plantingOptions" :key="planting.plantingId" :label="`${planting.speciesName} - ${planting.plantingDate}`" :value="planting.plantingId"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="管理类型" prop="managementType">
              <el-select v-model="operationForm.managementType" placeholder="请选择管理类型" class="form-select" style="width: 100%" @change="handleTypeChange">
                <el-option label="施肥" value="fertilizer" />
                <el-option label="施药" value="pesticide" />
                <el-option label="灌溉" value="irrigation" />
                <el-option label="除草" value="weeding" />
                <el-option label="其他" value="other" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row>
          <el-col :span="12">
            <el-form-item label="物料名称" prop="materialName">
              <el-input v-model="operationForm.materialName" placeholder="请输入物料名称" class="form-input" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="物料类型" prop="materialType">
              <el-input v-model="operationForm.materialType" placeholder="请输入物料类型" class="form-input" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row>
          <el-col :span="8">
            <el-form-item label="用量" prop="dosage">
              <el-input-number v-model="operationForm.dosage" :precision="2" :step="0.1" :min="0" class="form-number" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="单位" prop="unit">
              <el-select v-model="operationForm.unit" placeholder="请选择单位" class="form-select" style="width: 100%">
                <el-option label="kg" value="kg" />
                <el-option label="g" value="g" />
                <el-option label="L" value="L" />
                <el-option label="mL" value="mL" />
                <el-option label="亩" value="亩" />
                <el-option label="m³" value="m³" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="管理时间" prop="managementDate">
              <el-date-picker v-model="operationForm.managementDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss"
                              placeholder="选择时间" class="form-date-picker" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row>
          <el-col :span="12">
            <el-form-item label="使用方法" prop="method">
              <el-input v-model="operationForm.method" placeholder="请输入使用方法" class="form-input" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="目的" prop="purpose">
              <el-input v-model="operationForm.purpose" placeholder="请输入目的" class="form-input" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row>
          <el-col :span="8">
            <el-form-item label="成本" prop="cost">
              <el-input-number v-model="operationForm.cost" :precision="2" :step="0.01" :min="0" class="form-number" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="操作人员" prop="operator">
              <el-input v-model="operationForm.operator" placeholder="请输入操作人员" class="form-input" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="天气条件" prop="weatherCondition">
              <el-input v-model="operationForm.weatherCondition" placeholder="请输入天气条件" class="form-input" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-form-item label="效果描述" prop="effect">
          <el-input v-model="operationForm.effect" type="textarea" placeholder="请输入效果描述" class="form-textarea" :rows="3" />
        </el-form-item>
        
        <el-form-item label="备注" prop="notes">
          <el-input v-model="operationForm.notes" type="textarea" placeholder="请输入备注信息" class="form-textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancelOperation" class="cancel-btn">取 消</el-button>
        <el-button type="primary" @click="submitOperation" :loading="submitting" class="submit-btn">确 定</el-button>
      </div>
    </el-dialog>


    <!-- 任务详情对话框 -->
    <el-dialog title="任务详情" :visible.sync="taskViewOpen" width="800px" append-to-body 
               class="farming-dialog" :close-on-click-modal="false" @opened="refreshTaskDetail">
      <el-descriptions :column="2" border v-if="currentTask" class="dialog-descriptions" :key="taskDetailKey">
        <el-descriptions-item label="地块名称">{{ currentTask.landName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="作物名称">{{ currentTask.speciesName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="类型">
          <el-tag :type="getManagementTypeTag(currentTask.taskType)">{{ getManagementTypeText(currentTask.taskType) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="currentTask.status === '1' ? 'success' : 'warning'">{{ currentTask.status === '1' ? '已完成' : '待办' }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="标题" span="2">{{ currentTask.title || '--' }}</el-descriptions-item>
        <el-descriptions-item label="内容" span="2">{{ currentTask.content || '--' }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ parseTime(currentTask.createTime, '{y}-{m}-{d} {h}:{i}:{s}') || '--' }}</el-descriptions-item>
        <el-descriptions-item label="创建人">{{ currentTask.createBy || '--' }}</el-descriptions-item>
        <el-descriptions-item label="处理人">{{ currentTask.handler || '--' }}</el-descriptions-item>
        <el-descriptions-item label="处理时间">{{ currentTask.handledTime ? parseTime(currentTask.handledTime, '{y}-{m}-{d} {h}:{i}:{s}') : '--' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>




    <!-- 添加或修改种植管理对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body 
               class="farming-dialog" :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px" class="dialog-form">
        <el-row>
          <el-col :span="12">
            <el-form-item label="种植记录" prop="plantingId">
              <el-select v-model="form.plantingId" placeholder="请选择种植记录" class="form-select" style="width: 100%">
                <el-option v-for="planting in allPlantingOptions" :key="planting.plantingId" :label="`${planting.landName} - ${planting.speciesName}`" :value="planting.plantingId"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="管理类型" prop="managementType">
              <el-select v-model="form.managementType" placeholder="请选择管理类型" class="form-select" style="width: 100%">
                <el-option label="施肥" value="fertilizer" />
                <el-option label="施药" value="pesticide" />
                <el-option label="灌溉" value="irrigation" />
                <el-option label="除草" value="weeding" />
                <el-option label="其他" value="other" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="物料名称" prop="materialName">
              <el-input v-model="form.materialName" placeholder="请输入物料名称" class="form-input" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="物料类型" prop="materialType">
              <el-input v-model="form.materialType" placeholder="请输入物料类型" class="form-input" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="用量" prop="dosage">
              <el-input-number v-model="form.dosage" :precision="2" :step="0.1" :min="0" class="form-number" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="单位" prop="unit">
              <el-select v-model="form.unit" placeholder="请选择单位" class="form-select" style="width: 100%">
                <el-option label="kg" value="kg" />
                <el-option label="g" value="g" />
                <el-option label="L" value="L" />
                <el-option label="mL" value="mL" />
                <el-option label="亩" value="亩" />
                <el-option label="m³" value="m³" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="管理时间" prop="managementDate">
              <el-date-picker v-model="form.managementDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss"
                              placeholder="选择时间" class="form-date-picker" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="使用方法" prop="method">
              <el-input v-model="form.method" placeholder="请输入使用方法" class="form-input" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="目的" prop="purpose">
              <el-input v-model="form.purpose" placeholder="请输入目的" class="form-input" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="成本" prop="cost">
              <el-input-number v-model="form.cost" :precision="2" :step="0.01" :min="0" class="form-number" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="操作人员" prop="operator">
              <el-input v-model="form.operator" placeholder="请输入操作人员" class="form-input" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="天气条件" prop="weatherCondition">
              <el-input v-model="form.weatherCondition" placeholder="请输入天气条件" class="form-input" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="效果描述" prop="effect">
          <el-input v-model="form.effect" type="textarea" placeholder="请输入效果描述" class="form-textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="备注" prop="notes">
          <el-input v-model="form.notes" type="textarea" placeholder="请输入备注信息" class="form-textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel" class="cancel-btn">取 消</el-button>
        <el-button type="primary" @click="submitForm" class="submit-btn">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 查看管理详情对话框 -->
    <el-dialog title="管理详情" :visible.sync="viewOpen" width="800px" append-to-body 
               class="farming-dialog" :close-on-click-modal="false">
      <el-descriptions :column="2" border v-if="currentFarming" class="dialog-descriptions">
        <el-descriptions-item label="地块名称">{{ currentFarming.landName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="作物名称">{{ currentFarming.speciesName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="管理类型">
          <el-tag :type="getManagementTypeTag(currentFarming.managementType)">{{ getManagementTypeText(currentFarming.managementType) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="物料名称">{{ currentFarming.materialName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="物料类型">{{ currentFarming.materialType || '--' }}</el-descriptions-item>
        <el-descriptions-item label="用量">{{ currentFarming.dosage || '--' }} {{ currentFarming.unit || '' }}</el-descriptions-item>
        <el-descriptions-item label="管理时间">{{ parseTime(currentFarming.managementDate, '{y}-{m}-{d} {h}:{i}:{s}') || '--' }}</el-descriptions-item>
        <el-descriptions-item label="使用方法">{{ currentFarming.method || '--' }}</el-descriptions-item>
        <el-descriptions-item label="目的">{{ currentFarming.purpose || '--' }}</el-descriptions-item>
        <el-descriptions-item label="效果描述">{{ currentFarming.effect || '无' }}</el-descriptions-item>
        <el-descriptions-item label="成本">{{ currentFarming.cost || '--' }} 元</el-descriptions-item>
        <el-descriptions-item label="操作人员">{{ currentFarming.operator || '--' }}</el-descriptions-item>
        <el-descriptions-item label="天气条件">{{ currentFarming.weatherCondition || '--' }}</el-descriptions-item>
        <el-descriptions-item label="备注" span="2">{{ currentFarming.notes || '无' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script>
import { listFarming, getFarming, delFarming, addFarming, updateFarming, getFarmingStats } from "@/api/agriculture/farming";
import { listLand } from "@/api/agriculture/land";
import { listPlanting } from "@/api/agriculture/planting";
import { listTask, markTaskDone, getTask } from "@/api/agriculture/task";

export default {
  name: "Farming",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 种植管理表格数据
      farmingList: [],
      // 地块选项
      landOptions: [],
      // 种植选项
      plantingOptions: [],
      // 所有种植选项
      allPlantingOptions: [],
      // 管理统计数据
      farmingStats: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      viewOpen: false,
      // 当前查看的管理记录
      currentFarming: null,
      // 提交状态
      submitting: false,
      // 任务列表
      taskLoading: false,
      showTaskSearch: true,
      taskTotal: 0,
      taskList: [],
      taskQueryParams: {
        pageNum: 1,
        pageSize: 10,
        status: '0',  // 默认只显示待办任务
        taskType: null,
        title: null
      },
      taskRefreshTimer: null,  // 任务刷新定时器
      taskViewOpen: false,
      currentTask: null,
      taskDetailKey: 0,  // 用于强制刷新任务详情
      operationOpen: false,  // 控制处理任务对话框是否显示
      // 操作表单
      operationForm: {
        landId: null,
        plantingId: null,
        managementType: null,
        materialName: '',
        materialType: '',
        dosage: null,
        unit: 'kg',
        managementDate: (() => {
          const now = new Date();
          const year = now.getFullYear();
          const month = String(now.getMonth() + 1).padStart(2, '0');
          const day = String(now.getDate()).padStart(2, '0');
          const hour = String(now.getHours()).padStart(2, '0');
          const minute = String(now.getMinutes()).padStart(2, '0');
          const second = String(now.getSeconds()).padStart(2, '0');
          return `${year}-${month}-${day} ${hour}:${minute}:${second}`;
        })(),
        method: '',
        purpose: '',
        effect: '',
        cost: null,
        operator: '',
        weatherCondition: '',
        notes: ''
      },
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        landName: null,
        speciesName: null,
        managementType: null,
      },
      // 表单参数
      form: {},
      // 操作表单校验
      operationRules: {
        landId: [
          { required: true, message: "地块不能为空", trigger: "change" }
        ],
        plantingId: [
          { required: true, message: "种植记录不能为空", trigger: "change" }
        ],
        managementType: [
          { required: true, message: "管理类型不能为空", trigger: "change" }
        ],
        materialName: [
          { required: true, message: "物料名称不能为空", trigger: "blur" }
        ],
        dosage: [
          { required: true, message: "用量不能为空", trigger: "blur" }
        ],
        unit: [
          { required: true, message: "单位不能为空", trigger: "change" }
        ],
        managementDate: [
          { required: true, message: "管理时间不能为空", trigger: "change" }
        ],
      },
      // 表单校验
      rules: {
        plantingId: [
          { required: true, message: "种植记录不能为空", trigger: "change" }
        ],
        managementType: [
          { required: true, message: "管理类型不能为空", trigger: "change" }
        ],
        materialName: [
          { required: true, message: "物料名称不能为空", trigger: "blur" }
        ],
        dosage: [
          { required: true, message: "用量不能为空", trigger: "blur" }
        ],
        unit: [
          { required: true, message: "单位不能为空", trigger: "change" }
        ],
        managementDate: [
          { required: true, message: "管理时间不能为空", trigger: "change" }
        ],
      }
    };
  },
  computed: {
    // 待办任务数量
    pendingTaskCount() {
      return this.taskList.filter(task => task.status === '0').length;
    },
    // 紧急任务数量（病重等需要紧急处理的）
    urgentTaskCount() {
      return this.taskList.filter(task => {
        return task.status === '0' && this.isUrgentTask(task);
      }).length;
    }
  },
  created() {
    this.getList();
    this.getTaskList();
    this.getLandOptions();
    this.getAllPlantingOptions();
    this.getFarmingStatistics();
    // 定时刷新待办任务列表（每30秒）
    this.taskRefreshTimer = setInterval(() => {
      this.getTaskList();
    }, 30000);
  },
  beforeDestroy() {
    // 清除定时器
    if (this.taskRefreshTimer) {
      clearInterval(this.taskRefreshTimer);
    }
  },
  methods: {
    /** 查询种植管理列表 */
    getList() {
      this.loading = true;
      listFarming(this.queryParams).then(response => {
        this.farmingList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },

    /** 获取种植管理统计数据（供统计卡片显示） */
    getFarmingStatistics() {
      getFarmingStats().then(response => {
        const data = response.data || {};
        const typeStats = data.managementTypeStats || {};
        this.farmingStats = [
          { icon: 'el-icon-s-operation', value: data.totalOperations ?? 0, label: '总管理次数' },
          { icon: 'el-icon-present', value: typeStats.fertilizer ?? 0, label: '施肥次数' },
          { icon: 'el-icon-warning', value: typeStats.pesticide ?? 0, label: '施药次数' },
          { icon: 'el-icon-money', value: data.totalCost ?? 0, label: '总成本(元)' }
        ];
      }).catch(() => {
        this.farmingStats = [
          { icon: 'el-icon-s-operation', value: 0, label: '总管理次数' },
          { icon: 'el-icon-present', value: 0, label: '施肥次数' },
          { icon: 'el-icon-warning', value: 0, label: '施药次数' },
          { icon: 'el-icon-money', value: 0, label: '总成本(元)' }
        ];
      });
    },

    /** 查询任务列表 */
    getTaskList() {
      this.taskLoading = true;
      // 默认只显示待办任务
      if (this.taskQueryParams.status === null || this.taskQueryParams.status === undefined) {
        this.taskQueryParams.status = '0';
      }
      listTask(this.taskQueryParams).then(response => {
        // 确保数据正确更新
        if (response && response.rows) {
          this.taskList = response.rows;
          this.taskTotal = response.total || 0;
        } else {
          this.taskList = [];
          this.taskTotal = 0;
        }
        this.taskLoading = false;
        
        // 如果有紧急任务，显示提示（只在待办任务中检查）
        if (this.taskQueryParams.status === '0' && this.urgentTaskCount > 0) {
          this.$notify({
            title: '紧急提醒',
            message: `发现 ${this.urgentTaskCount} 个需要紧急处理的种植管理任务！`,
            type: 'warning',
            duration: 5000,
            position: 'top-right'
          });
        }
      }).catch((error) => {
        console.error('获取任务列表失败:', error);
        this.taskList = [];
        this.taskTotal = 0;
        this.taskLoading = false;
      });
    },

    handleTaskQuery() {
      this.taskQueryParams.pageNum = 1;
      this.getTaskList();
    },

    resetTaskQuery() {
      this.resetForm("taskQueryForm");
      this.taskQueryParams.pageNum = 1;
      this.taskQueryParams.pageSize = 10;
      this.taskQueryParams.status = '0';
      this.getTaskList();
    },

    handleTaskDone(row) {
      this.$modal.confirm('确认将该任务标记为已完成吗？').then(() => {
        return markTaskDone(row.taskId);
      }).then((response) => {
        this.$modal.msgSuccess('任务已标记为已完成');
        
        // 如果当前查看的是这个任务，更新详情数据
        if (this.currentTask && this.currentTask.taskId === row.taskId) {
          // 重新获取任务详情，确保数据是最新的
          getTask(row.taskId).then(res => {
            if (res && res.data) {
              this.currentTask = res.data;
            } else {
              // 如果获取失败，手动更新当前任务状态
              this.currentTask.status = '1';
              this.currentTask.handler = this.$store.state.user?.name || this.$store.state.user?.userName || '当前用户';
              this.currentTask.handledTime = new Date().toISOString().replace('T', ' ').substring(0, 19);
            }
          }).catch(() => {
            // 如果获取失败，手动更新当前任务状态
            this.currentTask.status = '1';
            this.currentTask.handler = this.$store.state.user?.name || this.$store.state.user?.userName || '当前用户';
            this.currentTask.handledTime = new Date().toISOString().replace('T', ' ').substring(0, 19);
          });
        }
        
        // 立即更新本地列表数据，提供即时反馈
        const taskIndex = this.taskList.findIndex(t => t.taskId === row.taskId);
        if (taskIndex !== -1) {
          // 如果当前筛选条件是待办任务，标记完成后应该从列表中移除
          if (this.taskQueryParams.status === '0') {
            this.taskList.splice(taskIndex, 1);
            this.taskTotal = Math.max(0, this.taskTotal - 1);
          } else {
            // 如果显示所有任务，更新任务状态
            const currentUser = this.$store.state.user?.name || this.$store.state.user?.userName || '当前用户';
            const now = new Date();
            const handledTime = now.getFullYear() + '-' + 
              String(now.getMonth() + 1).padStart(2, '0') + '-' + 
              String(now.getDate()).padStart(2, '0') + ' ' + 
              String(now.getHours()).padStart(2, '0') + ':' + 
              String(now.getMinutes()).padStart(2, '0') + ':' + 
              String(now.getSeconds()).padStart(2, '0');
            this.$set(this.taskList[taskIndex], 'status', '1');
            this.$set(this.taskList[taskIndex], 'handler', currentUser);
            this.$set(this.taskList[taskIndex], 'handledTime', handledTime);
          }
        }
        
        // 延迟刷新列表以确保数据同步（给后端一点时间更新）
        setTimeout(() => {
          this.getTaskList();
        }, 300);
        
        // 刷新种植记录列表，因为完成病虫害任务可能会更新种植记录的健康状态
        setTimeout(() => {
          this.getAllPlantingOptions();
        }, 500);
      }).catch((error) => {
        console.error('标记任务完成失败:', error);
        this.$modal.msgError('操作失败，请重试');
      });
    },

    handleTaskView(row) {
      // 重新获取任务详情，确保数据是最新的
      getTask(row.taskId).then(response => {
        this.currentTask = response.data || row;
        this.taskDetailKey = Date.now(); // 更新key以强制刷新
        this.taskViewOpen = true;
      }).catch(() => {
        // 如果获取失败，使用当前行数据
        this.currentTask = row;
        this.taskDetailKey = Date.now(); // 更新key以强制刷新
        this.taskViewOpen = true;
      });
    },
    // 刷新任务详情（对话框打开时）
    refreshTaskDetail() {
      if (this.currentTask && this.currentTask.taskId) {
        // 对话框打开时，重新获取最新数据
        getTask(this.currentTask.taskId).then(response => {
          if (response && response.data) {
            this.currentTask = response.data;
            this.taskDetailKey = Date.now(); // 更新key以强制刷新
          }
        }).catch(() => {
          // 获取失败时不做处理，使用已有数据
        });
      }
    },
    // 点击任务行
    handleTaskRowClick(row) {
      // 双击或点击处理按钮时自动填充表单
      if (row.status === '0') {
        this.handleTaskProcess(row);
      }
    },
    // 处理任务（点击处理按钮，自动填充表单）
    handleTaskProcess(row) {
      // 根据任务信息自动填充操作表单
      if (row.plantingId) {
        // 查找对应的种植记录
        const planting = this.allPlantingOptions.find(p => p.plantingId === row.plantingId);
        if (planting) {
          this.operationForm.landId = planting.landId;
          this.operationForm.plantingId = row.plantingId;
          this.operationForm.managementType = row.taskType || 'pesticide';
          
          // 如果是病虫害任务，自动填充一些信息
          if (row.taskType === 'pesticide') {
            this.operationForm.materialType = '农药';
            this.operationForm.purpose = '防治病虫害';
            if (row.content && row.content.includes('健康状态:')) {
              const healthStatus = row.content.split('健康状态:')[1]?.split(';')[0]?.trim();
              if (healthStatus === 'serious' || healthStatus === 'disease' || healthStatus === 'pest') {
                this.operationForm.notes = `紧急处理：${row.content}`;
              }
            }
          }
          
          // 显示处理任务对话框
          this.operationOpen = true;
        }
      }
    },
    // 判断是否为紧急任务
    isUrgentTask(task) {
      if (!task.content) return false;
      // 检查内容中是否包含紧急关键词
      const urgentKeywords = ['serious', '病重', '紧急', 'urgent', 'disease', 'pest'];
      const content = (task.content || '').toLowerCase();
      return urgentKeywords.some(keyword => content.includes(keyword.toLowerCase()));
    },
    // 获取任务行的类名
    getTaskRowClassName({ row }) {
      if (row.status === '0' && this.isUrgentTask(row)) {
        return 'row-urgent';
      }
      return '';
    },
    // 滚动到任务列表
    scrollToTaskList() {
      const taskElement = document.querySelector('.task-card');
      if (taskElement) {
        taskElement.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    },
    // 获取地块选项
    getLandOptions() {
      // 传递足够大的pageSize以获取所有可用地块
      listLand({ 
        status: '0',
        pageNum: 1,
        pageSize: 1000  // 设置足够大的值以获取所有数据
      }).then(response => {
        this.landOptions = response.rows || [];
      }).catch(error => {
        console.error('获取地块列表失败:', error);
        this.$message.error('获取地块列表失败');
      });
    },
    // 获取所有种植选项
    getAllPlantingOptions() {
      // 传递足够大的pageSize以获取所有种植记录
      listPlanting({
        pageNum: 1,
        pageSize: 1000  // 设置足够大的值以获取所有数据
      }).then(response => {
        this.allPlantingOptions = response.rows || [];
      }).catch(error => {
        console.error('获取种植记录列表失败:', error);
        this.$message.error('获取种植记录列表失败');
      });
    },
    // 地块改变事件
    handleLandChange(landId) {
      this.operationForm.plantingId = null;
      if (landId) {
        // 传递足够大的pageSize以获取该地块的所有种植记录
        listPlanting({ 
          landId: landId,
          pageNum: 1,
          pageSize: 1000  // 设置足够大的值以获取所有数据
        }).then(response => {
          this.plantingOptions = response.rows || [];
        }).catch(error => {
          console.error('获取种植记录失败:', error);
          this.$message.error('获取种植记录失败');
        });
      } else {
        this.plantingOptions = [];
      }
    },
    // 种植改变事件
    handlePlantingChange(plantingId) {
      // 可以在这里根据种植记录设置一些默认值
    },
    // 管理类型改变事件
    handleTypeChange(type) {
      // 根据管理类型设置一些默认值
      if (type === 'fertilizer') {
        this.operationForm.unit = 'kg';
        this.operationForm.materialType = '化肥';
      } else if (type === 'pesticide') {
        this.operationForm.unit = 'L';
        this.operationForm.materialType = '农药';
      } else if (type === 'irrigation') {
        this.operationForm.unit = 'm³';
        this.operationForm.materialType = '水';
      }
    },

    // 统计卡片点击事件
    handleStatClick(stat, index) {
      this.$message.info(`点击了${stat.label}: ${stat.value}`);
    },
    // 获取管理类型文本
    getManagementTypeText(type) {
      const textMap = {
        'fertilizer': '施肥',
        'pesticide': '施药',
        'irrigation': '灌溉',
        'weeding': '除草',
        'other': '其他'
      };
      return textMap[type] || type;
    },
    // 获取管理类型标签
    getManagementTypeTag(type) {
      const tagMap = {
        'fertilizer': 'success',
        'pesticide': 'danger',
        'irrigation': 'primary',
        'weeding': 'warning',
        'other': 'info'
      };
      return tagMap[type] || '';
    },
    // 提交管理操作
    // 提交操作表单
    submitOperation() {
      this.$refs["operationForm"].validate(valid => {
        if (valid) {
          this.submitting = true;
          addFarming(this.operationForm).then(response => {
            this.$modal.msgSuccess("管理记录添加成功！");
            this.cancelOperation();
            this.getList();
            this.getFarmingStatistics();
            // 刷新任务列表，检查是否有新任务或已完成的任务
            this.getTaskList();
          }).finally(() => {
            this.submitting = false;
          });
        }
      });
    },
    // 重置操作表单
    resetOperation() {
      const now = new Date();
      const year = now.getFullYear();
      const month = String(now.getMonth() + 1).padStart(2, '0');
      const day = String(now.getDate()).padStart(2, '0');
      const hour = String(now.getHours()).padStart(2, '0');
      const minute = String(now.getMinutes()).padStart(2, '0');
      const second = String(now.getSeconds()).padStart(2, '0');
      this.operationForm = {
        landId: null,
        plantingId: null,
        managementType: null,
        materialName: '',
        materialType: '',
        dosage: null,
        unit: 'kg',
        managementDate: `${year}-${month}-${day} ${hour}:${minute}:${second}`,
        method: '',
        purpose: '',
        effect: '',
        cost: null,
        operator: '',
        weatherCondition: '',
        notes: ''
      };
    },
    // 取消处理任务对话框
    cancelOperation() {
      this.operationOpen = false;
      this.resetOperation();
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        managementId: null,
        plantingId: null,
        managementType: null,
        materialName: null,
        materialType: null,
        dosage: null,
        unit: null,
        managementDate: null,
        method: null,
        purpose: null,
        effect: null,
        cost: null,
        operator: null,
        weatherCondition: null,
        notes: null
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.managementId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加种植管理";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const managementId = row.managementId || this.ids
      getFarming(managementId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改种植管理";
      });
    },
    /** 查看按钮操作 */
    handleView(row) {
      this.currentFarming = row;
      this.viewOpen = true;
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.managementId != null) {
            updateFarming(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
              this.getFarmingStatistics();
            });
          } else {
            addFarming(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
              this.getFarmingStatistics();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const managementIds = row.managementId || this.ids;
      this.$modal.confirm('是否确认删除种植管理编号为"' + managementIds + '"的数据项？').then(function() {
        return delFarming(managementIds);
      }).then(() => {
        this.getList();
        this.getFarmingStatistics();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('agriculture/farming/export', {
        ...this.queryParams
      }, `farming_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>

<style scoped>
/* 主容器样式 - 清新自然背景 */
.farming-container {
  background: linear-gradient(135deg, #f0f9f4 0%, #e8f5f0 50%, #f5f9fc 100%);
  min-height: 100vh;
  padding: 24px;
}

/* 统计卡片样式 - 农业主题配色 */
.stat-card {
  position: relative;
  color: white;
  border: none;
  border-radius: 20px;
  padding: 0;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
}

.stat-card:hover {
  transform: translateY(-8px) scale(1.02);
}

/* 自然绿色 - 总管理 */
.stat-card-0 {
  background: linear-gradient(145deg, #2E7D32 0%, #66BB6A 100%);
  box-shadow: 0 10px 40px rgba(46, 125, 50, 0.35);
}
.stat-card-0:hover {
  box-shadow: 0 20px 50px rgba(46, 125, 50, 0.45);
}

/* 土壤棕色 - 施肥 */
.stat-card-1 {
  background: linear-gradient(145deg, #5D4037 0%, #8D6E63 100%);
  box-shadow: 0 10px 40px rgba(93, 64, 55, 0.35);
}
.stat-card-1:hover {
  box-shadow: 0 20px 50px rgba(93, 64, 55, 0.45);
}

/* 警示橙色 - 施药 */
.stat-card-2 {
  background: linear-gradient(145deg, #E65100 0%, #FF9800 100%);
  box-shadow: 0 10px 40px rgba(230, 81, 0, 0.35);
}
.stat-card-2:hover {
  box-shadow: 0 20px 50px rgba(230, 81, 0, 0.45);
}

/* 天空蓝色 - 成本 */
.stat-card-3 {
  background: linear-gradient(145deg, #0277BD 0%, #4FC3F7 100%);
  box-shadow: 0 10px 40px rgba(2, 119, 189, 0.35);
}
.stat-card-3:hover {
  box-shadow: 0 20px 50px rgba(2, 119, 189, 0.45);
}

.stat-content {
  display: flex;
  align-items: center;
  padding: 28px 24px;
  position: relative;
  z-index: 2;
}

.stat-icon {
  width: 64px;
  height: 64px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20px;
  backdrop-filter: blur(10px);
}

.stat-icon i {
  font-size: 32px;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 36px;
  font-weight: 700;
  margin-bottom: 6px;
  letter-spacing: -0.5px;
}

.stat-label {
  font-size: 15px;
  opacity: 0.9;
  font-weight: 500;
}

.stat-decoration {
  position: absolute;
  top: -30%;
  right: -10%;
  width: 150px;
  height: 150px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
}

/* 紧急提示样式 */
.urgent-alert {
  margin-bottom: 24px;
  border-radius: 16px;
  border: none;
  background: linear-gradient(135deg, #FFF8E1 0%, #FFECB3 100%);
  box-shadow: 0 4px 20px rgba(255, 152, 0, 0.2);
}

.urgent-alert >>> .el-alert__title {
  font-size: 16px;
  font-weight: 600;
  color: #E65100;
}

.urgent-alert >>> .el-alert__icon {
  color: #FF9800;
}

/* 任务卡片样式 */
.task-card {
  background: white;
  border-radius: 20px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06);
  overflow: hidden;
  margin-top: 24px;
  border: 1px solid rgba(46, 125, 50, 0.1);
}

/* 优先卡片样式（待办任务） */
.priority-card {
  border: 2px solid #66BB6A;
  box-shadow: 0 8px 32px rgba(46, 125, 50, 0.15);
}

.task-badge {
  margin-left: 12px;
}

.task-badge >>> .el-badge__content {
  background: linear-gradient(135deg, #E65100, #FF9800);
  border: none;
  font-weight: 600;
  box-shadow: 0 2px 8px rgba(230, 81, 0, 0.3);
}

.card-header {
  background: linear-gradient(135deg, #2E7D32 0%, #43A047 100%);
  color: white;
  padding: 22px 28px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-title {
  display: flex;
  align-items: center;
  font-size: 18px;
  font-weight: 600;
  gap: 12px;
}

.header-title i {
  font-size: 22px;
}

.header-actions .el-button {
  background: rgba(255, 255, 255, 0.15);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  border-radius: 10px;
  transition: all 0.3s;
}

.header-actions .el-button:hover {
  background: rgba(255, 255, 255, 0.25);
  transform: translateY(-2px);
}

/* 搜索区域样式 */
.search-section {
  padding: 20px 28px;
  background: #FAFFFE;
  border-bottom: 1px solid rgba(46, 125, 50, 0.1);
}

.search-section .el-form {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 12px;
}

.search-section .el-form-item {
  margin-bottom: 0;
}

.search-select >>> .el-input__inner,
.search-input >>> .el-input__inner {
  border-radius: 10px;
  border: 2px solid #E8F5E9;
  transition: all 0.3s;
}

.search-select >>> .el-input__inner:hover,
.search-input >>> .el-input__inner:hover,
.search-select >>> .el-input__inner:focus,
.search-input >>> .el-input__inner:focus {
  border-color: #66BB6A;
  box-shadow: 0 0 0 3px rgba(102, 187, 106, 0.15);
}

.search-btn {
  background: linear-gradient(135deg, #2E7D32, #43A047) !important;
  border: none !important;
  border-radius: 10px !important;
  color: white !important;
  font-weight: 500;
  padding: 9px 20px !important;
  transition: all 0.3s;
}

.search-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(46, 125, 50, 0.35);
}

.reset-btn {
  background: white !important;
  border: 2px solid #E8F5E9 !important;
  border-radius: 10px !important;
  color: #5D4037 !important;
  font-weight: 500;
  transition: all 0.3s;
}

.reset-btn:hover {
  border-color: #66BB6A !important;
  color: #2E7D32 !important;
  background: #F1F8E9 !important;
}

/* 快速操作栏 */
.quick-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 28px;
  background: #FAFFFE;
  border-bottom: 1px solid rgba(46, 125, 50, 0.1);
}

.search-toggle-btn {
  background: white !important;
  border: 2px solid #E8F5E9 !important;
  border-radius: 10px !important;
  color: #5D4037 !important;
  transition: all 0.3s;
}

.search-toggle-btn:hover {
  border-color: #66BB6A !important;
  color: #2E7D32 !important;
}

/* 表格区域 */
.table-section {
  padding: 0 28px;
}

.modern-table {
  border-radius: 12px;
  overflow: hidden;
}

.modern-table >>> .el-table__header-wrapper {
  border-radius: 12px 12px 0 0;
}

.modern-table >>> .el-table__header th {
  background: linear-gradient(135deg, #E8F5E9 0%, #C8E6C9 100%) !important;
  color: #2E7D32 !important;
  font-weight: 600;
  border: none;
  padding: 18px 12px;
  font-size: 14px;
}

.modern-table >>> .el-table__body tr {
  transition: all 0.3s;
  cursor: pointer;
}

.modern-table >>> .el-table__body tr:hover td {
  background-color: #F1F8E9 !important;
}

.modern-table >>> .el-table__body tr.row-urgent {
  background: linear-gradient(90deg, #FFF8E1, #FFFFFF) !important;
}

.modern-table >>> .el-table__body tr.row-urgent td {
  border-left: 4px solid #FF9800;
}

.modern-table >>> .el-table__body tr.row-urgent:hover td {
  background-color: #FFF3E0 !important;
}

.urgent-title {
  color: #E65100;
  font-weight: 600;
}

/* 操作按钮 */
.action-link {
  margin: 0 3px;
  padding: 6px 12px;
  border-radius: 8px;
  font-weight: 500;
  font-size: 12px;
  transition: all 0.3s;
  border: none;
}

.action-link.el-button--success {
  background: linear-gradient(135deg, #2E7D32, #43A047);
}

.action-link.el-button--primary {
  background: linear-gradient(135deg, #0277BD, #039BE5);
}

.action-link.el-button--warning {
  background: linear-gradient(135deg, #E65100, #FF9800);
}

.action-link:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

/* 分页区域 */
.pagination-section {
  padding: 24px 28px;
  display: flex;
  justify-content: center;
  background: #FAFFFE;
  border-top: 1px solid rgba(46, 125, 50, 0.1);
}

/* 对话框样式 */
.farming-dialog >>> .el-dialog {
  border-radius: 20px;
  overflow: hidden;
}

.farming-dialog >>> .el-dialog__header {
  background: linear-gradient(135deg, #2E7D32 0%, #43A047 100%);
  padding: 24px 32px;
  margin: 0;
}

.farming-dialog >>> .el-dialog__title {
  color: white;
  font-size: 20px;
  font-weight: 600;
}

.farming-dialog >>> .el-dialog__headerbtn .el-dialog__close {
  color: white;
  font-size: 20px;
}

.farming-dialog >>> .el-dialog__body {
  padding: 32px;
  background: #FAFFFE;
}

/* 表单样式 */
.dialog-form .el-form-item__label {
  color: #2E7D32;
  font-weight: 500;
}

.form-input >>> .el-input__inner,
.form-select >>> .el-input__inner,
.form-date-picker >>> .el-input__inner {
  border-radius: 10px;
  border: 2px solid #E8F5E9;
  transition: all 0.3s;
}

.form-input >>> .el-input__inner:focus,
.form-select >>> .el-input__inner:focus,
.form-date-picker >>> .el-input__inner:focus {
  border-color: #66BB6A;
  box-shadow: 0 0 0 3px rgba(102, 187, 106, 0.15);
}

.form-number >>> .el-input__inner {
  border-radius: 10px;
  border: 2px solid #E8F5E9;
}

.form-textarea >>> .el-textarea__inner {
  border-radius: 10px;
  border: 2px solid #E8F5E9;
  transition: all 0.3s;
}

.form-textarea >>> .el-textarea__inner:focus {
  border-color: #66BB6A;
  box-shadow: 0 0 0 3px rgba(102, 187, 106, 0.15);
}

/* 对话框描述列表 */
.dialog-descriptions {
  padding: 20px 0;
}

.dialog-descriptions >>> .el-descriptions__label {
  background: #E8F5E9 !important;
  color: #2E7D32;
  font-weight: 600;
}

.dialog-descriptions >>> .el-descriptions__content {
  color: #5D4037;
}

/* 对话框底部 */
.dialog-footer {
  text-align: right;
  padding: 20px 32px;
  background: #F1F8E9;
  border-top: 1px solid #C8E6C9;
}

.cancel-btn {
  background: white !important;
  border: 2px solid #E8F5E9 !important;
  border-radius: 10px !important;
  color: #5D4037 !important;
  padding: 12px 24px !important;
  font-weight: 500;
  transition: all 0.3s;
}

.cancel-btn:hover {
  border-color: #66BB6A !important;
  color: #2E7D32 !important;
}

.submit-btn {
  background: linear-gradient(135deg, #2E7D32, #43A047) !important;
  border: none !important;
  border-radius: 10px !important;
  color: white !important;
  padding: 12px 24px !important;
  font-weight: 500;
  transition: all 0.3s;
}

.submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(46, 125, 50, 0.35);
}

/* Element UI 组件覆盖 */
.farming-container >>> .el-tag--success {
  background: #E8F5E9;
  border-color: #A5D6A7;
  color: #2E7D32;
}

.farming-container >>> .el-tag--warning {
  background: #FFF3E0;
  border-color: #FFCC80;
  color: #E65100;
}

.farming-container >>> .el-tag--danger {
  background: #FFEBEE;
  border-color: #EF9A9A;
  color: #C62828;
}

.farming-container >>> .el-tag--primary {
  background: #E3F2FD;
  border-color: #90CAF9;
  color: #0277BD;
}

.farming-container >>> .el-tag--info {
  background: #ECEFF1;
  border-color: #B0BEC5;
  color: #546E7A;
}

/* 间距样式 */
.mb20 {
  margin-bottom: 24px;
}

.mb8 {
  margin-bottom: 8px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .farming-container {
    padding: 16px;
  }
  
  .stat-card {
    margin-bottom: 16px;
  }
  
  .stat-content {
    padding: 20px;
  }
  
  .stat-value {
    font-size: 28px;
  }
  
  .card-header {
    padding: 18px 20px;
  }
  
  .search-section,
  .quick-actions,
  .table-section,
  .pagination-section {
    padding-left: 20px;
    padding-right: 20px;
  }
  
  .dialog-footer {
    padding: 16px 20px;
  }
}
</style>
