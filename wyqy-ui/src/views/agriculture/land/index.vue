<template>
  <div class="land-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <h2 class="page-title">
          <i class="el-icon-map-location"></i>
          地块信息管理
        </h2>
        <div class="header-actions">
          <el-button type="primary" icon="el-icon-plus" @click="handleAdd" 
                     class="add-btn">新增地块</el-button>
        </div>
      </div>
    </div>

    <!-- 查询条件 -->
    <div class="search-section">
      <div class="section-card">
        <div class="card-header">
          <h3 class="section-title">
            <i class="el-icon-search"></i>
            查询条件
          </h3>
          <el-button type="primary" icon="el-icon-search" @click="getList" 
                     class="search-btn">查询</el-button>
        </div>
        <div class="card-content">
          <el-form :model="queryParams" ref="queryForm" :inline="true" class="search-form">
            <el-form-item label="地块名称" prop="landName">
              <el-input v-model="queryParams.landName" placeholder="请输入地块名称" 
                       clearable class="search-input" />
            </el-form-item>
            <el-form-item label="土壤类型" prop="soilType">
              <el-select v-model="queryParams.soilType" placeholder="请选择土壤类型" 
                         clearable class="search-select">
                <el-option label="壤土" value="壤土" />
                <el-option label="沙壤土" value="沙壤土" />
                <el-option label="黏土" value="黏土" />
              </el-select>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </div>

    <!-- 地块列表 -->
    <div class="lands-section">
      <div class="section-header">
        <h3 class="section-title">
          <i class="el-icon-list"></i>
          地块信息列表
        </h3>
        <div class="section-stats">
          <span class="stats-item">
            <i class="el-icon-data-analysis"></i>
            共 {{ total }} 个地块
          </span>
          <el-button-group class="action-group">
            <el-button type="danger" icon="el-icon-delete" :disabled="ids.length === 0" 
                       @click="handleDelete" class="batch-delete-btn">批量删除</el-button>
          </el-button-group>
        </div>
      </div>
      
      <div v-loading="loading" class="lands-grid">
        <el-empty v-if="landList.length === 0" description="暂无地块数据" 
                  class="empty-state">
          <el-button type="primary" @click="handleAdd">新增地块</el-button>
        </el-empty>
        <div v-else class="cards-container">
          <el-row :gutter="20">
            <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="land in landList" :key="land.landId" class="land-card-col">
              <div class="land-card" :class="{ 'card-selected': isSelected(land.landId) }">
                <div class="card-header">
                  <el-checkbox 
                    :value="isSelected(land.landId)" 
                    @change="toggleSelection(land)"
                    class="card-checkbox"
                  ></el-checkbox>
                  <div class="land-info">
                    <h4 class="land-name">{{ land.landName || '未命名地块' }}</h4>
                    <p class="land-code">{{ land.landCode || '无编码' }}</p>
                  </div>
                  <div class="land-status">
                    <el-tag :type="land.status === '0' ? 'success' : 'danger'" size="mini">
                      {{ land.status === '0' ? '正常' : '停用' }}
                    </el-tag>
                  </div>
                </div>
                <div class="card-body">
                  <div class="data-grid">
                    <div class="data-item">
                      <div class="data-label">
                        <i class="el-icon-s-data"></i>
                        <span>面积</span>
                      </div>
                      <div class="data-value">{{ land.landArea != null ? land.landArea + ' 亩' : '--' }}</div>
                    </div>
                    <div class="data-item">
                      <div class="data-label">
                        <i class="el-icon-aim"></i>
                        <span>土壤类型</span>
                      </div>
                      <div class="data-value">
                        <span class="soil-type-text">{{ land.soilType || '--' }}</span>
                      </div>
                    </div>
                    <div class="data-item">
                      <div class="data-label">
                        <i class="el-icon-odometer"></i>
                        <span>土壤pH</span>
                      </div>
                      <div class="data-value">{{ land.soilPh != null ? land.soilPh : '--' }}</div>
                    </div>
                    <div class="data-item">
                      <div class="data-label">
                        <i class="el-icon-location"></i>
                        <span>位置</span>
                      </div>
                      <div class="data-value">{{ land.location || '--' }}</div>
                    </div>
                    <div class="data-item">
                      <div class="data-label">
                        <i class="el-icon-connection"></i>
                        <span>有机质</span>
                      </div>
                      <div class="data-value">{{ land.organicMatter != null ? land.organicMatter + ' %' : '--' }}</div>
                    </div>
                    <div class="data-item">
                      <div class="data-label">
                        <i class="el-icon-magic-stick"></i>
                        <span>氮磷钾</span>
                      </div>
                      <div class="data-value small-text">
                        N:{{ land.nitrogenContent || '--' }} P:{{ land.phosphorusContent || '--' }} K:{{ land.potassiumContent || '--' }}
                      </div>
                    </div>
                  </div>
                </div>
                <div class="card-footer">
                  <div class="land-info-extra">
                    <div class="info-item">
                      <i class="el-icon-water"></i>
                      <span>{{ land.irrigationMethod || '--' }}</span>
                    </div>
                    <div class="info-item">
                      <i class="el-icon-bottom"></i>
                      <span>{{ land.drainageCondition || '--' }}</span>
                    </div>
                  </div>
                  <div class="card-actions">
                    <el-button size="mini" type="primary" icon="el-icon-edit" 
                               @click="handleUpdate(land)" class="action-btn edit-btn">修改</el-button>
                    <el-button size="mini" type="danger" icon="el-icon-delete" 
                               @click="handleDelete(land)" class="action-btn delete-btn">删除</el-button>
                  </div>
                </div>
              </div>
            </el-col>
          </el-row>
        </div>
      </div>

      <!-- 分页 -->
      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
        class="pagination"
      />
    </div>

    <!-- 新增/修改地块对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body 
               class="land-dialog" :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="120px" class="dialog-form">
        <el-row>
          <el-col :span="12">
            <el-form-item label="地块名称" prop="landName">
              <el-input v-model="form.landName" placeholder="请输入地块名称" class="form-input" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="地块编码" prop="landCode">
              <el-input v-model="form.landCode" placeholder="请输入地块编码" class="form-input" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="面积(亩)" prop="landArea">
              <el-input-number v-model="form.landArea" :min="0" :precision="2" placeholder="请输入面积" 
                               class="form-number" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="位置" prop="location">
              <el-input v-model="form.location" placeholder="请输入位置" class="form-input" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="土壤类型" prop="soilType">
              <el-select v-model="form.soilType" placeholder="请选择土壤类型" class="form-select">
                <el-option label="壤土" value="壤土" />
                <el-option label="沙壤土" value="沙壤土" />
                <el-option label="黏土" value="黏土" />
                <el-option label="沙土" value="沙土" />
                <el-option label="黏壤土" value="黏壤土" />
                <el-option label="沙质壤土" value="沙质壤土" />
                <el-option label="粉砂壤土" value="粉砂壤土" />
                <el-option label="壤质砂土" value="壤质砂土" />
                <el-option label="粉壤土" value="粉壤土" />
                <el-option label="砂质黏土" value="砂质黏土" />
                <el-option label="粉砂黏土" value="粉砂黏土" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="土壤pH" prop="soilPh">
              <el-input-number v-model="form.soilPh" :min="0" :max="14" :precision="1" 
                               placeholder="请输入土壤pH" class="form-number" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="有机质含量(%)" prop="organicMatter">
              <el-input-number v-model="form.organicMatter" :min="0" :precision="2" 
                               placeholder="请输入有机质含量" class="form-number" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="氮含量(mg/kg)" prop="nitrogenContent">
              <el-input-number v-model="form.nitrogenContent" :min="0" :precision="1" 
                               placeholder="请输入氮含量" class="form-number" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="磷含量(mg/kg)" prop="phosphorusContent">
              <el-input-number v-model="form.phosphorusContent" :min="0" :precision="1" 
                               placeholder="请输入磷含量" class="form-number" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="钾含量(mg/kg)" prop="potassiumContent">
              <el-input-number v-model="form.potassiumContent" :min="0" :precision="1" 
                               placeholder="请输入钾含量" class="form-number" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="灌溉方式" prop="irrigationMethod">
              <el-select v-model="form.irrigationMethod" placeholder="请选择灌溉方式" class="form-select">
                <el-option label="滴灌" value="滴灌" />
                <el-option label="喷灌" value="喷灌" />
                <el-option label="沟灌" value="沟灌" />
                <el-option label="漫灌" value="漫灌" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="排水条件" prop="drainageCondition">
              <el-select v-model="form.drainageCondition" placeholder="请选择排水条件" class="form-select">
                <el-option label="良好" value="良好" />
                <el-option label="一般" value="一般" />
                <el-option label="较差" value="较差" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="form.status" class="form-radio">
                <el-radio label="0">正常</el-radio>
                <el-radio label="1">停用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="备注" prop="notes">
          <el-input v-model="form.notes" type="textarea" placeholder="请输入备注" 
                    class="form-textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel" class="cancel-btn">取 消</el-button>
        <el-button type="primary" @click="submitForm" class="submit-btn">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listLand, getLand, delLand, addLand, updateLand } from "@/api/agriculture/land";

