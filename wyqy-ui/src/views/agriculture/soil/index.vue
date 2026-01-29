<template>
  <div class="soil-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <h2 class="page-title">
          <i class="el-icon-connection"></i>
          土壤信息管理
        </h2>
        <div class="header-actions">
          <el-button type="primary" icon="el-icon-refresh" @click="getList" 
                     class="refresh-btn">刷新数据</el-button>
        </div>
      </div>
    </div>

    <!-- 地块选择 -->
    <div class="selection-section">
      <div class="section-card">
        <div class="card-header">
          <h3 class="section-title">
            <i class="el-icon-location-outline"></i>
            地块选择
          </h3>
        </div>
        <div class="card-content">
          <el-select v-model="selectedLandId" placeholder="请选择地块" 
                     class="land-selector" @change="handleLandChange">
            <el-option v-for="land in landOptions" :key="land.landId" 
                       :label="land.landName" :value="land.landId">
              <div class="option-item">
                <i class="el-icon-map-location"></i>
                <span>{{ land.landName }}</span>
                <small>{{ land.location || '未知位置' }}</small>
              </div>
            </el-option>
          </el-select>
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
            共 {{ landList.length }} 个地块
          </span>
        </div>
      </div>
      
      <div v-loading="loading" class="lands-grid">
        <el-empty v-if="landList.length === 0" description="暂无地块数据" 
                  class="empty-state">
          <el-button type="primary" @click="getList">重新加载</el-button>
        </el-empty>
        <div v-else class="cards-container">
          <el-row :gutter="20">
            <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="land in landList" :key="land.landId" class="land-card-col">
              <div class="land-card" @click="viewLand(land)">
                <div class="card-header">
                  <div class="land-info">
                    <h4 class="land-name">{{ land.landName || '未命名地块' }}</h4>
                    <p class="land-code">{{ land.landCode || '无编码' }}</p>
                  </div>
                  <div class="land-icon">
                    <i class="el-icon-connection"></i>
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
                        <el-tag size="mini" type="success">{{ land.soilType || '--' }}</el-tag>
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
                  </div>
                </div>
                <div class="card-footer">
                  <el-button type="primary" size="mini" icon="el-icon-view" 
                             @click.stop="viewLand(land)" class="view-btn">查看详情</el-button>
                </div>
              </div>
            </el-col>
          </el-row>
        </div>
      </div>
    </div>

    <!-- 详情抽屉 -->
    <el-drawer :visible.sync="drawerOpen" :title="drawerTitle" size="50%" 
               append-to-body class="soil-drawer" :close-on-click-modal="false">
      <div class="drawer-content" v-if="currentLand">
        <div class="drawer-header">
          <div class="land-summary">
            <div class="summary-icon">
              <i class="el-icon-connection"></i>
            </div>
            <div class="summary-info">
              <h3>{{ currentLand.landName || '未命名地块' }}</h3>
              <p>{{ currentLand.landCode || '无编码' }}</p>
            </div>
          </div>
        </div>
        
        <div class="drawer-body">
          <el-descriptions :column="2" border class="soil-descriptions">
            <el-descriptions-item label="地块名称">
              <span class="desc-value">{{ currentLand.landName || '-' }}</span>
            </el-descriptions-item>
            <el-descriptions-item label="地块编码">
              <span class="desc-value">{{ currentLand.landCode || '-' }}</span>
            </el-descriptions-item>
            <el-descriptions-item label="面积">
              <span class="desc-value">{{ currentLand.landArea != null ? currentLand.landArea + ' 亩' : '-' }}</span>
            </el-descriptions-item>
            <el-descriptions-item label="位置">
              <span class="desc-value">{{ currentLand.location || '-' }}</span>
            </el-descriptions-item>
            <el-descriptions-item label="土壤类型">
              <el-tag type="success">{{ currentLand.soilType || '-' }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="土壤pH">
              <span class="desc-value">{{ currentLand.soilPh != null ? currentLand.soilPh : '-' }}</span>
            </el-descriptions-item>
            <el-descriptions-item label="有机质含量">
              <span class="desc-value">{{ currentLand.organicMatter != null ? currentLand.organicMatter + ' %' : '-' }}</span>
            </el-descriptions-item>
            <el-descriptions-item label="氮含量">
              <span class="desc-value">{{ currentLand.nitrogenContent != null ? currentLand.nitrogenContent + ' mg/kg' : '-' }}</span>
            </el-descriptions-item>
            <el-descriptions-item label="磷含量">
              <span class="desc-value">{{ currentLand.phosphorusContent != null ? currentLand.phosphorusContent + ' mg/kg' : '-' }}</span>
            </el-descriptions-item>
            <el-descriptions-item label="钾含量">
              <span class="desc-value">{{ currentLand.potassiumContent != null ? currentLand.potassiumContent + ' mg/kg' : '-' }}</span>
            </el-descriptions-item>
            <el-descriptions-item label="灌溉方式">
              <span class="desc-value">{{ currentLand.irrigationMethod || '-' }}</span>
            </el-descriptions-item>
            <el-descriptions-item label="排水条件">
              <span class="desc-value">{{ currentLand.drainageCondition || '-' }}</span>
            </el-descriptions-item>
          </el-descriptions>
        </div>
      </div>
      
      <div class="drawer-footer">
        <el-button @click="drawerOpen = false" class="close-btn">关闭</el-button>
      </div>
    </el-drawer>
  </div>
</template>

<script>
import { listLand } from "@/api/agriculture/land";

export default {
  name: "Soil",
  data() {
    return {
      loading: false,
      selectedLandId: null,
      landList: [],
      landOptions: [],
      currentLand: null,
      drawerOpen: false,
      drawerTitle: "土壤信息详情"
    }
  },
  created() {
    console.log('土壤信息页面初始化')
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listLand().then(response => {
        console.log('API返回数据:', response);
        if (response && response.rows) {
          this.landList = response.rows || [];
          this.landOptions = response.rows || [];
        } else {
          this.landList = [];
          this.landOptions = [];
        }
        this.loading = false;
      }).catch(error => {
        console.error('API调用失败:', error);
        this.$message.error('获取地块信息失败');
        this.loading = false;
      });
    },
    handleLandChange(landId) {
      console.log('选择地块:', landId);
      this.currentLand = this.landOptions.find(land => land.landId === landId);
      if (this.currentLand) {
        this.drawerTitle = `土壤信息详情 - ${this.currentLand.landName}`;
        this.drawerOpen = true;
      }
    },
    viewLand(land) {
      this.selectedLandId = land.landId;
      this.currentLand = land;
      this.drawerTitle = `土壤信息详情 - ${land.landName}`;
      this.drawerOpen = true;
    }
  }
}
</script>

