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
/* 主容器样式 */
.land-container {
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
  min-height: 100vh;
  padding: 24px;
}

/* 页面头部 */
.page-header {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  border-radius: 16px;
  padding: 28px 32px;
  margin-bottom: 28px;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  position: relative;
  overflow: hidden;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.page-header:hover {
  transform: translateY(-2px);
  box-shadow: 0 25px 30px -5px rgba(0, 0, 0, 0.15), 0 15px 15px -5px rgba(0, 0, 0, 0.06);
}

.page-header::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
  animation: shimmer 3s ease-in-out infinite;
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
  color: white;
  margin: 0;
  font-size: 26px;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 12px;
  text-shadow: 0 2px 4px rgba(0,0,0,0.1);
  letter-spacing: 0.5px;
}

.page-title i {
  font-size: 30px;
}

.add-btn {
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  border-radius: 12px;
  padding: 12px 24px;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.add-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.15), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}

/* 搜索区域 */
.search-section {
  margin-bottom: 28px;
}

.section-card {
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  border: 1px solid rgba(229, 231, 235, 0.5);
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.section-card:hover {
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  border-color: rgba(34, 197, 94, 0.2);
}

.card-header {
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  padding: 24px 28px;
  border-bottom: 1px solid rgba(229, 231, 235, 0.5);
  display: flex;
  justify-content: space-between;
  align-items: center;
  backdrop-filter: blur(10px);
}

.section-title {
  color: #1f2937;
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 10px;
}

.section-title i {
  color: #22c55e;
  font-size: 20px;
}

.search-btn {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  border: none;
  border-radius: 12px;
  color: white;
  font-weight: 600;
  transition: all 0.3s ease;
  padding: 10px 20px;
  box-shadow: 0 4px 6px -1px rgba(34, 197, 94, 0.3);
}

.search-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(34, 197, 94, 0.3), 0 10px 10px -5px rgba(34, 197, 94, 0.1);
}

.card-content {
  padding: 28px;
}

.search-form {
  display: flex;
  gap: 20px;
  align-items: flex-end;
}

.search-input,
.search-select {
  min-width: 200px;
}

.search-input .el-input__inner,
.search-select .el-input__inner {
  border-radius: 12px;
  border: 1px solid rgba(229, 231, 235, 0.8);
  transition: all 0.3s ease;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
}

.search-input .el-input__inner:focus,
.search-select .el-input__inner:focus {
  border-color: #22c55e;
  box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.1);
}

/* 地块列表区域 */
.lands-section {
  background: #ffffff;
  border-radius: 16px;
  padding: 28px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  border: 1px solid rgba(229, 231, 235, 0.5);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.lands-section:hover {
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  border-color: rgba(34, 197, 94, 0.2);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 28px;
  padding-bottom: 20px;
  border-bottom: 1px solid rgba(229, 231, 235, 0.5);
}

.section-stats {
  display: flex;
  gap: 16px;
  align-items: center;
}

.stats-item {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #6b7280;
  font-size: 14px;
  font-weight: 500;
}

.stats-item i {
  color: #22c55e;
}

.action-group {
  display: flex;
  gap: 8px;
}

.batch-delete-btn {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  border: none;
  border-radius: 12px;
  color: white;
  transition: all 0.3s ease;
  font-weight: 600;
  padding: 10px 16px;
  box-shadow: 0 4px 6px -1px rgba(239, 68, 68, 0.3);
}

.batch-delete-btn:hover {
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(239, 68, 68, 0.3), 0 10px 10px -5px rgba(239, 68, 68, 0.1);
}

.lands-grid {
  min-height: 400px;
}

.cards-container {
  padding: 8px 0;
}

.land-card-col {
  margin-bottom: 20px;
}

.land-card {
  background: #ffffff;
  border-radius: 16px;
  border: 2px solid transparent;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  overflow: hidden;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.land-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  border-color: rgba(34, 197, 94, 0.2);
}

.land-card.card-selected {
  border-color: #22c55e;
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.05) 0%, rgba(16, 163, 74, 0.05) 100%);
  box-shadow: 0 20px 25px -5px rgba(34, 197, 94, 0.15), 0 10px 10px -5px rgba(34, 197, 94, 0.05);
}

.land-card .card-header {
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  padding: 20px 24px;
  border-bottom: 1px solid rgba(229, 231, 235, 0.5);
  display: flex;
  align-items: center;
  gap: 12px;
  backdrop-filter: blur(10px);
}

.card-checkbox {
  margin-right: 8px;
}

.land-info {
  flex: 1;
}

.land-info h4 {
  color: #1f2937;
  margin: 0 0 6px 0;
  font-size: 16px;
  font-weight: 700;
  background: linear-gradient(135deg, #1f2937 0%, #374151 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
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
  padding: 24px;
  flex: 1;
}

.data-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.data-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 16px;
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  border-radius: 12px;
  border: 1px solid rgba(229, 231, 235, 0.5);
  transition: all 0.3s ease;
}