export default {
  name: "Land",
  data() {
    return {
      loading: false,
      ids: [],
      total: 0,
      landList: [],
      open: false,
      title: '',
      form: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        landName: null,
        soilType: null
      },
      rules: {
        landName: [
          { required: true, message: '地块名称不能为空', trigger: 'blur' }
        ],
        landCode: [
          { required: true, message: '地块编码不能为空', trigger: 'blur' }
        ],
        landArea: [
          { required: true, message: '面积不能为空', trigger: 'blur' }
        ],
        location: [
          { required: true, message: '位置不能为空', trigger: 'blur' }
        ],
        soilType: [
          { required: true, message: '土壤类型不能为空', trigger: 'change' }
        ],
        soilPh: [
          { required: true, message: '土壤pH不能为空', trigger: 'blur' }
        ],
        irrigationMethod: [
          { required: true, message: '灌溉方式不能为空', trigger: 'change' }
        ],
        drainageCondition: [
          { required: true, message: '排水条件不能为空', trigger: 'change' }
        ]
      }
    }
  },
  created() {
    console.log('地块信息页面初始化')
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listLand(this.queryParams).then(response => {
        console.log('地块API返回数据:', response);
        if (response && response.rows) {
          this.landList = response.rows || [];
          this.total = response.total || 0;
        } else {
          this.landList = [];
          this.total = 0;
        }
        this.loading = false;
      }).catch(error => {
        console.error('地块API调用失败:', error);
        this.$message.error('获取地块信息失败');
        this.loading = false;
      });
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.landId)
    },
    // 判断是否选中（卡片用）
    isSelected(landId) {
      return this.ids.includes(landId)
    },
    // 切换选择状态（卡片用）
    toggleSelection(land) {
      const index = this.ids.indexOf(land.landId)
      if (index > -1) {
        this.ids.splice(index, 1)
      } else {
        this.ids.push(land.landId)
      }
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "新增地块";
    },
    handleUpdate(row) {
      this.reset();
      const landId = row.landId || this.ids;
      getLand(landId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改地块";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.landId != null) {
            updateLand(this.form).then(response => {
              this.$message.success("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addLand(this.form).then(response => {
              this.$message.success("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    cancel() {
      this.open = false;
      this.reset();
    },
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
    handleDelete(row) {
      const landIds = row.landId || this.ids;
      this.$confirm('是否确认删除地块编号为"' + landIds + '"的数据项?', "警告", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      }).then(() => {
        return delLand(landIds).then(() => {
          this.getList();
          this.$message.success("删除成功");
        });
      }).catch(() => {
        this.$message.error('删除失败');
      });
    }
  }
}
</script>

<style scoped>
/* 主容器样式：中性浅灰蓝背景，偏工业科技感 */
.land-container {
  background: #f5f7fb;
  min-height: 100vh;
  padding: 24px;
  box-sizing: border-box;
}

/* 页面头部：青绿色主色调 */
.page-header {
  background: linear-gradient(135deg, #0097a7 0%, #00acc1 45%, #26c6da 100%);
  border-radius: 16px;
  padding: 28px 32px;
  margin-bottom: 28px;
  box-shadow: 0 18px 32px rgba(0, 150, 167, 0.35);
  position: relative;
  overflow: hidden;
  transition: transform 0.25s ease, box-shadow 0.25s ease;
}

.page-header:hover {
  transform: translateY(-2px);
  box-shadow: 0 24px 40px rgba(0, 150, 167, 0.45);
}

.page-header::before {
  content: '';
  position: absolute;
  inset: -40%;
  background: radial-gradient(circle at 0% 0%, rgba(255, 255, 255, 0.25), transparent 60%);
  opacity: 0.9;
  pointer-events: none;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: relative;
  z-index: 1;
}

.page-title {
  color: #ffffff;
  margin: 0;
  font-size: 24px;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 10px;
  letter-spacing: 0.06em;
}

.page-title i {
  font-size: 26px;
}

.add-btn {
  background: rgba(0, 0, 0, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.4);
  color: #e0f7fa;
  border-radius: 999px;
  padding: 10px 22px;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.25);
}

.add-btn:hover {
  background: rgba(255, 255, 255, 0.18);
  transform: translateY(-1px);
}

/* 搜索区域 */
.search-section {
  margin-bottom: 28px;
}

.section-card {
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08);
  border: 1px solid rgba(148, 163, 184, 0.25);
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.section-card:hover {
  box-shadow: 0 16px 32px rgba(15, 23, 42, 0.12);
  border-color: rgba(0, 172, 193, 0.4);
  transform: translateY(-1px);
}

.card-header {
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  padding: 20px 24px;
  border-bottom: 1px solid rgba(226, 232, 240, 0.9);
  display: flex;
  justify-content: space-between;
  align-items: center;
  backdrop-filter: blur(10px);
}

.section-title {
  color: #0f172a;
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 10px;
}

.section-title i {
  color: #00acc1;
  font-size: 18px;
}

.search-btn {
  background: linear-gradient(135deg, #0097a7 0%, #00acc1 45%, #26c6da 100%);
  border: none;
  border-radius: 999px;
  color: #ffffff;
  font-weight: 600;
  transition: all 0.3s ease;
  padding: 8px 18px;
  box-shadow: 0 4px 14px rgba(0, 150, 167, 0.35);
  font-size: 13px;
}

.search-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 8px 22px rgba(0, 150, 167, 0.45);
}

.card-content {
  padding: 22px 24px 20px;
}

.search-form {
  display: flex;
  gap: 20px;
  align-items: flex-end;
  flex-wrap: wrap;
}

.search-input,
.search-select {
  min-width: 200px;
}

.search-input .el-input__inner,
.search-select .el-input__inner {
  border-radius: 12px;
  border: 1px solid #d1d5db;
  transition: all 0.2s ease;
  box-shadow: 0 1px 3px rgba(15, 23, 42, 0.06);
  background: #f9fafb;
}

.search-input .el-input__inner:focus,
.search-select .el-input__inner:focus {
  border-color: #00acc1;
  box-shadow: 0 0 0 3px rgba(0, 172, 193, 0.18);
  background: #ffffff;
}

/* 地块列表区域 */
.lands-section {
  background: #ffffff;
  border-radius: 16px;
  padding: 24px 24px 20px;
  box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08);
  border: 1px solid rgba(148, 163, 184, 0.25);
  transition: all 0.2s ease;
}

.lands-section:hover {
  box-shadow: 0 18px 32px rgba(15, 23, 42, 0.12);
  border-color: rgba(0, 172, 193, 0.4);
  transform: translateY(-1px);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 22px;
  padding-bottom: 16px;
  border-bottom: 1px solid rgba(226, 232, 240, 0.9);
}

.section-stats {
  display: flex;
  gap: 16px;
  align-items: center;
}

.stats-item {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #6b7280;
  font-size: 13px;
  font-weight: 500;
}

.stats-item i {
  color: #00acc1;
}

.action-group {
  display: flex;
  gap: 8px;
}

.batch-delete-btn {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  border: none;
  border-radius: 999px;
  color: #ffffff;
  transition: all 0.2s ease;
  font-weight: 600;
  padding: 8px 14px;
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
  font-size: 12px;
}

.batch-delete-btn:hover {
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
  transform: translateY(-1px);
}

.lands-grid {
  min-height: 400px;
}

.cards-container {
  padding: 6px 0;
}

.land-card-col {
  margin-bottom: 20px;
}

.land-card {
  background: #ffffff;
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.35);
  box-shadow: 0 6px 18px rgba(15, 23, 42, 0.08);
  transition: all 0.2s ease;
  cursor: pointer;
  overflow: hidden;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.land-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 14px 28px rgba(15, 23, 42, 0.15);
  border-color: rgba(0, 172, 193, 0.6);
}

