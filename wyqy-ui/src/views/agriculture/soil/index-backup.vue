<template>
  <div class="app-container">
    <!-- 测试内容 -->
    <div style="background: #f0f9ff; padding: 20px; margin-bottom: 20px; border: 1px solid #409eff;">
      <h2>🧪 土壤信息页面 - 调试版本</h2>
      <p>如果你能看到这个蓝色区域，说明Vue组件加载正常</p>
      <el-button type="primary" @click="testClick">点击测试</el-button>
      <span v-if="testResult" style="margin-left: 20px; color: #67c23a;">✅ 测试成功!</span>
    </div>
    
    <!-- 原始内容 -->
    <!-- 地块选择和土壤信息概览 -->
    <el-row :gutter="20" class="mb20">
      <el-col :span="24">
        <el-card class="soil-overview-card">
          <div slot="header" class="clearfix">
            <span style="font-size: 18px; font-weight: bold;">土壤信息概览</span>
            <el-select v-model="selectedLandId" placeholder="请选择地块" style="float: right; width: 200px" @change="handleLandChange">
              <el-option v-for="land in landOptions" :key="land.landId" :label="land.landName" :value="land.landId"></el-option>
            </el-select>
          </div>
          <el-row :gutter="20" v-loading="soilLoading" v-if="selectedLandId">
            <el-col :span="6" v-for="(item, index) in soilCards" :key="index">
              <div class="soil-item">
                <div class="soil-icon">
                  <i :class="item.icon"></i>
                </div>
                <div class="soil-info">
                  <div class="soil-title">{{ item.title }}</div>
                  <div class="soil-value">{{ item.value }} {{ item.unit }}</div>
                  <div class="soil-status" :class="item.statusClass">{{ item.status }}</div>
                </div>
              </div>
            </el-col>
          </el-row>
          <div v-else class="no-data">
            <i class="el-icon-warning-outline" style="font-size: 48px; color: #909399;"></i>
            <p>请选择地块查看土壤信息</p>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 地块列表 -->
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>地块土壤信息管理</span>
      </div>
      
      <!-- 查询条件 -->
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="地块名称" prop="landName">
          <el-input v-model="queryParams.landName" placeholder="请输入地块名称" clearable style="width: 200px" @keyup.enter.native="handleQuery" />
        </el-form-item>
        <el-form-item label="土壤类型" prop="soilType">
          <el-select v-model="queryParams.soilType" placeholder="请选择土壤类型" clearable style="width: 200px">
            <el-option label="壤土" value="壤土" />
            <el-option label="沙壤土" value="沙壤土" />
            <el-option label="黏土" value="黏土" />
            <el-option label="沙土" value="沙土" />
            <el-option label="砾石土" value="砾石土" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 操作按钮 -->
      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['agriculture:land:add']">新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['agriculture:land:edit']">修改</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['agriculture:land:remove']">删除</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['agriculture:land:export']">导出</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <!-- 数据表格 -->
      <el-table v-loading="loading" :data="landList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="地块名称" align="center" prop="landName" />
        <el-table-column label="地块编号" align="center" prop="landCode" />
        <el-table-column label="面积(亩)" align="center" prop="landArea" />
        <el-table-column label="位置" align="center" prop="location" />
        <el-table-column label="土壤类型" align="center" prop="soilType" />
        <el-table-column label="pH值" align="center" prop="soilPh">
          <template slot-scope="scope">
            <el-tag :type="getPhStatus(scope.row.soilPh).type">{{ scope.row.soilPh }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="有机质(%)" align="center" prop="organicMatter" />
        <el-table-column label="氮含量(mg/kg)" align="center" prop="nitrogenContent" />
        <el-table-column label="磷含量(mg/kg)" align="center" prop="phosphorusContent" />
        <el-table-column label="钾含量(mg/kg)" align="center" prop="potassiumContent" />
        <el-table-column label="灌溉方式" align="center" prop="irrigationMethod" />
        <el-table-column label="排水条件" align="center" prop="drainageCondition" />
        <el-table-column label="状态" align="center" prop="status">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status"/>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">查看</el-button>
            <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['agriculture:land:edit']">修改</el-button>
            <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['agriculture:land:remove']">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
    </el-card>

    <!-- 添加或修改地块信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="地块名称" prop="landName">
              <el-input v-model="form.landName" placeholder="请输入地块名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="地块编号" prop="landCode">
              <el-input v-model="form.landCode" placeholder="请输入地块编号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="面积(亩)" prop="landArea">
              <el-input-number v-model="form.landArea" :precision="2" :step="0.1" :min="0" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="位置" prop="location">
              <el-input v-model="form.location" placeholder="请输入位置描述" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="土壤类型" prop="soilType">
              <el-select v-model="form.soilType" placeholder="请选择土壤类型">
                <el-option label="壤土" value="壤土" />
                <el-option label="沙壤土" value="沙壤土" />
                <el-option label="黏土" value="黏土" />
                <el-option label="沙土" value="沙土" />
                <el-option label="砾石土" value="砾石土" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="pH值" prop="soilPh">
              <el-input-number v-model="form.soilPh" :precision="2" :step="0.1" :min="0" :max="14" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="有机质(%)" prop="organicMatter">
              <el-input-number v-model="form.organicMatter" :precision="2" :step="0.1" :min="0" :max="10" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="氮含量(mg/kg)" prop="nitrogenContent">
              <el-input-number v-model="form.nitrogenContent" :precision="2" :step="0.1" :min="0" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="磷含量(mg/kg)" prop="phosphorusContent">
              <el-input-number v-model="form.phosphorusContent" :precision="2" :step="0.1" :min="0" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="钾含量(mg/kg)" prop="potassiumContent">
              <el-input-number v-model="form.potassiumContent" :precision="2" :step="0.1" :min="0" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="灌溉方式" prop="irrigationMethod">
              <el-select v-model="form.irrigationMethod" placeholder="请选择灌溉方式">
                <el-option label="滴灌" value="滴灌" />
                <el-option label="喷灌" value="喷灌" />
                <el-option label="沟灌" value="沟灌" />
                <el-option label="漫灌" value="漫灌" />
                <el-option label="微灌" value="微灌" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="排水条件" prop="drainageCondition">
              <el-select v-model="form.drainageCondition" placeholder="请选择排水条件">
                <el-option label="良好" value="良好" />
                <el-option label="一般" value="一般" />
                <el-option label="较差" value="较差" />
                <el-option label="差" value="差" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio v-for="dict in dict.type.sys_normal_disable" :key="dict.value" :label="dict.value">{{dict.label}}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="备注" prop="notes">
          <el-input v-model="form.notes" type="textarea" placeholder="请输入内容" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 查看土壤详情对话框 -->
    <el-dialog title="土壤信息详情" :visible.sync="viewOpen" width="600px" append-to-body>
      <el-descriptions :column="2" border v-if="currentLand">
        <el-descriptions-item label="地块名称">{{ currentLand.landName }}</el-descriptions-item>
        <el-descriptions-item label="地块编号">{{ currentLand.landCode }}</el-descriptions-item>
        <el-descriptions-item label="面积">{{ currentLand.landArea }} 亩</el-descriptions-item>
        <el-descriptions-item label="位置">{{ currentLand.location }}</el-descriptions-item>
        <el-descriptions-item label="土壤类型">{{ currentLand.soilType }}</el-descriptions-item>
        <el-descriptions-item label="pH值">{{ currentLand.soilPh }}</el-descriptions-item>
        <el-descriptions-item label="有机质含量">{{ currentLand.organicMatter }}%</el-descriptions-item>
        <el-descriptions-item label="氮含量">{{ currentLand.nitrogenContent }} mg/kg</el-descriptions-item>
        <el-descriptions-item label="磷含量">{{ currentLand.phosphorusContent }} mg/kg</el-descriptions-item>
        <el-descriptions-item label="钾含量">{{ currentLand.potassiumContent }} mg/kg</el-descriptions-item>
        <el-descriptions-item label="灌溉方式">{{ currentLand.irrigationMethod }}</el-descriptions-item>
        <el-descriptions-item label="排水条件">{{ currentLand.drainageCondition }}</el-descriptions-item>
      </el-descriptions>
      
      <div style="margin-top: 20px;">
        <h4>土壤养分评估</h4>
        <el-progress :percentage="getNutrientScore('nitrogen', currentLand.nitrogenContent)" status="success" :format="formatNutrient">氮含量</el-progress>
        <el-progress :percentage="getNutrientScore('phosphorus', currentLand.phosphorusContent)" status="warning" :format="formatNutrient" style="margin-top: 10px;">磷含量</el-progress>
        <el-progress :percentage="getNutrientScore('potassium', currentLand.potassiumContent)" status="exception" :format="formatNutrient" style="margin-top: 10px;">钾含量</el-progress>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listLand, getLand, delLand, addLand, updateLand, getLandSoilInfo } from "@/api/agriculture/land";

