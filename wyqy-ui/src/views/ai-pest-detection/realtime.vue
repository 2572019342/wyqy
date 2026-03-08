<template>
  <div class="realtime-detection-container" tabindex="0">
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
          <div class="stat-decoration"></div>-
        </div>
      </el-col>
    </el-row>

    <!-- AI识别主界面 -->
    <el-row :gutter="20" class="mb20">
      <el-col :span="24">
        <el-row :gutter="20" class="dual-video-row">
          <el-col :span="12">
            <el-card class="video-card video-card--drone">
              <div slot="header" class="card-header">
                <div class="header-title">
                  <i class="el-icon-video-camera"></i>
                  <span>实时监控</span>
                </div>
                <div class="header-status">
                  <span class="status-tag" :class="'status-' + aiStatus.type">{{ aiStatus.text }}</span>
                </div>
              </div>
              <div class="video-container">
                <div class="video-wrapper">
                  <iframe
                    :src="droneVideoStreamUrl"
                    class="video-stream"
                    @error="handleVideoError('drone')"
                    @load="handleVideoLoad('drone')"
                    frameborder="0"
                    allowfullscreen
                  ></iframe>
                  <div class="video-overlay" v-if="!droneVideoConnected">
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

          <el-col :span="12">
            <el-card class="video-card video-card--car">
              <div slot="header" class="card-header">
                <div class="header-title">
                  <i class="el-icon-video-camera"></i>
                  <span>小车出行</span>
                </div>
                <div class="header-status">
                  <span class="status-tag" :class="'status-' + carVideoStatus.type">{{ carVideoStatus.text }}</span>
                </div>
              </div>
              <div class="video-container">
                <div class="video-wrapper">
                  <iframe
                    :src="carVideoStreamUrl"
                    class="video-stream"
                    @error="handleVideoError('car')"
                    @load="handleVideoLoad('car')"
                    frameborder="0"
                    allowfullscreen
                  ></iframe>
                  <div class="video-overlay" v-if="!carVideoConnected">
                    <div class="loading-spinner">
                      <i class="el-icon-loading"></i>
                      <p>正在连接视频流...</p>
                    </div>
                  </div>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </el-col>
    </el-row>

    <el-row :gutter="20" class="mb20">
      <el-col :span="24">
        <el-card class="control-panel control-panel--bottom">
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

    <!-- openclaw 智能分析聊天框（结构、样式、内容与种植页聊天框完全一致） -->
    <div class="ai-assistant">
      <div class="assistant-toggle" @click="toggleOpenclawPanel">
        <img src="/photo/picture.png" alt="AI助手" class="assistant-icon" />
      </div>
      <transition name="assistant-scale">
        <div
          v-if="openclawTaskVisible"
          class="assistant-panel openclaw-panel"
          @mousedown.stop
        >
          <div class="assistant-header">
            <span class="assistant-title">openclaw 智能分析</span>
            <i class="el-icon-close assistant-close" @click.stop="closeOpenclawPanel"></i>
          </div>
          <div ref="openclawBody" class="assistant-body">
            <div
              v-for="(msg, index) in openclawMessages"
              :key="index"
              class="assistant-message"
              :class="'assistant-message--' + msg.role"
            >
              <span class="assistant-message-role">
                <img
                  :src="msg.role === 'user' ? '/photo/profile.jpg' : '/photo/picture.png'"
                  :alt="msg.role === 'user' ? '我' : '助手'"
                  class="assistant-message-avatar"
                />
              </span>
              <span class="assistant-message-content">{{ msg.content }}</span>
            </div>
            <div v-if="openclawMessages.length === 0" class="assistant-empty">
              我可以帮助您完成您想要的操作11
            </div>
          </div>
          <div class="assistant-footer">
            <el-input
              v-model="assistantInput"
              type="textarea"
              :rows="2"
              placeholder="请输入要咨询的问题，按 Enter 发送"
              disabled
            />
            <el-button type="primary" size="mini" class="assistant-send" disabled>
              发送
            </el-button>
          </div>
          <div class="assistant-resizer assistant-resizer-se"></div>
          <div class="assistant-resizer assistant-resizer-sw"></div>
          <div class="assistant-resizer assistant-resizer-ne"></div>
          <div class="assistant-resizer assistant-resizer-nw"></div>
        </div>
      </transition>
    </div>

    <!-- Ctrl+2 弹出的 AI 聊天框（窗口形式，可自由拖拽改变大小） -->
    <el-dialog
      ref="aiChatDialogRef"
      :visible.sync="aiChatDialogVisible"
      :title="''"
      :show-close="false"
      :width="aiChatWidth + 'px'"
      top="5vh"
      append-to-body
      custom-class="ai-chat-dialog ai-chat-dialog-window"
      modal-class="ai-chat-modal"
      :close-on-click-modal="false"
      @open="onAiChatDialogOpen"
      @close="onAiChatDialogClose"
    >
      <div class="ai-chat-dialog-body">
        <!-- 透明拖拽区：不显示白条，但可拖动窗口 -->
        <div
          class="ai-chat-drag-area"
          @mousedown.prevent="startAiChatDrag"
        ></div>
        <span class="ai-chat-close" @click="aiChatDialogVisible = false" title="关闭">
          <i class="el-icon-close"></i>
        </span>
        <iframe
          v-if="aiChatIframeUrl"
          :src="aiChatIframeUrl"
          class="ai-chat-iframe"
          frameborder="0"
        />
      </div>
      <div
        class="ai-chat-resize-handle"
        @mousedown.prevent="startAiChatResize"
      ></div>
    </el-dialog>

    <!-- Ctrl+4 完成提示（屏幕中间强提示） -->
    <transition name="ai-complete-pop">
      <div
        v-if="aiCompleteToastVisible"
        class="ai-complete-toast-mask"
        @click="aiCompleteToastVisible = false"
      >
        <div class="ai-complete-toast" @click.stop>
          <img class="ai-complete-toast__icon" src="/photo/picture.png" alt="AI" />
          <div class="ai-complete-toast__text">处理已完成，我将保持病虫害的实时识别</div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import { detectPest, getVideoStream, getDetectionStats, listAiPestDetection } from "@/api/agriculture/ai-pest-detection";