<style scoped>
/* 主容器样式 */
.soil-container {
  background-color: #F7F9FC;
  min-height: 100vh;
  padding: 20px;
}

/* 页面头部 */
.page-header {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  border-radius: 16px;
  padding: 24px 32px;
  margin-bottom: 24px;
  box-shadow: 0 8px 32px rgba(5, 117, 230, 0.3);
  position: relative;
  overflow: hidden;
}

.page-header::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(45deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0.05) 100%);
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
  font-size: 24px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 12px;
}

.page-title i {
  font-size: 28px;
}

.refresh-btn {
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  border-radius: 8px;
  padding: 10px 20px;
  font-size: 14px;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.refresh-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

/* 选择区域 */
.selection-section {
  margin-bottom: 24px;
}

.section-card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(5, 117, 230, 0.1);
  overflow: hidden;
}

.card-header {
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  padding: 20px 24px;
  border-bottom: 1px solid #f1f5f9;
}

.section-title {
  color: #1E293B;
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 8px;
}

.section-title i {
  color: #0575E6;
  font-size: 20px;
}

.card-content {
  padding: 24px;
}

.land-selector {
  width: 100%;
  max-width: 400px;
}

.land-selector .el-input__inner {
  border-radius: 8px;
  border: 1px solid #e2e8f0;
  transition: all 0.3s ease;
}

.land-selector .el-input__inner:focus {
  border-color: #0575E6;
  box-shadow: 0 0 0 3px rgba(5, 117, 230, 0.1);
}

