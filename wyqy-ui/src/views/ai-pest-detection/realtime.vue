<template>
  <div class="realtime-detection-container" @keydown="handleKeyDown" tabindex="0">
    <!-- AI识别状态概览 -->
    <el-row :gutter="20" class="mb20 stats-row">
      <el-col :span="6" v-for="(stat, index) in detectionStats" :key="index">
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
          <div class="stat-decoration"></div>
        </div>
      </el-col>
    </el-row>

    <!-- AI识别主界面 -->
    <el-row :gutter="20" class="mb20">
      <!-- 左侧：视频流显示 -->
      <el-col :span="16">
        <el-card class="video-card">
          <div slot="header" class="card-header">
            <div class="header-title">
              <i class="el-icon-video-camera"></i>
              <span>智农AI实时监控</span>
            </div>
            <div class="header-status">
              <span class="status-tag" :class="'status-' + aiStatus.type">{{ aiStatus.text }}</span>
            </div>
          </div>
          <div class="video-container">
            <div class="video-wrapper">
              <iframe 
                :src="videoStreamUrl" 
                class="video-stream"
                @error="handleVideoError"
                @load="handleVideoLoad"
                frameborder="0"
                allowfullscreen
              ></iframe>
              <div class="video-overlay" v-if="!videoConnected">
                <div class="loading-spinner">
                  <i class="el-icon-loading"></i>
                  <p>正在连接视频流...</p>
                </div>
              </div>
              <div class="ai-indicator" v-if="isAnalyzing">
                <div class="ai-scanner"></div>
                <div class="ai-text">智农AI正在识别...</div>
              </div>
              <!-- 识别结果叠加层 -->
              <div class="detection-overlay" v-if="currentDetection">
                <div class="detection-box" :class="'detection-' + currentDetection.detectionType">
                  <div class="detection-label">
                    {{ getDetectionTypeText(currentDetection.detectionType) }}: {{ currentDetection.pestName }}
                  </div>
                  <div class="detection-confidence">
                    置信度: {{ (currentDetection.confidence * 100).toFixed(1) }}%
                  </div>
                </div>
              </div>
            </div>
            
          </div>
        </el-card>
      </el-col>

    <!-- 右侧：最近识别结果面板 -->
      <el-col :span="8">
        <el-card class="control-panel">
          <!-- 卡片头部 -->
          <div slot="header" class="card-header">
            <div class="header-title">
              <i class="el-icon-bell"></i>
              <span>最近识别结果</span>
            </div>
            <div class="header-status" v-if="recentDetections && recentDetections.length">
              <span class="count-badge">共 {{ recentDetections.length }} 条</span>
            </div>
          </div>

          <!-- 最近识别结果列表 -->
          <div class="recent-results">
            <div class="result-list" v-if="recentDetections.length > 0">
              <div 
                v-for="detection in recentDetections" 
                :key="detection.detectionId"
                class="result-item"
                :class="'result-' + detection.detectionType"
              >
                <div class="result-header">
                  <span class="result-type">{{ getDetectionTypeText(detection.detectionType) }}</span>
                  <span class="result-confidence">{{ (detection.confidence * 100).toFixed(1) }}%</span>
                </div>
                <div class="result-content">
                  <div class="result-name">{{ detection.pestName }}</div>
                  <div class="result-time">{{ formatTime(detection.detectionTime) }}</div>
                </div>
              </div>
            </div>
            <div class="no-results" v-else>
              <i class="el-icon-document"></i>
              <p>暂无识别结果</p>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 识别结果提示框（识别到虫害/病害） -->
    <el-dialog 
      :visible.sync="pestDetectionDialogVisible" 
      width="600px" 
      append-to-body 
      :close-on-click-modal="false"
      :close-on-press-escape="false"
      :show-close="false"
      class="pest-detection-dialog"
      center>
      <div class="pest-detection-content" v-if="detectionResult">
        <div class="detection-icon">
          <i :class="getDetectionTypeIcon(detectionResult.detectionType)"></i>
        </div>
        <h2 class="detection-title">{{ detectionResult.message || '识别完成' }}</h2>
        <div class="detection-details">
          <div class="detail-row" v-if="detectionResult.pestName">
            <i class="el-icon-info"></i>
            <span>病虫害名称：{{ detectionResult.pestName }}</span>
          </div>
          <div class="detail-row">
            <i class="el-icon-s-data"></i>
            <span>置信度：{{ Math.round((detectionResult.confidence || 0) * 100) }}%</span>
          </div>
        </div>
        <div class="recommendation-section">
          <h3 class="recommendation-title">
            <i class="el-icon-lightbulb"></i>
            推荐处理方案
          </h3>
          <p class="recommendation-text">{{ detectionResult.recommendation || '暂无推荐方案，请根据实际情况进行处理。' }}</p>
        </div>
        <div class="detection-actions">
          <el-button type="primary" size="medium" @click="handleCloseDetectionDialog" class="confirm-btn">
            <i class="el-icon-check"></i>
            我知道了
          </el-button>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { detectPest, getVideoStream, getDetectionStats, listAiPestDetection } from "@/api/agriculture/ai-pest-detection";
