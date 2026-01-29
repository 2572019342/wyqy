<template>
  <div class="app-container">
    <!-- 地块统计概览 -->
    <el-row :gutter="20" class="mb20">
      <el-col :span="6" v-for="(stat, index) in landStats" :key="index">
        <el-card class="stat-card" :class="'stat-card-' + index">
          <div class="stat-content">
            <div class="stat-icon">
              <i :class="stat.icon"></i>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stat.value }}</div>
              <div class="stat-label">{{ stat.label }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 地块信息管理1 -->
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>地块信息管理1111</span>
      </div>
      
      <!-- 查询条件 -->
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="地块名称" prop="landName">
          <el-input v-model="queryParams.landName" placeholder="请输入地块名称" clearable style="width: 200px" @keyup.enter.native="handleQuery" />
        </el-form-item>
        <el-form-item label="地块编号" prop="landCode">
          <el-input v-model="queryParams.landCode" placeholder="请输入地块编号" clearable style="width: 200px" @keyup.enter.native="handleQuery" />
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
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="请选择状态" clearable style="width: 200px">
            <el-option label="正常" value="0" />
            <el-option label="停用" value="1" />
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
        <el-table-column label="面积(亩)" align="center" prop="area" />
        <el-table-column label="位置" align="center" prop="location" />
        <el-table-column label="土壤类型" align="center" prop="soilType">
          <template slot-scope="scope">
            <el-tag :type="getSoilTypeTag(scope.row.soilType)">{{ scope.row.soilType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="pH值" align="center" prop="soilPh">
          <template slot-scope="scope">
            <el-tag :type="getPhStatus(scope.row.soilPh).type">{{ scope.row.soilPh }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="有机质(%)" align="center" prop="soilOrganicMatter" />
        <el-table-column label="灌溉方式" align="center" prop="irrigationType" />
        <el-table-column label="排水条件" align="center" prop="drainageCondition">
          <template slot-scope="scope">
            <el-tag :type="getDrainageType(scope.row.drainageCondition)">{{ scope.row.drainageCondition }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="状态" align="center" prop="status">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status"/>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
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
            <el-form-item label="面积(亩)" prop="area">
              <el-input-number v-model="form.area" :precision="2" :step="0.1" :min="0" style="width: 100%" />
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
              <el-select v-model="form.soilType" placeholder="请选择土壤类型" style="width: 100%">
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
              <el-input-number v-model="form.soilPh" :precision="2" :step="0.1" :min="0" :max="14" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-divider content-position="left">土壤养分含量</el-divider>
        
        <el-row>
          <el-col :span="8">
            <el-form-item label="有机质(%)" prop="soilOrganicMatter">
              <el-input-number v-model="form.soilOrganicMatter" :precision="2" :step="0.1" :min="0" :max="10" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="氮含量(mg/kg)" prop="soilNitrogen">
              <el-input-number v-model="form.soilNitrogen" :precision="2" :step="0.1" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="磷含量(mg/kg)" prop="soilPhosphorus">
              <el-input-number v-model="form.soilPhosphorus" :precision="2" :step="0.1" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="钾含量(mg/kg)" prop="soilPotassium">
              <el-input-number v-model="form.soilPotassium" :precision="2" :step="0.1" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="灌溉方式" prop="irrigationType">
              <el-select v-model="form.irrigationType" placeholder="请选择灌溉方式" style="width: 100%">
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
              <el-select v-model="form.drainageCondition" placeholder="请选择排水条件" style="width: 100%">
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
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 查看地块详情对话框 -->
    <el-dialog title="地块详情" :visible.sync="viewOpen" width="800px" append-to-body>
      <el-descriptions :column="2" border v-if="currentLand">
        <el-descriptions-item label="地块名称">{{ currentLand.landName }}</el-descriptions-item>
        <el-descriptions-item label="地块编号">{{ currentLand.landCode }}</el-descriptions-item>
        <el-descriptions-item label="面积">{{ currentLand.area }} 亩</el-descriptions-item>
        <el-descriptions-item label="位置">{{ currentLand.location }}</el-descriptions-item>
        <el-descriptions-item label="土壤类型">
          <el-tag :type="getSoilTypeTag(currentLand.soilType)">{{ currentLand.soilType }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="pH值">
          <el-tag :type="getPhStatus(currentLand.soilPh).type">{{ currentLand.soilPh }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="有机质含量">{{ currentLand.soilOrganicMatter }}%</el-descriptions-item>
        <el-descriptions-item label="氮含量">{{ currentLand.soilNitrogen }} mg/kg</el-descriptions-item>
        <el-descriptions-item label="磷含量">{{ currentLand.soilPhosphorus }} mg/kg</el-descriptions-item>
        <el-descriptions-item label="钾含量">{{ currentLand.soilPotassium }} mg/kg</el-descriptions-item>
        <el-descriptions-item label="灌溉方式">{{ currentLand.irrigationType }}</el-descriptions-item>
        <el-descriptions-item label="排水条件">
          <el-tag :type="getDrainageType(currentLand.drainageCondition)">{{ currentLand.drainageCondition }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <dict-tag :options="dict.type.sys_normal_disable" :value="currentLand.status"/>
        </el-descriptions-item>
        <el-descriptions-item label="备注">{{ currentLand.remark || '无' }}</el-descriptions-item>
      </el-descriptions>
      
      <div style="margin-top: 20px;">
        <h4>土壤养分评估</h4>
        <el-row :gutter="20">
          <el-col :span="8">
            <div class="nutrient-card">
              <div class="nutrient-title">氮含量</div>
              <el-progress :percentage="getNutrientScore('nitrogen', currentLand.soilNitrogen)" status="success" :format="formatNutrient"></el-progress>
              <div class="nutrient-desc">{{ getNutrientLevel('nitrogen', currentLand.soilNitrogen) }}</div>
            </div>
          </el-col>
          <el-col :span="8">
            <div class="nutrient-card">
              <div class="nutrient-title">磷含量</div>
              <el-progress :percentage="getNutrientScore('phosphorus', currentLand.soilPhosphorus)" status="warning" :format="formatNutrient"></el-progress>
              <div class="nutrient-desc">{{ getNutrientLevel('phosphorus', currentLand.soilPhosphorus) }}</div>
            </div>
          </el-col>
          <el-col :span="8">
            <div class="nutrient-card">
              <div class="nutrient-title">钾含量</div>
              <el-progress :percentage="getNutrientScore('potassium', currentLand.soilPotassium)" status="exception" :format="formatNutrient"></el-progress>
              <div class="nutrient-desc">{{ getNutrientLevel('potassium', currentLand.soilPotassium) }}</div>
            </div>
          </el-col>
        </el-row>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listLand, getLand, delLand, addLand, updateLand } from "@/api/agriculture/land";

export default {
  name: "Land",
  dicts: ['sys_normal_disable'],
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
      // 地块信息表格数据
      landList: [],
      // 地块统计数据
      landStats: [],
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
        landCode: null,
        soilType: null,
        status: null,
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
        area: [
          { required: true, message: "面积不能为空", trigger: "blur" }
        ],
        soilType: [
          { required: true, message: "土壤类型不能为空", trigger: "change" }
        ],
      }
    };
  },
  created() {
    this.getList();
    this.getLandStatistics();
  },
  methods: {
    /** 查询地块信息列表 */
    getList() {
      this.loading = true;
      listLand(this.queryParams).then(response => {
        this.landList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 获取地块统计
    getLandStatistics() {
      // 模拟统计数据，实际应该从后端获取
      this.landStats = [
        {
          value: this.landList.length,
          label: '总地块数',
          icon: 'el-icon-s-grid'
        },
        {
          value: this.landList.reduce((sum, item) => sum + (item.area || 0), 0).toFixed(2),
          label: '总面积(亩)',
          icon: 'el-icon-s-data'
        },
        {
          value: this.landList.filter(item => item.status === '0').length,
          label: '正常地块',
          icon: 'el-icon-s-check'
        },
        {
          value: this.landList.filter(item => item.soilType === '壤土').length,
          label: '壤土地块',
          icon: 'el-icon-s-opportunity'
        }
      ];
    },
    // 获取土壤类型标签
    getSoilTypeTag(soilType) {
      const tagMap = {
        '壤土': 'success',
        '沙壤土': 'primary',
        '黏土': 'warning',
        '沙土': 'info',
        '砾石土': 'danger'
      };
      return tagMap[soilType] || '';
    },
    // 获取pH状态
    getPhStatus(ph) {
      if (ph < 6.0) return { type: 'danger', text: '偏酸' };
      if (ph > 7.5) return { type: 'warning', text: '偏碱' };
      return { type: 'success', text: '适宜' };
    },
    // 获取排水条件类型
    getDrainageType(condition) {
      const typeMap = {
        '良好': 'success',
        '一般': 'warning',
        '较差': 'danger',
        '差': 'danger'
      };
      return typeMap[condition] || '';
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
    // 获取养分等级
    getNutrientLevel(type, value) {
      if (!value) return '无数据';
      const standards = {
        nitrogen: { low: 80, high: 150 },
        phosphorus: { low: 20, high: 80 },
        potassium: { low: 80, high: 200 }
      };
      const standard = standards[type];
      if (value < standard.low) return '缺乏';
      if (value > standard.high) return '丰富';
      return '适中';
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
        area: null,
        location: null,
        soilType: null,
        soilPh: null,
        soilOrganicMatter: null,
        soilNitrogen: null,
        soilPhosphorus: null,
        soilPotassium: null,
        irrigationType: null,
        drainageCondition: null,
        status: "0",
        remark: null
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
              this.getLandStatistics();
            });
          } else {
            addLand(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
              this.getLandStatistics();
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
        this.getLandStatistics();
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
.stat-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
}

.stat-card-0 {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.stat-card-1 {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.stat-card-2 {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.stat-card-3 {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
}

.stat-content {
  display: flex;
  align-items: center;
  padding: 20px;
}

.stat-icon {
  font-size: 40px;
  margin-right: 15px;
  opacity: 0.8;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 28px;
  font-weight: bold;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  opacity: 0.8;
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

.nutrient-card {
  text-align: center;
  padding: 15px;
  border: 1px solid #ebeef5;
  border-radius: 4px;
}

.nutrient-title {
  font-weight: bold;
  margin-bottom: 10px;
}

.nutrient-desc {
  margin-top: 10px;
  font-size: 12px;
  color: #666;
}
</style>