.option-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 0;
}

.option-item i {
  color: #0575E6;
  font-size: 16px;
}

.option-item small {
  color: #64748B;
  margin-left: auto;
}

/* 地块列表区域 */
.lands-section {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(5, 117, 230, 0.1);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid #f1f5f9;
}

.section-stats {
  display: flex;
  gap: 16px;
}

.stats-item {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #64748B;
  font-size: 14px;
}

.stats-item i {
  color: #0575E6;
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
  background: white;
  border-radius: 12px;
  border: 2px solid transparent;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
  cursor: pointer;
  overflow: hidden;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.land-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(5, 117, 230, 0.15);
  border-color: rgba(5, 117, 230, 0.2);
}

.land-card .card-header {
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  padding: 20px;
  border-bottom: 1px solid #f1f5f9;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.land-info h4 {
  color: #1E293B;
  margin: 0 0 4px 0;
  font-size: 16px;
  font-weight: 600;
}

.land-info p {
  color: #64748B;
  margin: 0;
  font-size: 12px;
}

.land-icon {
  width: 48px;
  height: 48px;
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 24px;
}

.land-card .card-body {
  padding: 20px;
  flex: 1;
}

.data-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
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

.land-card .card-footer {
  padding: 16px 20px;
  border-top: 1px solid #f1f5f9;
  background: #f8fafc;
}

.view-btn {
  width: 100%;
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  border: none;
  border-radius: 8px;
  color: white;
  font-weight: 500;
  transition: all 0.3s ease;
}

.view-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(5, 117, 230, 0.3);
}

/* 抽屉样式 */
.soil-drawer {
  border-radius: 16px 0 0 16px;
}

.soil-drawer .el-drawer__header {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  color: white;
  padding: 24px 32px;
  margin-bottom: 0;
}

.soil-drawer .el-drawer__title {
  color: white;
  font-size: 18px;
  font-weight: 600;
}

.drawer-content {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.drawer-header {
  padding: 24px 32px;
  background: #f8fafc;
  border-bottom: 1px solid #f1f5f9;
}

.land-summary {
  display: flex;
  align-items: center;
  gap: 16px;
}

.summary-icon {
  width: 64px;
  height: 64px;
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 32px;
}

.summary-info h3 {
  color: #1E293B;
  margin: 0 0 4px 0;
  font-size: 20px;
  font-weight: 600;
}

.summary-info p {
  color: #64748B;
  margin: 0;
  font-size: 14px;
}

.drawer-body {
  padding: 32px;
  flex: 1;
  overflow-y: auto;
}

.soil-descriptions {
  border-radius: 8px;
  overflow: hidden;
}

.soil-descriptions .el-descriptions__header {
  background: #f8fafc;
}

.soil-descriptions .el-descriptions-item__label {
  background: #f8fafc;
  color: #1E293B;
  font-weight: 500;
}

.desc-value {
  color: #64748B;
  font-weight: 500;
}

.drawer-footer {
  padding: 24px 32px;
  background: #f8fafc;
  border-top: 1px solid #f1f5f9;
  text-align: right;
}

.close-btn {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  color: #64748B;
  padding: 10px 20px;
  transition: all 0.3s ease;
}

.close-btn:hover {
  border-color: #0575E6;
  color: #0575E6;
  background: rgba(5, 117, 230, 0.05);
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 60px 20px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .soil-container {
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
  
  .section-header {
    flex-direction: column;
    gap: 16px;
    text-align: center;
  }
  
  .data-grid {
    grid-template-columns: 1fr;
  }
  
  .soil-drawer {
    border-radius: 0;
  }
  
  .drawer-header,
  .drawer-body,
  .drawer-footer {
    padding: 20px;
  }
  
  .land-summary {
    flex-direction: column;
    text-align: center;
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

.land-card {
  animation: fadeInUp 0.6s ease-out;
}

.land-card:nth-child(1) { animation-delay: 0.1s; }
.land-card:nth-child(2) { animation-delay: 0.2s; }
.land-card:nth-child(3) { animation-delay: 0.3s; }
.land-card:nth-child(4) { animation-delay: 0.4s; }
</style>