.data-item:hover {
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.05) 0%, rgba(16, 163, 74, 0.02) 100%);
  border-color: rgba(34, 197, 94, 0.2);
  transform: translateY(-2px);
  box-shadow: 0 4px 6px -1px rgba(34, 197, 94, 0.1);
}

.data-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: #6b7280;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.data-label i {
  font-size: 14px;
  color: #22c55e;
}

.data-value {
  font-size: 14px;
  font-weight: 700;
  color: #1f2937;
  word-break: break-word;
  background: linear-gradient(135deg, #1f2937 0%, #374151 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* 土壤类型文字样式 */
.soil-type-text {
  color: #000000 !important;
  font-weight: 700 !important;
  font-size: 14px !important;
}

.data-value.small-text {
  font-size: 12px;
  line-height: 1.4;
}

.land-card .card-footer {
  padding: 20px 24px;
  border-top: 1px solid rgba(229, 231, 235, 0.5);
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  border-radius: 0 0 16px 16px;
}

.land-info-extra {
  display: flex;
  gap: 16px;
  margin-bottom: 12px;
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
  color: #22c55e;
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
  padding: 10px 16px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: none;
  font-weight: 600;
  box-shadow: 0 2px 4px -1px rgba(0, 0, 0, 0.1);
}

.action-btn.edit-btn {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: white;
}

.action-btn.edit-btn:hover {
  background: linear-gradient(135deg, #059669 0%, #047857 100%);
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(16, 185, 129, 0.3), 0 10px 10px -5px rgba(16, 185, 129, 0.1);
}

.action-btn.delete-btn {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: white;
}

.action-btn.delete-btn:hover {
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(239, 68, 68, 0.3), 0 10px 10px -5px rgba(239, 68, 68, 0.1);
}

/* 对话框样式 */
.land-dialog {
  border-radius: 16px;
  overflow: hidden;
}

.land-dialog .el-dialog__header {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  color: white;
  border-radius: 16px 16px 0 0;
  padding: 28px 32px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.land-dialog .el-dialog__title {
  color: white;
  font-size: 18px;
  font-weight: 700;
  text-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.land-dialog .el-dialog__body {
  padding: 32px;
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
}

.dialog-form .el-form-item__label {
  color: #1f2937;
  font-weight: 600;
  font-size: 14px;
}

.form-input,
.form-number,
.form-select,
.form-textarea {
  border-radius: 12px;
  border: 1px solid rgba(229, 231, 235, 0.8);
  transition: all 0.3s ease;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
}

.form-input:focus,
.form-number:focus,
.form-select:focus,
.form-textarea:focus {
  border-color: #22c55e;
  box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.1);
}

.form-radio {
  display: flex;
  gap: 16px;
}

.dialog-footer {
  text-align: right;
  padding: 24px 32px;
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  border-radius: 0 0 16px 16px;
  border-top: 1px solid rgba(229, 231, 235, 0.5);
}

.cancel-btn {
  background: white;
  border: 1px solid rgba(229, 231, 235, 0.8);
  border-radius: 12px;
  color: #6b7280;
  padding: 12px 24px;
  transition: all 0.3s ease;
  font-weight: 600;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
}

.cancel-btn:hover {
  border-color: #22c55e;
  color: #22c55e;
  background: rgba(34, 197, 94, 0.05);
  transform: translateY(-2px);
  box-shadow: 0 4px 6px -1px rgba(34, 197, 94, 0.2);
}

.submit-btn {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  border: none;
  border-radius: 12px;
  color: white;
  padding: 12px 24px;
  font-weight: 600;
  transition: all 0.3s ease;
  box-shadow: 0 4px 6px -1px rgba(34, 197, 94, 0.3);
}

.submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(34, 197, 94, 0.3), 0 10px 10px -5px rgba(34, 197, 94, 0.1);
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 80px 20px;
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  border-radius: 16px;
  border: 2px dashed rgba(156, 163, 175, 0.3);
  margin: 20px 0;
}

/* 分页样式 */
.pagination {
  margin-top: 20px;
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
    gap: 16px;
    text-align: center;
  }
  
  .search-form {
    flex-direction: column;
    gap: 16px;
  }
  
  .search-input,
  .search-select {
    width: 100%;
  }
  
  .section-header {
    flex-direction: column;
    gap: 16px;
    text-align: center;
  }
  
  .data-grid {
    grid-template-columns: 1fr;
  }
  
  .land-info-extra {
    flex-direction: column;
    gap: 8px;
  }
  
  .card-actions {
    flex-direction: column;
  }
  
  .action-btn {
    width: 100%;
  }
  
  .land-dialog {
    border-radius: 0;
  }
  
  .land-dialog .el-dialog__header,
  .land-dialog .el-dialog__body,
  .dialog-footer {
    padding: 20px;
  }
}

/* 动画效果 */
@keyframes shimmer {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

.land-card {
  animation: fadeInUp 0.6s ease-out;
}

.land-card:nth-child(1) { animation-delay: 0.1s; }
.land-card:nth-child(2) { animation-delay: 0.2s; }
.land-card:nth-child(3) { animation-delay: 0.3s; }
.land-card:nth-child(4) { animation-delay: 0.4s; }

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
</style>
