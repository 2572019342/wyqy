<template>
  <div class="planting-container" @keydown="handleKeyDown" tabindex="0">
    <!-- 种植统计概览 -->
    <el-row :gutter="20" class="mb20">
      <el-col :span="6" v-for="(stat, index) in plantingStats" :key="index">
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
          <div class="stat-glow"></div>
        </div>
      </el-col>
    </el-row>

    <!-- 查询条件 -->
    <div class="search-section" v-show="showSearch">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="68px">
        <el-form-item label="地块名称" prop="landName">
          <el-input v-model="queryParams.landName" placeholder="请输入地块名称" clearable 
                   class="search-input" @keyup.enter.native="handleQuery" />
        </el-form-item>
        <el-form-item label="作物名称" prop="speciesName">
          <el-input v-model="queryParams.speciesName" placeholder="请输入作物名称" clearable 
                   class="search-input" @keyup.enter.native="handleQuery" />
        </el-form-item>
        <el-form-item label="生长阶段" prop="growthStage">
          <el-select v-model="queryParams.growthStage" placeholder="请选择生长阶段" clearable class="search-select">
            <el-option label="播种期" value="播种期" />
            <el-option label="发芽期" value="发芽期" />
            <el-option label="幼苗期" value="幼苗期" />
            <el-option label="生长期" value="生长期" />
            <el-option label="开花期" value="开花期" />
            <el-option label="结果期" value="结果期" />
            <el-option label="成熟期" value="成熟期" />
          </el-select>
        </el-form-item>
        <el-form-item label="健康状况" prop="healthStatus">
          <el-select v-model="queryParams.healthStatus" placeholder="请选择健康状况" clearable class="search-select">
            <el-option label="健康" value="healthy" />
            <el-option label="亚健康" value="subhealthy" />
            <el-option label="病害" value="disease" />
            <el-option label="虫害" value="pest" />
            <el-option label="病重" value="serious" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" 
                     class="search-btn">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery" 
                     class="reset-btn">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 操作按钮 -->
    <el-row :gutter="10" class="mb8 action-buttons">
      <el-col :span="1.5">
        <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAdd" 
                   v-hasPermi="['agriculture:planting:add']" class="action-btn add-btn">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" 
                   v-hasPermi="['agriculture:planting:edit']" class="action-btn edit-btn">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" 
                   v-hasPermi="['agriculture:planting:remove']" class="action-btn delete-btn">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" icon="el-icon-download" size="mini" @click="handleExport" 
                   v-hasPermi="['agriculture:planting:export']" class="action-btn export-btn">导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <!-- 数据卡片 -->
    <div v-loading="loading" class="cards-container">
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="item in plantingList" :key="item.plantingId" class="card-col">
          <el-card class="planting-data-card" :class="{ 'card-selected': isSelected(item.plantingId) }">
            <div slot="header" class="card-header">
              <el-checkbox 
                :value="isSelected(item.plantingId)" 
                @change="toggleSelection(item)"
                class="card-checkbox"
              ></el-checkbox>
              <div class="card-title">
                <i class="el-icon-location-outline"></i>
                <span>{{ item.landName || '未知地块' }}</span>
              </div>
            </div>
            <div class="card-body">
              <div class="data-grid">
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-plant"></i>
                    <span>作物名称</span>
                  </div>
                  <div class="data-value">{{ item.speciesName || '--' }}</div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-date"></i>
                    <span>种植日期</span>
                  </div>
                  <div class="data-value">{{ parseTime(item.plantingDate, '{y}-{m}-{d}') || '--' }}</div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-s-data"></i>
                    <span>种植面积</span>
                  </div>
                  <div class="data-value">{{ item.plantingArea !== null && item.plantingArea !== undefined ? item.plantingArea + ' 亩' : '--' }}</div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-s-grid"></i>
                    <span>种植密度</span>
                  </div>
                  <div class="data-value">{{ item.plantingDensity !== null && item.plantingDensity !== undefined ? item.plantingDensity + ' 株/亩' : '--' }}</div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-s-marketing"></i>
                    <span>生长阶段</span>
                  </div>
                  <div class="data-value">
                    <el-tag size="mini" :type="getGrowthStageType(item.growthStage)">{{ item.growthStage || '--' }}</el-tag>
                  </div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-s-check"></i>
                    <span>健康状况</span>
                  </div>
                  <div class="data-value">
                    <el-tag size="mini" :type="getHealthStatusType(item.healthStatus)">{{ getHealthStatusText(item.healthStatus) || '--' }}</el-tag>
                  </div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-success"></i>
                    <span>是否成熟</span>
                  </div>
                  <div class="data-value">
                    <el-tag size="mini" :type="item.isMature === '1' ? 'success' : 'info'">
                      {{ item.isMature === '1' ? '已成熟' : '未成熟' }}
                    </el-tag>
                  </div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-shopping-bag-2"></i>
                    <span>可采摘</span>
                  </div>
                  <div class="data-value">
                    <el-tag size="mini" :type="item.canHarvest === '1' ? 'success' : 'danger'">
                      {{ item.canHarvest === '1' ? '可采摘' : '不可采摘' }}
                    </el-tag>
                  </div>
                </div>
              </div>
              <div class="card-footer">
                <div class="card-actions">
                  <el-button size="mini" type="primary" icon="el-icon-view" @click="handleView(item)" 
                             class="action-btn">查看</el-button>
                  <el-button size="mini" type="success" icon="el-icon-edit" @click="handleUpdate(item)" 
                             v-hasPermi="['agriculture:planting:edit']" class="action-btn">修改</el-button>
                  <el-button size="mini" type="danger" icon="el-icon-delete" @click="handleDelete(item)" 
                             v-hasPermi="['agriculture:planting:remove']" class="action-btn">删除</el-button>
                </div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
      <div v-if="plantingList.length === 0" class="empty-state">
        <i class="el-icon-document"></i>
        <p>暂无数据</p>
      </div>
    </div>

    <!-- 分页 -->
    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" 
                :limit.sync="queryParams.pageSize" @pagination="getList" class="pagination" />

    <!-- 添加或修改种植记录对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body 
               class="planting-dialog" :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px" class="dialog-form">
        <el-row>
          <el-col :span="12">
            <el-form-item label="地块" prop="landId">
              <el-select v-model="form.landId" placeholder="请选择地块" class="form-select">
                <el-option v-for="land in landOptions" :key="land.landId" :label="land.landName" :value="land.landId"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="作物" prop="speciesId">
              <el-select v-model="form.speciesId" placeholder="请选择作物" class="form-select">
                <el-option v-for="species in speciesOptions" :key="species.speciesId" :label="species.speciesName" :value="species.speciesId"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="种植日期" prop="plantingDate">
              <el-date-picker clearable v-model="form.plantingDate" type="date" value-format="yyyy-MM-dd" 
                              placeholder="请选择种植日期" class="form-date-picker">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="预期收获日期" prop="expectedHarvestDate">
              <el-date-picker clearable v-model="form.expectedHarvestDate" type="date" value-format="yyyy-MM-dd" 
                              placeholder="请选择预期收获日期" class="form-date-picker">
              </el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="种植面积(亩)" prop="plantingArea">
              <el-input-number v-model="form.plantingArea" :precision="2" :step="0.1" :min="0" class="form-number" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="种植密度(株/亩)" prop="plantingDensity">
              <el-input-number v-model="form.plantingDensity" :precision="2" :step="100" :min="0" class="form-number" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="种子用量(kg)" prop="seedQuantity">
              <el-input-number v-model="form.seedQuantity" :precision="2" :step="0.1" :min="0" class="form-number" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="种子来源" prop="seedSource">
              <el-input v-model="form.seedSource" placeholder="请输入种子来源" class="form-input" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="生长阶段" prop="growthStage">
              <el-select v-model="form.growthStage" placeholder="请选择生长阶段" class="form-select">
                <el-option label="播种期" value="播种期" />
                <el-option label="发芽期" value="发芽期" />
                <el-option label="幼苗期" value="幼苗期" />
                <el-option label="生长期" value="生长期" />
                <el-option label="开花期" value="开花期" />
                <el-option label="结果期" value="结果期" />
                <el-option label="成熟期" value="成熟期" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="健康状况" prop="healthStatus">
              <el-select v-model="form.healthStatus" placeholder="请选择健康状况" class="form-select">
                <el-option label="健康" value="healthy" />
                <el-option label="亚健康" value="subhealthy" />
                <el-option label="病害" value="disease" />
                <el-option label="虫害" value="pest" />
                <el-option label="病重" value="serious" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="病害信息" prop="diseaseInfo">
          <el-input v-model="form.diseaseInfo" type="textarea" placeholder="请输入病害信息" 
                    class="form-textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="虫害信息" prop="pestInfo">
          <el-input v-model="form.pestInfo" type="textarea" placeholder="请输入虫害信息" 
                    class="form-textarea" :rows="3" />
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="是否成熟" prop="isMature">
              <el-radio-group v-model="form.isMature" disabled>
                <el-radio label="1">已成熟</el-radio>
                <el-radio label="0">未成熟</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="可采摘" prop="canHarvest">
              <el-radio-group v-model="form.canHarvest" disabled>
                <el-radio label="1">可采摘</el-radio>
                <el-radio label="0">不可采摘</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" 
                    class="form-textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel" class="cancel-btn">取 消</el-button>
        <el-button type="primary" @click="submitForm" class="submit-btn">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 查看种植详情对话框 -->
    <el-dialog title="种植详情" :visible.sync="viewOpen" width="800px" append-to-body 
               class="planting-dialog" :close-on-click-modal="false">
      <el-descriptions :column="2" border v-if="currentPlanting" class="dialog-descriptions">
        <el-descriptions-item label="地块名称">{{ currentPlanting.landName }}</el-descriptions-item>
        <el-descriptions-item label="作物名称">{{ currentPlanting.speciesName }}</el-descriptions-item>
        <el-descriptions-item label="种植日期">{{ parseTime(currentPlanting.plantingDate, '{y}-{m}-{d}') }}</el-descriptions-item>
        <el-descriptions-item label="预期收获日期">{{ parseTime(currentPlanting.expectedHarvestDate, '{y}-{m}-{d}') }}</el-descriptions-item>
        <el-descriptions-item label="种植面积">{{ currentPlanting.plantingArea }} 亩</el-descriptions-item>
        <el-descriptions-item label="种植密度">{{ currentPlanting.plantingDensity }} 株/亩</el-descriptions-item>
        <el-descriptions-item label="种子用量">{{ currentPlanting.seedQuantity }} kg</el-descriptions-item>
        <el-descriptions-item label="种子来源">{{ currentPlanting.seedSource }}</el-descriptions-item>
        <el-descriptions-item label="生长阶段">
          <el-tag :type="getGrowthStageType(currentPlanting.growthStage)">{{ currentPlanting.growthStage }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="健康状况">
          <el-tag :type="getHealthStatusType(currentPlanting.healthStatus)">{{ getHealthStatusText(currentPlanting.healthStatus) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="是否成熟">
          <el-tag :type="currentPlanting.isMature === '1' ? 'success' : 'info'">{{ currentPlanting.isMature === '1' ? '已成熟' : '未成熟' }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="可采摘">
          <el-tag :type="currentPlanting.canHarvest === '1' ? 'success' : 'danger'">{{ currentPlanting.canHarvest === '1' ? '可采摘' : '不可采摘' }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="病害信息" span="2">{{ currentPlanting.diseaseInfo || '无' }}</el-descriptions-item>
        <el-descriptions-item label="虫害信息" span="2">{{ currentPlanting.pestInfo || '无' }}</el-descriptions-item>
        <el-descriptions-item label="备注" span="2">{{ currentPlanting.remark || '无' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>

    <!-- 光照不足提示对话框 -->
    <el-dialog 
      :visible.sync="showPestWarningDialog" 
      width="600px" 
      append-to-body 
      :close-on-click-modal="false"
      :close-on-press-escape="false"
      :show-close="false"
      class="pest-warning-dialog"
      center>
      <div class="pest-warning-content">
        <div class="warning-icon">
          <i class="el-icon-sunny"></i>
        </div>
        <h2 class="warning-title">检测到光照较低</h2>
        <p class="warning-message">检测到光照较低，即将进行自动补光</p>
        <div v-if="currentAlert" class="alert-details">
          <div class="detail-row" v-if="currentAlert.landName">
            <i class="el-icon-location-outline"></i>
            <span>地块：{{ currentAlert.landName }}</span>
          </div>
          <div class="detail-row" v-if="currentAlert.speciesName">
            <i class="el-icon-plant"></i>
            <span>作物：{{ currentAlert.speciesName }}</span>
          </div>
        </div>
        <div class="warning-actions">
          <el-button type="primary" size="medium" @click="handleGoToFarming" class="go-farming-btn">
            <i class="el-icon-sunny"></i>
            确认
          </el-button>
          <el-button size="medium" @click="handleClosePestWarning" class="close-warning-btn">
            取消
          </el-button>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listPlanting, getPlanting, delPlanting, addPlanting, updatePlanting, getPlantingStats, getLandPlantingInfo, createPestAlert, getPestAlert, markPestAlertRead } from "@/api/agriculture/planting";
import { listLand } from "@/api/agriculture/land";
import { listCropSpecies } from "@/api/agriculture/crop";

export default {
  name: "Planting",
  data() {
    return {
      // 遮罩层
      loading: true,
      plantingLoading: false,
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
      // 种植记录表格数据
      plantingList: [],
      // 地块选项
      landOptions: [],
      // 作物选项
      speciesOptions: [],
      // 选中的地块ID
      selectedLandId: null,
      // 地块种植信息
      landPlantingInfo: null,
      // 种植统计数据
      plantingStats: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      viewOpen: false,
      // 当前查看的种植记录
      currentPlanting: null,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        landName: null,
        speciesName: null,
        growthStage: null,
        healthStatus: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        landId: [
          { required: true, message: "地块不能为空", trigger: "change" }
        ],
        speciesId: [
          { required: true, message: "作物不能为空", trigger: "change" }
        ],
        plantingDate: [
          { required: true, message: "种植日期不能为空", trigger: "change" }
        ],
        plantingArea: [
          { required: true, message: "种植面积不能为空", trigger: "blur" }
        ],
      },
      // 全屏警告显示状态
      showPestWarningDialog: false,
      // 当前报警信息
      currentAlert: null,
      // 轮询定时器
      alertPollingTimer: null,
      // 最后检查的报警ID
      lastCheckedAlertId: null,
      // 报警防抖定时器
      alertDebounceTimer: null,
      // 本地刚创建的报警ID，避免轮询重复显示
      locallyCreatedAlertId: null,
      // 已处理的报警ID集合，防止重复显示
      processedAlertIds: new Set(),
      // 轮询是否启用
      pollingEnabled: true,
      // 已显示的报警ID集合（使用localStorage持久化）
      displayedAlertIds: new Set(),
      // 全局拦截器 - 确保只显示一次报警
      alertInterceptor: {
        hasShown: false,
        currentAlertId: null,
        lock: false
      },
      // 报警音频对象
      alarmAudio: null,
      // 音频是否已解锁（用户交互后）
      audioUnlocked: false
    };
  },
  created() {
    this.getList();
    this.getLandOptions();
    this.getSpeciesOptions();
    this.getPlantingStatistics();
    
    // 从localStorage加载已显示的报警ID
    this.loadDisplayedAlertIds();
  },
  mounted() {
    // 确保容器元素可以获得焦点
    this.$nextTick(() => {
      const container = this.$el;
      if (container) {
        container.setAttribute('tabindex', '0');
        console.log('容器元素已设置 tabindex');
      }
    });
    
    // 启动报警轮询检查
    this.startAlertPolling();
    
    // 初始化报警音频
    this.initAlarmAudio();
    
    // 监听用户交互，解锁音频播放
    this.setupAudioUnlock();
    
    // 提供全局清除方法（用于调试和重置）
    window.clearPlantingAlerts = () => {
      this.clearDisplayedAlertIds();
      this.resetAlertInterceptor();
      console.log('已清除所有种植记录报警显示记录和拦截器状态');
    };
  },
  beforeDestroy() {
    // 清除轮询定时器
    if (this.alertPollingTimer) {
      clearInterval(this.alertPollingTimer);
      this.alertPollingTimer = null;
    }
    // 清除防抖定时器
    if (this.alertDebounceTimer) {
      clearTimeout(this.alertDebounceTimer);
      this.alertDebounceTimer = null;
    }
    // 停止并清理报警音频
    this.stopAlarmAudio();
    if (this.alarmAudio) {
      this.alarmAudio = null;
    }
  },
  methods: {
    /** 从localStorage加载已显示的报警ID */
    loadDisplayedAlertIds() {
      try {
        const stored = localStorage.getItem('displayedAlertIds');
        if (stored) {
          const ids = JSON.parse(stored);
          this.displayedAlertIds = new Set(ids);
          console.log('从localStorage加载已显示报警ID:', Array.from(this.displayedAlertIds));
        }
      } catch (error) {
        console.error('加载已显示报警ID失败:', error);
        this.displayedAlertIds = new Set();
      }
    },
    
    /** 保存已显示的报警ID到localStorage */
    saveDisplayedAlertIds() {
      try {
        const ids = Array.from(this.displayedAlertIds);
        localStorage.setItem('displayedAlertIds', JSON.stringify(ids));
        console.log('保存已显示报警ID到localStorage:', ids);
      } catch (error) {
        console.error('保存已显示报警ID失败:', error);
      }
    },
    
    /** 检查报警是否已显示过 */
    isAlertDisplayed(alertId) {
      return this.displayedAlertIds.has(alertId);
    },
    
    /** 标记报警为已显示 */
    markAlertAsDisplayed(alertId) {
      this.displayedAlertIds.add(alertId);
      this.saveDisplayedAlertIds();
      console.log('标记报警为已显示:', alertId);
    },
    
    /** 清除已显示报警记录（用于测试或重置） */
    clearDisplayedAlertIds() {
      this.displayedAlertIds.clear();
      localStorage.removeItem('displayedAlertIds');
      console.log('已清除所有已显示报警记录');
    },
    
    /** 查询种植记录列表 */
    getList() {
      this.loading = true;
      listPlanting(this.queryParams).then(response => {
        this.plantingList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 获取地块选项
    getLandOptions() {
      listLand({}).then(response => {
        this.landOptions = response.rows;
      });
    },
    // 获取作物选项
    getSpeciesOptions() {
      listCropSpecies({}).then(response => {
        this.speciesOptions = response.rows;
      });
    },
    // 获取种植统计
    getPlantingStatistics() {
      getPlantingStats({}).then(response => {
        const data = response.data;
        this.plantingStats = [
          {
            value: data.totalPlantings || 0,
            label: '总种植数',
            icon: 'el-icon-s-grid'
          },
          {
            value: data.totalArea || 0,
            label: '总种植面积(亩)',
            icon: 'el-icon-s-data'
          },
          {
            value: data.healthyCount || 0,
            label: '健康作物',
            icon: 'el-icon-s-check'
          },
          {
            value: data.matureCount || 0,
            label: '成熟作物',
            icon: 'el-icon-s-finance'
          }
        ];
      });
    },
    // 地块改变事件
    handleLandChange(landId) {
      if (landId) {
        this.plantingLoading = true;
        getLandPlantingInfo(landId).then(response => {
          this.landPlantingInfo = response.data;
          this.plantingLoading = false;
        });
      }
    },
    // 获取生长阶段类型
    getGrowthStageType(stage) {
      const typeMap = {
        '播种期': 'info',
        '发芽期': 'primary',
        '幼苗期': 'success',
        '生长期': 'warning',
        '开花期': 'danger',
        '结果期': 'warning',
        '成熟期': 'success'
      };
      return typeMap[stage] || 'info';
    },
    // 获取健康状况类型
    getHealthStatusType(status) {
      const typeMap = {
        'healthy': 'success',
        'subhealthy': 'warning',
        'disease': 'danger',
        'pest': 'danger',
        'serious': 'danger'
      };
      return typeMap[status] || 'info';
    },
    // 获取健康状况文本
    getHealthStatusText(status) {
      const textMap = {
        'healthy': '健康',
        'subhealthy': '亚健康',
        'disease': '病害',
        'pest': '虫害',
        'serious': '病重'
      };
      return textMap[status] || status;
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        plantingId: null,
        landId: null,
        speciesId: null,
        plantingDate: null,
        expectedHarvestDate: null,
        actualHarvestDate: null,
        plantingArea: null,
        plantingDensity: null,
        seedQuantity: null,
        seedSource: null,
        growthStage: null,
        healthStatus: null,
        diseaseInfo: null,
        pestInfo: null,
        isMature: "0",
        canHarvest: "0",
        remark: null
      };
      this.resetForm("form");
    },
    // 添加统计卡片点击事件
    handleStatClick(stat, index) {
      this.$message.info(`点击了${stat.label}: ${stat.value}`);
    },
    // 添加刷新数据方法
    refreshData() {
      this.getList();
      this.getPlantingStatistics();
      this.$message.success('数据已刷新');
    },
    // 表格行样式
    tableRowClassName({row, rowIndex}) {
      if (row.healthStatus === 'disease' || row.healthStatus === 'pest') {
        return 'warning-row';
      }
      return '';
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
    // 多选框选中数据（表格用）
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.plantingId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    // 判断是否选中（卡片用）
    isSelected(plantingId) {
      return this.ids.includes(plantingId)
    },
    // 切换选择状态（卡片用）
    toggleSelection(item) {
      const index = this.ids.indexOf(item.plantingId)
      if (index > -1) {
        this.ids.splice(index, 1)
      } else {
        this.ids.push(item.plantingId)
      }
      this.single = this.ids.length !== 1
      this.multiple = this.ids.length === 0
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加种植记录";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const plantingId = row.plantingId || this.ids
      getPlanting(plantingId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改种植记录";
      });
    },
    /** 查看按钮操作 */
    handleView(row) {
      this.currentPlanting = row;
      this.viewOpen = true;
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.plantingId != null) {
            updatePlanting(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
              this.getPlantingStatistics();
            });
          } else {
            addPlanting(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
              this.getPlantingStatistics();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const plantingIds = row.plantingId || this.ids;
      this.$modal.confirm('是否确认删除种植记录编号为"' + plantingIds + '"的数据项？').then(function() {
        return delPlanting(plantingIds);
      }).then(() => {
        this.getList();
        this.getPlantingStatistics();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('agriculture/planting/export', {
        ...this.queryParams
      }, `planting_${new Date().getTime()}.xlsx`)
    },
    /** 键盘事件处理 */
    handleKeyDown(event) {
      // 防止重复触发 - 如果拦截器已锁定，跳过处理
      if (this.alertInterceptor.lock) {
        console.log('拦截器已锁定，跳过键盘事件处理');
        return;
      }
      
      // 监听 Ctrl+1 键
      // 检测 Ctrl 键 (Windows/Linux) 或 Meta 键 (Mac)
      const isCtrlOrMeta = event.ctrlKey || event.metaKey;
      // 检测数字1键 (keyCode 49 或 key === '1' 或 code === 'Digit1')
      const isNumberOne = event.keyCode === 49 || event.key === '1' || event.code === 'Digit1';
      
      // 调试信息（仅在开发环境）
      if (process.env.NODE_ENV === 'development') {
        console.log('按键检测:', {
          ctrlKey: event.ctrlKey,
          metaKey: event.metaKey,
          keyCode: event.keyCode,
          key: event.key,
          code: event.code,
          isCtrlOrMeta: isCtrlOrMeta,
          isNumberOne: isNumberOne,
          target: event.target.tagName
        });
      }
      
      if (isCtrlOrMeta && isNumberOne) {
        event.preventDefault();
        event.stopPropagation();
        console.log('✓ 检测到 Ctrl+1，但当前有报警显示，跳过更新健康状况');
        // 如果当前正在显示报警，不执行更新，防止重复报警
        if (!this.showPestWarningDialog) {
          console.log('✓ 开始更新健康状况');
          this.updateLatestPlantingHealthStatus();
        }
        return false;
      }
    },
    /** 更新最新一条种植记录的健康状况为虫害 */
    updateLatestPlantingHealthStatus() {
      console.log('开始更新最新种植记录的健康状况');
      
      // 如果轮询被禁用，说明正在处理报警，跳过更新
      if (!this.pollingEnabled) {
        console.log('轮询已禁用，跳过健康状况更新');
        return;
      }
      
      // 如果当前正在显示报警，跳过更新
      if (this.showPestWarningDialog) {
        console.log('当前正在显示报警，跳过健康状况更新');
        return;
      }
      
      // 显示加载提示
      const loading = this.$loading({
        lock: true,
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)'
      });
      
      // 获取所有种植记录，取第一页（通常最新记录在第一页）
      listPlanting({
        pageNum: 1,
        pageSize: 100  // 获取足够多的记录以确保能找到最新的
      }).then(response => {
        console.log('获取种植记录列表成功:', response);
        
        if (response.rows && response.rows.length > 0) {
          // 按 plantingId 降序排列，取第一条（假设ID越大越新）
          // 或者按 createTime 排序
          const sortedList = [...response.rows].sort((a, b) => {
            // 优先按 plantingId 排序（降序）
            if (a.plantingId && b.plantingId) {
              return b.plantingId - a.plantingId;
            }
            // 如果没有ID，按创建时间排序
            if (a.createTime && b.createTime) {
              return new Date(b.createTime) - new Date(a.createTime);
            }
            return 0;
          });
          
          const latestPlanting = sortedList[0];
          console.log('找到最新种植记录:', latestPlanting);
          
          // 获取完整的种植记录信息
          getPlanting(latestPlanting.plantingId).then(response => {
            const plantingRecord = response.data;
            console.log('获取种植记录详情成功:', plantingRecord);
            
            // 更新健康状况为虫害
            const oldHealthStatus = plantingRecord.healthStatus;
            plantingRecord.healthStatus = 'pest';
            
            console.log('准备更新健康状况:', {
              plantingId: plantingRecord.plantingId,
              oldStatus: oldHealthStatus,
              newStatus: plantingRecord.healthStatus
            });
            
            // 调用更新API
            updatePlanting(plantingRecord).then(() => {
              loading.close();
              // 刷新列表和统计
              this.getList();
              this.getPlantingStatistics();
              
              // 创建报警并保存到Redis，供所有用户查看
              console.log('=== 开始创建虫害报警 ===');
              console.log('报警数据:', {
                plantingId: plantingRecord.plantingId,
                landName: latestPlanting.landName || '未知地块',
                speciesName: latestPlanting.speciesName || '未知作物'
              });
              
              createPestAlert({
                plantingId: plantingRecord.plantingId,
                landName: latestPlanting.landName || '未知地块',
                speciesName: latestPlanting.speciesName || '未知作物'
              }).then(response => {
                console.log('✅ 报警创建成功，响应:', response);
                // 保存创建的报警ID，避免轮询重复显示
                if (response.data && response.data.alertId) {
                  this.locallyCreatedAlertId = response.data.alertId;
                  console.log('保存本地创建的报警ID:', this.locallyCreatedAlertId);
                }
                // 显示全屏警告
                console.log('准备调用 showPestWarning 显示报警');
                this.showPestWarning();
              }).catch(error => {
                console.error('❌ 创建报警失败:', error);
                // 即使创建报警失败，也显示本地警告
                console.log('创建失败，显示本地警告');
                this.showPestWarning();
              });
            }).catch(error => {
              loading.close();
              console.error('更新失败:', error);
              this.$modal.msgError('更新失败：' + (error.msg || error.message || '请重试'));
            });
          }).catch(error => {
            loading.close();
            console.error('获取种植记录详情失败:', error);
            this.$modal.msgError('获取种植记录详情失败：' + (error.msg || error.message || ''));
          });
        } else {
          loading.close();
          console.warn('暂无种植记录');
          this.$modal.msgWarning('暂无种植记录');
        }
      }).catch(error => {
        loading.close();
        console.error('获取种植记录列表失败:', error);
        this.$modal.msgError('获取种植记录列表失败：' + (error.msg || error.message || ''));
      });
    },
    /** 设置音频解锁机制（在用户首次交互时解锁音频播放权限） */
    setupAudioUnlock() {
      // 一次性事件监听器，用户首次交互后解锁音频
      const unlockAudio = () => {
        if (!this.audioUnlocked && this.alarmAudio) {
          try {
            // 尝试播放并立即暂停，这样可以"解锁"音频播放权限
            const playPromise = this.alarmAudio.play();
            if (playPromise !== undefined) {
              playPromise.then(() => {
                // 立即暂停
                this.alarmAudio.pause();
                this.alarmAudio.currentTime = 0;
                this.audioUnlocked = true;
                console.log('音频播放权限已解锁');
                // 移除所有解锁监听器
                document.removeEventListener('click', unlockAudio, true);
                document.removeEventListener('keydown', unlockAudio, true);
                document.removeEventListener('touchstart', unlockAudio, true);
              }).catch(() => {
                // 如果失败，继续等待用户交互
                console.log('音频解锁失败，等待下次用户交互');
              });
            }
          } catch (error) {
            console.warn('解锁音频失败:', error);
          }
        }
      };
      
      // 监听多种用户交互事件
      document.addEventListener('click', unlockAudio, true);
      document.addEventListener('keydown', unlockAudio, true);
      document.addEventListener('touchstart', unlockAudio, true);
    },
    /** 初始化报警音频 */
    initAlarmAudio() {
      try {
        // 创建音频对象
        this.alarmAudio = new Audio();
        // 设置循环播放
        this.alarmAudio.loop = true;
        // 设置音量（0-1之间，0.7表示70%音量）
        this.alarmAudio.volume = 0.7;
        // 预加载音频
        this.alarmAudio.preload = 'auto';
        
        // 文件在 public/music/ 目录下，尝试多个可能的路径格式
        // public 目录下的文件可以通过根路径直接访问
        const possiblePaths = [
          '/music/Alarm - Danger! Danger!.mp3', // 直接路径（浏览器会自动处理空格）
          encodeURI('/music/Alarm - Danger! Danger!.mp3'), // URL编码版本
          '/music/Alarm%20-%20Danger!%20Danger!.mp3', // 手动URL编码
          './music/Alarm - Danger! Danger!.mp3' // 相对路径
        ];
        
        // 尝试加载第一个路径
        let currentPathIndex = 0;
        const tryLoadAudio = (pathIndex) => {
          if (pathIndex >= possiblePaths.length) {
            console.warn('所有音频路径都加载失败，报警功能将无法播放声音');
            console.warn('请确保音频文件位于: public/music/Alarm - Danger! Danger!.mp3');
            // 不显示错误提示，避免干扰用户
            return;
          }
          
          const currentPath = possiblePaths[pathIndex];
          this.alarmAudio.src = currentPath;
          
          // 监听音频加载成功
          const onCanPlay = () => {
            console.log('报警音频加载成功:', currentPath);
            this.alarmAudio.removeEventListener('canplay', onCanPlay);
            this.alarmAudio.removeEventListener('error', onError);
          };
          
          // 监听音频加载错误
          const onError = (e) => {
            console.warn(`音频路径 ${currentPath} 加载失败，尝试下一个路径`);
            this.alarmAudio.removeEventListener('canplay', onCanPlay);
            this.alarmAudio.removeEventListener('error', onError);
            // 尝试下一个路径
            tryLoadAudio(pathIndex + 1);
          };
          
          this.alarmAudio.addEventListener('canplay', onCanPlay, { once: true });
          this.alarmAudio.addEventListener('error', onError, { once: true });
          
          // 尝试加载
          this.alarmAudio.load();
        };
        
        // 开始尝试加载
        tryLoadAudio(0);
        
        console.log('报警音频初始化完成，正在尝试加载...');
      } catch (error) {
        console.error('初始化报警音频失败:', error);
      }
    },
    /** 播放报警音频 */
    playAlarmAudio() {
      if (this.alarmAudio) {
        try {
          // 检查音频是否已加载（readyState >= 2 表示至少已加载元数据）
          if (this.alarmAudio.readyState >= 2) {
            // 重置播放位置到开头
            this.alarmAudio.currentTime = 0;
            // 播放音频
            const playPromise = this.alarmAudio.play();
            
            // 处理自动播放策略限制
            if (playPromise !== undefined) {
              playPromise.then(() => {
                console.log('报警音频开始播放');
                // 标记为已解锁（如果之前未解锁）
                if (!this.audioUnlocked) {
                  this.audioUnlocked = true;
                }
              }).catch(error => {
                console.warn('播放报警音频失败，尝试在对话框显示时播放:', error);
                // 如果自动播放失败，在对话框显示后再次尝试（因为显示对话框也算用户交互）
                this.$nextTick(() => {
                  if (this.showPestWarningDialog) {
                    // 延迟一点再试，确保对话框已完全显示
                    setTimeout(() => {
                      this.retryPlayAudio();
                    }, 100);
                  }
                });
              });
            }
          } else {
            console.warn('报警音频尚未加载完成，无法播放');
          }
        } catch (error) {
          console.warn('播放报警音频失败:', error);
        }
      }
    },
    /** 重试播放音频（在用户交互后） */
    retryPlayAudio() {
      if (this.alarmAudio && this.alarmAudio.readyState >= 2) {
        try {
          this.alarmAudio.currentTime = 0;
          const playPromise = this.alarmAudio.play();
          if (playPromise !== undefined) {
            playPromise.then(() => {
              console.log('报警音频重试播放成功');
              this.audioUnlocked = true;
            }).catch(error => {
              console.warn('重试播放音频仍然失败:', error);
            });
          }
        } catch (error) {
          console.warn('重试播放音频失败:', error);
        }
      }
    },
    /** 停止报警音频 */
    stopAlarmAudio() {
      if (this.alarmAudio) {
        try {
          this.alarmAudio.pause();
          this.alarmAudio.currentTime = 0;
          console.log('报警音频已停止');
        } catch (error) {
          console.error('停止报警音频失败:', error);
        }
      }
    },
    /** 全局报警拦截器 - 确保只显示一次报警 */
    interceptAlert(alertInfo) {
      console.log('=== 报警拦截器开始检查 ===');
      console.log('拦截器状态:', {
        lock: this.alertInterceptor.lock,
        hasShown: this.alertInterceptor.hasShown,
        currentAlertId: this.alertInterceptor.currentAlertId
      });
      console.log('报警信息:', alertInfo);
      
      // 如果拦截器已锁定，直接返回
      if (this.alertInterceptor.lock) {
        console.log('❌ 拦截器已锁定，跳过报警显示');
        return false;
      }
      
      // 获取报警ID
      const alertId = alertInfo?.alertId || alertInfo?.id;
      if (!alertId) {
        console.log('❌ 报警ID为空，跳过显示');
        return false;
      }
      
      console.log('当前报警ID:', alertId);
      
      // 如果已经显示过这个报警，直接返回
      if (this.alertInterceptor.hasShown && this.alertInterceptor.currentAlertId === alertId) {
        console.log('❌ 报警已显示过，拦截:', alertId);
        return false;
      }
      
      // 锁定拦截器
      this.alertInterceptor.lock = true;
      this.alertInterceptor.hasShown = true;
      this.alertInterceptor.currentAlertId = alertId;
      
      // 保存到localStorage
      this.markAlertAsDisplayed(alertId);
      
      console.log('✅ 拦截器通过，显示报警:', alertId);
      console.log('=== 报警拦截器检查结束 ===');
      return true;
    },
    
    /** 重置拦截器 */
    resetAlertInterceptor() {
      this.alertInterceptor.hasShown = false;
      this.alertInterceptor.currentAlertId = null;
      this.alertInterceptor.lock = false;
      console.log('拦截器已重置');
    },
    
    /** 显示虫害全屏警告 */
    showPestWarning(alertInfo = null) {
      console.log('=== showPestWarning 被调用 ===');
      console.log('传入的报警信息:', alertInfo);
      
      // 使用拦截器检查
      // if (alertInfo && !this.interceptAlert(alertInfo)) {
      //   console.log('❌ 拦截器阻止了报警显示');
      //   return;
      // }
      
      if (alertInfo) {
        this.currentAlert = alertInfo;
        console.log('设置当前报警信息:', this.currentAlert);
      }
      
      console.log('准备显示报警对话框');
      this.showPestWarningDialog = true;
      
      // 开始播放报警音频
      // 使用 nextTick 确保对话框已显示（显示对话框也算用户交互的响应）
      this.$nextTick(() => {
        console.log('报警对话框已显示，开始播放音频');
        this.playAlarmAudio();
        // 如果第一次播放失败，延迟一点再试（对话框显示后可能触发用户交互）
        setTimeout(() => {
          if (this.showPestWarningDialog && this.alarmAudio && this.alarmAudio.paused) {
            console.log('音频播放失败，尝试重试');
            this.retryPlayAudio();
          }
        }, 200);
      });
      
      console.log('=== showPestWarning 处理完成 ===');
    },
    /** 关闭虫害警告并跳转到农事管理 */
    handleGoToFarming() {
      console.log('=== handleGoToFarming 被调用 ===');
      
      // 停止报警音频
      this.stopAlarmAudio();
      
      // 立即关闭对话框，避免用户看到重复的报警
      this.showPestWarningDialog = false;
      console.log('报警对话框已关闭');
      
      // 重置拦截器
      this.resetAlertInterceptor();
      console.log('拦截器已重置');
      
      // 标记报警为已读（会删除Redis中的报警，所有用户都不再显示）
      if (this.currentAlert && this.currentAlert.alertId) {
        const alertId = typeof this.currentAlert.alertId === 'number' 
          ? this.currentAlert.alertId 
          : parseInt(this.currentAlert.alertId) || this.currentAlert.alertId;
        
        console.log('准备标记报警为已读:', alertId);
        
        // 立即更新本地状态，避免重复显示
        this.lastCheckedAlertId = alertId;
        this.currentAlert = null;
        this.locallyCreatedAlertId = null; // 清除本地创建标记
        this.processedAlertIds.add(alertId); // 添加到已处理集合
        
        // 完全禁用轮询，防止重复检查
        this.pollingEnabled = false;
        
        // 启动防抖定时器，10秒内不检查新报警
        this.startAlertDebounce();
        
        markPestAlertRead({ alertId: alertId }).then(() => {
          console.log('✅ 报警已标记为已读，所有用户将不再显示此报警');
        }).catch(error => {
          console.error('❌ 标记已读失败:', error);
          // 即使标记失败，本地状态已更新，不会重复显示
        });
      }
      
      // 跳转到农事管理页面
      console.log('准备跳转到农事管理页面');
      this.$router.push('/agriculture/planting/farming');
      console.log('=== handleGoToFarming 处理完成 ===');
    },
    /** 关闭虫害警告 */
    handleClosePestWarning() {
      console.log('=== handleClosePestWarning 被调用 ===');
      
      // 停止报警音频
      this.stopAlarmAudio();
      
      // 立即关闭对话框
      this.showPestWarningDialog = false;
      console.log('报警对话框已关闭');
      
      // 重置拦截器
      this.resetAlertInterceptor();
      console.log('拦截器已重置');
      
      // 标记报警为已读（会删除Redis中的报警，所有用户都不再显示）
      if (this.currentAlert && this.currentAlert.alertId) {
        const alertId = typeof this.currentAlert.alertId === 'number' 
          ? this.currentAlert.alertId 
          : parseInt(this.currentAlert.alertId) || this.currentAlert.alertId;
        
        console.log('准备标记报警为已读:', alertId);
        
        // 立即更新本地状态，避免重复显示
        this.lastCheckedAlertId = alertId;
        this.currentAlert = null;
        this.locallyCreatedAlertId = null; // 清除本地创建标记
        this.processedAlertIds.add(alertId); // 添加到已处理集合
        
        // 完全禁用轮询，防止重复检查
        this.pollingEnabled = false;
        
        // 启动防抖定时器，10秒内不检查新报警
        this.startAlertDebounce();
        
        markPestAlertRead({ alertId: alertId }).then(() => {
          console.log('✅ 报警已标记为已读，所有用户将不再显示此报警');
        }).catch(error => {
          console.error('❌ 标记已读失败:', error);
          // 即使标记失败，本地状态已更新，不会重复显示
        });
      }
      
      console.log('=== handleClosePestWarning 处理完成 ===');
    },
    /** 启动报警防抖 */
    startAlertDebounce() {
      // 清除之前的防抖定时器
      if (this.alertDebounceTimer) {
        clearTimeout(this.alertDebounceTimer);
      }
      
      // 设置30秒防抖，期间不检查新报警，给Redis足够时间同步
      this.alertDebounceTimer = setTimeout(() => {
        console.log('报警防抖结束，重新启用轮询，清理已处理报警集合');
        this.alertDebounceTimer = null;
        // 重新启用轮询
        this.pollingEnabled = true;
        // 清理已处理的报警集合，避免内存泄漏
        // 保留最近的10个已处理报警ID，防止内存无限增长
        if (this.processedAlertIds.size > 10) {
          const idsArray = Array.from(this.processedAlertIds);
          this.processedAlertIds = new Set(idsArray.slice(-10));
        }
      }, 30000); // 延长到30秒
    },
    /** 启动报警轮询检查 */
    startAlertPolling() {

      this.checkPestAlert();
    },
    /** 检查是否有新的虫害报警 */
    checkPestAlert() {
      console.log('=== checkPestAlert 开始检查 ===');
      
      // 如果轮询被禁用，直接返回
      if (!this.pollingEnabled) {
        console.log('❌ 轮询已禁用，跳过报警检查');
        return;
      }
      
      // 如果处于防抖期间，跳过检查
      if (this.alertDebounceTimer) {
        console.log('❌ 处于防抖期间，跳过报警检查');
        return;
      }
      
      console.log('开始调用 getPestAlert API');
      getPestAlert().then(response => {
        console.log('getPestAlert API 响应:', response);
        
        if (response.code === 200) {
          console.log('检查报警 - 当前状态:', {
            showPestWarningDialog: this.showPestWarningDialog,
            lastCheckedAlertId: this.lastCheckedAlertId,
            currentAlert: this.currentAlert,
            responseData: response.data
          });
          
          // 如果当前正在显示警告对话框
          if (this.showPestWarningDialog) {
            console.log('当前正在显示警告对话框');
            // 检查报警是否已被其他用户处理（返回null表示已被删除）
            if (!response.data) {
              console.log('检测到报警已被其他用户处理，自动关闭对话框');
              // 停止报警音频
              this.stopAlarmAudio();
              // 保存当前报警ID，用于更新最后检查的ID
              let currentAlertId = null;
              if (this.currentAlert && this.currentAlert.alertId) {
                currentAlertId = typeof this.currentAlert.alertId === 'number' 
                  ? this.currentAlert.alertId 
                  : parseInt(this.currentAlert.alertId) || this.currentAlert.alertId;
              }
              // 自动关闭对话框
              this.showPestWarningDialog = false;
              this.currentAlert = null;
              // 更新最后检查的报警ID，避免重复显示
              if (currentAlertId) {
                this.lastCheckedAlertId = currentAlertId;
              }
              return;
            }
            
            // 如果报警还存在，检查报警ID是否变化或者是已处理的报警
            const alertInfo = response.data;
            const alertId = typeof alertInfo.alertId === 'number' 
              ? alertInfo.alertId 
              : parseInt(alertInfo.alertId) || alertInfo.alertId;
            
            console.log('对话框显示中 - 检查报警ID:', { alertId, lastCheckedAlertId: this.lastCheckedAlertId });
            
            // 如果这个报警已经被用户处理过，不重复显示
            if (this.lastCheckedAlertId === alertId) {
              console.log('报警已被处理，跳过显示:', alertId);
              return;
            }
            
            // 如果报警ID与当前显示的不同，说明有新的报警，更新显示
            if (this.currentAlert && this.currentAlert.alertId !== alertId) {
              console.log('检测到新的虫害报警，更新对话框:', alertInfo);
              this.showPestWarning(alertInfo);
            }
            return;
          }
          
          // 如果对话框未显示，检查是否有新报警
          if (response.data) {
            const alertInfo = response.data;
            // 确保alertId是数字类型
            const alertId = typeof alertInfo.alertId === 'number' 
              ? alertInfo.alertId 
              : parseInt(alertInfo.alertId) || alertInfo.alertId;
            
            console.log('对话框未显示 - 检查新报警:', { 
              alertId, 
              lastCheckedAlertId: this.lastCheckedAlertId, 
              locallyCreatedAlertId: this.locallyCreatedAlertId,
              processedAlertIds: Array.from(this.processedAlertIds),
              displayedAlertIds: Array.from(this.displayedAlertIds)
            });
            
            // 检查是否是本地刚创建的报警，避免重复显示
            if (this.locallyCreatedAlertId === alertId) {
              console.log('本地刚创建的报警，跳过显示:', alertId);
              return;
            }
            
            // 检查是否是已处理的报警，防止重复显示
            if (this.processedAlertIds.has(alertId)) {
              console.log('已处理的报警，跳过显示:', alertId);
              return;
            }
            
            // 检查是否已经显示过的报警
            if (this.isAlertDisplayed(alertId)) {
              console.log('已显示过的报警，跳过显示:', alertId);
              return;
            }
            
            // 检查是否是新的报警（与上次检查的不同）
            if (this.lastCheckedAlertId !== alertId) {
              console.log('检测到新的虫害报警:', alertInfo);
              // 显示全屏警告
              this.showPestWarning(alertInfo);
            } else {
              console.log('报警已被处理，不重复显示:', alertId);
            }
          } else {
            // 没有报警，不重置lastCheckedAlertId，避免重复显示已处理的报警
            // 只有在页面刷新或重新加载时才重置
            if (!this.lastCheckedAlertId) {
              this.lastCheckedAlertId = null;
            }
            console.log('没有报警数据');
          }
        }
      }).catch(error => {
        // 静默处理错误，避免频繁弹出错误提示
        // 只在开发环境输出错误日志
        if (process.env.NODE_ENV === 'development') {
          console.error('检查报警失败:', error);
        }
      });
    },
  }
};
</script>

<style scoped>
/* 主容器样式 */
.planting-container {
  background-color: #F7F9FC;
  min-height: 100vh;
  padding: 20px;
}

/* 统计卡片样式 */
.stat-card {
  position: relative;
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  color: white;
  border: none;
  border-radius: 16px;
  padding: 0;
  cursor: pointer;
  transition: all 0.3s ease;
  overflow: hidden;
  box-shadow: 0 8px 32px rgba(5, 117, 230, 0.3);
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 12px 40px rgba(5, 117, 230, 0.4);
}

.stat-card-0 {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
}

.stat-card-1 {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.stat-card-2 {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.stat-card-3 {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.stat-content {
  display: flex;
  align-items: center;
  padding: 24px;
  position: relative;
  z-index: 2;
}

.stat-icon {
  font-size: 48px;
  margin-right: 20px;
  opacity: 0.9;
  animation: float 3s ease-in-out infinite;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 32px;
  font-weight: bold;
  margin-bottom: 8px;
  text-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.stat-label {
  font-size: 16px;
  opacity: 0.9;
  font-weight: 500;
}

.stat-glow {
  position: absolute;
  top: -50%;
  right: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
  animation: rotate 10s linear infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

@keyframes rotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* 搜索区域样式 */
.search-section {
  background: white;
  border-radius: 12px;
  padding: 24px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(5, 117, 230, 0.1);
}

.search-input,
.search-select {
  border-radius: 8px;
  border: 1px solid #e2e8f0;
  transition: all 0.3s ease;
}

.search-input:focus,
.search-select:focus {
  border-color: #0575E6;
  box-shadow: 0 0 0 3px rgba(5, 117, 230, 0.1);
}

.search-btn {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  border: none;
  border-radius: 8px;
  color: white;
  font-weight: 500;
  transition: all 0.3s ease;
}

.search-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(5, 117, 230, 0.3);
}

.reset-btn {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  color: #64748B;
  transition: all 0.3s ease;
}

.reset-btn:hover {
  border-color: #0575E6;
  color: #0575E6;
  background: rgba(5, 117, 230, 0.05);
}

/* 操作按钮样式 */
.action-buttons {
  margin-bottom: 20px;
}

.action-btn {
  border-radius: 8px;
  font-weight: 500;
  transition: all 0.3s ease;
  border: none;
}

.add-btn {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  color: white;
}

.add-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(5, 117, 230, 0.3);
}

.edit-btn {
  background: #10b981;
  color: white;
}

.edit-btn:hover {
  background: #059669;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
}

.delete-btn {
  background: #ef4444;
  color: white;
}

.delete-btn:hover {
  background: #dc2626;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
}

.export-btn {
  background: #FFB300;
  color: white;
}

.export-btn:hover {
  background: #f59e0b;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(255, 179, 0, 0.3);
}

/* 卡片容器样式 */
.cards-container {
  min-height: 400px;
  padding: 20px 0;
}

.card-col {
  margin-bottom: 20px;
}

.planting-data-card {
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
  border: 2px solid transparent;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.planting-data-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(5, 117, 230, 0.15);
  border-color: rgba(5, 117, 230, 0.2);
}

.planting-data-card.card-selected {
  border-color: #0575E6;
  background: linear-gradient(135deg, rgba(5, 117, 230, 0.05) 0%, rgba(0, 242, 96, 0.05) 100%);
}

.planting-data-card >>> .el-card__body {
  padding: 0;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 20px;
  border-bottom: 1px solid #f1f5f9;
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
}

.card-checkbox {
  margin-right: 8px;
}

.card-title {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: 600;
  color: #1E293B;
}

.card-title i {
  color: #0575E6;
  font-size: 18px;
}

.card-body {
  padding: 20px;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.data-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  margin-bottom: 20px;
}

.data-item {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.data-label {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: #64748B;
  font-weight: 500;
}

.data-label i {
  font-size: 14px;
  color: #0575E6;
}

.data-value {
  font-size: 14px;
  font-weight: 600;
  color: #1E293B;
  word-break: break-word;
}

.card-footer {
  margin-top: auto;
  padding-top: 16px;
  border-top: 1px solid #f1f5f9;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.card-actions {
  display: flex;
  gap: 8px;
}

.card-actions .action-btn {
  flex: 1;
  border-radius: 6px;
  font-size: 12px;
  padding: 8px 12px;
  transition: all 0.3s ease;
}

.card-actions .action-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #94a3b8;
}

.empty-state i {
  font-size: 64px;
  margin-bottom: 16px;
  opacity: 0.5;
}

.empty-state p {
  font-size: 16px;
  margin: 0;
}

/* 分页样式 */
.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

/* 对话框样式 */
.planting-dialog {
  border-radius: 16px;
}

.planting-dialog .el-dialog__header {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  color: white;
  border-radius: 16px 16px 0 0;
  padding: 24px 32px;
}

.planting-dialog .el-dialog__title {
  color: white;
  font-size: 18px;
  font-weight: 600;
}

.planting-dialog .el-dialog__body {
  padding: 32px;
}

.dialog-form .el-form-item__label {
  color: #1E293B;
  font-weight: 500;
}

.form-input,
.form-number,
.form-select,
.form-date-picker,
.form-textarea {
  border-radius: 8px;
  border: 1px solid #e2e8f0;
  transition: all 0.3s ease;
}

.form-input:focus,
.form-number:focus,
.form-select:focus,
.form-date-picker:focus,
.form-textarea:focus {
  border-color: #0575E6;
  box-shadow: 0 0 0 3px rgba(5, 117, 230, 0.1);
}

.dialog-footer {
  text-align: right;
  padding: 24px 32px;
  background: #f8fafc;
  border-radius: 0 0 16px 16px;
}

.cancel-btn {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  color: #64748B;
  padding: 10px 20px;
  transition: all 0.3s ease;
}

.cancel-btn:hover {
  border-color: #0575E6;
  color: #0575E6;
  background: rgba(5, 117, 230, 0.05);
}

.submit-btn {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  border: none;
  border-radius: 8px;
  color: white;
  padding: 10px 20px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(5, 117, 230, 0.3);
}

.dialog-descriptions {
  padding: 20px 0;
}

/* 间距样式 */
.mb20 {
  margin-bottom: 20px;
}

.mb8 {
  margin-bottom: 8px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .planting-container {
    padding: 12px;
  }
  
  .stat-card {
    margin-bottom: 16px;
  }
  
  .data-grid {
    grid-template-columns: 1fr;
  }
  
  .card-actions {
    flex-direction: column;
  }
  
  .card-actions .action-btn {
    width: 100%;
  }
}

/* 动画效果 */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.planting-data-card {
  animation: fadeInUp 0.6s ease-out;
}

.planting-data-card:nth-child(1) { animation-delay: 0.1s; }
.planting-data-card:nth-child(2) { animation-delay: 0.2s; }
.planting-data-card:nth-child(3) { animation-delay: 0.3s; }
.planting-data-card:nth-child(4) { animation-delay: 0.4s; }

/* 虫害警告对话框样式 */
.pest-warning-dialog {
  border-radius: 16px;
}

.pest-warning-dialog >>> .el-dialog {
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(255, 0, 0, 0.3);
}

.pest-warning-dialog >>> .el-dialog__header {
  display: none;
}

.pest-warning-dialog >>> .el-dialog__body {
  padding: 0;
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
}

.pest-warning-content {
  text-align: center;
  padding: 60px 40px;
  color: white;
  position: relative;
  overflow: hidden;
}

.pest-warning-content::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
  animation: rotate 20s linear infinite;
}

.warning-icon {
  font-size: 120px;
  margin-bottom: 30px;
  animation: pulse 2s ease-in-out infinite;
  position: relative;
  z-index: 1;
}

.warning-icon i {
  color: rgba(255, 255, 255, 0.95);
  text-shadow: 0 0 30px rgba(255, 255, 255, 0.5);
}

.warning-title {
  font-size: 36px;
  font-weight: bold;
  margin: 0 0 20px 0;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
  position: relative;
  z-index: 1;
}

.warning-message {
  font-size: 20px;
  margin: 0 0 20px 0;
  opacity: 0.95;
  line-height: 1.6;
  position: relative;
  z-index: 1;
}

.alert-details {
  margin: 20px 0 40px 0;
  padding: 20px;
  background: rgba(255, 255, 255, 0.15);
  border-radius: 12px;
  backdrop-filter: blur(10px);
  position: relative;
  z-index: 1;
}

.detail-row {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin: 8px 0;
  font-size: 16px;
  color: rgba(255, 255, 255, 0.95);
}

.detail-row i {
  font-size: 18px;
}

.warning-actions {
  display: flex;
  justify-content: center;
  gap: 20px;
  position: relative;
  z-index: 1;
}

.go-farming-btn {
  background: white;
  color: #ff6b6b;
  border: none;
  border-radius: 12px;
  padding: 14px 32px;
  font-size: 16px;
  font-weight: 600;
  transition: all 0.3s ease;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
}

.go-farming-btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 30px rgba(0, 0, 0, 0.3);
  background: #f8f9fa;
}

.go-farming-btn i {
  margin-right: 8px;
  font-size: 18px;
}

.close-warning-btn {
  background: rgba(255, 255, 255, 0.2);
  color: white;
  border: 2px solid rgba(255, 255, 255, 0.5);
  border-radius: 12px;
  padding: 14px 32px;
  font-size: 16px;
  font-weight: 600;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.close-warning-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  border-color: rgba(255, 255, 255, 0.8);
  transform: translateY(-3px);
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.1);
    opacity: 0.9;
  }
}

/* 全屏遮罩样式 */
.pest-warning-dialog >>> .el-dialog__wrapper {
  background-color: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(5px);
}
</style>
