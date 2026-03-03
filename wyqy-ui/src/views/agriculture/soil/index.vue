<template>
  <div class="soil-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <h2 class="page-title">
          <i class="el-icon-connection"></i>
          土壤信息
        </h2>
        <div class="header-actions">
          <el-button type="primary" icon="el-icon-refresh" @click="getList" 
                     class="refresh-btn">刷新数据</el-button>
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
  --brand: #14b8a6;
  --brand-2: #06b6d4;
  --brand-soft: rgba(20, 184, 166, 0.12);
  --text-1: #0f172a;
  --text-2: #334155;
  --text-3: #64748b;
  --border: rgba(15, 23, 42, 0.08);
  --surface: rgba(255, 255, 255, 0.82);
  --surface-solid: #ffffff;
  --radius-lg: 18px;
  --radius-md: 14px;
  --shadow-sm: 0 6px 16px rgba(2, 8, 23, 0.08);
  --shadow-md: 0 16px 32px rgba(2, 8, 23, 0.10);

  background:
    radial-gradient(900px 380px at 20% 0%, rgba(20, 184, 166, 0.10) 0%, transparent 55%),
    radial-gradient(900px 380px at 90% 10%, rgba(56, 189, 248, 0.10) 0%, transparent 55%),
    linear-gradient(180deg, #f7fbfc 0%, #f2f6f8 100%);
  min-height: 100vh;
  padding: 24px;
}

/* 页面头部 */
.page-header {
  background: linear-gradient(135deg, rgba(20, 184, 166, 0.92) 0%, rgba(6, 182, 212, 0.92) 55%, rgba(56, 189, 248, 0.86) 100%);
  border-radius: var(--radius-lg);
  padding: 28px 32px;
  margin-bottom: 28px;
  box-shadow: var(--shadow-md);
  position: relative;
  overflow: hidden;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.page-header:hover {
  transform: translateY(-2px);
  box-shadow: 0 22px 40px rgba(2, 8, 23, 0.14);
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

.refresh-btn {
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

.refresh-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
  box-shadow: 0 22px 32px rgba(2, 8, 23, 0.16);
}

/* 选择区域 */
.selection-section {
  margin-bottom: 28px;
}

.section-card {
  background: var(--surface);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--border);
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  backdrop-filter: blur(10px);
}

.section-card:hover {
  box-shadow: var(--shadow-md);
  border-color: rgba(20, 184, 166, 0.22);
}

.card-header {
  background: linear-gradient(135deg, rgba(248, 250, 252, 0.88) 0%, rgba(241, 245, 249, 0.82) 100%);
  padding: 24px 28px;
  border-bottom: 1px solid var(--border);
  backdrop-filter: blur(10px);
}

.section-title {
  color: var(--text-1);
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 10px;
}

.section-title i {
  color: var(--brand);
  font-size: 20px;
}

.card-content {
  padding: 28px;
}

.land-selector {
  width: 100%;
  max-width: 400px;
}

.land-selector .el-input__inner {
  border-radius: 12px;
  border: 1px solid rgba(15, 23, 42, 0.12);
  transition: all 0.3s ease;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
}

.land-selector .el-input__inner:focus {
  border-color: var(--brand);
  box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.14);
}

.option-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 0;
}

.option-item i {
  color: var(--brand);
  font-size: 16px;
}

.option-item small {
  color: var(--text-3);
  margin-left: auto;
  font-weight: 500;
}

/* 地块列表区域 */
.lands-section {
  background: var(--surface);
  border-radius: var(--radius-lg);
  padding: 28px;
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--border);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  backdrop-filter: blur(10px);
}

.lands-section:hover {
  box-shadow: var(--shadow-md);
  border-color: rgba(20, 184, 166, 0.22);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 28px;
  padding-bottom: 20px;
  border-bottom: 1px solid var(--border);
}

.section-stats {
  display: flex;
  gap: 16px;
}

.stats-item {
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--text-3);
  font-size: 14px;
  font-weight: 500;
}

.stats-item i {
  color: var(--brand);
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
  background: var(--surface);
  border-radius: var(--radius-lg);
  border: 2px solid transparent;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  overflow: hidden;
  height: 100%;
  display: flex;
  flex-direction: column;
  backdrop-filter: blur(10px);
}

.land-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
  border-color: rgba(20, 184, 166, 0.22);
}

.land-card .card-header {
  background: linear-gradient(135deg, rgba(248, 250, 252, 0.88) 0%, rgba(241, 245, 249, 0.82) 100%);
  padding: 24px;
  border-bottom: 1px solid var(--border);
  display: flex;
  justify-content: space-between;
  align-items: center;
  backdrop-filter: blur(10px);
}

.land-info h4 {
  color: var(--text-1);
  margin: 0 0 6px 0;
  font-size: 16px;
  font-weight: 700;
}

.land-info p {
  color: var(--text-3);
  margin: 0;
  font-size: 12px;
  font-weight: 500;
}

.land-icon {
  width: 52px;
  height: 52px;
  background: linear-gradient(135deg, var(--brand) 0%, var(--brand-2) 100%);
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 26px;
  box-shadow: 0 10px 22px rgba(2, 8, 23, 0.16);
  transition: transform 0.3s ease;
}