export default {
  name: "Soil",
  dicts: ['sys_normal_disable'],
  data() {
    return {
      // 测试用
      testResult: false,
      // 遮罩层
      loading: true,
      soilLoading: false,
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
      // 地块信息表格数据
      landList: [],
      // 地块选项
      landOptions: [],
      // 选中的地块ID
      selectedLandId: null,
      // 土壤卡片数据
      soilCards: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      viewOpen: false,
      // 当前查看的地块
      currentLand: null,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        landName: null,
        soilType: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        landName: [
          { required: true, message: "地块名称不能为空", trigger: "blur" }
        ],
        landCode: [
          { required: true, message: "地块编号不能为空", trigger: "blur" }
        ],
        landArea: [
          { required: true, message: "面积不能为空", trigger: "blur" }
        ],
        soilType: [
          { required: true, message: "土壤类型不能为空", trigger: "change" }
        ],
      }
    };
  },
  created() {
    console.log('土壤信息页面created方法执行')
    // 临时注释掉API调用，先测试组件是否能正常渲染
    // this.getList();
  },
  methods: {
    // 测试方法
    testClick() {
      this.$message.success('Vue组件工作正常!')
      this.testResult = true
      console.log('土壤信息页面测试成功')
    },
    /** 查询地块信息列表 */
    getList() {
      this.loading = true;
      listLand(this.queryParams).then(response => {
        this.landList = response.rows;
        this.total = response.total;
        this.landOptions = response.rows;
        this.loading = false;
      });
    },
    // 地块改变事件
    handleLandChange(landId) {
      if (landId) {
        this.soilLoading = true;
        getLandSoilInfo(landId).then(response => {
          const data = response.data;
          this.soilCards = [
            {
              title: 'pH值',
              value: data.soilPh || '--',
              unit: '',
              icon: 'el-icon-data-analysis',
              status: this.getPhStatus(data.soilPh).text,
              statusClass: this.getPhStatus(data.soilPh).class
            },
            {
              title: '有机质',
              value: data.organicMatter || '--',
              unit: '%',
              icon: 'el-icon-pie-chart',
              status: this.getOrganicStatus(data.organicMatter),
              statusClass: this.getOrganicStatusClass(data.organicMatter)
            },
            {
              title: '氮含量',
              value: data.nitrogenContent || '--',
              unit: 'mg/kg',
              icon: 'el-icon-coin',
              status: this.getNitrogenStatus(data.nitrogenContent),
              statusClass: this.getNitrogenStatusClass(data.nitrogenContent)
            },
            {
              title: '磷钾比',
              value: this.getPKRatio(data.phosphorusContent, data.potassiumContent),
              unit: '',
              icon: 'el-icon-balance',
              status: '平衡',
              statusClass: 'status-normal'
            }
          ];
          this.soilLoading = false;
        });
      }
    },
    // 获取pH状态
    getPhStatus(ph) {
      if (ph < 6.0) return { type: 'danger', text: '偏酸', class: 'status-danger' };
      if (ph > 7.5) return { type: 'warning', text: '偏碱', class: 'status-warning' };
      return { type: 'success', text: '适宜', class: 'status-success' };
    },
    // 获取有机质状态
    getOrganicStatus(value) {
      if (value < 1.0) return '偏低';
      if (value > 3.0) return '偏高';
      return '适宜';
    },
    getOrganicStatusClass(value) {
      if (value < 1.0) return 'status-danger';
      if (value > 3.0) return 'status-warning';
      return 'status-success';
    },
    // 获取氮含量状态
    getNitrogenStatus(value) {
      if (value < 80) return '缺乏';
      if (value > 150) return '丰富';
      return '适中';
    },
    getNitrogenStatusClass(value) {
      if (value < 80) return 'status-danger';
      if (value > 150) return 'status-warning';
      return 'status-success';
    },
    // 获取磷钾比
    getPKRatio(phosphorus, potassium) {
      if (!phosphorus || !potassium) return '--';
      const ratio = (potassium / phosphorus).toFixed(2);
      return ratio;
    },
    // 获取养分评分
    getNutrientScore(type, value) {
      if (!value) return 0;
      const standards = {
        nitrogen: { min: 80, max: 150, optimal: 120 },
        phosphorus: { min: 20, max: 80, optimal: 50 },
        potassium: { min: 80, max: 200, optimal: 120 }
      };
      const standard = standards[type];
      if (value < standard.min) return Math.round((value / standard.min) * 50);
      if (value > standard.max) return 100;
      return Math.round(((value - standard.min) / (standard.max - standard.min)) * 50 + 50);
    },
    // 格式化养分显示
    formatNutrient(percentage) {
      return percentage + '%';
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        landId: null,
        landName: null,
        landCode: null,
        landArea: null,
        location: null,
        soilType: null,
        soilPh: null,
        organicMatter: null,
        nitrogenContent: null,
        phosphorusContent: null,
        potassiumContent: null,
        irrigationMethod: null,
        drainageCondition: null,
        status: "0",
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
      this.ids = selection.map(item => item.landId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加地块信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const landId = row.landId || this.ids
      getLand(landId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改地块信息";
      });
    },
    /** 查看按钮操作 */
    handleView(row) {
      this.currentLand = row;
      this.viewOpen = true;
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.landId != null) {
            updateLand(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addLand(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const landIds = row.landId || this.ids;
      this.$modal.confirm('是否确认删除地块信息编号为"' + landIds + '"的数据项？').then(function() {
        return delLand(landIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('agriculture/land/export', {
        ...this.queryParams
      }, `land_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>

<style scoped>
.soil-overview-card {
  background: linear-gradient(135deg, #8BC34A 0%, #4CAF50 100%);
  color: white;
}

.soil-overview-card .el-card__header {
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.soil-item {
  display: flex;
  align-items: center;
  padding: 20px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
  height: 120px;
}

.soil-item:hover {
  transform: translateY(-5px);
  background: rgba(255, 255, 255, 0.2);
}

.soil-icon {
  font-size: 40px;
  margin-right: 15px;
  opacity: 0.8;
}

.soil-info {
  flex: 1;
}

.soil-title {
  font-size: 14px;
  opacity: 0.8;
  margin-bottom: 5px;
}

.soil-value {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 5px;
}

.soil-status {
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.2);
}

.status-success {
  background: rgba(76, 175, 80, 0.3);
  color: #E8F5E8;
}

.status-warning {
  background: rgba(255, 193, 7, 0.3);
  color: #FFF8E1;
}

.status-danger {
  background: rgba(244, 67, 54, 0.3);
  color: #FFEBEE;
}

.status-normal {
  background: rgba(33, 150, 243, 0.3);
  color: #E3F2FD;
}

.no-data {
  text-align: center;
  padding: 40px;
  color: rgba(255, 255, 255, 0.7);
}

.mb20 {
  margin-bottom: 20px;
}

.mb8 {
  margin-bottom: 8px;
}

.box-card {
  margin-top: 20px;
}
</style>
