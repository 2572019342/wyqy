<template>
  <div class="app-container">
    <!-- 作物分类统计 -->
    <el-row :gutter="20" class="mb20">
      <el-col :span="24">
        <el-card class="crop-stats-card">
          <div slot="header" class="clearfix">
            <span style="font-size: 18px; font-weight: bold;">作物分类统计</span>
          </div>
          <el-row :gutter="20" v-loading="statsLoading">
            <el-col :span="6" v-for="(stat, index) in categoryStats" :key="index">
              <div class="category-item">
                <div class="category-icon">
                  <i :class="stat.icon"></i>
                </div>
                <div class="category-info">
                  <div class="category-name">{{ stat.name }}</div>
                  <div class="category-count">{{ stat.count }} 种</div>
                  <div class="category-desc">{{ stat.desc }}</div>
                </div>
              </div>
            </el-col>
          </el-row>
        </el-card>
      </el-col>
    </el-row>

    <!-- 作物物种管理 -->
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>作物物种管理</span>
      </div>
      
      <!-- 查询条件 -->
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="物种名称" prop="speciesName">
          <el-input v-model="queryParams.speciesName" placeholder="请输入物种名称" clearable style="width: 200px" @keyup.enter.native="handleQuery" />
        </el-form-item>
        <el-form-item label="分类" prop="category">
          <el-select v-model="queryParams.category" placeholder="请选择分类" clearable style="width: 200px">
            <el-option label="蔬菜" value="蔬菜" />
            <el-option label="水果" value="水果" />
            <el-option label="粮食" value="粮食" />
            <el-option label="经济作物" value="经济作物" />
            <el-option label="药用植物" value="药用植物" />
            <el-option label="其他" value="其他" />
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
          <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['agriculture:crop:add']">新增</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['agriculture:crop:edit']">修改</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['agriculture:crop:remove']">删除</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['agriculture:crop:export']">导出</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <!-- 数据表格 -->
      <el-table v-loading="loading" :data="cropList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="物种名称" align="center" prop="speciesName" />
        <el-table-column label="物种编号" align="center" prop="speciesCode" />
        <el-table-column label="学名" align="center" prop="scientificName" />
        <el-table-column label="分类" align="center" prop="category">
          <template slot-scope="scope">
            <el-tag :type="getCategoryType(scope.row.category)">{{ scope.row.category }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="生长周期(天)" align="center" prop="growthPeriod" />
        <el-table-column label="最适温度(℃)" align="center">
          <template slot-scope="scope">
            {{ scope.row.optimalTemperatureMin }}~{{ scope.row.optimalTemperatureMax }}
          </template>
        </el-table-column>
        <el-table-column label="最适湿度(%)" align="center">
          <template slot-scope="scope">
            {{ scope.row.optimalHumidityMin }}~{{ scope.row.optimalHumidityMax }}
          </template>
        </el-table-column>
        <el-table-column label="预期产量(kg/亩)" align="center" prop="expectedYield" />
        <el-table-column label="状态" align="center" prop="status">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status"/>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">查看</el-button>
            <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['agriculture:crop:edit']">修改</el-button>
            <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['agriculture:crop:remove']">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
    </el-card>

    <!-- 添加或修改作物物种对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="900px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="物种名称" prop="speciesName">
              <el-input v-model="form.speciesName" placeholder="请输入物种名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="物种编号" prop="speciesCode">
              <el-input v-model="form.speciesCode" placeholder="请输入物种编号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="学名" prop="scientificName">
              <el-input v-model="form.scientificName" placeholder="请输入学名" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="分类" prop="category">
              <el-select v-model="form.category" placeholder="请选择分类" style="width: 100%">
                <el-option label="蔬菜" value="蔬菜" />
                <el-option label="水果" value="水果" />
                <el-option label="粮食" value="粮食" />
                <el-option label="经济作物" value="经济作物" />
                <el-option label="药用植物" value="药用植物" />
                <el-option label="其他" value="其他" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="生长周期(天)" prop="growthPeriod">
              <el-input-number v-model="form.growthPeriod" :min="1" :max="365" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="种植密度(株/亩)" prop="plantingDensity">
              <el-input-number v-model="form.plantingDensity" :precision="2" :step="100" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="预期产量(kg/亩)" prop="expectedYield">
              <el-input-number v-model="form.expectedYield" :precision="2" :step="10" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-divider content-position="left">生长条件</el-divider>
        
        <el-row>
          <el-col :span="12">
            <el-form-item label="最适温度(℃)">
              <el-row>
                <el-col :span="12">
                  <el-input-number v-model="form.optimalTemperatureMin" :precision="1" :step="0.5" :min="-20" :max="50" placeholder="最低" style="width: 100%" />
                </el-col>
                <el-col :span="12">
                  <el-input-number v-model="form.optimalTemperatureMax" :precision="1" :step="0.5" :min="-20" :max="50" placeholder="最高" style="width: 100%" />
                </el-col>
              </el-row>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="最适湿度(%)">
              <el-row>
                <el-col :span="12">
                  <el-input-number v-model="form.optimalHumidityMin" :precision="1" :step="1" :min="0" :max="100" placeholder="最低" style="width: 100%" />
                </el-col>
                <el-col :span="12">
                  <el-input-number v-model="form.optimalHumidityMax" :precision="1" :step="1" :min="0" :max="100" placeholder="最高" style="width: 100%" />
                </el-col>
              </el-row>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row>
          <el-col :span="12">
            <el-form-item label="水分需求" prop="waterRequirement">
              <el-select v-model="form.waterRequirement" placeholder="请选择水分需求" style="width: 100%">
                <el-option label="低" value="低" />
                <el-option label="中等" value="中等" />
                <el-option label="较高" value="较高" />
                <el-option label="高" value="高" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="光照需求" prop="lightRequirement">
              <el-select v-model="form.lightRequirement" placeholder="请选择光照需求" style="width: 100%">
                <el-option label="弱光" value="弱光" />
                <el-option label="中等" value="中等" />
                <el-option label="充足" value="充足" />
                <el-option label="强光" value="强光" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row>
          <el-col :span="24">
            <el-form-item label="肥料需求" prop="fertilizerRequirement">
              <el-input v-model="form.fertilizerRequirement" placeholder="请输入肥料需求" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row>
          <el-col :span="24">
            <el-form-item label="土壤要求" prop="soilRequirement">
              <el-input v-model="form.soilRequirement" placeholder="请输入土壤要求" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-divider content-position="left">抗性特征</el-divider>
        
        <el-row>
          <el-col :span="12">
            <el-form-item label="抗病性" prop="diseaseResistance">
              <el-input v-model="form.diseaseResistance" placeholder="请输入抗病性" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="抗虫性" prop="pestResistance">
              <el-input v-model="form.pestResistance" placeholder="请输入抗虫性" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row>
          <el-col :span="24">
            <el-form-item label="描述" prop="description">
              <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入描述" />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row>
          <el-col :span="12">
            <el-form-item label="图片URL" prop="imageUrl">
              <el-input v-model="form.imageUrl" placeholder="请输入图片URL" />
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

    <!-- 查看作物详情对话框 -->
    <el-dialog title="作物物种详情" :visible.sync="viewOpen" width="800px" append-to-body>
      <el-descriptions :column="2" border v-if="currentCrop">
        <el-descriptions-item label="物种名称">{{ currentCrop.speciesName }}</el-descriptions-item>
        <el-descriptions-item label="物种编号">{{ currentCrop.speciesCode }}</el-descriptions-item>
        <el-descriptions-item label="学名">{{ currentCrop.scientificName }}</el-descriptions-item>
        <el-descriptions-item label="分类">
          <el-tag :type="getCategoryType(currentCrop.category)">{{ currentCrop.category }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="生长周期">{{ currentCrop.growthPeriod }} 天</el-descriptions-item>
        <el-descriptions-item label="种植密度">{{ currentCrop.plantingDensity }} 株/亩</el-descriptions-item>
        <el-descriptions-item label="预期产量">{{ currentCrop.expectedYield }} kg/亩</el-descriptions-item>
        <el-descriptions-item label="最适温度">{{ currentCrop.optimalTemperatureMin }}~{{ currentCrop.optimalTemperatureMax }} ℃</el-descriptions-item>
        <el-descriptions-item label="最适湿度">{{ currentCrop.optimalHumidityMin }}~{{ currentCrop.optimalHumidityMax }} %</el-descriptions-item>
        <el-descriptions-item label="水分需求">{{ currentCrop.waterRequirement }}</el-descriptions-item>
        <el-descriptions-item label="光照需求">{{ currentCrop.lightRequirement }}</el-descriptions-item>
        <el-descriptions-item label="肥料需求" span="2">{{ currentCrop.fertilizerRequirement }}</el-descriptions-item>
        <el-descriptions-item label="土壤要求" span="2">{{ currentCrop.soilRequirement }}</el-descriptions-item>
        <el-descriptions-item label="抗病性" span="2">{{ currentCrop.diseaseResistance }}</el-descriptions-item>
        <el-descriptions-item label="抗虫性" span="2">{{ currentCrop.pestResistance }}</el-descriptions-item>
        <el-descriptions-item label="描述" span="2">{{ currentCrop.description || '无' }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <dict-tag :options="dict.type.sys_normal_disable" :value="currentCrop.status"/>
        </el-descriptions-item>
        <el-descriptions-item label="备注">{{ currentCrop.remark || '无' }}</el-descriptions-item>
      </el-descriptions>
      
      <div v-if="currentCrop.imageUrl" style="margin-top: 20px; text-align: center;">
        <h4>作物图片</h4>
        <el-image :src="currentCrop.imageUrl" style="width: 200px; height: 200px;" fit="cover">
          <div slot="error" class="image-slot">
            <i class="el-icon-picture-outline"></i>
          </div>
        </el-image>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listCropSpecies, getCropSpecies, delCropSpecies, addCropSpecies, updateCropSpecies, getCropCategoryStats } from "@/api/agriculture/crop";

export default {
  name: "Crop",
  dicts: ['sys_normal_disable'],
  data() {
    return {
      // 遮罩层
      loading: true,
      statsLoading: false,
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
      // 作物物种表格数据
      cropList: [],
      // 分类统计数据
      categoryStats: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      viewOpen: false,
      // 当前查看的作物
      currentCrop: null,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        speciesName: null,
        category: null,
        status: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        speciesName: [
          { required: true, message: "物种名称不能为空", trigger: "blur" }
        ],
        speciesCode: [
          { required: true, message: "物种编号不能为空", trigger: "blur" }
        ],
        category: [
          { required: true, message: "分类不能为空", trigger: "change" }
        ],
        growthPeriod: [
          { required: true, message: "生长周期不能为空", trigger: "blur" }
        ],
      }
    };
  },
  created() {
    this.getList();
    this.getCategoryStatistics();
  },
  methods: {
    /** 查询作物物种列表 */
    getList() {
      this.loading = true;
      listCropSpecies(this.queryParams).then(response => {
        this.cropList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 获取分类统计
    getCategoryStatistics() {
      this.statsLoading = true;
      getCropCategoryStats().then(response => {
        const data = response.data;
        this.categoryStats = [
          {
            name: '蔬菜',
            count: data.vegetable || 0,
            desc: '叶菜类、根茎类等',
            icon: 'el-icon-vegetable'
          },
          {
            name: '水果',
            count: data.fruit || 0,
            desc: '浆果类、仁果类等',
            icon: 'el-icon-apple'
          },
          {
            name: '粮食',
            count: data.grain || 0,
            desc: '谷物类、豆类等',
            icon: 'el-icon-grain'
          },
          {
            name: '经济作物',
            count: data.economic || 0,
            desc: '棉花、烟草等',
            icon: 'el-icon-money'
          }
        ];
        this.statsLoading = false;
      });
    },
    // 获取分类类型
    getCategoryType(category) {
      const typeMap = {
        '蔬菜': 'success',
        '水果': 'warning',
        '粮食': 'primary',
        '经济作物': 'danger',
        '药用植物': 'info',
        '其他': ''
      };
      return typeMap[category] || '';
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        speciesId: null,
        speciesName: null,
        speciesCode: null,
        scientificName: null,
        category: null,
        growthPeriod: null,
        optimalTemperatureMin: null,
        optimalTemperatureMax: null,
        optimalHumidityMin: null,
        optimalHumidityMax: null,
        waterRequirement: null,
        fertilizerRequirement: null,
        lightRequirement: null,
        soilRequirement: null,
        plantingDensity: null,
        expectedYield: null,
        diseaseResistance: null,
        pestResistance: null,
        description: null,
        imageUrl: null,
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
      this.ids = selection.map(item => item.speciesId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加作物物种";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const speciesId = row.speciesId || this.ids
      getCropSpecies(speciesId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改作物物种";
      });
    },
    /** 查看按钮操作 */
    handleView(row) {
      this.currentCrop = row;
      this.viewOpen = true;
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.speciesId != null) {
            updateCropSpecies(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
              this.getCategoryStatistics();
            });
          } else {
            addCropSpecies(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
              this.getCategoryStatistics();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const speciesIds = row.speciesId || this.ids;
      this.$modal.confirm('是否确认删除作物物种编号为"' + speciesIds + '"的数据项？').then(function() {
        return delCropSpecies(speciesIds);
      }).then(() => {
        this.getList();
        this.getCategoryStatistics();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('agriculture/crop/export', {
        ...this.queryParams
      }, `crop_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>

<style scoped>
.crop-stats-card {
  background: linear-gradient(135deg, #8BC34A 0%, #4CAF50 100%);
  color: white;
}

.crop-stats-card .el-card__header {
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.category-item {
  display: flex;
  align-items: center;
  padding: 20px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
  height: 120px;
}

.category-item:hover {
  transform: translateY(-5px);
  background: rgba(255, 255, 255, 0.2);
}

.category-icon {
  font-size: 40px;
  margin-right: 15px;
  opacity: 0.8;
}

.category-info {
  flex: 1;
}

.category-name {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 5px;
}

.category-count {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 5px;
}

.category-desc {
  font-size: 12px;
  opacity: 0.7;
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

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  color: #909399;
  font-size: 30px;
}
</style>