import { listLand } from "@/api/agriculture/land";
import { listCropSpecies } from "@/api/agriculture/crop";
import { listPlanting, getPlanting, updatePlanting } from "@/api/agriculture/planting";
import request from "@/utils/request";
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
      droneVideoStreamUrl: "http://192.168.1.103:1145/play_drone.html",
      carVideoStreamUrl: "http://192.168.1.103:1145/play_car.html",
      droneVideoConnected: false,
      carVideoConnected: false,
      carVideoStatus: {
        type: 'info',
        text: '未连接'
      },
      // 机器人运行状态
      robotRunning: false,
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
      refreshTimer: null,
      // openclaw 智能分析聊天框（与种植页聊天框数据结构一致）
      openclawTaskVisible: false,
      openclawTaskText: 'AI 已触发报警工单，请注意查看。',
      openclawTaskTimer: null,
      openclawMessages: [],
      assistantInput: '',
      // Ctrl+2 弹出的 AI 聊天框（窗口形式，可调整大小）
      aiChatDialogVisible: false,
      aiChatIframeUrl: process.env.VUE_APP_AI_CHAT_URL || 'http://localhost:3000',
      aiChatWidth: 900,
      aiChatHeight: 560,
      aiChatLeft: null,
      aiChatTop: null,
      aiChatResizing: false,
      aiChatResizeStart: null,
      aiChatDragging: false,
      aiChatDragStart: null,
      // Ctrl+4 中间提示
      aiCompleteToastVisible: false,
      aiCompleteToastTimer: null
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
    // 全局监听 Ctrl+2 / Ctrl+6，不依赖容器焦点
    document.addEventListener('keydown', this.handleKeyDown);
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
    document.removeEventListener('keydown', this.handleKeyDown);
    // 清理定时器
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer);
    }
    if (this.openclawTaskTimer) {
      clearTimeout(this.openclawTaskTimer);
    }
    if (this.aiCompleteToastTimer) {
      clearTimeout(this.aiCompleteToastTimer);
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
      this.droneVideoConnected = true;
      this.carVideoConnected = true;
      this.aiStatus = { type: 'success', text: '已连接' };
      this.carVideoStatus = { type: 'success', text: '已连接' };
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
    // 前端触发后端运行 robot.py
    async runRobot() {
      if (this.robotRunning) {
        return;
      }
      this.robotRunning = true;
      try {
        const res = await request({
          url: '/robot/run',
          method: 'post'
        });
        if (!(res && (res.code === 200 || res.success))) {
          // 保留日志，避免打扰用户界面
          console.error((res && res.msg) || '机器人任务启动失败');
        }
      } catch (e) {
        // 保留错误日志，避免弹出提示
        console.error('机器人任务启动失败', e);
      } finally {
        this.robotRunning = false;
      }
    },
    // 刷新视频
    refreshVideo() {
      this.droneVideoConnected = false;
      this.carVideoConnected = false;
      this.aiStatus = { type: 'info', text: '重新连接中...' };
      this.carVideoStatus = { type: 'info', text: '重新连接中...' };
      // 强制刷新iframe
      const iframes = document.querySelectorAll('.video-stream');
      if (iframes && iframes.length) {
        iframes.forEach(iframe => {
          iframe.src = iframe.src;
        });
      }
      setTimeout(() => {
        this.checkVideoConnection();
      }, 1000);
    },
    // 处理视频错误
    handleVideoError(type) {
      if (type === 'car') {
        this.carVideoConnected = false;
        this.carVideoStatus = { type: 'danger', text: '连接失败' };
        return;
      }
      this.droneVideoConnected = false;
      this.aiStatus = { type: 'danger', text: '连接失败' };
    },
    // 处理视频加载
    handleVideoLoad(type) {
      if (type === 'car') {
        this.carVideoConnected = true;
        this.carVideoStatus = { type: 'success', text: '已连接' };
        return;
      }
      this.droneVideoConnected = true;
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

      const isCtrlOrMeta = event.ctrlKey || event.metaKey;
      const isKey6 = event.key === '6' || event.code === 'Digit6';
      const isKey2 = event.key === '2' || event.code === 'Digit2';
      const isKey4 = event.key === '4' || event.code === 'Digit4';

      // Ctrl+2：弹出 AI 聊天框（显示 @聊天框 内容）
      if (isCtrlOrMeta && isKey2) {
        event.preventDefault();
        this.aiChatDialogVisible = true;
        return;
      }

      // Ctrl+4：关闭聊天窗口，并提示处理完成
      if (isCtrlOrMeta && isKey4) {
        event.preventDefault();
        this.aiChatDialogVisible = false;
        this.showAiChatCompletedToast();
        return;
      }

      // Ctrl+6：启动机器人
      if (isCtrlOrMeta && isKey6) {
        event.preventDefault();
        this.runRobot();
      }
    },
    showAiChatCompletedToast() {
      this.aiCompleteToastVisible = true;
      if (this.aiCompleteToastTimer) clearTimeout(this.aiCompleteToastTimer);
      this.aiCompleteToastTimer = setTimeout(() => {
        this.aiCompleteToastVisible = false;
      }, 2200);
    },
    // AI 聊天框打开时应用尺寸与位置（首次居中）
    onAiChatDialogOpen() {
      if (this.aiChatLeft == null || this.aiChatTop == null) {
        const pad = 24;
        this.aiChatLeft = Math.max(pad, (window.innerWidth - this.aiChatWidth) / 2);
        this.aiChatTop = Math.max(pad, (window.innerHeight - this.aiChatHeight) / 2 - 20);
      }
      this.$nextTick(() => {
        this.applyAiChatDialogSize(true);
        // 发送暂停消息到iframe
        this.sendPauseMessageToIframe();
      });
    },
    // AI 聊天框关闭时的处理
    onAiChatDialogClose() {
      this.aiChatDialogVisible = false;
      // 发送恢复消息到iframe
      this.sendResumeMessageToIframe();
    },
    applyAiChatDialogSize(forceQuery = false) {
      if (!this.aiChatDialogVisible) return;
      if (forceQuery || !this._aiChatDialogEl) {
        this._aiChatDialogEl = document.querySelector('.ai-chat-dialog.ai-chat-dialog-window');
      }
      const el = this._aiChatDialogEl;
      if (!el) return;

      // 拖拽/缩放中关闭过渡，避免“回弹/拖影”
      if (this.aiChatDragging || this.aiChatResizing) {
        el.classList.add('is-interacting');
      } else {
        el.classList.remove('is-interacting');
      }

      el.style.position = 'fixed';
      el.style.left = this.aiChatLeft + 'px';
      el.style.top = this.aiChatTop + 'px';
      el.style.transform = 'none';
      el.style.margin = '0';
      el.style.width = this.aiChatWidth + 'px';
      el.style.height = this.aiChatHeight + 'px';
    },
    sendPauseMessageToIframe() {
      this.$nextTick(() => {
        const iframe = document.querySelector('.ai-chat-iframe');
        if (iframe && iframe.contentWindow) {
          try {
            iframe.contentWindow.postMessage({ type: 'PAUSE_VIDEO' }, '*');
          } catch (e) {
            console.log('无法发送暂停消息到iframe:', e);
          }
        }
      });
    },
    sendResumeMessageToIframe() {
      const iframe = document.querySelector('.ai-chat-iframe');
      if (iframe && iframe.contentWindow) {
        try {
          iframe.contentWindow.postMessage({ type: 'RESUME_VIDEO' }, '*');
        } catch (e) {
          console.log('无法发送恢复消息到iframe:', e);
        }
      }
    },
    startAiChatDrag(e) {
      if (this.aiChatResizing) return;
      this.applyAiChatDialogSize();
      this.aiChatDragging = true;
      this.aiChatDragStart = {
        x: e.clientX,
        y: e.clientY,
        left: this.aiChatLeft,
        top: this.aiChatTop
      };
      document.addEventListener('mousemove', this.doAiChatDrag);
      document.addEventListener('mouseup', this.stopAiChatDrag);
    },
    doAiChatDrag(e) {
      if (!this.aiChatDragging || !this.aiChatDragStart) return;
      let left = this.aiChatDragStart.left + (e.clientX - this.aiChatDragStart.x);
      let top = this.aiChatDragStart.top + (e.clientY - this.aiChatDragStart.y);
      // 限制在视口内至少露出一部分
      const pad = 40;
      left = Math.max(-this.aiChatWidth + pad, Math.min(left, window.innerWidth - pad));
      top = Math.max(-this.aiChatHeight + pad, Math.min(top, window.innerHeight - pad));
      this.aiChatLeft = Math.round(left);
      this.aiChatTop = Math.round(top);
      this.applyAiChatDialogSize();
    },
    stopAiChatDrag() {
      this.aiChatDragging = false;
      this.aiChatDragStart = null;
      document.removeEventListener('mousemove', this.doAiChatDrag);
      document.removeEventListener('mouseup', this.stopAiChatDrag);
    },
    startAiChatResize(e) {
      this.aiChatResizing = true;
      this.applyAiChatDialogSize();
      this.aiChatResizeStart = {
        x: e.clientX,
        y: e.clientY,
        w: this.aiChatWidth,
        h: this.aiChatHeight
      };
      document.addEventListener('mousemove', this.doAiChatResize);
      document.addEventListener('mouseup', this.stopAiChatResize);
    },
    doAiChatResize(e) {
      if (!this.aiChatResizing || !this.aiChatResizeStart) return;
      const minW = 400;
      const minH = 300;
      let w = this.aiChatResizeStart.w + (e.clientX - this.aiChatResizeStart.x);
      let h = this.aiChatResizeStart.h + (e.clientY - this.aiChatResizeStart.y);
      this.aiChatWidth = Math.max(minW, Math.round(w));
      this.aiChatHeight = Math.max(minH, Math.round(h));
      this.applyAiChatDialogSize();
    },
    stopAiChatResize() {
      this.aiChatResizing = false;
      this.aiChatResizeStart = null;
      document.removeEventListener('mousemove', this.doAiChatResize);
      document.removeEventListener('mouseup', this.stopAiChatResize);
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

          // 打开 openclaw 风格的报警工单弹窗
          const result = this.detectionResult || {};
          const typeText = this.getDetectionTypeText(result.detectionType || 'pest');
          const pestName = result.pestName || '未知病虫害';
          const baseMessage = result.message || `检测到${typeText}：${pestName}`;
          const recommendation = result.recommendation ? `处理建议：${result.recommendation}` : '';
          this.showOpenclawTaskCard(
            recommendation ? `${baseMessage}，${recommendation}` : baseMessage
          );
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
    // 显示 openclaw 报警工单弹窗（模拟 AI 多步思考 + 填写完整工单）
    showOpenclawTaskCard(message) {
      this.openclawTaskText = message || 'AI 已触发报警工单，请注意查看。';
      this.openclawTaskVisible = true;
      if (this.openclawTaskTimer) {
        clearTimeout(this.openclawTaskTimer);
      }
      // 重置消息列表（与种植页聊天框一致：{ role, content }）
      this.openclawMessages = [];

      // 基于当前页面已有信息，构造一个“AI 结构化思考 + 正常聊天式”示例输出（纯前端文案模拟）
      let landName = typeof this.getSelectedLandName === 'function' ? this.getSelectedLandName() : '';
      if (!landName || landName === '未知地块') {
        landName = '示范田块A1';
      }
      let speciesName = typeof this.getSelectedSpeciesName === 'function' ? this.getSelectedSpeciesName() : '';
      if (!speciesName || speciesName === '未知作物') {
        speciesName = '水稻';
      }

      const dr = this.detectionResult || {};
      const detectionTypeText = typeof this.getDetectionTypeText === 'function'
        ? this.getDetectionTypeText(dr.detectionType || 'pest')
        : '虫害';
      const pestName = dr.pestName || (speciesName.indexOf('稻') !== -1 ? '稻飞虱' : '蚜虫');
      const confidence = typeof dr.confidence === 'number' ? dr.confidence : 0.82;
      let severity = '轻度';
      if (confidence >= 0.85) {
        severity = '重度';
      } else if (confidence >= 0.6) {
        severity = '中度';
      }

      const now = new Date();
      const y = now.getFullYear();
      const m = String(now.getMonth() + 1).padStart(2, '0');
      const d = String(now.getDate()).padStart(2, '0');
      const rnd = String(Math.floor(1000 + Math.random() * 9000));
      const orderId = `${y}${m}${d}${rnd}`;
      const execTime = '立即执行';

      // 定义每一步的“核心结论 → 模块拆解”文案（全部字段已填好，不需要用户再修改）
      const stepMessages = [
        // 核心结论：先给出本次识别与处理的总体结果
        `【核心结论】已在“${landName}”的“${speciesName}”上检测到${detectionTypeText}“${pestName}”，当前风险评估为${severity}，环境与设备条件满足作业要求，推荐立即调度作业车 Car-01 使用吡虫啉进行精准喷洒，本次任务具备可执行性。`,

        // 模块一：图像与病虫害研判
        `【模块一：图像研判】思考：当前框选区域是否为真实病虫害、属于哪一类以及轻中重程度。操作：对前端传入的图像与框选坐标进行特征比对，自动排除杂草、石块、枯叶等非病虫害目标，并结合“${speciesName}”的叶片纹理和病斑特征进行识别。输出：确认目标为${detectionTypeText}“${pestName}”，置信度约为 ${(confidence * 100).toFixed(1)}%，综合样本分布与受灾范围，将本次病虫害评估为${severity}风险，需要进入处理与调度环节。`,

        // 模块二：多源信息查询验证
        `【模块二：信息查询】思考：初步处理方案是否合理、可执行。操作：从病虫害数据库中查询“${pestName}”在“${speciesName}”上的高发阶段、典型症状与推荐药剂，得到示例方案：使用吡虫啉药剂，推荐稀释比例约 1:1000；从地块档案中读取“${landName}”的土壤类型为中性壤土且近 7 天无打药记录；从智能作业车数据库中检索到作业车 Car-01 当前空闲，已挂载农药喷洒模块且药剂余量充足；环境数据库显示当前风力 2 级、无降雨，适合开展喷洒作业。输出：验证初步方案在安全性、可行性和设备资源上均满足要求，可作为本次处理的执行方案。`,

        // 模块三：删除无效信息 + 给出最终任务描述（非工单格式，而是自然语言总结）
        `【模块三：清理与输出】思考：哪些数据和指令是无效或不可执行，需要剔除。操作：清除 1 个被识别为误检的框选目标，过滤掉忙碌或无喷洒模块的作业车记录，并删除在当前天气条件下无法立即执行的候选指令，仅保留“有效病虫害框选区域 + 可调度作业车 Car-01 + 执行时间 ${execTime}”这一组合。输出：为本次任务总结出一条清晰可执行的处理描述——在“${landName}”中由 Car-01 对“${speciesName}”上确认的“${pestName}”病虫害区域进行吡虫啉 1:1000 比例的精准喷洒作业，覆盖全部有效框选区域，作业完成后需回传执行结果，当前无需用户再补充任何信息即可直接执行。`
      ];

      const stepInterval = 2200;
      const lastIndex = stepMessages.length - 1;

      const runStep = (index) => {
        this.openclawMessages.push({ role: 'assistant', content: stepMessages[index] });
        this.$nextTick(() => {
          const el = this.$refs.openclawBody;
          if (el) el.scrollTop = el.scrollHeight;
        });
        if (index < lastIndex) {
          this.openclawTaskTimer = setTimeout(() => {
            runStep(index + 1);
          }, stepInterval);
        } else {
          // 最后一步展示完成后再停留一会儿自动收起
          this.openclawTaskTimer = setTimeout(() => {
            this.openclawTaskVisible = false;
            this.openclawTaskTimer = null;
          }, 4000);
        }
      };

      runStep(0);
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
      // 统一为清新绿色系
      if (confidence >= 0.8) return '#3e7f6a';
      if (confidence >= 0.6) return '#5ca996';
      return '#b7ded2';
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
    },
    toggleOpenclawPanel() {
      this.openclawTaskVisible = !this.openclawTaskVisible;
      if (!this.openclawTaskVisible && this.openclawTaskTimer) {
        clearTimeout(this.openclawTaskTimer);
        this.openclawTaskTimer = null;
      }
    },
    closeOpenclawPanel() {
      this.openclawTaskVisible = false;
      if (this.openclawTaskTimer) {
        clearTimeout(this.openclawTaskTimer);
        this.openclawTaskTimer = null;
      }
    }
  }
};
</script>

