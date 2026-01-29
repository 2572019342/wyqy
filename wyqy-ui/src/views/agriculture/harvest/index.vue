<template>
  <div class="harvest-container">
    <!-- 采摘统计概览 -->
    <el-row :gutter="20" class="mb20">
      <el-col :span="6" v-for="(stat, index) in harvestStats" :key="index">
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

    <!-- 可采摘列表 -->
    <div class="harvestable-card">
      <div class="card-header">
        <div class="header-title">
          <i class="el-icon-shopping-bag-2"></i>
          <span>可采摘列表</span>
        </div>
      </div>
      <div class="table-section">
        <el-table v-loading="harvestableLoading" :data="harvestablePlantings" class="modern-table">
          <el-table-column label="地块名称" align="center" prop="landName" min-width="120" />
          <el-table-column label="作物名称" align="center" prop="speciesName" min-width="120" />
          <el-table-column label="种植日期" align="center" prop="plantingDate" width="120">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.plantingDate, '{y}-{m}-{d}') }}</span>
            </template>
          </el-table-column>
          <el-table-column label="种植面积(亩)" align="center" prop="plantingArea" min-width="120" />
          <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="120">
            <template slot-scope="scope">
              <el-button size="mini" type="primary" icon="el-icon-collection" @click="handleHarvest(scope.row)" class="action-link">采摘</el-button>
            </template>
          </el-table-column>
        </el-table>
        <div v-if="harvestablePlantings.length === 0 && !harvestableLoading" class="empty-state">
          <i class="el-icon-document"></i>
          <p>暂无可采摘的作物</p>
        </div>
      </div>
    </div>



    <!-- 采摘记录列表 -->
    <div class="harvest-list-card">
      <div class="card-header">
        <div class="header-title">
          <i class="el-icon-s-order"></i>
          <span>采摘记录列表</span>
        </div>
      </div>
      
      <!-- 查询条件 -->
      <div class="search-section" v-show="showSearch">
        <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="68px">
          <el-form-item label="地块名称" prop="landName">
            <el-input v-model="queryParams.landName" placeholder="请输入地块名称" clearable 
                     class="search-input" style="width: 200px" @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="作物名称" prop="speciesName">
            <el-input v-model="queryParams.speciesName" placeholder="请输入作物名称" clearable 
                     class="search-input" style="width: 200px" @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="质量等级" prop="qualityGrade">
            <el-select v-model="queryParams.qualityGrade" placeholder="请选择质量等级" clearable class="search-select" style="width: 200px">
              <el-option label="特等" value="特等" />
              <el-option label="一等" value="一等" />
              <el-option label="二等" value="二等" />
              <el-option label="三等" value="三等" />
              <el-option label="等外" value="等外" />
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
      <div class="action-section">
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAdd" 
                       v-hasPermi="['agriculture:harvest:add']" class="action-btn add-btn">新增</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="success" icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" 
                       v-hasPermi="['agriculture:harvest:edit']" class="action-btn edit-btn">修改</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" 
                       v-hasPermi="['agriculture:harvest:remove']" class="action-btn delete-btn">删除</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="warning" icon="el-icon-download" size="mini" @click="handleExport" 
                       v-hasPermi="['agriculture:harvest:export']" class="action-btn export-btn">导出</el-button>
          </el-col>
          <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
        </el-row>
      </div>

      <!-- 数据表格 -->
      <div class="table-section">
        <el-table v-loading="loading" :data="harvestList" @selection-change="handleSelectionChange" class="modern-table">
          <el-table-column type="selection" width="55" align="center" />
          <el-table-column label="地块名称" align="center" prop="landName" min-width="120" />
          <el-table-column label="作物名称" align="center" prop="speciesName" min-width="120" />
          <el-table-column label="采摘时间" align="center" prop="harvestDate" width="180">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.harvestDate, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
            </template>
          </el-table-column>
          <el-table-column label="采摘面积(亩)" align="center" prop="harvestArea" min-width="120" />
          <el-table-column label="采摘数量(kg)" align="center" prop="harvestQuantity" min-width="120" />
          <el-table-column label="质量等级" align="center" prop="qualityGrade" min-width="100">
            <template slot-scope="scope">
              <el-tag :type="getQualityGradeType(scope.row.qualityGrade)" size="small">{{ scope.row.qualityGrade }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="单价(元/kg)" align="center" prop="unitPrice" min-width="120" />
          <el-table-column label="总价(元)" align="center" prop="totalPrice" min-width="120" />
          <el-table-column label="操作人员" align="center" prop="operator" min-width="100" />
          <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
            <template slot-scope="scope">
              <el-button size="mini" type="primary" icon="el-icon-view" @click="handleView(scope.row)" class="action-link">查看</el-button>
              <el-button size="mini" type="success" icon="el-icon-edit" @click="handleUpdate(scope.row)" 
                         v-hasPermi="['agriculture:harvest:edit']" class="action-link">修改</el-button>
              <el-button size="mini" type="danger" icon="el-icon-delete" @click="handleDelete(scope.row)" 
                         v-hasPermi="['agriculture:harvest:remove']" class="action-link">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <div v-if="harvestList.length === 0 && !loading" class="empty-state">
          <i class="el-icon-document"></i>
          <p>暂无数据</p>
        </div>
      </div>

      <!-- 分页 -->
      <div class="pagination-section">
        <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" 
                    :limit.sync="queryParams.pageSize" @pagination="getList" />
      </div>
    </div>

    <!-- 添加或修改采摘记录对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body 
               class="harvest-dialog" :close-on-click-modal="false">
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
            <el-form-item label="采摘时间" prop="harvestDate">
              <el-date-picker v-model="form.harvestDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss"
                              placeholder="选择采摘时间" class="form-date-picker" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="采摘面积(亩)" prop="harvestArea">
              <el-input-number v-model="form.harvestArea" :precision="2" :step="0.1" :min="0" class="form-number" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="采摘数量(kg)" prop="harvestQuantity">
              <el-input-number v-model="form.harvestQuantity" :precision="2" :step="0.1" :min="0" class="form-number" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="质量等级" prop="qualityGrade">
              <el-select v-model="form.qualityGrade" placeholder="请选择质量等级" class="form-select" style="width: 100%">
                <el-option label="特等" value="特等" />
                <el-option label="一等" value="一等" />
                <el-option label="二等" value="二等" />
                <el-option label="三等" value="三等" />
                <el-option label="等外" value="等外" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="单价(元/kg)" prop="unitPrice">
              <el-input-number v-model="form.unitPrice" :precision="2" :step="0.01" :min="0" class="form-number" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="采摘方式" prop="harvestMethod">
              <el-select v-model="form.harvestMethod" placeholder="请选择采摘方式" class="form-select" style="width: 100%">
                <el-option label="人工采摘" value="人工采摘" />
                <el-option label="机械采摘" value="机械采摘" />
                <el-option label="半机械采摘" value="半机械采摘" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="操作人员" prop="operator">
              <el-input v-model="form.operator" placeholder="请输入操作人员" class="form-input" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="存储位置" prop="storageLocation">
              <el-input v-model="form.storageLocation" placeholder="请输入存储位置" class="form-input" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="存储条件" prop="storageConditions">
              <el-input v-model="form.storageConditions" placeholder="请输入存储条件" class="form-input" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="收购方" prop="buyer">
              <el-input v-model="form.buyer" placeholder="请输入收购方" class="form-input" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="运输方式" prop="transportMethod">
              <el-select v-model="form.transportMethod" placeholder="请选择运输方式" class="form-select" style="width: 100%">
                <el-option label="自提" value="自提" />
                <el-option label="配送" value="配送" />
                <el-option label="第三方物流" value="第三方物流" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="备注" prop="notes">
          <el-input v-model="form.notes" type="textarea" placeholder="请输入备注信息" class="form-textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel" class="cancel-btn">取 消</el-button>
        <el-button type="primary" @click="submitForm" class="submit-btn">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 查看采摘详情对话框 -->
    <el-dialog title="采摘详情" :visible.sync="viewOpen" width="800px" append-to-body 
               class="harvest-dialog" :close-on-click-modal="false">
      <el-descriptions :column="2" border v-if="currentHarvest" class="dialog-descriptions">
        <el-descriptions-item label="地块名称">{{ currentHarvest.landName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="作物名称">{{ currentHarvest.speciesName || '--' }}</el-descriptions-item>
        <el-descriptions-item label="采摘时间">{{ parseTime(currentHarvest.harvestDate, '{y}-{m}-{d} {h}:{i}:{s}') || '--' }}</el-descriptions-item>
        <el-descriptions-item label="采摘面积">{{ currentHarvest.harvestArea || '--' }} 亩</el-descriptions-item>
        <el-descriptions-item label="采摘数量">{{ currentHarvest.harvestQuantity || '--' }} kg</el-descriptions-item>
        <el-descriptions-item label="质量等级">
          <el-tag :type="getQualityGradeType(currentHarvest.qualityGrade)">{{ currentHarvest.qualityGrade || '--' }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="单价">{{ currentHarvest.unitPrice || '--' }} 元/kg</el-descriptions-item>
        <el-descriptions-item label="总价">{{ currentHarvest.totalPrice || '--' }} 元</el-descriptions-item>
        <el-descriptions-item label="采摘方式">{{ currentHarvest.harvestMethod || '--' }}</el-descriptions-item>
        <el-descriptions-item label="操作人员">{{ currentHarvest.operator || '--' }}</el-descriptions-item>
        <el-descriptions-item label="存储位置">{{ currentHarvest.storageLocation || '--' }}</el-descriptions-item>
        <el-descriptions-item label="存储条件">{{ currentHarvest.storageConditions || '--' }}</el-descriptions-item>
        <el-descriptions-item label="收购方">{{ currentHarvest.buyer || '--' }}</el-descriptions-item>
        <el-descriptions-item label="运输方式">{{ currentHarvest.transportMethod || '--' }}</el-descriptions-item>
        <el-descriptions-item label="备注" span="2">{{ currentHarvest.notes || '无' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script>
import { listHarvest, getHarvest, delHarvest, addHarvest, updateHarvest, getHarvestablePlantings, getHarvestStats } from "@/api/agriculture/harvest";
import { listLand } from "@/api/agriculture/land";
import { listPlanting } from "@/api/agriculture/planting";

export default {
  name: "Harvest",
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
      // 采摘记录表格数据
      harvestList: [],
      // 地块选项
      landOptions: [],
      // 可采摘的种植记录
      harvestablePlantings: [],
      harvestableLoading: false,
      // 所有种植选项
      allPlantingOptions: [],
      // 选中的种植记录
      selectedPlanting: null,
      // 采摘统计数据
      harvestStats: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      viewOpen: false,
      // 当前查看的采摘记录
      currentHarvest: null,
      // 提交状态
      submitting: false,
      // 采摘表单
      harvestForm: {
        landId: null,
        plantingId: null,
        harvestDate: new Date(),
        harvestArea: null,
        harvestQuantity: null,
        qualityGrade: null,
        unitPrice: null,
        harvestMethod: null,
        operator: '',
        storageLocation: '',
        storageConditions: '',
        buyer: '',
        transportMethod: null,
        notes: ''
      },
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        landName: null,
        speciesName: null,
        qualityGrade: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        plantingId: [
          { required: true, message: "种植记录不能为空", trigger: "change" }
        ],
        harvestDate: [
          { required: true, message: "采摘时间不能为空", trigger: "change" }
        ],
        harvestArea: [
          { required: true, message: "采摘面积不能为空", trigger: "blur" }
        ],
        harvestQuantity: [
          { required: true, message: "采摘数量不能为空", trigger: "blur" }
        ],
        qualityGrade: [
          { required: true, message: "质量等级不能为空", trigger: "change" }
        ],
        unitPrice: [
          { required: true, message: "单价不能为空", trigger: "blur" }
        ],
        operator: [
          { required: true, message: "操作人员不能为空", trigger: "blur" }
        ],
      }
    };
  },
  computed: {
    // 是否可以采摘
    canHarvest() {
      return this.selectedPlanting && 
             this.selectedPlanting.canHarvest === '1' && 
             this.selectedPlanting.isMature === '1' && 
             this.selectedPlanting.healthStatus === 'healthy';
    }
  },
  created() {
    this.getList();
    this.getLandOptions();
    this.getHarvestablePlantings();
    this.getAllPlantingOptions();
    this.getHarvestStatistics();
  },
  methods: {
    /** 查询采摘记录列表 */
    getList() {
      this.loading = true;
      listHarvest(this.queryParams).then(response => {
        this.harvestList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
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
    // 获取可采摘的种植记录
    getHarvestablePlantings() {
      this.harvestableLoading = true;
      getHarvestablePlantings().then(response => {
        this.harvestablePlantings = response.data || [];
        this.harvestableLoading = false;
      }).catch(() => {
        this.harvestableLoading = false;
      });
    },

    // 点击可采摘列表的采摘按钮
    handleHarvest(row) {
      this.reset();
      this.title = "采摘";
      this.open = true;
      const now = new Date();
      const year = now.getFullYear();
      const month = String(now.getMonth() + 1).padStart(2, '0');
      const day = String(now.getDate()).padStart(2, '0');
      const hour = String(now.getHours()).padStart(2, '0');
      const minute = String(now.getMinutes()).padStart(2, '0');
      const second = String(now.getSeconds()).padStart(2, '0');
      this.form.harvestId = null;
      this.form.plantingId = row.plantingId;
      this.form.harvestDate = `${year}-${month}-${day} ${hour}:${minute}:${second}`;
      this.form.harvestArea = row.plantingArea;
      this.form.operator = '';
      this.form.notes = '';
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
    // 获取采摘统计
    getHarvestStatistics() {
      getHarvestStats({}).then(response => {
        const data = response.data;
        this.harvestStats = [
          {
            value: data.totalCount || 0,
            label: '总采摘次数',
            icon: 'el-icon-s-operation'
          },
          {
            value: data.totalQuantity || 0,
            label: '总采摘量(kg)',
            icon: 'el-icon-goods'
          },
          {
            value: data.totalValue || 0,
            label: '总价值(元)',
            icon: 'el-icon-money'
          },
          {
            value: data.avgQuality ? Number(data.avgQuality).toFixed(2) : '0.00',
            label: '平均质量等级',
            icon: 'el-icon-star-on'
          }
        ];
      });
    },
    // 统计卡片点击事件
    handleStatClick(stat, index) {
      this.$message.info(`点击了${stat.label}: ${stat.value}`);
    },
    // 地块改变事件
    handleLandChange(landId) {
      this.harvestForm.plantingId = null;
      this.selectedPlanting = null;
      if (landId) {
        const filtered = this.harvestablePlantings.filter(item => item.landId === landId);
        // 这里可以更新可采摘的种植记录列表
      }
    },
    // 种植改变事件
    handlePlantingChange(plantingId) {
      this.selectedPlanting = this.harvestablePlantings.find(item => item.plantingId === plantingId) || null;
      if (this.selectedPlanting) {
        this.harvestForm.landId = this.selectedPlanting.landId;
        // 设置默认采摘面积
        this.harvestForm.harvestArea = this.selectedPlanting.plantingArea;
      }
    },
    // 获取质量等级类型
    getQualityGradeType(grade) {
      const typeMap = {
        '特等': 'success',
        '一等': 'primary',
        '二等': 'warning',
        '三等': 'info',
        '等外': 'danger'
      };
      return typeMap[grade] || '';
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
    // 提交采摘记录
    submitHarvest() {
      if (!this.canHarvest) {
        this.$modal.msgError('当前作物不符合采摘条件！');
        return;
      }
      
      this.submitting = true;
      // 计算总价
      const harvestData = {
        ...this.harvestForm,
        harvestDate: this.parseTime(this.harvestForm.harvestDate, '{y}-{m}-{d} {h}:{i}:{s}'),
        totalPrice: (this.harvestForm.harvestQuantity * this.harvestForm.unitPrice).toFixed(2)
      };
      
      addHarvest(harvestData).then(response => {
        this.$modal.msgSuccess("采摘记录添加成功！");
        this.resetHarvest();
        this.getList();
        this.getHarvestStatistics();
        this.getHarvestablePlantings();
      }).finally(() => {
        this.submitting = false;
      });
    },
    // 重置采摘表单
    resetHarvest() {
      this.harvestForm = {
        landId: null,
        plantingId: null,
        harvestDate: new Date(),
        harvestArea: null,
        harvestQuantity: null,
        qualityGrade: null,
        unitPrice: null,
        harvestMethod: null,
        operator: '',
        storageLocation: '',
        storageConditions: '',
        buyer: '',
        transportMethod: null,
        notes: ''
      };
      this.selectedPlanting = null;
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        harvestId: null,
        plantingId: null,
        harvestDate: null,
        harvestArea: null,
        harvestQuantity: null,
        qualityGrade: null,
        unitPrice: null,
        totalPrice: null,
        harvestMethod: null,
        operator: null,
        storageLocation: null,
        storageConditions: null,
        buyer: null,
        transportMethod: null,
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
      this.ids = selection.map(item => item.harvestId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加采摘记录";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const harvestId = row.harvestId || this.ids
      getHarvest(harvestId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改采摘记录";
      });
    },
    /** 查看按钮操作 */
    handleView(row) {
      this.currentHarvest = row;
      this.viewOpen = true;
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          // 计算总价
          this.form.totalPrice = (this.form.harvestQuantity * this.form.unitPrice).toFixed(2);
          // 日期已经是字符串格式，直接使用
          const harvestDate = typeof this.form.harvestDate === 'string' 
            ? this.form.harvestDate 
            : this.parseTime(this.form.harvestDate, '{y}-{m}-{d} {h}:{i}:{s}');
          this.form.harvestDate = harvestDate;
          
          if (this.form.harvestId != null) {
            updateHarvest(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
              this.getHarvestStatistics();
              this.getHarvestablePlantings();
            });
          } else {
            addHarvest(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
              this.getHarvestStatistics();
              this.getHarvestablePlantings();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const harvestIds = row.harvestId || this.ids;
      this.$modal.confirm('是否确认删除采摘记录编号为"' + harvestIds + '"的数据项？').then(function() {
        return delHarvest(harvestIds);
      }).then(() => {
        this.getList();
        this.getHarvestStatistics();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('agriculture/harvest/export', {
        ...this.queryParams
      }, `harvest_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>

<style scoped>
/* 主容器样式 */
.harvest-container {
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

/* 卡片样式 */
.harvestable-card, .harvest-list-card {
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  margin-top: 20px;
}

.card-header {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  color: white;
  padding: 20px 24px;
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
  font-size: 20px;
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

/* 操作按钮区域 */
.action-section {
  padding: 20px 24px;
  background: white;
  border-bottom: 1px solid #E8EEF4;
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

/* 表格区域 */
.table-section {
  padding: 0 24px;
}

.modern-table {
  border-radius: 8px;
  overflow: hidden;
}

.modern-table >>> .el-table__header {
  background: linear-gradient(90deg, #0575E6 0%, #00F260 100%);
}

.modern-table >>> .el-table__header th {
  color: white;
  font-weight: 600;
  border: none;
  padding: 16px 12px;
}

.modern-table >>> .el-table__body tr {
  transition: all 0.3s ease;
}

.modern-table >>> .el-table__body tr:hover {
  background-color: #F8FAFF;
}

.action-link {
  margin: 0 4px;
  padding: 4px 8px;
  border-radius: 4px;
  font-weight: 500;
  transition: all 0.3s ease;
  border: none;
}

.action-link:hover {
  transform: scale(1.05);
}

/* 分页区域 */
.pagination-section {
  padding: 20px 24px;
  display: flex;
  justify-content: center;
  background: white;
  border-top: 1px solid #E8EEF4;
}

/* 空状态样式 */
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

/* 对话框样式 */
.harvest-dialog {
  border-radius: 16px;
}

.harvest-dialog .el-dialog__header {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  color: white;
  border-radius: 16px 16px 0 0;
  padding: 24px 32px;
}

.harvest-dialog .el-dialog__title {
  color: white;
  font-size: 18px;
  font-weight: 600;
}

.harvest-dialog .el-dialog__body {
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

.dialog-descriptions {
  padding: 20px 0;
}

.dialog-descriptions >>> .el-descriptions__label {
  color: #1E293B;
  font-weight: 500;
}

.dialog-descriptions >>> .el-descriptions__content {
  color: #64748B;
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

/* 间距样式 */
.mb20 {
  margin-bottom: 20px;
}

.mb8 {
  margin-bottom: 8px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .harvest-container {
    padding: 12px;
  }
  
  .stat-card {
    margin-bottom: 16px;
  }
  
  .card-header {
    padding: 16px 20px;
  }
  
  .search-section,
  .action-section,
  .table-section,
  .pagination-section {
    padding-left: 20px;
    padding-right: 20px;
  }
}
</style>
