<template>
  <div class="operate-container">
    <!-- 种植向导 -->
    <div class="wizard-card">
      <!-- <div class="card-header">
        <div class="header-content">
          <h3 class="card-title">
            <i class="el-icon-s-grid"></i>
            种植向导
          </h3>
        </div>
        <div class="steps-wrapper">
          <el-steps :active="currentStep" finish-status="success" class="wizard-steps">
            <el-step title="选择地块" icon="el-icon-location"></el-step>
            <el-step title="选择作物" icon="el-icon-vegetables"></el-step>
            <el-step title="设置参数" icon="el-icon-setting"></el-step>
            <el-step title="确认种植" icon="el-icon-check"></el-step>
          </el-steps>
        </div>
      </div> -->

      <!-- 步骤1: 选择地块 -->
      <div v-if="currentStep === 0" class="step-content">
        <h3 class="step-title">选择种植地块</h3>
        
        <!-- 搜索筛选区域 -->
        <div class="search-filter-wrapper">
          <el-row :gutter="16">
            <el-col :xs="24" :sm="12" :md="8">
              <el-input
                v-model="landSearchForm.landName"
                placeholder="搜索地块名称"
                clearable
                prefix-icon="el-icon-search"
                class="search-input"
                @input="handleSearch"
              />
            </el-col>
            <el-col :xs="24" :sm="12" :md="8">
              <el-select
                v-model="landSearchForm.soilType"
                placeholder="选择土壤类型"
                clearable
                class="filter-select"
                @change="handleSearch"
              >
                <el-option
                  v-for="soilType in soilTypeOptions"
                  :key="soilType"
                  :label="soilType"
                  :value="soilType"
                />
              </el-select>
            </el-col>
            <el-col :xs="24" :sm="12" :md="8">
              <el-input
                v-model="landSearchForm.location"
                placeholder="搜索位置"
                clearable
                prefix-icon="el-icon-location"
                class="search-input"
                @input="handleSearch"
              />
            </el-col>
          </el-row>
          <div class="search-actions" v-if="hasSearchFilter">
            <el-button size="small" @click="clearSearch" icon="el-icon-refresh-left">清除筛选</el-button>
            <span class="search-result-count">找到 {{ filteredLandOptions.length }} 个地块</span>
          </div>
        </div>

        <el-row :gutter="20">
          <el-col :xs="24" :sm="12" :md="8" v-for="land in filteredLandOptions" :key="land.landId" class="card-col">
            <el-card class="land-card" :class="{ 'card-selected': selectedLandId === land.landId }" @click.native="selectLand(land)">
              <div class="land-info">
                <div class="card-header-inner">
                  <div class="land-name">
                    <i class="el-icon-location-outline"></i>
                    {{ land.landName }}
                  </div>
                  <el-tag :type="land.status === '0' ? 'success' : 'danger'" size="mini">
                    {{ land.status === '0' ? '可用' : '停用' }}
                  </el-tag>
                </div>
                <div class="land-details">
                  <div class="detail-item">
                    <i class="el-icon-s-data"></i>
                    <span>面积: {{ land.area }} 亩</span>
                  </div>
                  <div class="detail-item">
                    <i class="el-icon-connection"></i>
                    <span>土壤类型: {{ land.soilType || '--' }}</span>
                  </div>
                  <div class="detail-item">
                    <i class="el-icon-map-location"></i>
                    <span>位置: {{ land.location || '--' }}</span>
                  </div>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
        <div v-if="filteredLandOptions.length === 0" class="empty-state">
          <i class="el-icon-warning-outline"></i>
          <p v-if="hasSearchFilter">未找到匹配的地块，请调整筛选条件</p>
          <p v-else>暂无可用地块</p>
        </div>
        <div class="step-actions">
          <el-button type="primary" @click="nextStep" :disabled="!selectedLandId" class="next-btn">下一步</el-button>
        </div>
      </div>

      <!-- 步骤2: 选择作物 -->
      <div v-if="currentStep === 1" class="step-content">
        <h3 class="step-title">选择种植作物</h3>
        <el-row :gutter="20">
          <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="crop in cropOptions" :key="crop.speciesId" class="card-col">
            <el-card class="crop-card" :class="{ 'card-selected': selectedCropId === crop.speciesId }" @click.native="selectCrop(crop)">
              <div class="crop-info">
                <div class="card-header-inner">
                  <div class="crop-name">
                    <i class="el-icon-plant"></i>
                    {{ crop.speciesName }}
                  </div>
                  <el-tag :type="getCategoryType(crop.category)" size="mini">{{ crop.category || '--' }}</el-tag>
                </div>
                <div class="crop-details">
                  <div class="detail-item">
                    <i class="el-icon-time"></i>
                    <span>生长周期: {{ crop.growthPeriod || '--' }} 天</span>
                  </div>
                  <div class="detail-item">
                    <i class="el-icon-s-data"></i>
                    <span>预期产量: {{ crop.expectedYield || '--' }} kg/亩</span>
                  </div>
                  <div class="detail-item">
                    <i class="el-icon-s-grid"></i>
                    <span>种植密度: {{ crop.plantingDensity || '--' }} 株/亩</span>
                  </div>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
        <div v-if="cropOptions.length === 0" class="empty-state">
          <i class="el-icon-warning-outline"></i>
          <p>暂无可用作物</p>
        </div>
        <div class="step-actions">
          <el-button @click="prevStep" class="prev-btn">上一步</el-button>
          <el-button type="primary" @click="nextStep" :disabled="!selectedCropId" class="next-btn">下一步</el-button>
        </div>
      </div>

      <!-- 步骤3: 设置参数 -->
      <div v-if="currentStep === 2" class="step-content">
        <h3 class="step-title">设置种植参数</h3>
        <el-form ref="plantingForm" :model="plantingForm" :rules="plantingRules" label-width="120px" class="form-wrapper">
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="种植日期" prop="plantingDate">
                <el-date-picker v-model="plantingForm.plantingDate" type="date" value-format="yyyy-MM-dd" 
                                placeholder="选择种植日期" class="form-date-picker" style="width: 100%" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="预期收获日期" prop="expectedHarvestDate">
                <el-date-picker v-model="plantingForm.expectedHarvestDate" type="date" value-format="yyyy-MM-dd" 
                                placeholder="选择预期收获日期" class="form-date-picker" style="width: 100%" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="种植面积(亩)" prop="plantingArea">
                <el-input-number v-model="plantingForm.plantingArea" :precision="2" :step="0.1" :min="0.1" 
                                :max="selectedLandInfo.area" class="form-number" style="width: 100%" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="种植密度(株/亩)" prop="plantingDensity">
                <el-input-number v-model="plantingForm.plantingDensity" :precision="2" :step="100" :min="0" 
                                class="form-number" style="width: 100%" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="种子用量(kg)" prop="seedQuantity">
                <el-input-number v-model="plantingForm.seedQuantity" :precision="2" :step="0.1" :min="0" 
                                class="form-number" style="width: 100%" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="种子来源" prop="seedSource">
                <el-input v-model="plantingForm.seedSource" placeholder="请输入种子来源" class="form-input" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-form-item label="备注">
            <el-input v-model="plantingForm.remark" type="textarea" placeholder="请输入备注信息" 
                      class="form-textarea" :rows="3" />
          </el-form-item>
        </el-form>
        <div class="step-actions">
          <el-button @click="prevStep" class="prev-btn">上一步</el-button>
          <el-button type="primary" @click="nextStep" class="next-btn">下一步</el-button>
        </div>
      </div>

      <!-- 步骤4: 确认种植 -->
      <div v-if="currentStep === 3" class="step-content">
        <h3 class="step-title">确认种植信息</h3>
        <el-descriptions :column="2" border class="confirm-descriptions">
          <el-descriptions-item label="地块名称">{{ selectedLandInfo.landName || '--' }}</el-descriptions-item>
          <el-descriptions-item label="作物名称">{{ selectedCropInfo.speciesName || '--' }}</el-descriptions-item>
          <el-descriptions-item label="种植日期">{{ parseTime(plantingForm.plantingDate, '{y}-{m}-{d}') || '--' }}</el-descriptions-item>
          <el-descriptions-item label="预期收获日期">{{ parseTime(plantingForm.expectedHarvestDate, '{y}-{m}-{d}') || '--' }}</el-descriptions-item>
          <el-descriptions-item label="种植面积">{{ plantingForm.plantingArea || '--' }} 亩</el-descriptions-item>
          <el-descriptions-item label="种植密度">{{ plantingForm.plantingDensity || '--' }} 株/亩</el-descriptions-item>
          <el-descriptions-item label="种子用量">{{ plantingForm.seedQuantity || '--' }} kg</el-descriptions-item>
          <el-descriptions-item label="种子来源">{{ plantingForm.seedSource || '--' }}</el-descriptions-item>
          <el-descriptions-item label="预计总产量">{{ selectedCropInfo.expectedYield && plantingForm.plantingArea ? (plantingForm.plantingArea * selectedCropInfo.expectedYield).toFixed(2) : '--' }} kg</el-descriptions-item>
          <el-descriptions-item label="预计种植株数">{{ plantingForm.plantingArea && plantingForm.plantingDensity ? (plantingForm.plantingArea * plantingForm.plantingDensity).toFixed(0) : '--' }} 株</el-descriptions-item>
          <el-descriptions-item label="备注" span="2">{{ plantingForm.remark || '无' }}</el-descriptions-item>
        </el-descriptions>
        <div class="step-actions">
          <el-button @click="prevStep" class="prev-btn">上一步</el-button>
          <el-button type="primary" @click="confirmPlanting" :loading="submitting" class="confirm-btn">确认种植</el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { listLand } from "@/api/agriculture/land";