<style scoped>
.realtime-detection-container {
  /* 主题色（清新绿色系） */
  --wyqy-c1: #059669;   /* 深主色 */
  --wyqy-c2: #10B981;   /* 主色 */
  --wyqy-c3: #34D399;   /* 浅主色 */
  --wyqy-c4: #6EE7B7;   /* 更浅主色 */
  --wyqy-c5: #ECFDF5;   /* 最浅背景 */
  --wyqy-surface: #ffffff;
  --wyqy-text: #111827;
  --wyqy-text-muted: #6b7280;
  --wyqy-shadow: rgba(5, 150, 105, 0.18);

  padding: 24px;
  background: linear-gradient(
    135deg,
    var(--wyqy-c5) 0%,
    rgba(110, 231, 183, 0.22) 50%,
    rgba(52, 211, 153, 0.08) 100%
  );
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
  background: linear-gradient(135deg, rgba(110, 231, 183, 0.16) 0%, rgba(236, 253, 245, 0.12) 100%);
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
  background: linear-gradient(135deg, var(--wyqy-c1) 0%, var(--wyqy-c2) 100%);
  box-shadow: 0 8px 24px rgba(5, 150, 105, 0.26);
}

.stat-card-0:hover {
  box-shadow: 0 16px 36px rgba(5, 150, 105, 0.34);
}