import { listLand } from "@/api/agriculture/land";
import { listCropSpecies } from "@/api/agriculture/crop";
import { listPlanting, getPlanting, updatePlanting } from "@/api/agriculture/planting";

export default {
  name: "RealtimeDetection",
  data() {
    return {
      // 统计数据
      detectionStats: [],
      // 地块选项
      landOptions: [],
      // 作物选项
      speciesOptions: [],
      // 识别表单
      detectionForm: {
        landId: null,
        speciesId: null,
        landName: null,
        speciesName: null
      },
      // 视频流相关
      videoStreamUrl: "http://192.168.1.103:1145/play_drone.html",
      videoConnected: false,
      isAnalyzing: false,
      aiStatus: {
        type: 'info',
        text: '未连接'
      },
      // 识别结果
      detectionResult: null,
      currentDetection: null,
      // 识别结果提示框显示状态
      pestDetectionDialogVisible: false,
      // 最近识别结果
      recentDetections: [],
      // 键盘监听状态
      keyListenerEnabled: true,
      // 自动刷新定时器
      refreshTimer: null
    };
  },
  created() {
    this.getLandOptions();
    this.getSpeciesOptions();
    this.getDetectionStatistics();
    this.initVideoStream();
    this.loadRecentDetections();
  },
  mounted() {
    // 确保容器可以获得焦点
    this.$nextTick(() => {
      const container = this.$el;
      if (container) {
        container.setAttribute('tabindex', '0');
      }
    });
    
    // 启动定时刷新
    this.startAutoRefresh();

    // 进入页面后自动进入"AI正在识别"状态（等同于点击"开始识别"）
    this.startAnalysis();
  },
  beforeDestroy() {
    // 清理定时器
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer);
    }
  },
  methods: {
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
    // 获取识别统计
    getDetectionStatistics() {
      getDetectionStats().then(response => {
        const data = response.data;
        this.detectionStats = [
          {
            value: data.totalDetections || 0,
            label: '总识别次数',
            icon: 'el-icon-s-data'
          },
          {
            value: data.pestDetections || 0,
            label: '虫害识别',
            icon: 'el-icon-warning'
          },
          {
            value: data.diseaseDetections || 0,
            label: '病害识别',
            icon: 'el-icon-warning'
          },
          {
            value: data.pendingCount || 0,
            label: '待处理',
            icon: 'el-icon-time'
          }
        ];
      });
    },
    // 加载最近识别结果
    loadRecentDetections() {
      const queryParams = {
        pageNum: 1,
        pageSize: 5
      };
      listAiPestDetection(queryParams).then(response => {
        this.recentDetections = response.rows;
      });
    },
    // 启动自动刷新
    startAutoRefresh() {
      this.refreshTimer = setInterval(() => {
        this.getDetectionStatistics();
        this.loadRecentDetections();
      }, 30000); // 30秒刷新一次
    },
    // 初始化视频流
    initVideoStream() {
      this.checkVideoConnection();
      // 定期检查视频连接状态
      setInterval(() => {
        this.checkVideoConnection();
      }, 30000); // 30秒检查一次
    },
    // 检查视频连接状态
    checkVideoConnection() {
      // 由于使用iframe，我们直接尝试连接
      // 实际项目中可以通过postMessage或其他方式检测iframe加载状态
      this.videoConnected = true;
      this.aiStatus = { type: 'success', text: '已连接' };
    },
    // 切换分析状态
    toggleAnalysis() {
      if (this.isAnalyzing) {
        this.stopAnalysis();
      } else {
        this.startAnalysis();
      }
    },
    // 开始分析（进入"AI 正在识别"状态）
    startAnalysis() {
      this.isAnalyzing = true;
      this.aiStatus = { type: 'warning', text: 'AI监控中...' };
      // 不在这里直接调用识别，用户通过 Ctrl+2 或截图识别来获取结果
    },
    // 停止分析
    stopAnalysis() {
      this.isAnalyzing = false;
      // 不要清除 currentDetection，因为需要显示识别结果
      // this.currentDetection = null;
      this.aiStatus = { type: 'success', text: '已连接' };
    },
    // 执行识别
    performDetection() {
      const params = {
        landId: this.detectionForm.landId,
        speciesId: this.detectionForm.speciesId,
        landName: this.getSelectedLandName(),
        speciesName: this.getSelectedSpeciesName()
      };
      
      detectPest(params).then(response => {
        if (response.code === 200) {
          this.detectionResult = response.data;
          this.currentDetection = response.data;
          // 弹出识别结果提示框
          this.pestDetectionDialogVisible = true;
          this.getDetectionStatistics();
          this.loadRecentDetections();
        } else {
          this.$message.error(response.msg || '识别失败');
        }
        this.stopAnalysis();
      }).catch(() => {
        this.$message.error('识别失败');
        this.stopAnalysis();
      });
    },
    // 截图识别（仍然可以提示用户先选择地块和作物）
    captureFrame() {
      if (!this.detectionForm.landId || !this.detectionForm.speciesId) {
        this.$message.warning('请先选择地块和作物');
        return;
      }
      
      this.$message.info('正在截图并识别...');
      this.performDetection();
    },
    // 刷新视频
    refreshVideo() {
      this.videoConnected = false;
      this.aiStatus = { type: 'info', text: '重新连接中...' };
      // 强制刷新iframe
      const iframe = document.querySelector('.video-stream');
      if (iframe) {
        iframe.src = iframe.src;
      }
      setTimeout(() => {
        this.checkVideoConnection();
      }, 1000);
    },
    // 处理视频错误
    handleVideoError() {
      this.videoConnected = false;
      this.aiStatus = { type: 'danger', text: '连接失败' };
    },
    // 处理视频加载
    handleVideoLoad() {
      this.videoConnected = true;
      this.aiStatus = { type: 'success', text: '已连接' };
    },
    // 获取选中的地块名称
    getSelectedLandName() {
      const land = this.landOptions.find(l => l.landId === this.detectionForm.landId);
      return land ? land.landName : '未知地块';
    },
    // 获取选中的作物名称
    getSelectedSpeciesName() {
      const species = this.speciesOptions.find(s => s.speciesId === this.detectionForm.speciesId);
      return species ? species.speciesName : '未知作物';
    },
    // 键盘事件处理
    handleKeyDown(event) {
      if (!this.keyListenerEnabled) return;
      
      // 监听 Ctrl+2 键
      const isCtrlOrMeta = event.ctrlKey || event.metaKey;
      const isKey2 = event.key === '2' || event.code === 'Digit2';
      
      if (isCtrlOrMeta && isKey2) {
        event.preventDefault();
        this.quickDetect();
      }
    },
    // 快速识别（Ctrl+2），不再强制选择地块和作物
    quickDetect() {
      // 每次按下 Ctrl+2 都执行一次识别，并在完成后弹出结果
      // 将状态短暂切换为"AI识别中..."，识别结束后恢复为"AI监控中..."
      this.isAnalyzing = true;
      this.aiStatus = { type: 'warning', text: 'AI识别中...' };

      const params = {
        landId: this.detectionForm.landId,
        speciesId: this.detectionForm.speciesId,
        landName: this.getSelectedLandName(),
        speciesName: this.getSelectedSpeciesName()
      };
      
      detectPest(params).then(response => {
        if (response.code === 200) {
          // 保存本次识别结果
          this.detectionResult = response.data;
          this.currentDetection = response.data;
          // 弹出识别结果提示框
          this.pestDetectionDialogVisible = true;
          this.getDetectionStatistics();
          
          // Ctrl+2 触发时修改最新种植记录的健康状况为虫害
          this.updateLatestPlantingHealthStatus();
        } else {
          this.$message.error(response.msg || '识别失败');
        }
      }).catch(() => {
        this.$message.error('识别失败');
      }).finally(() => {
        // 识别完成后恢复为"监控中"状态，保持页面一直处于 AI 识别中效果
        this.isAnalyzing = true;
        this.aiStatus = { type: 'warning', text: 'AI监控中...' };
      });
    },
    /** 更新最新一条种植记录的健康状况为虫害（Ctrl+2 触发） */
    updateLatestPlantingHealthStatus() {
      console.log('开始更新最新种植记录的健康状况为虫害');
      
      // 获取所有种植记录，取最新一条
      listPlanting({
        pageNum: 1,
        pageSize: 100
      }).then(response => {
        if (response.rows && response.rows.length > 0) {
          // 按 plantingId 降序排列，取第一条
          const sortedList = [...response.rows].sort((a, b) => {
            if (a.plantingId && b.plantingId) {
              return b.plantingId - a.plantingId;
            }
            return 0;
          });
          
          const latestPlanting = sortedList[0];
          console.log('找到最新种植记录:', latestPlanting);
          
          // 获取完整的种植记录信息
          getPlanting(latestPlanting.plantingId).then(response => {
            const plantingRecord = response.data;
            
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
              console.log('✅ 健康状况已更新为虫害');
            }).catch(error => {
              console.error('❌ 更新健康状况失败:', error);
            });
          }).catch(error => {
            console.error('获取种植记录详情失败:', error);
          });
        } else {
          console.log('没有找到种植记录');
        }
      }).catch(error => {
        console.error('获取种植记录列表失败:', error);
      });
    },
    // 获取识别类型文本
    getDetectionTypeText(type) {
      const typeMap = {
        'disease': '病害',
        'pest': '虫害',
        'healthy': '健康'
      };
      return typeMap[type] || type;
    },
    // 获取识别类型图标
    getDetectionTypeIcon(type) {
      const iconMap = {
        'disease': 'el-icon-warning',
        'pest': 'el-icon-bug',
        'healthy': 'el-icon-success'
      };
      return iconMap[type] || 'el-icon-info';
    },
    // 获取置信度颜色
    getConfidenceColor(confidence) {
      if (confidence >= 0.8) return '#2E7D32';
      if (confidence >= 0.6) return '#E65100';
      return '#C62828';
    },
    // 格式化置信度
    formatConfidence(percentage) {
      return percentage + '%';
    },
    // 格式化时间
    formatTime(time) {
      if (!time) return '--';
      return this.parseTime(time, '{h}:{i}:{s}');
    },
    // 统计卡片点击事件
    handleStatClick(stat, index) {
      this.$message.info(`点击了${stat.label}: ${stat.value}`);
    },
    // 关闭识别结果提示框
    handleCloseDetectionDialog() {
      this.pestDetectionDialogVisible = false;
      // 不清除 detectionResult，保留识别结果供后续查看
    }
  }
};
</script>