import { listCropSpecies } from "@/api/agriculture/crop";
import { addPlanting, listPlanting } from "@/api/agriculture/planting";

export default {
  name: "PlantingOperate",
  data() {
    return {
      // 当前步骤
      currentStep: 0,
      // 地块选项
      landOptions: [],
      // 地块搜索筛选表单
      landSearchForm: {
        landName: '',
        soilType: '',
        location: ''
      },
      // 土壤类型选项（从现有数据中提取）
      soilTypeOptions: [],
      // 作物选项
      cropOptions: [],
      // 选中的地块ID
      selectedLandId: null,
      // 选中的作物ID
      selectedCropId: null,
      // 选中的地块信息
      selectedLandInfo: {},
      // 选中的作物信息
      selectedCropInfo: {},
      // 种植表单
      plantingForm: {
        plantingDate: (() => {
          const today = new Date();
          const year = today.getFullYear();
          const month = String(today.getMonth() + 1).padStart(2, '0');
          const day = String(today.getDate()).padStart(2, '0');
          return `${year}-${month}-${day}`;
        })(),
        expectedHarvestDate: null,
        plantingArea: null,
        plantingDensity: null,
        seedQuantity: null,
        seedSource: '',
        remark: ''
      },
      // 种植表单验证规则
      plantingRules: {
        plantingDate: [
          { required: true, message: '请选择种植日期', trigger: 'change' }
        ],
        expectedHarvestDate: [
          { required: true, message: '请选择预期收获日期', trigger: 'change' }
        ],
        plantingArea: [
          { required: true, message: '请输入种植面积', trigger: 'blur' }
        ],
        plantingDensity: [
          { required: true, message: '请输入种植密度', trigger: 'blur' }
        ],
        seedQuantity: [
          { required: true, message: '请输入种子用量', trigger: 'blur' }
        ]
      },
      // 提交状态
      submitting: false,
      // 最近种植记录
      recentPlantings: []
    };
  },
  computed: {
    // 过滤后的地块选项
    filteredLandOptions() {
      let filtered = this.landOptions;
      
      // 按地块名称筛选
      if (this.landSearchForm.landName) {
        const keyword = this.landSearchForm.landName.toLowerCase();
        filtered = filtered.filter(land => 
          land.landName && land.landName.toLowerCase().includes(keyword)
        );
      }
      
      // 按土壤类型筛选
      if (this.landSearchForm.soilType) {
        filtered = filtered.filter(land => 
          land.soilType === this.landSearchForm.soilType
        );
      }
      
      // 按位置筛选
      if (this.landSearchForm.location) {
        const keyword = this.landSearchForm.location.toLowerCase();
        filtered = filtered.filter(land => 
          land.location && land.location.toLowerCase().includes(keyword)
        );
      }
      
      return filtered;
    },
    // 是否有筛选条件
    hasSearchFilter() {
      return !!(this.landSearchForm.landName || 
                this.landSearchForm.soilType || 
                this.landSearchForm.location);
    }
  },
  created() {
    this.getLandOptions();
    this.getCropOptions();
    this.getRecentPlantings();
  },
  methods: {
    // 获取地块选项
    getLandOptions() {
      // 传递足够大的pageSize以获取所有可用地块
      listLand({ 
        status: '0',
        pageNum: 1,
        pageSize: 1000  // 设置足够大的值以获取所有数据
      }).then(response => {
        this.landOptions = response.rows || [];
        // 提取所有唯一的土壤类型
        const soilTypes = [...new Set(this.landOptions.map(land => land.soilType).filter(Boolean))];
        this.soilTypeOptions = soilTypes.sort();
      }).catch(error => {
        console.error('获取地块列表失败:', error);
        this.$message.error('获取地块列表失败');
      });
    },
    // 处理搜索
    handleSearch() {
      // 搜索逻辑在computed中处理，这里可以添加其他逻辑
    },
    // 清除筛选
    clearSearch() {
      this.landSearchForm = {
        landName: '',
        soilType: '',
        location: ''
      };
    },
    // 获取作物选项
    getCropOptions() {
      // 传递足够大的pageSize以获取所有可用作物
      listCropSpecies({ 
        status: '0',
        pageNum: 1,
        pageSize: 1000  // 设置足够大的值以获取所有数据
      }).then(response => {
        this.cropOptions = response.rows || [];
      }).catch(error => {
        console.error('获取作物列表失败:', error);
        this.$message.error('获取作物列表失败');
      });
    },
    // 获取最近种植记录
    getRecentPlantings() {
      listPlanting({ pageNum: 1, pageSize: 5 }).then(response => {
        this.recentPlantings = response.rows;
      });
    },
    // 选择地块
    selectLand(land) {
      this.selectedLandId = land.landId;
      this.selectedLandInfo = land;
    },
    // 选择作物
    selectCrop(crop) {
      this.selectedCropId = crop.speciesId;
      this.selectedCropInfo = crop;
      // 自动设置种植密度
      this.plantingForm.plantingDensity = crop.plantingDensity;
      // 自动计算预期收获日期
      if (this.plantingForm.plantingDate) {
        const plantingDate = typeof this.plantingForm.plantingDate === 'string' 
          ? new Date(this.plantingForm.plantingDate) 
          : this.plantingForm.plantingDate;
        const expectedDate = new Date(plantingDate);
        expectedDate.setDate(expectedDate.getDate() + (crop.growthPeriod || 0));
        // 格式化为 yyyy-MM-dd
        const year = expectedDate.getFullYear();
        const month = String(expectedDate.getMonth() + 1).padStart(2, '0');
        const day = String(expectedDate.getDate()).padStart(2, '0');
        this.plantingForm.expectedHarvestDate = `${year}-${month}-${day}`;
      }
    },
    // 上一步
    prevStep() {
      if (this.currentStep > 0) {
        this.currentStep--;
      }
    },
    // 下一步
    nextStep() {
      if (this.currentStep === 2) {
        // 验证表单
        this.$refs.plantingForm.validate((valid) => {
          if (valid) {
            this.currentStep++;
          }
        });
      } else {
        this.currentStep++;
      }
    },
    // 确认种植
    confirmPlanting() {
      this.submitting = true;
      // 日期已经是 yyyy-MM-dd 格式，直接使用
      const plantingDate = typeof this.plantingForm.plantingDate === 'string' 
        ? this.plantingForm.plantingDate 
        : this.parseTime(this.plantingForm.plantingDate, '{y}-{m}-{d}');
      const expectedHarvestDate = typeof this.plantingForm.expectedHarvestDate === 'string' 
        ? this.plantingForm.expectedHarvestDate 
        : this.parseTime(this.plantingForm.expectedHarvestDate, '{y}-{m}-{d}');
      
      const plantingData = {
        landId: this.selectedLandId,
        speciesId: this.selectedCropId,
        plantingDate: plantingDate,
        expectedHarvestDate: expectedHarvestDate,
        plantingArea: this.plantingForm.plantingArea,
        plantingDensity: this.plantingForm.plantingDensity,
        seedQuantity: this.plantingForm.seedQuantity,
        seedSource: this.plantingForm.seedSource,
        growthStage: '播种期',
        healthStatus: 'healthy',
        isMature: '0',
        canHarvest: '0',
        remark: this.plantingForm.remark
      };
      
      addPlanting(plantingData).then(response => {
        this.$modal.msgSuccess("种植成功！");
        this.resetWizard();
        this.getRecentPlantings();
      }).finally(() => {
        this.submitting = false;
      });
    },
    // 重置向导
    resetWizard() {
      this.currentStep = 0;
      this.selectedLandId = null;
      this.selectedCropId = null;
      this.selectedLandInfo = {};
      this.selectedCropInfo = {};
      this.clearSearch();
      const today = new Date();
      const year = today.getFullYear();
      const month = String(today.getMonth() + 1).padStart(2, '0');
      const day = String(today.getDate()).padStart(2, '0');
      this.plantingForm = {
        plantingDate: `${year}-${month}-${day}`,
        expectedHarvestDate: null,
        plantingArea: null,
        plantingDensity: null,
        seedQuantity: null,
        seedSource: '',
        remark: ''
      };
      this.$refs.plantingForm && this.$refs.plantingForm.resetFields();
    },
    // 查看全部种植记录
    viewAllPlantings() {
      this.$router.push('/agriculture/planting');
    },
    // 查看种植详情
    viewPlantingDetail(row) {
      this.$router.push({
        path: '/agriculture/planting',
        query: { id: row.plantingId }
      });
    },
    // 管理种植
    managePlanting(row) {
      this.$router.push({
        path: '/agriculture/farming',
        query: { plantingId: row.plantingId }
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
    }
  }
};
</script>

<style scoped>
/* 主容器样式 */
.operate-container {
  background-color: #F7F9FC;
  min-height: 100vh;
  padding: 20px;
}

/* 向导卡片样式 */
.wizard-card {
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}

.card-header {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  color: white;
  padding: 24px 32px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.card-title {
  color: white;
  margin: 0;
  font-size: 20px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 12px;
}

.card-title i {
  font-size: 24px;
}

.steps-wrapper {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  padding: 20px;
  backdrop-filter: blur(10px);
}

.wizard-steps {
  background: transparent;
}

.wizard-steps >>> .el-steps__item {
  color: rgba(255, 255, 255, 0.8);
}

.wizard-steps >>> .el-steps__item.is-process {
  color: white;
}

.wizard-steps >>> .el-steps__item.is-finish {
  color: rgba(255, 255, 255, 0.9);
}

.wizard-steps >>> .el-step__title {
  color: inherit;
  font-weight: 500;
}

.wizard-steps >>> .el-step__icon {
  color: inherit;
  border-color: rgba(255, 255, 255, 0.5);
}

.wizard-steps >>> .el-step__icon.is-text {
  background-color: rgba(255, 255, 255, 0.2);
  color: white;
}

.wizard-steps >>> .el-step__head.is-process {
  color: white;
  border-color: white;
}

.wizard-steps >>> .el-step__head.is-finish {
  color: rgba(255, 255, 255, 0.9);
  border-color: rgba(255, 255, 255, 0.9);
}

/* 步骤内容样式 */
.step-content {
  padding: 32px;
  background: white;
}

/* 搜索筛选区域样式 */
.search-filter-wrapper {
  margin-bottom: 24px;
  padding: 20px;
  background: #F8FAFC;
  border-radius: 12px;
  border: 1px solid #E2E8F0;
}

.search-input,
.filter-select {
  width: 100%;
}

.search-input >>> .el-input__inner {
  border-radius: 8px;
  border: 1px solid #E2E8F0;
  transition: all 0.3s ease;
}

.search-input >>> .el-input__inner:focus {
  border-color: #0575E6;
  box-shadow: 0 0 0 3px rgba(5, 117, 230, 0.1);
}

.filter-select >>> .el-input__inner {
  border-radius: 8px;
  border: 1px solid #E2E8F0;
  transition: all 0.3s ease;
}

.filter-select >>> .el-input__inner:focus {
  border-color: #0575E6;
  box-shadow: 0 0 0 3px rgba(5, 117, 230, 0.1);
}

.search-actions {
  margin-top: 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 12px;
}

.search-result-count {
  color: #64748B;
  font-size: 14px;
  font-weight: 500;
}

.step-title {
  margin-bottom: 24px;
  font-size: 18px;
  font-weight: 600;
  color: #1E293B;
  display: flex;
  align-items: center;
  gap: 8px;
}

.step-title::before {
  content: '';
  width: 4px;
  height: 20px;
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  border-radius: 2px;
}

/* 卡片样式 */
.card-col {
  margin-bottom: 20px;
}

.land-card, .crop-card {
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 12px;
  border: 2px solid transparent;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

.land-card:hover, .crop-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(5, 117, 230, 0.15);
  border-color: rgba(5, 117, 230, 0.2);
}

.land-card.card-selected, .crop-card.card-selected {
  border-color: #0575E6;
  background: linear-gradient(135deg, rgba(5, 117, 230, 0.05) 0%, rgba(0, 242, 96, 0.05) 100%);
  box-shadow: 0 4px 16px rgba(5, 117, 230, 0.2);
}

.land-card >>> .el-card__body {
  padding: 20px;
}

.land-info, .crop-info {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.card-header-inner {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f1f5f9;
}

.land-name, .crop-name {
  font-size: 16px;
  font-weight: 600;
  color: #1E293B;
  display: flex;
  align-items: center;
  gap: 8px;
}

.land-name i, .crop-name i {
  color: #0575E6;
  font-size: 18px;
}

.land-details, .crop-details {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.detail-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #64748B;
}

.detail-item i {
  color: #0575E6;
  font-size: 16px;
}

/* 表单样式 */
.form-wrapper {
  margin-top: 20px;
}

.form-wrapper .el-form-item__label {
  color: #1E293B;
  font-weight: 500;
}

.form-input,
.form-number,
.form-date-picker,
.form-textarea {
  border-radius: 8px;
  border: 1px solid #e2e8f0;
  transition: all 0.3s ease;
}

.form-input:focus,
.form-number:focus,
.form-date-picker:focus,
.form-textarea:focus {
  border-color: #0575E6;
  box-shadow: 0 0 0 3px rgba(5, 117, 230, 0.1);
}

/* 确认信息样式 */
.confirm-descriptions {
  margin-top: 20px;
}

.confirm-descriptions >>> .el-descriptions__label {
  color: #1E293B;
  font-weight: 500;
}

.confirm-descriptions >>> .el-descriptions__content {
  color: #64748B;
}

/* 步骤操作按钮 */
.step-actions {
  text-align: center;
  margin-top: 32px;
  padding-top: 24px;
  border-top: 1px solid #f1f5f9;
}

.prev-btn {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  color: #64748B;
  padding: 10px 24px;
  font-weight: 500;
  transition: all 0.3s ease;
  margin-right: 12px;
}

.prev-btn:hover {
  border-color: #0575E6;
  color: #0575E6;
  background: rgba(5, 117, 230, 0.05);
}

.next-btn, .confirm-btn {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  border: none;
  border-radius: 8px;
  color: white;
  padding: 10px 24px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.next-btn:hover, .confirm-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(5, 117, 230, 0.3);
}

.next-btn:disabled, .confirm-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
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

/* 响应式设计 */
@media (max-width: 768px) {
  .operate-container {
    padding: 12px;
  }
  
  .card-header {
    padding: 20px 24px;
  }
  
  .step-content {
    padding: 20px;
  }
  
  .step-actions {
    display: flex;
    flex-direction: column;
    gap: 12px;
  }
  
  .prev-btn, .next-btn, .confirm-btn {
    width: 100%;
    margin: 0;
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

.land-card, .crop-card {
  animation: fadeInUp 0.6s ease-out;
}

.land-card:nth-child(1), .crop-card:nth-child(1) { animation-delay: 0.1s; }
.land-card:nth-child(2), .crop-card:nth-child(2) { animation-delay: 0.2s; }
.land-card:nth-child(3), .crop-card:nth-child(3) { animation-delay: 0.3s; }
.land-card:nth-child(4), .crop-card:nth-child(4) { animation-delay: 0.4s; }
</style>