.land-card.card-selected {
  border-color: #00acc1;
  background: linear-gradient(135deg, rgba(0, 172, 193, 0.06) 0%, rgba(38, 198, 218, 0.04) 100%);
  box-shadow: 0 16px 32px rgba(0, 172, 193, 0.35);
}

.land-card .card-header {
  background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
  padding: 16px 20px;
  border-bottom: 1px solid rgba(226, 232, 240, 0.9);
  display: flex;
  align-items: center;
  gap: 10px;
}

.card-checkbox {
  margin-right: 4px;
}

.land-info {
  flex: 1;
}

.land-info h4 {
  margin: 0 0 4px 0;
  font-size: 15px;
  font-weight: 700;
  color: #0f172a;
}

.land-info p {
  color: #6b7280;
  margin: 0;
  font-size: 12px;
  font-weight: 500;
}

.land-status {
  display: flex;
  align-items: center;
}

.land-card .card-body {
  padding: 18px 20px 16px;
  flex: 1;
}

.data-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 14px;
}

.data-item {
  display: flex;
  flex-direction: column;
  gap: 6px;
  padding: 12px 12px 10px;
  background: #f9fafb;
  border-radius: 12px;
  border: 1px solid rgba(226, 232, 240, 0.9);
  transition: all 0.2s ease;
}