<style scoped>
.realtime-detection-container {
  padding: 24px;
  background: linear-gradient(135deg, #e8f5e9 0%, #f1f8e9 50%, #e0f2f1 100%);
  min-height: 100vh;
  position: relative;
  overflow-x: hidden;
  box-sizing: border-box;
}

.realtime-detection-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 260px;
  background: linear-gradient(135deg, rgba(46, 125, 50, 0.08) 0%, rgba(102, 187, 106, 0.08) 100%);
  z-index: 0;
  pointer-events: none;
}

/* 统计卡片样式 */
.stats-row {
  position: relative;
  z-index: 1;
}

.stat-card {
  position: relative;
  border-radius: 16px;
  padding: 24px 20px;
  color: white;
  cursor: pointer;
  transition: all 0.35s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.2);
  z-index: 1;
}

.stat-card:hover {
  transform: translateY(-6px) scale(1.02);
  box-shadow: 0 16px 36px rgba(0, 0, 0, 0.18);
}

.stat-card-0 {
  background: linear-gradient(135deg, #2E7D32 0%, #66BB6A 100%);
  box-shadow: 0 8px 24px rgba(46, 125, 50, 0.3);
}

.stat-card-0:hover {
  box-shadow: 0 16px 36px rgba(46, 125, 50, 0.4);
}

.stat-card-1 {
  background: linear-gradient(135deg, #E65100 0%, #FF9800 100%);
  box-shadow: 0 8px 24px rgba(230, 81, 0, 0.3);
}

.stat-card-1:hover {
  box-shadow: 0 16px 36px rgba(230, 81, 0, 0.4);
}

.stat-card-2 {
  background: linear-gradient(135deg, #C62828 0%, #EF5350 100%);
  box-shadow: 0 8px 24px rgba(198, 40, 40, 0.3);
}

.stat-card-2:hover {
  box-shadow: 0 16px 36px rgba(198, 40, 40, 0.4);
}

.stat-card-3 {
  background: linear-gradient(135deg, #0277BD 0%, #4FC3F7 100%);
  box-shadow: 0 8px 24px rgba(2, 119, 189, 0.3);
}

.stat-card-3:hover {
  box-shadow: 0 16px 36px rgba(2, 119, 189, 0.4);
}

.stat-content {
  display: flex;
  align-items: center;
  position: relative;
  z-index: 2;
}

.stat-icon {
  width: 56px;
  height: 56px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16px;
  backdrop-filter: blur(10px);
  transition: transform 0.3s ease;
}

.stat-icon i {
  font-size: 28px;
  color: white;
}

.stat-card:hover .stat-icon {
  transform: scale(1.08) rotate(4deg);
}

.stat-value {
  font-size: 30px;
  font-weight: 700;
  margin-bottom: 4px;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  letter-spacing: -0.5px;
}

.stat-label {
  font-size: 14px;
  opacity: 0.95;
  font-weight: 500;
  letter-spacing: 0.3px;
}

.stat-decoration {
  position: absolute;
  top: -30px;
  right: -30px;
  width: 100px;
  height: 100px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
}

/* 视频卡片样式 */
.video-card {
  height: calc(100vh - 260px);
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  border: none;
  overflow: hidden;
  transition: all 0.3s ease;
  z-index: 1;
}

.video-card:hover {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

.video-card >>> .el-card__header {
  background: linear-gradient(135deg, #2E7D32 0%, #66BB6A 100%);
  color: white;
  padding: 18px 24px;
  border-bottom: none;
}

.video-card >>> .el-card__body {
  padding: 20px;
  background: #ffffff;
  height: calc(100% - 60px);
  box-sizing: border-box;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-title {
  display: flex;
  align-items: center;
  font-weight: 600;
  font-size: 16px;
  color: white;
}

.header-title i {
  margin-right: 10px;
  font-size: 20px;
  color: rgba(255, 255, 255, 0.95);
}

.header-status .status-tag {
  display: inline-block;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
}

.status-tag.status-success {
  background: rgba(255, 255, 255, 0.2);
  color: white;
}

.status-tag.status-warning {
  background: #FFF3E0;
  color: #E65100;
}

.status-tag.status-info {
  background: rgba(255, 255, 255, 0.2);
  color: white;
}

.status-tag.status-danger {
  background: #FFEBEE;
  color: #C62828;
}

.video-container {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.video-wrapper {
  flex: 1;
  position: relative;
  background: #1a1a1a;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
  transition: all 0.3s ease;
}

.video-wrapper:hover {
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.25);
}

.video-stream {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border: none;
}

.video-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.loading-spinner {
  text-align: center;
}

.loading-spinner i {
  font-size: 32px;
  margin-bottom: 10px;
  color: #66BB6A;
}

.ai-indicator {
  position: absolute;
  top: 20px;
  left: 20px;
  background: linear-gradient(135deg, #E65100 0%, #FF9800 100%);
  color: white;
  padding: 10px 16px;
  border-radius: 24px;
  display: flex;
  align-items: center;
  animation: ai-pulse 1.5s infinite;
  box-shadow: 0 4px 12px rgba(230, 81, 0, 0.4);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  z-index: 10;
}

.ai-scanner {
  width: 12px;
  height: 12px;
  background: white;
  border-radius: 50%;
  margin-right: 8px;
  animation: ai-scan 1.5s infinite;
}

.ai-text {
  font-size: 12px;
  font-weight: bold;
}

@keyframes ai-pulse {
  0%, 100% { opacity: 0.9; }
  50% { opacity: 1; }
}

@keyframes ai-scan {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.3); }
}

/* 识别结果叠加层 */
.detection-overlay {
  position: absolute;
  top: 20px;
  right: 20px;
}

.detection-box {
  background: rgba(255,255,255,0.95);
  border-radius: 12px;
  padding: 14px 16px;
  border-left: 4px solid #2E7D32;
  box-shadow: 0 4px 16px rgba(0,0,0,0.15);
  min-width: 220px;
  backdrop-filter: blur(10px);
}

.detection-pest {
  border-left-color: #E65100;
  background: linear-gradient(135deg, rgba(255, 243, 224, 0.95) 0%, rgba(255, 255, 255, 0.95) 100%);
}

.detection-disease {
  border-left-color: #C62828;
  background: linear-gradient(135deg, rgba(255, 235, 238, 0.95) 0%, rgba(255, 255, 255, 0.95) 100%);
}

.detection-healthy {
  border-left-color: #2E7D32;
  background: linear-gradient(135deg, rgba(232, 245, 233, 0.95) 0%, rgba(255, 255, 255, 0.95) 100%);
}

.detection-label {
  font-weight: 600;
  margin-bottom: 4px;
  color: #2c3e50;
}

.detection-confidence {
  font-size: 12px;
  color: #666;
}

/* 右侧控制卡片 */
.control-panel {
  height: calc(100vh - 260px);
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  border: none;
  transition: all 0.3s ease;
  z-index: 1;
}

.control-panel:hover {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}

.control-panel >>> .el-card__header {
  background: linear-gradient(135deg, #5D4037 0%, #8D6E63 100%);
  color: white;
  padding: 16px 22px;
  border-bottom: none;
  border-radius: 16px 16px 0 0;
}

.control-panel >>> .el-card__body {
  padding: 22px;
  background: #ffffff;
  height: calc(100% - 56px);
  overflow-y: auto;
  box-sizing: border-box;
}

.count-badge {
  display: inline-block;
  padding: 4px 10px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  font-size: 12px;
  color: white;
}

.recent-results {
  height: 100%;
  overflow-y: auto;
}

.result-item {
  background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
  border-radius: 12px;
  padding: 14px 16px;
  margin-bottom: 12px;
  border-left: 4px solid #2E7D32;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  cursor: pointer;
}

.result-item:hover {
  transform: translateX(4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.result-pest {
  border-left-color: #E65100;
  background: linear-gradient(135deg, #FFF8E1 0%, #ffffff 100%);
}

.result-pest:hover {
  background: linear-gradient(135deg, #FFF3E0 0%, #ffffff 100%);
}

.result-disease {
  border-left-color: #C62828;
  background: linear-gradient(135deg, #FFEBEE 0%, #ffffff 100%);
}

.result-disease:hover {
  background: linear-gradient(135deg, #FFCDD2 0%, #ffffff 100%);
}

.result-healthy {
  border-left-color: #2E7D32;
  background: linear-gradient(135deg, #E8F5E9 0%, #ffffff 100%);
}

.result-healthy:hover {
  background: linear-gradient(135deg, #C8E6C9 0%, #ffffff 100%);
}

.result-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 6px;
}

.result-type {
  font-weight: 600;
  font-size: 13px;
  color: #2c3e50;
}

.result-confidence {
  font-size: 12px;
  color: #666;
  background: #f5f5f5;
  padding: 2px 8px;
  border-radius: 10px;
}

.result-name {
  font-weight: 600;
  margin-bottom: 4px;
  color: #2c3e50;
}

.result-time {
  font-size: 12px;
  color: #999;
}

.no-results {
  text-align: center;
  color: #999;
  padding: 40px 20px;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border-radius: 12px;
  border: 2px dashed #e0e0e0;
}

.no-results i {
  font-size: 48px;
  margin-bottom: 12px;
  opacity: 0.4;
  color: #bdbdbd;
}

/* 识别结果提示框样式 */
.pest-detection-dialog >>> .el-dialog {
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 24px 60px rgba(198, 40, 40, 0.35);
}

.pest-detection-dialog >>> .el-dialog__header {
  display: none;
}

.pest-detection-dialog >>> .el-dialog__body {
  padding: 0;
  background: linear-gradient(135deg, #E65100 0%, #FF6D00 100%);
}

.pest-detection-content {
  text-align: center;
  padding: 52px 40px 48px;
  color: white;
  position: relative;
  overflow: hidden;
}

.pest-detection-content::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.12) 0%, transparent 70%);
  animation: rotate-bg 20s linear infinite;
}

.detection-icon {
  font-size: 110px;
  margin-bottom: 26px;
  animation: dialog-pulse 2s ease-in-out infinite;
  position: relative;
  z-index: 1;
}

.detection-icon i {
  color: rgba(255, 255, 255, 0.96);
  text-shadow: 0 0 30px rgba(255, 255, 255, 0.5);
}

.detection-title {
  font-size: 32px;
  font-weight: 700;
  margin: 0 0 24px 0;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.25);
  position: relative;
  z-index: 1;
}

.detection-details {
  margin: 24px 0;
  padding: 18px 20px;
  background: rgba(255, 255, 255, 0.16);
  border-radius: 14px;
  backdrop-filter: blur(10px);
  position: relative;
  z-index: 1;
}

.detail-row {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin: 10px 0;
  font-size: 17px;
  color: rgba(255, 255, 255, 0.96);
}

.detail-row i {
  font-size: 18px;
}

.recommendation-section {
  margin: 24px 0 32px;
  padding: 22px 24px;
  background: rgba(255, 255, 255, 0.22);
  border-radius: 14px;
  backdrop-filter: blur(12px);
  position: relative;
  z-index: 1;
}

.recommendation-title {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  font-size: 22px;
  font-weight: 700;
  margin: 0 0 14px 0;
  color: rgba(255, 255, 255, 0.97);
}

.recommendation-title i {
  font-size: 24px;
}

.recommendation-text {
  font-size: 17px;
  line-height: 1.8;
  margin: 0;
  color: rgba(255, 255, 255, 0.97);
}

.detection-actions {
  display: flex;
  justify-content: center;
  gap: 18px;
  position: relative;
  z-index: 1;
}

.confirm-btn {
  background: white !important;
  color: #E65100 !important;
  border: none !important;
  border-radius: 28px !important;
  padding: 13px 38px !important;
  font-size: 16px !important;
  font-weight: 600 !important;
  transition: all 0.3s ease !important;
  box-shadow: 0 6px 24px rgba(0, 0, 0, 0.25) !important;
}

.confirm-btn:hover {
  transform: translateY(-3px) !important;
  box-shadow: 0 10px 32px rgba(0, 0, 0, 0.3) !important;
  background: #f8f9fa !important;
}

.confirm-btn i {
  margin-right: 6px;
  font-size: 16px;
}

@keyframes dialog-pulse {
  0%, 100% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.06);
    opacity: 0.92;
  }
}

@keyframes rotate-bg {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* 全屏遮罩样式 */
.pest-detection-dialog >>> .el-dialog__wrapper {
  background-color: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(5px);
}

/* 间距 */
.mb20 {
  margin-bottom: 24px;
  position: relative;
  z-index: 1;
}

.mb20:last-of-type {
  margin-bottom: 0;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .el-col-16 {
    width: 100%;
    margin-bottom: 20px;
  }
  
  .el-col-8 {
    width: 100%;
  }

  .realtime-detection-container {
    padding: 16px;
  }

  .stat-card {
    margin-bottom: 16px;
  }

  .video-card,
  .control-panel {
    height: 420px;
  }
}
</style>