.stat-card-1 {
  background: linear-gradient(135deg, var(--wyqy-c2) 0%, var(--wyqy-c3) 100%);
  box-shadow: 0 8px 24px rgba(16, 185, 129, 0.26);
}

.stat-card-1:hover {
  box-shadow: 0 16px 36px rgba(16, 185, 129, 0.34);
}

.stat-card-2 {
  background: linear-gradient(135deg, var(--wyqy-c1) 0%, var(--wyqy-c3) 100%);
  box-shadow: 0 8px 24px rgba(5, 150, 105, 0.24);
}

.stat-card-2:hover {
  box-shadow: 0 16px 36px rgba(5, 150, 105, 0.32);
}

.stat-card-3 {
  background: linear-gradient(135deg, var(--wyqy-c3) 0%, var(--wyqy-c2) 100%);
  box-shadow: 0 8px 24px rgba(52, 211, 153, 0.22);
}

.stat-card-3:hover {
  box-shadow: 0 16px 36px rgba(52, 211, 153, 0.30);
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
.dual-video-row {
  height: 62vh;
  min-height: 420px;
  display: flex;
  flex-wrap: nowrap;
}

.dual-video-row >>> .el-col {
  display: flex;
}

.dual-video-row .video-card {
  flex: 1;
  height: 100%;
}

.video-card {
  height: 100%;
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
  background: linear-gradient(135deg, var(--wyqy-c1) 0%, var(--wyqy-c2) 100%);
  color: white;
  padding: 18px 24px;
  border-bottom: none;
}

.video-card >>> .el-card__body {
  padding: 16px;
  background: var(--wyqy-surface);
  height: calc(100% - 60px);
  box-sizing: border-box;
}

.video-card--drone >>> .el-card__header {
  background: linear-gradient(135deg, var(--wyqy-c1) 0%, var(--wyqy-c2) 100%);
}

.video-card--car >>> .el-card__header {
  background: linear-gradient(135deg, var(--wyqy-c3) 0%, var(--wyqy-c2) 100%);
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
  background: rgba(255, 255, 255, 0.18);
  color: rgba(255, 255, 255, 0.96);
  border: 1px solid rgba(255, 255, 255, 0.22);
}

.status-tag.status-success {
  background: rgba(255, 255, 255, 0.18);
  color: rgba(255, 255, 255, 0.96);
}

.status-tag.status-warning {
  background: rgba(255, 255, 255, 0.18);
  color: rgba(255, 255, 255, 0.96);
}

.status-tag.status-info {
  background: rgba(255, 255, 255, 0.18);
  color: rgba(255, 255, 255, 0.96);
}

.status-tag.status-danger {
  background: rgba(255, 255, 255, 0.18);
  color: rgba(255, 255, 255, 0.96);
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
  color: var(--wyqy-c3);
}

.ai-indicator {
  position: absolute;
  top: 20px;
  left: 20px;
  background: linear-gradient(135deg, var(--wyqy-c2) 0%, var(--wyqy-c3) 100%);
  color: white;
  padding: 10px 16px;
  border-radius: 24px;
  display: flex;
  align-items: center;
  animation: ai-pulse 1.5s infinite;
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.30);
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
  border-left: 4px solid var(--wyqy-c2);
  box-shadow: 0 4px 16px rgba(0,0,0,0.15);
  min-width: 220px;
  backdrop-filter: blur(10px);
}