.data-item:hover {
  background: linear-gradient(135deg, #f1f5f9 0%, #e0f7fa 100%);
  border-color: rgba(0, 172, 193, 0.4);
  transform: translateY(-1px);
  box-shadow: 0 4px 10px rgba(148, 163, 184, 0.4);
}

.data-label {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 11px;
  color: #6b7280;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.data-label i {
  font-size: 14px;
  color: #00acc1;
}

.data-value {
  font-size: 13px;
  font-weight: 700;
  color: #0f172a;
  word-break: break-word;
}

/* 土壤类型文字样式 */
.soil-type-text {
  color: #00838f !important;
  font-weight: 700 !important;
  font-size: 13px !important;
}

.data-value.small-text {
  font-size: 12px;
  line-height: 1.4;
}

.land-card .card-footer {
  padding: 14px 20px 14px;
  border-top: 1px solid rgba(226, 232, 240, 0.9);
  background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
  border-radius: 0 0 16px 16px;
}

.land-info-extra {
  display: flex;
  gap: 12px;
  margin-bottom: 10px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: #6b7280;
  font-weight: 500;
}

.info-item i {
  color: #00acc1;
  font-size: 14px;
}

.card-actions {
  display: flex;
  gap: 8px;
}

.action-btn {
  flex: 1;
  border-radius: 8px;
  font-size: 12px;
  padding: 8px 14px;
  transition: all 0.2s ease;
  border: none;
  font-weight: 600;
  box-shadow: 0 2px 6px rgba(15, 23, 42, 0.14);
}

.action-btn.edit-btn {
  background: linear-gradient(135deg, #0097a7 0%, #00acc1 45%, #26c6da 100%);
  color: #ffffff;
}

.action-btn.edit-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(0, 150, 167, 0.45);
}

.action-btn.delete-btn {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: #ffffff;
}

.action-btn.delete-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(239, 68, 68, 0.5);
}