.land-card:hover .land-icon {
  transform: scale(1.1);
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
  background: linear-gradient(135deg, rgba(248, 250, 252, 0.88) 0%, rgba(255, 255, 255, 0.82) 100%);
  border-radius: 12px;
  border: 1px solid rgba(15, 23, 42, 0.08);
  transition: all 0.3s ease;
}

.data-item:hover {
  background: linear-gradient(135deg, rgba(20, 184, 166, 0.08) 0%, rgba(56, 189, 248, 0.06) 100%);
  border-color: rgba(20, 184, 166, 0.22);
  transform: translateY(-2px);
  box-shadow: 0 10px 18px rgba(2, 8, 23, 0.10);
}

.data-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: var(--text-3);
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.data-label i {
  font-size: 14px;
  color: var(--brand);
}

.data-value {
  font-size: 14px;
  font-weight: 700;
  color: var(--text-1);
  word-break: break-word;
}

/* 土壤类型文字样式 */
.soil-type-text {
  color: #000000 !important;
  font-weight: 700 !important;
  font-size: 14px !important;
}

.land-card .card-footer {
  padding: 20px 24px;
  border-top: 1px solid var(--border);
  background: linear-gradient(135deg, rgba(248, 250, 252, 0.88) 0%, rgba(241, 245, 249, 0.82) 100%);
  border-radius: 0 0 var(--radius-lg) var(--radius-lg);
}

.view-btn {
  width: 100%;
  background: linear-gradient(135deg, var(--brand) 0%, var(--brand-2) 100%);
  border: none;
  border-radius: 12px;
  color: white;
  font-weight: 600;
  transition: all 0.3s ease;
  padding: 12px 20px;
  box-shadow: 0 10px 18px rgba(20, 184, 166, 0.22);
}

.view-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 22px 32px rgba(2, 8, 23, 0.16);
}

/* 抽屉样式 */
.soil-drawer {
  border-radius: 16px 0 0 16px;
}

.soil-drawer .el-drawer__header {
  background: linear-gradient(135deg, var(--brand) 0%, var(--brand-2) 55%, rgba(56, 189, 248, 0.90) 100%);
  color: white;
  padding: 28px 32px;
  margin-bottom: 0;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.soil-drawer .el-drawer__title {
  color: white;
  font-size: 18px;
  font-weight: 700;
  text-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.drawer-content {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.drawer-header {
  padding: 28px 32px;
  background: linear-gradient(135deg, rgba(248, 250, 252, 0.88) 0%, rgba(241, 245, 249, 0.82) 100%);
  border-bottom: 1px solid var(--border);
  backdrop-filter: blur(10px);
}

.land-summary {
  display: flex;
  align-items: center;
  gap: 16px;
}

.summary-icon {
  width: 64px;
  height: 64px;
  background: linear-gradient(135deg, var(--brand) 0%, var(--brand-2) 100%);
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 32px;
  box-shadow: 0 10px 22px rgba(2, 8, 23, 0.16);
}

.summary-info h3 {
  color: var(--text-1);
  margin: 0 0 6px 0;
  font-size: 20px;
  font-weight: 700;
}

.summary-info p {
  color: var(--text-3);
  margin: 0;
  font-size: 14px;
  font-weight: 500;
}

.drawer-body {
  padding: 32px;
  flex: 1;
  overflow-y: auto;
  background: linear-gradient(135deg, rgba(248, 250, 252, 0.88) 0%, rgba(241, 245, 249, 0.82) 100%);
}

.soil-descriptions {
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow-sm);
}

.soil-descriptions .el-descriptions__header {
  background: linear-gradient(135deg, rgba(248, 250, 252, 0.88) 0%, rgba(241, 245, 249, 0.82) 100%);
}

.soil-descriptions .el-descriptions-item__label {
  background: linear-gradient(135deg, rgba(248, 250, 252, 0.88) 0%, rgba(241, 245, 249, 0.82) 100%);
  color: var(--text-1);
  font-weight: 600;
}

.desc-value {
  color: var(--text-2);
  font-weight: 600;
}

.drawer-footer {
  padding: 24px 32px;
  background: linear-gradient(135deg, rgba(248, 250, 252, 0.88) 0%, rgba(241, 245, 249, 0.82) 100%);
  border-top: 1px solid var(--border);
  text-align: right;
}

.close-btn {
  background: white;
  border: 1px solid rgba(229, 231, 235, 0.8);
  border-radius: 12px;
  color: var(--text-3);
  padding: 12px 24px;
  transition: all 0.3s ease;
  font-weight: 600;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
}

.close-btn:hover {
  border-color: rgba(20, 184, 166, 0.32);
  color: var(--brand);
  background: rgba(20, 184, 166, 0.06);
  transform: translateY(-2px);
  box-shadow: 0 10px 16px rgba(2, 8, 23, 0.10);
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 80px 20px;
  background: linear-gradient(135deg, rgba(248, 250, 252, 0.88) 0%, rgba(255, 255, 255, 0.82) 100%);
  border-radius: var(--radius-lg);
  border: 2px dashed rgba(148, 163, 184, 0.42);
  margin: 20px 0;
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