.detection-pest {
  border-left-color: var(--wyqy-c3);
  background: linear-gradient(135deg, rgba(236, 253, 245, 0.95) 0%, rgba(255, 255, 255, 0.95) 100%);
}

.detection-disease {
  border-left-color: var(--wyqy-c1);
  background: linear-gradient(135deg, rgba(52, 211, 153, 0.20) 0%, rgba(255, 255, 255, 0.95) 100%);
}

.detection-healthy {
  border-left-color: var(--wyqy-c2);
  background: linear-gradient(135deg, rgba(110, 231, 183, 0.24) 0%, rgba(255, 255, 255, 0.95) 100%);
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
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  border: none;
  transition: all 0.3s ease;
  z-index: 1;
}

.control-panel--bottom {
  height: 32vh;
  min-height: 280px;
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
  background: linear-gradient(135deg, var(--wyqy-c1) 0%, var(--wyqy-c2) 100%);
  color: white;
  padding: 16px 22px;
  border-bottom: none;
  border-radius: 16px 16px 0 0;
}

.control-panel >>> .el-card__body {
  padding: 22px;
  background: var(--wyqy-surface);
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
  background: linear-gradient(135deg, #ffffff 0%, #f4f7f6 100%);
  border-radius: 12px;
  padding: 14px 16px;
  margin-bottom: 12px;
  border-left: 4px solid var(--wyqy-c2);
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  cursor: pointer;
}

.result-item:hover {
  transform: translateX(4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.result-pest {
  border-left-color: var(--wyqy-c3);
  background: linear-gradient(135deg, rgba(236, 253, 245, 0.95) 0%, #ffffff 100%);
}

.result-pest:hover {
  background: linear-gradient(135deg, rgba(110, 231, 183, 0.24) 0%, #ffffff 100%);
}

.result-disease {
  border-left-color: var(--wyqy-c1);
  background: linear-gradient(135deg, rgba(5, 150, 105, 0.18) 0%, #ffffff 100%);
}

.result-disease:hover {
  background: linear-gradient(135deg, rgba(5, 150, 105, 0.24) 0%, #ffffff 100%);
}

.result-healthy {
  border-left-color: var(--wyqy-c2);
  background: linear-gradient(135deg, rgba(236, 253, 245, 0.95) 0%, #ffffff 100%);
}

.result-healthy:hover {
  background: linear-gradient(135deg, rgba(110, 231, 183, 0.24) 0%, #ffffff 100%);
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
  background: rgba(241, 241, 254, 0.9);
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
  background: linear-gradient(135deg, rgba(236, 253, 245, 0.95) 0%, #ffffff 100%);
  border-radius: 12px;
  border: 2px dashed rgba(52, 211, 153, 0.75);
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
  box-shadow: 0 24px 60px rgba(5, 150, 105, 0.26);
}

.pest-detection-dialog >>> .el-dialog__header {
  display: none;
}

.pest-detection-dialog >>> .el-dialog__body {
  padding: 0;
  background: linear-gradient(135deg, var(--wyqy-c1) 0%, var(--wyqy-c3) 100%);
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
  color: var(--wyqy-c1) !important;
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

/* openclaw 智能分析聊天框（与种植页聊天框样式、内容完全一致） */
.ai-assistant {
  position: fixed;
  right: 24px;
  bottom: 96px;
  z-index: 1100;
}

.assistant-toggle {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: linear-gradient(145deg, #ffffff 0%, var(--wyqy-c5) 100%);
  box-shadow: 0 8px 24px rgba(5, 150, 105, 0.22), 0 2px 8px rgba(0, 0, 0, 0.08);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  overflow: hidden;
  transition: transform 0.25s ease, box-shadow 0.25s ease;
  border: 2px solid rgba(52, 211, 153, 0.7);
}

.assistant-toggle:hover {
  transform: translateY(-3px) scale(1.05);
  box-shadow: 0 12px 32px rgba(5, 150, 105, 0.28);
}

.assistant-icon {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.openclaw-panel {
  position: fixed;
  right: 24px;
  bottom: 164px;
  left: auto;
  top: auto;
  z-index: 1300;
}

.assistant-panel {
  width: 360px;
  max-height: 540px;
  background: #ffffff;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(15, 23, 42, 0.16), 0 0 0 1px rgba(52, 211, 153, 0.18);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  backdrop-filter: blur(10px);
}

.assistant-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 18px;
  background: linear-gradient(135deg, var(--wyqy-c1) 0%, var(--wyqy-c2) 55%, var(--wyqy-c3) 100%);
  color: #ffffff;
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.30);
}

.assistant-title {
  font-size: 15px;
  font-weight: 700;
  letter-spacing: 0.03em;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.assistant-close {
  cursor: pointer;
  font-size: 18px;
  opacity: 0.9;
  padding: 4px;
  border-radius: 8px;
  transition: background 0.2s, opacity 0.2s;
}

.assistant-close:hover {
  background: rgba(255, 255, 255, 0.2);
  opacity: 1;
}

.assistant-body {
  padding: 16px;
  background: linear-gradient(180deg, var(--wyqy-c5) 0%, rgba(110, 231, 183, 0.22) 35%, #ffffff 100%);
  overflow-y: auto;
  flex: 1;
  min-height: 180px;
}

.assistant-message {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  margin-bottom: 14px;
  font-size: 14px;
  width: 100%;
  animation: msgFadeIn 0.35s ease-out;
}

@keyframes msgFadeIn {
  from {
    opacity: 0;
    transform: translateY(6px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.assistant-message-role {
  flex-shrink: 0;
}

.assistant-message-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  object-fit: cover;
  display: block;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
  border: 2px solid rgba(255, 255, 255, 0.9);
}

.assistant-message-content {
  padding: 10px 14px;
  border-radius: 16px;
  max-width: 260px;
  line-height: 1.6;
  font-size: 14px;
  font-weight: 500;
  letter-spacing: 0.02em;
  word-break: break-word;
  white-space: pre-wrap;
}

.assistant-message--user {
  justify-content: flex-end;
}

.assistant-message--user .assistant-message-content {
  background: linear-gradient(135deg, var(--wyqy-c2) 0%, var(--wyqy-c3) 100%);
  color: #ffffff;
  border-bottom-right-radius: 4px;
  box-shadow: 0 2px 12px rgba(16, 185, 129, 0.28);
}

.assistant-message--user .assistant-message-content {
  order: 1;
}

.assistant-message--user .assistant-message-role {
  order: 2;
  margin-left: 10px;
}

.assistant-message--assistant .assistant-message-content {
  background: #ffffff;
  color: #1f2937;
  border-bottom-left-radius: 4px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
  border: 1px solid rgba(52, 211, 153, 0.26);
}

.assistant-empty {
  text-align: center;
  font-size: 14px;
  color: #6b7280;
  padding: 36px 20px;
  font-weight: 500;
  background: rgba(255, 255, 255, 0.6);
  border-radius: 14px;
  margin: 0 4px;
  border: 1px dashed rgba(52, 211, 153, 0.9);
}

.assistant-footer {
  padding: 12px 14px 14px;
  background: linear-gradient(180deg, #f8fafc 0%, #f1f5f9 100%);
  border-top: 1px solid rgba(226, 232, 240, 0.9);
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.assistant-footer >>> .el-textarea__inner {
  font-size: 14px;
  border-radius: 12px;
  border: 1px solid rgba(226, 232, 240, 0.9);
  transition: border-color 0.2s, box-shadow 0.2s;
}

.assistant-footer >>> .el-textarea__inner:focus {
  border-color: var(--wyqy-c2);
  box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.18);
}

.assistant-send {
  align-self: flex-end;
  border-radius: 10px;
  font-weight: 600;
  padding: 8px 20px;
  box-shadow: 0 2px 8px rgba(16, 185, 129, 0.24);
}

.assistant-resizer {
  position: absolute;
  width: 12px;
  height: 12px;
  cursor: se-resize;
  background: linear-gradient(135deg, transparent 0, transparent 40%, rgba(156, 163, 175, 0.35) 40%, rgba(107, 114, 128, 0.6) 100%);
  border-radius: 2px;
  z-index: 2;
}

.assistant-resizer-se {
  right: 2px;
  bottom: 2px;
  cursor: se-resize;
}

.assistant-resizer-sw {
  left: 2px;
  bottom: 2px;
  cursor: sw-resize;
}

.assistant-resizer-ne {
  right: 2px;
  top: 2px;
  cursor: ne-resize;
}

.assistant-resizer-nw {
  left: 2px;
  top: 2px;
  cursor: nw-resize;
}

.assistant-scale-enter-active,
.assistant-scale-leave-active {
  transition: opacity 0.3s ease, transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.assistant-scale-enter,
.assistant-scale-leave-to {
  opacity: 0;
  transform: scale(0.85);
}

.ai-chat-dialog-body {
  position: relative;
  flex: 1;
  min-height: 0;
  width: 100%;
  display: flex;
  align-items: stretch;
  justify-content: center;
  background: var(--wyqy-c5);
  overflow: hidden;
}
.ai-chat-drag-area {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 42px;
  cursor: move;
  z-index: 10;
  background: transparent;
  user-select: none;
}
.ai-chat-resize-handle {
  position: absolute;
  right: 0;
  bottom: 0;
  width: 20px;
  height: 20px;
  cursor: se-resize;
  z-index: 10;
  background: linear-gradient(135deg, transparent 50%, rgba(0,0,0,0.08) 50%);
  transition: background 160ms ease, transform 160ms ease;
}
.ai-chat-resize-handle:hover {
  background: linear-gradient(135deg, transparent 50%, rgba(0,0,0,0.15) 50%);
  transform: scale(1.06);
}

.ai-chat-iframe {
  width: 100%;
  height: 100%;
  border: none;
}
.ai-chat-close {
  position: absolute;
  top: 8px;
  right: 8px;
  z-index: 12;
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: #909399;
  border-radius: 4px;
  font-size: 16px;
  transition: background 160ms ease, color 160ms ease, transform 160ms ease;
}
.ai-chat-close:hover {
  color: #606266;
  background: rgba(0,0,0,0.06);
}
.ai-chat-close:active {
  transform: scale(0.92);
}

/* Ctrl+4 中间强提示 */
.ai-complete-pop-enter-active,
.ai-complete-pop-leave-active {
  transition: opacity 220ms ease;
}
.ai-complete-pop-enter,
.ai-complete-pop-leave-to {
  opacity: 0;
}
.ai-complete-toast-mask {
  position: fixed;
  inset: 0;
  z-index: 3005;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(17, 24, 39, 0.32);
  backdrop-filter: blur(2px);
  -webkit-backdrop-filter: blur(2px);
}
.ai-complete-toast {
  width: min(640px, calc(100vw - 48px));
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 16px 18px;
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.92);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  box-shadow: 0 18px 60px rgba(0, 0, 0, 0.24);
  transform-origin: center;
  animation: aiCompletePop 320ms cubic-bezier(0.16, 1, 0.3, 1);
}
@keyframes aiCompletePop {
  0% {
    opacity: 0;
    transform: translateY(10px) scale(0.94);
  }
  60% {
    opacity: 1;
    transform: translateY(0) scale(1.02);
  }
  100% {
    transform: translateY(0) scale(1);
  }
}
.ai-complete-toast__icon {
  width: 40px;
  height: 40px;
  flex: 0 0 40px;
  filter: drop-shadow(0 10px 18px rgba(0, 0, 0, 0.18));
}
.ai-complete-toast__text {
  font-size: 16px;
  font-weight: 600;
  color: #111827;
  letter-spacing: 0.2px;
  line-height: 1.35;
}
</style>

<!-- 可调整大小的窗口式对话框：无边框、无标题栏 -->
<style lang="scss">
.ai-chat-modal {
  background-color: rgba(17, 24, 39, 0.28) !important;
  backdrop-filter: blur(2px);
  -webkit-backdrop-filter: blur(2px);
  animation: aiChatMaskIn 180ms ease-out;
}
@keyframes aiChatMaskIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
@keyframes aiChatPopIn {
  from {
    opacity: 0;
    transform: translateY(10px) scale(0.98);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}
.ai-chat-dialog.ai-chat-dialog-window {
  margin: 0 !important;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  border: none !important;
  background: rgba(255, 255, 255, 0.92);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.16);
  animation: aiChatPopIn 240ms cubic-bezier(0.16, 1, 0.3, 1);
  transition: box-shadow 220ms ease, opacity 220ms ease;

  &.is-interacting {
    transition: none !important;
  }

  &:not(.is-interacting):hover {
    box-shadow: 0 16px 45px rgba(0, 0, 0, 0.22);
  }

  .el-dialog__header {
    display: none;
  }
  .el-dialog__body {
    padding: 0;
    flex: 1;
    min-height: 0;
    overflow: hidden;
    position: relative;
    display: flex;
    flex-direction: column;
  }
}
</style>