/* 对话框样式 */
.land-dialog {
  border-radius: 16px;
  overflow: hidden;
}

.land-dialog .el-dialog__header {
  background: linear-gradient(135deg, #0097a7 0%, #00acc1 45%, #26c6da 100%);
  color: #ffffff;
  border-radius: 16px 16px 0 0;
  padding: 22px 26px;
  box-shadow: 0 4px 12px rgba(15, 23, 42, 0.16);
}

.land-dialog .el-dialog__title {
  color: #ffffff;
  font-size: 16px;
  font-weight: 700;
}

.land-dialog .el-dialog__body {
  padding: 24px 26px;
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
}

.dialog-form .el-form-item__label {
  color: #0f172a;
  font-weight: 600;
  font-size: 13px;
}

.form-input,
.form-number,
.form-select,
.form-textarea {
  border-radius: 12px;
  border: 1px solid #d1d5db;
  transition: all 0.2s ease;
  box-shadow: 0 1px 3px rgba(15, 23, 42, 0.08);
}

.form-input:focus,
.form-number:focus,
.form-select:focus,
.form-textarea:focus {
  border-color: #00acc1;
  box-shadow: 0 0 0 3px rgba(0, 172, 193, 0.18);
}

.form-radio {
  display: flex;
  gap: 16px;
}

.dialog-footer {
  text-align: right;
  padding: 18px 26px;
  background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
  border-radius: 0 0 16px 16px;
  border-top: 1px solid rgba(226, 232, 240, 0.9);
}

.cancel-btn {
  background: #ffffff;
  border: 1px solid #e5e7eb;
  border-radius: 999px;
  color: #6b7280;
  padding: 8px 20px;
  transition: all 0.2s ease;
  font-weight: 600;
  font-size: 13px;
}

.cancel-btn:hover {
  border-color: #00acc1;
  color: #00838f;
  background: rgba(0, 172, 193, 0.06);
}

.submit-btn {
  background: linear-gradient(135deg, #0097a7 0%, #00acc1 45%, #26c6da 100%);
  border: none;
  border-radius: 999px;
  color: #ffffff;
  padding: 8px 20px;
  font-weight: 600;
  transition: all 0.2s ease;
  font-size: 13px;
  box-shadow: 0 4px 12px rgba(0, 150, 167, 0.45);
}

.submit-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 8px 20px rgba(0, 150, 167, 0.55);
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 64px 20px;
  background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
  border-radius: 16px;
  border: 1px dashed rgba(148, 163, 184, 0.6);
  margin: 16px 0;
}

/* 分页样式 */
.pagination {
  margin-top: 16px;
  display: flex;
  justify-content: center;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .land-container {
    padding: 12px;
  }
  
  .page-header {
    padding: 20px;
  }
  
  .header-content {
    flex-direction: column;
    gap: 14px;
    text-align: center;
  }
  
  .search-form {
    flex-direction: column;
    gap: 14px;
  }
  
  .search-input,
  .search-select {
    width: 100%;
  }
  
  .section-header {
    flex-direction: column;
    gap: 12px;
    text-align: center;
  }
  
  .data-grid {
    grid-template-columns: 1fr;
  }
  
  .land-info-extra {
    flex-direction: column;
    gap: 6px;
  }
  
  .card-actions {
    flex-direction: column;
  }
  
  .action-btn {
    width: 100%;
  }
}

/* 卡片入场动画，轻微淡入上移 */
.land-card {
  animation: fadeInUp 0.4s ease-out;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
