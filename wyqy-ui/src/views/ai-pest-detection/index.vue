<template>
  <div class="ai-pest-detection-container" @keydown="handleKeyDown" tabindex="0">
    <!-- AI识别状态概览 -->
    <el-row :gutter="20" class="mb20">
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
          <div class="stat-glow"></div>
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
              <el-tag :type="aiStatus.type" size="mini">{{ aiStatus.text }}</el-tag>
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
              <el-tag size="mini" type="success">共 {{ recentDetections.length }} 条</el-tag>
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

    <!-- 识别记录表格 -->
    <el-card class="records-card">
      <div slot="header" class="card-header">
        <div class="header-title">
          <i class="el-icon-s-data"></i>
          <span>识别记录</span>
        </div>
        <div class="header-actions">
          <el-button type="primary" icon="el-icon-refresh" size="mini" @click="getList">刷新</el-button>
          <el-button type="success" icon="el-icon-download" size="mini" @click="handleExport">导出</el-button>
        </div>
      </div>

      <!-- 查询条件 -->
      <div class="search-section">
        <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="68px">
          <el-form-item label="地块名称" prop="landName">
            <el-input v-model="queryParams.landName" placeholder="请输入地块名称" clearable @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="作物名称" prop="speciesName">
            <el-input v-model="queryParams.speciesName" placeholder="请输入作物名称" clearable @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="识别类型" prop="detectionType">
            <el-select v-model="queryParams.detectionType" placeholder="请选择识别类型" clearable>
              <el-option label="病害" value="disease" />
              <el-option label="虫害" value="pest" />
              <el-option label="健康" value="healthy" />
            </el-select>
          </el-form-item>
          <el-form-item label="处理状态" prop="processStatus">
            <el-select v-model="queryParams.processStatus" placeholder="请选择处理状态" clearable>
              <el-option label="待处理" value="pending" />
              <el-option label="处理中" value="processing" />
              <el-option label="已处理" value="completed" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
            <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
          </el-form-item>
        </el-form>
      </div>

      <!-- 数据表格 -->
      <el-table v-loading="loading" :data="detectionList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="识别ID" align="center" prop="detectionId" width="80" />
        <el-table-column label="地块名称" align="center" prop="landName" />
        <el-table-column label="作物名称" align="center" prop="speciesName" />
        <el-table-column label="识别类型" align="center" prop="detectionType">
          <template slot-scope="scope">
            <el-tag :type="getDetectionTypeTag(scope.row.detectionType)">
              {{ getDetectionTypeText(scope.row.detectionType) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="病虫害" align="center" prop="pestName" />
        <el-table-column label="置信度" align="center" prop="confidence">
          <template slot-scope="scope">
            <el-progress 
              :percentage="Math.round(scope.row.confidence * 100)" 
              :color="getConfidenceColor(scope.row.confidence)"
              :show-text="true"
              :format="formatConfidence"
            />
          </template>
        </el-table-column>
        <el-table-column label="处理状态" align="center" prop="processStatus">
          <template slot-scope="scope">
            <el-tag :type="getProcessStatusTag(scope.row.processStatus)">
              {{ getProcessStatusText(scope.row.processStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="识别时间" align="center" prop="detectionTime" width="180">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.detectionTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="text"
              icon="el-icon-view"
              @click="handleView(scope.row)"
            >查看</el-button>
            <el-button
              size="mini"
              type="text"
              icon="el-icon-check"
              @click="handleMarkProcessed(scope.row)"
              v-if="scope.row.isProcessed === '0'"
            >标记已处理</el-button>
            <el-button
              size="mini"
              type="text"
              icon="el-icon-delete"
              @click="handleDelete(scope.row)"
              v-hasPermi="['agriculture:ai-pest-detection:remove']"
            >删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <!-- 查看详情对话框 -->
    <el-dialog title="识别详情" :visible.sync="viewOpen" width="800px" append-to-body>
      <el-descriptions :column="2" border v-if="currentDetection">
        <el-descriptions-item label="识别ID">{{ currentDetection.detectionId }}</el-descriptions-item>
        <el-descriptions-item label="地块名称">{{ currentDetection.landName }}</el-descriptions-item>
        <el-descriptions-item label="作物名称">{{ currentDetection.speciesName }}</el-descriptions-item>
        <el-descriptions-item label="识别类型">
          <el-tag :type="getDetectionTypeTag(currentDetection.detectionType)">
            {{ getDetectionTypeText(currentDetection.detectionType) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="病虫害名称">{{ currentDetection.pestName }}</el-descriptions-item>
        <el-descriptions-item label="置信度">{{ (currentDetection.confidence * 100).toFixed(1) }}%</el-descriptions-item>
        <el-descriptions-item label="处理状态">
          <el-tag :type="getProcessStatusTag(currentDetection.processStatus)">
            {{ getProcessStatusText(currentDetection.processStatus) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="识别时间">{{ parseTime(currentDetection.detectionTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</el-descriptions-item>
        <el-descriptions-item label="推荐处理方案" span="2">{{ currentDetection.recommendation }}</el-descriptions-item>
        <el-descriptions-item label="备注" span="2">{{ currentDetection.remark || '无' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>

    <!-- 识别结果弹窗 -->
    <el-dialog 
      title="" 
      :visible.sync="resultDialogVisible" 
      width="650px" 
      :close-on-click-modal="false"
      center
      class="ai-result-dialog"
      :show-close="false"
    >
      <div class="result-dialog-content" v-if="detectionResult">
        <!-- 美化的标题区域 -->
        <div class="result-header-enhanced">
          <div class="result-icon-enhanced" :class="'result-' + detectionResult.detectionType">
            <i :class="getDetectionTypeIcon(detectionResult.detectionType)"></i>
          </div>
          <div class="result-title-section">
            <h2 class="result-main-title">AI识别结果</h2>
            <div class="result-subtitle">{{ detectionResult.message }}</div>
          </div>
          <div class="result-close-btn" @click="resultDialogVisible = false">
            <i class="el-icon-close"></i>
          </div>
        </div>

        <!-- 置信度显示区域 -->
        <div class="confidence-section">
          <div class="confidence-header">
            <span class="confidence-title">置信度分析</span>
            <span class="confidence-value" :class="'confidence-' + getConfidenceLevel(detectionResult.confidence)">
              {{ Math.round(detectionResult.confidence * 100) }}%
            </span>
          </div>
          <div class="confidence-progress-wrapper">
            <el-progress 
              :percentage="Math.round(detectionResult.confidence * 100)" 
              :color="getConfidenceGradient(detectionResult.confidence)"
              :stroke-width="12"
              :show-text="false"
            />
          </div>
          <div class="confidence-description">
            {{ getConfidenceDescription(detectionResult.confidence) }}
          </div>
        </div>

        <!-- 推荐处理方案 -->
        <div class="recommendation-section">
          <div class="recommendation-header">
            <div class="recommendation-icon">
              <i class="el-icon-lightbulb"></i>
            </div>
            <h3 class="recommendation-title">推荐处理方案</h3>
          </div>
          <div class="recommendation-content">
            <div class="recommendation-text">{{ detectionResult.recommendation }}</div>
            <div class="recommendation-tips">
              <div class="tip-item">
                <i class="el-icon-warning-outline"></i>
                <span>请及时处理以防止扩散</span>
              </div>
              <div class="tip-item">
                <i class="el-icon-time"></i>
                <span>建议在24小时内采取行动</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 操作按钮 -->
        <div class="result-actions-enhanced">
          <el-button type="primary" size="medium" @click="handleConfirmResult" class="confirm-btn">
            <i class="el-icon-check"></i>
            确认处理
          </el-button>
          <el-button size="medium" @click="resultDialogVisible = false" class="cancel-btn">
            <i class="el-icon-close"></i>
            关闭
          </el-button>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listAiPestDetection, getAiPestDetection, delAiPestDetection, addAiPestDetection, updateAiPestDetection, detectPest, getVideoStream, getDetectionStats, markAsProcessed } from "@/api/agriculture/ai-pest-detection";
import { listLand } from "@/api/agriculture/land";
import { listCropSpecies } from "@/api/agriculture/crop";

export default {
  name: "AiPestDetection",
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
      // 总条数
      total: 0,
      // AI病虫害识别表格数据
      detectionList: [],
      // 地块选项
      landOptions: [],
      // 作物选项
      speciesOptions: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      viewOpen: false,
      // 当前查看的识别记录
      currentDetection: null,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        landName: null,
        speciesName: null,
        detectionType: null,
        processStatus: null,
      },
      // 识别表单
      detectionForm: {
        landId: null,
        speciesId: null,
        landName: null,
        speciesName: null
      },
      // 统计数据
      detectionStats: [],
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
      resultDialogVisible: false,
      // 最近识别结果
      recentDetections: [],
      // 键盘监听状态
      keyListenerEnabled: true
    };
  },
  created() {
    this.getList();
    this.getLandOptions();
    this.getSpeciesOptions();
    this.getDetectionStatistics();
    this.initVideoStream();
  },
  mounted() {
    // 确保容器可以获得焦点
    this.$nextTick(() => {
      const container = this.$el;
      if (container) {
        container.setAttribute('tabindex', '0');
      }
    });
  },
  methods: {
    /** 查询AI病虫害识别列表 */
    getList() {
      this.loading = true;
      listAiPestDetection(this.queryParams).then(response => {
        this.detectionList = response.rows;
        this.total = response.total;
        this.loading = false;
        // 更新最近识别结果
        this.updateRecentDetections();
      });
    },
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
            icon: 'el-icon-bug'
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
    // 开始分析
    startAnalysis() {
      if (!this.detectionForm.landId || !this.detectionForm.speciesId) {
        this.$message.warning('请先选择地块和作物');
        return;
      }
      
      this.isAnalyzing = true;
      this.aiStatus = { type: 'warning', text: 'AI监控中...' };
      
      // 不再自动执行识别，只是显示监控状态
      // 用户需要按 Ctrl+2 才会触发识别
    },
    // 停止分析
    stopAnalysis() {
      this.isAnalyzing = false;
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
          this.resultDialogVisible = true;
          this.getList();
          this.getDetectionStatistics();
        } else {
          this.$message.error(response.msg || '识别失败');
        }
        this.stopAnalysis();
      }).catch(() => {
        this.$message.error('识别失败');
        this.stopAnalysis();
      });
    },
    // 截图识别
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
    // 快速识别
    quickDetect() {
      if (!this.detectionForm.landId || !this.detectionForm.speciesId) {
        this.$message.warning('请先选择地块和作物');
        return;
      }
      
      if (this.isAnalyzing) {
        this.$message.info('AI正在识别中，请稍候...');
        return;
      }
      
      
      // 设置识别状态
      this.isAnalyzing = true;
      this.aiStatus = { type: 'warning', text: 'AI识别中...' };
      
      // 直接执行识别，不等待3秒
      const params = {
        landId: this.detectionForm.landId,
        speciesId: this.detectionForm.speciesId,
        landName: this.getSelectedLandName(),
        speciesName: this.getSelectedSpeciesName()
      };
      
      detectPest(params).then(response => {
        if (response.code === 200) {
          this.detectionResult = response.data;
          this.resultDialogVisible = true;
          this.getList();
          this.getDetectionStatistics();
        } else {
          this.$message.error(response.msg || '识别失败');
        }
        this.stopAnalysis();
      }).catch(() => {
        this.$message.error('识别失败');
        this.stopAnalysis();
      });
    },
    // 更新最近识别结果
    updateRecentDetections() {
      this.recentDetections = this.detectionList.slice(0, 5);
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
    // 获取识别类型标签
    getDetectionTypeTag(type) {
      const tagMap = {
        'disease': 'danger',
        'pest': 'warning',
        'healthy': 'success'
      };
      return tagMap[type] || 'info';
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
    // 获取处理状态文本
    getProcessStatusText(status) {
      const statusMap = {
        'pending': '待处理',
        'processing': '处理中',
        'completed': '已处理'
      };
      return statusMap[status] || status;
    },
    // 获取处理状态标签
    getProcessStatusTag(status) {
      const tagMap = {
        'pending': 'warning',
        'processing': 'primary',
        'completed': 'success'
      };
      return tagMap[status] || 'info';
    },
    // 获取置信度颜色
    getConfidenceColor(confidence) {
      if (confidence >= 0.8) return '#67c23a';
      if (confidence >= 0.6) return '#e6a23c';
      return '#f56c6c';
    },
    // 获取置信度等级
    getConfidenceLevel(confidence) {
      if (confidence >= 0.8) return 'high';
      if (confidence >= 0.6) return 'medium';
      return 'low';
    },
    // 获取置信度渐变色
    getConfidenceGradient(confidence) {
      if (confidence >= 0.8) {
        return [
          { color: '#67c23a', percentage: 0 },
          { color: '#85ce61', percentage: 100 }
        ];
      }
      if (confidence >= 0.6) {
        return [
          { color: '#e6a23c', percentage: 0 },
          { color: '#ebb563', percentage: 100 }
        ];
      }
      return [
        { color: '#f56c6c', percentage: 0 },
        { color: '#f78989', percentage: 100 }
      ];
    },
    // 获取置信度描述
    getConfidenceDescription(confidence) {
      if (confidence >= 0.8) return '高置信度 - AI模型非常确定这个识别结果';
      if (confidence >= 0.6) return '中等置信度 - AI模型有一定把握，建议人工确认';
      return '低置信度 - AI模型不太确定，建议专业人员进行现场检查';
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
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.detectionId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
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
    /** 查看按钮操作 */
    handleView(row) {
      this.currentDetection = row;
      this.viewOpen = true;
    },
    /** 标记已处理按钮操作 */
    handleMarkProcessed(row) {
      const that = this;
      this.$modal.confirm('确认标记该识别记录为已处理？').then(function() {
        return markAsProcessed(row.detectionId);
      }).then(() => {
        that.getList();
        that.getDetectionStatistics();
        that.$modal.msgSuccess("标记成功");
      }).catch(() => {});
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const detectionIds = row.detectionId || this.ids;
      this.$modal.confirm('是否确认删除AI病虫害识别编号为"' + detectionIds + '"的数据项？').then(function() {
        return delAiPestDetection(detectionIds);
      }).then(() => {
        this.getList();
        this.getDetectionStatistics();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('agriculture/ai-pest-detection/export', {
        ...this.queryParams
      }, `ai-pest-detection_${new Date().getTime()}.xlsx`)
    },
    // 确认识别结果
    handleConfirmResult() {
      this.resultDialogVisible = false;
      this.detectionResult = null;
    }
  }
};
</script>

<style scoped>
.ai-pest-detection-container {
  padding: 24px;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  min-height: calc(100vh - 84px);
  position: relative;
  overflow-x: hidden;
}

.ai-pest-detection-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 300px;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
  z-index: 0;
  pointer-events: none;
}

/* 统计卡片样式 */
.stat-card {
  position: relative;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 20px;
  padding: 28px 24px;
  color: white;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(102, 126, 234, 0.25);
  border: 1px solid rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  z-index: 1;
}

.stat-card:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: 0 16px 40px rgba(102, 126, 234, 0.4);
}

.stat-card:active {
  transform: translateY(-4px) scale(0.98);
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

.stat-card-0:hover {
  box-shadow: 0 16px 40px rgba(102, 126, 234, 0.4);
}

.stat-card-1:hover {
  box-shadow: 0 16px 40px rgba(240, 147, 251, 0.4);
}

.stat-card-2:hover {
  box-shadow: 0 16px 40px rgba(79, 172, 254, 0.4);
}

.stat-card-3:hover {
  box-shadow: 0 16px 40px rgba(67, 233, 123, 0.4);
}

.stat-content {
  display: flex;
  align-items: center;
  position: relative;
  z-index: 2;
}

.stat-icon {
  font-size: 42px;
  margin-right: 18px;
  opacity: 0.95;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.2));
  transition: transform 0.3s ease;
}

.stat-card:hover .stat-icon {
  transform: scale(1.1) rotate(5deg);
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  margin-bottom: 8px;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  letter-spacing: -0.5px;
}

.stat-label {
  font-size: 15px;
  opacity: 0.95;
  font-weight: 500;
  letter-spacing: 0.3px;
}

.stat-glow {
  position: absolute;
  top: -50%;
  right: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
  animation: glow 3s ease-in-out infinite alternate;
}

@keyframes glow {
  from { transform: scale(0.8); opacity: 0.5; }
  to { transform: scale(1.2); opacity: 0.8; }
}

/* 视频卡片样式 */
.video-card {
  height: 500px;
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
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 18px 24px;
  border-bottom: none;
}

.video-card >>> .el-card__body {
  padding: 20px;
  background: #ffffff;
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

.video-container {
  height: 400px;
  display: flex;
  flex-direction: column;
}

.video-wrapper {
  flex: 1;
  position: relative;
  background: #000;
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
}

.ai-indicator {
  position: absolute;
  top: 20px;
  left: 20px;
  background: linear-gradient(135deg, rgba(255, 0, 0, 0.9) 0%, rgba(238, 90, 111, 0.9) 100%);
  color: white;
  padding: 12px 18px;
  border-radius: 25px;
  display: flex;
  align-items: center;
  animation: pulse 1.5s infinite;
  box-shadow: 0 4px 12px rgba(255, 0, 0, 0.4);
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
  animation: scan 1.5s infinite;
}

.ai-text {
  font-size: 12px;
  font-weight: bold;
}

@keyframes pulse {
  0%, 100% { opacity: 0.8; }
  50% { opacity: 1; }
}

@keyframes scan {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.2); }
}

.video-controls {
  margin-top: 20px;
  text-align: center;
  display: flex;
  justify-content: center;
  gap: 12px;
  flex-wrap: wrap;
}

.video-controls .el-button {
  margin: 0;
  border-radius: 8px;
  font-weight: 500;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.video-controls .el-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.video-controls .el-button:active {
  transform: translateY(0);
}

/* 控制面板样式 */
.control-panel {
  height: 500px;
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
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: white;
  padding: 18px 24px;
  border-bottom: none;
  border-radius: 16px 16px 0 0;
}

.control-panel >>> .el-card__body {
  padding: 24px;
  background: #ffffff;
  height: calc(100% - 60px);
  overflow-y: auto;
}

.selection-panel {
  margin-bottom: 20px;
}

.full-width {
  width: 100%;
}

.quick-actions {
  margin-bottom: 20px;
}

.action-title {
  font-weight: bold;
  margin-bottom: 10px;
  color: #303133;
}

.action-hint {
  margin-bottom: 15px;
}

.recent-results {
  height: 100%;
  overflow-y: auto;
}

.results-title {
  font-weight: 600;
  margin-bottom: 16px;
  color: #1a1a1a;
  font-size: 16px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.results-title::before {
  content: '';
  width: 4px;
  height: 18px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 2px;
}

.result-item {
  background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
  border-radius: 12px;
  padding: 14px 16px;
  margin-bottom: 12px;
  border-left: 4px solid #409eff;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  cursor: pointer;
}

.result-item:hover {
  transform: translateX(4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  background: linear-gradient(135deg, #ffffff 0%, #f0f4ff 100%);
}

.result-pest {
  border-left-color: #e6a23c;
  background: linear-gradient(135deg, #fff8e1 0%, #ffffff 100%);
}

.result-pest:hover {
  background: linear-gradient(135deg, #fff3cd 0%, #fff8e1 100%);
}

.result-disease {
  border-left-color: #f56c6c;
  background: linear-gradient(135deg, #ffebee 0%, #ffffff 100%);
}

.result-disease:hover {
  background: linear-gradient(135deg, #ffcdd2 0%, #ffebee 100%);
}

.result-healthy {
  border-left-color: #67c23a;
  background: linear-gradient(135deg, #e8f5e9 0%, #ffffff 100%);
}

.result-healthy:hover {
  background: linear-gradient(135deg, #c8e6c9 0%, #e8f5e9 100%);
}

.result-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 5px;
}

.result-type {
  font-weight: bold;
  font-size: 12px;
}

.result-confidence {
  font-size: 12px;
  color: #909399;
}

.result-name {
  font-weight: bold;
  margin-bottom: 3px;
}

.result-time {
  font-size: 12px;
  color: #909399;
}

.no-results {
  text-align: center;
  color: #909399;
  padding: 40px 20px;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border-radius: 12px;
  border: 2px dashed #e4e7ed;
}

.no-results i {
  font-size: 48px;
  margin-bottom: 16px;
  opacity: 0.5;
  color: #c0c4cc;
}

.no-results p {
  font-size: 14px;
  margin: 0;
  color: #909399;
}

/* 记录卡片样式 */
.records-card {
  margin-top: 24px;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  border: none;
  overflow: hidden;
  z-index: 1;
}

.records-card >>> .el-card__header {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  color: white;
  padding: 18px 24px;
  border-bottom: none;
}

.records-card >>> .el-card__body {
  padding: 24px;
  background: #ffffff;
}

.header-actions {
  display: flex;
  gap: 12px;
}

.header-actions .el-button {
  border-radius: 8px;
  font-weight: 500;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.3);
  background: rgba(255, 255, 255, 0.2);
  color: white;
  backdrop-filter: blur(10px);
}

.header-actions .el-button:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.search-section {
  margin-bottom: 24px;
  padding: 24px;
  background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.search-section >>> .el-form-item {
  margin-bottom: 16px;
}

.search-section >>> .el-input__inner,
.search-section >>> .el-select .el-input__inner {
  border-radius: 8px;
  border-color: #e4e7ed;
  transition: all 0.3s ease;
}

.search-section >>> .el-input__inner:focus,
.search-section >>> .el-select .el-input__inner:focus {
  border-color: #667eea;
  box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.1);
}

.search-section >>> .el-button {
  border-radius: 8px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.search-section >>> .el-button--primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
}

.search-section >>> .el-button--primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

/* 识别结果弹窗样式 */
.result-dialog-content {
  text-align: center;
}

/* 美化后的AI识别结果弹窗样式 */
.ai-result-dialog {
  .el-dialog {
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
    border: none;
  }
  
  .el-dialog__header {
    padding: 0;
  }
  
  .el-dialog__body {
    padding: 0;
  }
}

.result-dialog-content {
  background: linear-gradient(135deg, #f8f9ff 0%, #ffffff 100%);
  min-height: 500px;
}

.result-header-enhanced {
  display: flex;
  align-items: center;
  padding: 35px 35px 25px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  position: relative;
  border-radius: 20px 20px 0 0;
  box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
}

.result-icon-enhanced {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 25px;
  font-size: 32px;
  color: white;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
  position: relative;
  overflow: hidden;
  
  &::before {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.4), transparent);
    animation: shine 3s infinite;
  }
  
  &::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    border-radius: 50%;
    border: 2px solid rgba(255, 255, 255, 0.3);
    animation: pulse 2s infinite;
  }
}

@keyframes shine {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

@keyframes pulse {
  0% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.1); opacity: 0.7; }
  100% { transform: scale(1); opacity: 1; }
}

.result-pest {
  background: linear-gradient(135deg, #ff6b6b, #ee5a24);
}

.result-disease {
  background: linear-gradient(135deg, #f368e0, #ee5a6f);
}

.result-healthy {
  background: linear-gradient(135deg, #26de81, #20bf6b);
}

.result-title-section {
  flex: 1;
}

.result-main-title {
  margin: 0 0 12px 0;
  font-size: 28px;
  font-weight: 700;
  text-shadow: 0 3px 6px rgba(0, 0, 0, 0.3);
  letter-spacing: 0.5px;
}

.result-subtitle {
  font-size: 18px;
  opacity: 0.95;
  font-weight: 400;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.result-close-btn {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
  
  &:hover {
    background: rgba(255, 255, 255, 0.3);
    transform: scale(1.1) rotate(90deg);
  }
}

.confidence-section {
  padding: 30px 35px;
  background: white;
  margin: 0 25px;
  border-radius: 16px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
  margin-top: 25px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.confidence-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.confidence-title {
  font-size: 18px;
  font-weight: 700;
  color: #303133;
  display: flex;
  align-items: center;
  
  &::before {
    content: '📊';
    margin-right: 8px;
    font-size: 20px;
  }
}

.confidence-value {
  font-size: 24px;
  font-weight: bold;
  padding: 8px 16px;
  border-radius: 25px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  
  &.confidence-high {
    background: linear-gradient(135deg, #26de81, #20bf6b);
    color: white;
  }
  
  &.confidence-medium {
    background: linear-gradient(135deg, #fed330, #f7b731);
    color: white;
  }
  
  &.confidence-low {
    background: linear-gradient(135deg, #fc5c65, #eb3b5a);
    color: white;
  }
}

.confidence-progress-wrapper {
  margin: 20px 0;
  
  .el-progress-bar__outer {
    border-radius: 10px;
    background: #f0f2f5;
  }
  
  .el-progress-bar__inner {
    border-radius: 10px;
    transition: all 0.8s ease;
  }
}

.confidence-description {
  font-size: 15px;
  color: #606266;
  line-height: 1.6;
  font-style: italic;
  padding: 15px;
  background: #f8f9fa;
  border-radius: 10px;
  border-left: 4px solid #667eea;
}

.recommendation-section {
  padding: 30px 35px;
  background: linear-gradient(135deg, #fff5f5, #fff);
  margin: 25px;
  border-radius: 16px;
  border-left: 5px solid #667eea;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
}

.recommendation-header {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}

.recommendation-icon {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea, #764ba2);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  margin-right: 15px;
  font-size: 20px;
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.3);
  animation: glow 2s infinite;
}

@keyframes glow {
  0%, 100% { box-shadow: 0 6px 20px rgba(102, 126, 234, 0.3); }
  50% { box-shadow: 0 6px 30px rgba(102, 126, 234, 0.5); }
}

.recommendation-title {
  margin: 0;
  font-size: 20px;
  font-weight: 700;
  color: #303133;
}

.recommendation-content {
  .recommendation-text {
    font-size: 17px;
    color: #303133;
    line-height: 1.7;
    margin-bottom: 20px;
    padding: 20px;
    background: white;
    border-radius: 12px;
    border: 2px solid #e4e7ed;
    position: relative;
    
    &::before {
      content: '💡';
      position: absolute;
      top: -10px;
      left: 15px;
      background: white;
      padding: 0 8px;
      font-size: 18px;
    }
  }
  
  .recommendation-tips {
    .tip-item {
      display: flex;
      align-items: center;
      margin-bottom: 12px;
      font-size: 15px;
      color: #606266;
      padding: 12px;
      background: rgba(230, 162, 60, 0.1);
      border-radius: 8px;
      transition: all 0.3s ease;
      
      &:hover {
        background: rgba(230, 162, 60, 0.2);
        transform: translateX(5px);
      }
      
      i {
        margin-right: 10px;
        color: #e6a23c;
        font-size: 16px;
      }
      
      &:last-child {
        margin-bottom: 0;
      }
    }
  }
}

.result-actions-enhanced {
  padding: 25px 35px 35px;
  text-align: center;
  display: flex;
  justify-content: center;
  gap: 20px;
}

.confirm-btn {
  background: linear-gradient(135deg, #667eea, #764ba2);
  border: none;
  padding: 15px 40px;
  font-size: 17px;
  font-weight: 600;
  border-radius: 30px;
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  
  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
    transition: left 0.5s;
  }
  
  &:hover {
    transform: translateY(-3px);
    box-shadow: 0 12px 30px rgba(102, 126, 234, 0.5);
    
    &::before {
      left: 100%;
    }
  }
}

.cancel-btn {
  background: white;
  border: 2px solid #e4e7ed;
  color: #606266;
  padding: 15px 40px;
  font-size: 17px;
  font-weight: 600;
  border-radius: 30px;
  transition: all 0.3s ease;
  position: relative;
  
  &:hover {
    border-color: #667eea;
    color: #667eea;
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);
  }
}

/* 原有样式保持不变 */
.result-header {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}

.result-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20px;
  font-size: 24px;
  color: white;
}

.result-pest {
  background: linear-gradient(135deg, #e6a23c, #f56c6c);
}

.result-disease {
  background: linear-gradient(135deg, #f56c6c, #d32f2f);
}

.result-healthy {
  background: linear-gradient(135deg, #67c23a, #4caf50);
}

.result-info h3 {
  margin: 0 0 10px 0;
  color: #303133;
}

.confidence-bar {
  display: flex;
  align-items: center;
}

.confidence-label {
  margin-right: 10px;
  font-weight: bold;
}

.result-recommendation {
  text-align: left;
  background: #f8f9fa;
  padding: 15px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.result-recommendation h4 {
  margin: 0 0 10px 0;
  color: #303133;
}

.result-recommendation p {
  margin: 0;
  color: #606266;
  line-height: 1.6;
}

.result-actions {
  text-align: center;
}

/* 表格美化 */
.ai-pest-detection-container >>> .el-table {
  border-radius: 12px;
  overflow: hidden;
}

.ai-pest-detection-container >>> .el-table th {
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  color: #495057;
  font-weight: 600;
  border-bottom: 2px solid #dee2e6;
}

.ai-pest-detection-container >>> .el-table td {
  border-bottom: 1px solid #f1f3f5;
}

.ai-pest-detection-container >>> .el-table tbody tr {
  transition: all 0.2s ease;
}

.ai-pest-detection-container >>> .el-table tbody tr:hover {
  background: linear-gradient(135deg, #f8f9ff 0%, #ffffff 100%);
  transform: scale(1.01);
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
}

.ai-pest-detection-container >>> .el-table tbody tr:hover td {
  border-bottom-color: #667eea;
}

/* 分页美化 */
.ai-pest-detection-container >>> .pagination-container {
  margin-top: 24px;
  padding: 16px;
  background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

/* 对话框美化 */
.ai-pest-detection-container >>> .el-dialog {
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
}

.ai-pest-detection-container >>> .el-dialog__header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 20px 24px;
}

.ai-pest-detection-container >>> .el-dialog__title {
  color: white;
  font-weight: 600;
}

.ai-pest-detection-container >>> .el-dialog__headerbtn .el-dialog__close {
  color: white;
}

.ai-pest-detection-container >>> .el-dialog__headerbtn:hover .el-dialog__close {
  color: rgba(255, 255, 255, 0.8);
}

/* 间距样式 */
.mb20 {
  margin-bottom: 24px;
  position: relative;
  z-index: 1;
}

/* 动画效果 */
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

.stat-card {
  animation: fadeInUp 0.6s ease-out;
}

.stat-card:nth-child(1) { animation-delay: 0.1s; }
.stat-card:nth-child(2) { animation-delay: 0.2s; }
.stat-card:nth-child(3) { animation-delay: 0.3s; }
.stat-card:nth-child(4) { animation-delay: 0.4s; }

.video-card,
.control-panel,
.records-card {
  animation: fadeInUp 0.8s ease-out;
}

/* 滚动条美化 */
.recent-results::-webkit-scrollbar,
.control-panel >>> .el-card__body::-webkit-scrollbar {
  width: 6px;
}

.recent-results::-webkit-scrollbar-track,
.control-panel >>> .el-card__body::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 10px;
}

.recent-results::-webkit-scrollbar-thumb,
.control-panel >>> .el-card__body::-webkit-scrollbar-thumb {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 10px;
}

.recent-results::-webkit-scrollbar-thumb:hover,
.control-panel >>> .el-card__body::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
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
  
  .ai-pest-detection-container {
    padding: 16px;
  }
  
  .stat-card {
    margin-bottom: 16px;
  }
  
  .stat-value {
    font-size: 28px;
  }
  
  .stat-icon {
    font-size: 36px;
  }
}
</style>
