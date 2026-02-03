<template>
  <div class="app-container">
    <!-- 翻译主区域 -->
    <el-row :gutter="24">
      <!-- 左侧：原文输入区 -->
      <el-col :span="12">
        <div class="translation-card source-card">
          <div class="card-header">
            <div class="header-left">
              <div class="header-icon">
                <i class="el-icon-edit-outline"></i>
              </div>
              <span class="header-title">原文</span>
            </div>
            <el-button class="clear-btn" type="text" @click="clearSource">
              <i class="el-icon-delete"></i> 清空
            </el-button>
          </div>
          
          <div class="card-body">
            <el-form ref="form" :model="form" :rules="rules" label-width="80px">
              <el-form-item label="语言" prop="sourceLanguage">
                <el-select v-model="form.sourceLanguage" placeholder="请选择源语言" style="width: 100%">
                  <el-option label="自动检测" value="auto"></el-option>
                  <el-option label="英语" value="en"></el-option>
                  <el-option label="中文" value="zh"></el-option>
                  <el-option label="日语" value="ja"></el-option>
                  <el-option label="韩语" value="ko"></el-option>
                  <el-option label="法语" value="fr"></el-option>
                  <el-option label="德语" value="de"></el-option>
                  <el-option label="西班牙语" value="es"></el-option>
                </el-select>
              </el-form-item>
              
              <el-form-item label="领域" prop="domainType">
                <el-select v-model="form.domainType" placeholder="请选择领域类型" style="width: 100%">
                  <el-option label="通用" value="general"></el-option>
                  <el-option label="商务" value="business"></el-option>
                  <el-option label="技术" value="technical"></el-option>
                  <el-option label="医学" value="medical"></el-option>
                  <el-option label="法律" value="legal"></el-option>
                </el-select>
              </el-form-item>
              
              <el-form-item label="原文" prop="sourceText">
                <el-input
                  v-model="form.sourceText"
                  type="textarea"
                  :rows="12"
                  placeholder="请输入要翻译的文本..."
                  maxlength="5000"
                  show-word-limit
                  @input="onSourceInput"
                  class="custom-textarea"
                ></el-input>
              </el-form-item>
              
              <el-form-item>
                <el-button class="translate-btn" @click="handleTranslate" :loading="loading" size="medium">
                  <i class="el-icon-s-promotion"></i> 翻译
                </el-button>
                <el-button class="swap-btn" @click="handleSwap" size="medium">
                  <i class="el-icon-refresh"></i> 交换语言
                </el-button>
              </el-form-item>
            </el-form>
          </div>
        </div>
      </el-col>
      
      <!-- 右侧：译文显示区 -->
      <el-col :span="12">
        <div class="translation-card target-card">
          <div class="card-header target-header">
            <div class="header-left">
              <div class="header-icon target-icon">
                <i class="el-icon-document-checked"></i>
              </div>
              <span class="header-title">译文</span>
            </div>
            <div class="header-actions">
              <el-button class="action-btn" type="text" @click="copyTarget">
                <i class="el-icon-document-copy"></i> 复制
              </el-button>
              <el-button class="action-btn" type="text" @click="clearTarget">
                <i class="el-icon-delete"></i> 清空
              </el-button>
            </div>
          </div>
          
          <div class="card-body">
            <el-form label-width="80px">
              <el-form-item label="语言">
                <el-select v-model="form.targetLanguage" placeholder="请选择目标语言" style="width: 100%" @change="onTargetLanguageChange">
                  <el-option label="中文" value="zh"></el-option>
                  <el-option label="英语" value="en"></el-option>
                  <el-option label="日语" value="ja"></el-option>
                  <el-option label="韩语" value="ko"></el-option>
                  <el-option label="法语" value="fr"></el-option>
                  <el-option label="德语" value="de"></el-option>
                  <el-option label="西班牙语" value="es"></el-option>
                </el-select>
              </el-form-item>
              
              <el-form-item label="译文">
                <el-input
                  v-model="translationResult.targetText"
                  type="textarea"
                  :rows="12"
                  placeholder="翻译结果将显示在这里..."
                  readonly
                  class="custom-textarea result-textarea"
                  maxlength="5000"
                  show-word-limit
                ></el-input>
              </el-form-item>
              
              <el-form-item v-if="translationResult.confidenceScore">
                <div class="translation-info">
                  <span class="info-tag confidence-tag">
                    <i class="el-icon-success"></i>
                    置信度: {{ (translationResult.confidenceScore * 100).toFixed(1) }}%
                  </span>
                  <span class="info-tag time-tag">
                    <i class="el-icon-time"></i>
                    耗时: {{ translationResult.processingTime }}ms
                  </span>
                  <span v-if="translationResult.corpusHitRate > 0" class="info-tag corpus-tag">
                    <i class="el-icon-collection"></i>
                    语料匹配: {{ (translationResult.corpusHitRate * 100).toFixed(1) }}%
                  </span>
                </div>
              </el-form-item>
            </el-form>
          </div>
        </div>
      </el-col>
    </el-row>
    
    <!-- 翻译历史 -->
    <div class="history-card">
      <div class="card-header history-header">
        <div class="header-left">
          <div class="header-icon history-icon">
            <i class="el-icon-time"></i>
          </div>
          <span class="header-title">翻译历史</span>
        </div>
        <el-button class="refresh-btn" type="text" @click="refreshHistory">
          <i class="el-icon-refresh"></i> 刷新
        </el-button>
      </div>
      
      <div class="card-body">
        <el-table
          v-loading="historyLoading"
          :data="historyList"
          style="width: 100%"
          @row-click="handleHistoryClick"
          class="custom-table"
        >
          <el-table-column
            prop="sourceText"
            label="原文"
            :show-overflow-tooltip="true"
            min-width="200"
          >
            <template slot-scope="scope">
              <div class="history-text">{{ scope.row.sourceText }}</div>
            </template>
          </el-table-column>
          
          <el-table-column
            prop="targetText"
            label="译文"
            :show-overflow-tooltip="true"
            min-width="200"
          >
            <template slot-scope="scope">
              <div class="history-text">{{ scope.row.targetText }}</div>
            </template>
          </el-table-column>
          
          <el-table-column
            prop="sourceLanguage"
            label="语言"
            width="140"
            align="center"
          >
            <template slot-scope="scope">
              <span class="language-tag">
                {{ getLanguageName(scope.row.sourceLanguage) }} 
                <i class="el-icon-right"></i> 
                {{ getLanguageName(scope.row.targetLanguage) }}
              </span>
            </template>
          </el-table-column>
          
          <el-table-column
            prop="createTime"
            label="时间"
            width="160"
            align="center"
          >
            <template slot-scope="scope">
              <span class="time-text">
                <i class="el-icon-time"></i>
                {{ parseTime(scope.row.createTime) }}
              </span>
            </template>
          </el-table-column>
          
          <el-table-column
            prop="status"
            label="状态"
            width="100"
            align="center"
          >
            <template slot-scope="scope">
              <span v-if="scope.row.status === '0'" class="status-tag status-success">
                <i class="el-icon-success"></i> 成功
              </span>
              <span v-else class="status-tag status-fail">
                <i class="el-icon-error"></i> 失败
              </span>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </div>
  </div>
</template>

<script>
import { translate, getTranslationHistory } from "@/api/translation"

export default {
  name: "Translation",
  data() {
    return {
      // 表单数据
      form: {
        sourceText: "",
        sourceLanguage: "auto",
        targetLanguage: "zh",
        domainType: "general",
        translationType: "auto"
      },
      
      // 表单校验
      rules: {
        sourceText: [
          { required: true, message: "原文不能为空", trigger: "blur" }
        ]
      },
      
      // 翻译结果
      translationResult: {
        targetText: "",
        confidenceScore: null,
        processingTime: null,
        corpusHitRate: null
      },
      
      // 加载状态
      loading: false,
      historyLoading: false,
      
      // 翻译历史
      historyList: [],
      
      // 语言映射
      languageMap: {
        'auto': '自动',
        'zh': '中文',
        'en': '英语',
        'ja': '日语',
        'ko': '韩语',
        'fr': '法语',
        'de': '德语',
        'es': '西班牙语'
      }
    }
  },
  created() {
    this.loadHistory()
  },
  methods: {
    /** 执行翻译 */
    handleTranslate() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.loading = true
          translate(this.form).then(response => {
            if (response.code === 200) {
              this.translationResult = response.data
              this.$message.success("翻译完成")
              this.loadHistory()
            } else {
              this.$message.error(response.msg || "翻译失败")
            }
          }).catch(() => {
            this.$message.error("翻译失败")
          }).finally(() => {
            this.loading = false
          })
        }
      })
    },
    
    /** 交换语言 */
    handleSwap() {
      if (this.form.sourceLanguage === 'auto') {
        this.$message.warning("自动检测语言无法交换")
        return
      }
      
      const temp = this.form.sourceLanguage
      this.form.sourceLanguage = this.form.targetLanguage
      this.form.targetLanguage = temp
      
      // 交换文本内容
      const tempText = this.form.sourceText
      this.form.sourceText = this.translationResult.targetText
      this.translationResult.targetText = tempText
    },
    
    /** 清空原文 */
    clearSource() {
      this.form.sourceText = ""
      this.translationResult.targetText = ""
      this.translationResult.confidenceScore = null
      this.translationResult.processingTime = null
      this.translationResult.corpusHitRate = null
    },
    
    /** 清空译文 */
    clearTarget() {
      this.translationResult.targetText = ""
    },
    
    /** 复制译文 */
    copyTarget() {
      if (this.translationResult.targetText) {
        this.$copyText(this.translationResult.targetText).then(() => {
          this.$message.success("已复制到剪贴板")
        }).catch(() => {
          this.$message.error("复制失败")
        })
      } else {
        this.$message.warning("没有可复制的内容")
      }
    },
    
    /** 原文输入事件 */
    onSourceInput() {
      // 可以在这里添加自动翻译逻辑
    },
    
    /** 目标语言改变事件 */
    onTargetLanguageChange() {
      // 如果有原文，可以自动重新翻译
    },
    
    /** 加载翻译历史 */
    loadHistory() {
      this.historyLoading = true
      getTranslationHistory(20).then(response => {
        if (response.code === 200) {
          this.historyList = response.data || []
        }
      }).catch(() => {
        this.$message.error("加载历史记录失败")
      }).finally(() => {
        this.historyLoading = false
      })
    },
    
    /** 刷新历史 */
    refreshHistory() {
      this.loadHistory()
    },
    
    /** 点击历史记录 */
    handleHistoryClick(row) {
      this.form.sourceText = row.sourceText
      this.form.sourceLanguage = row.sourceLanguage
      this.form.targetLanguage = row.targetLanguage
      this.translationResult.targetText = row.targetText
      this.translationResult.confidenceScore = row.confidenceScore
      this.translationResult.processingTime = row.processingTime
    },
    
    /** 获取语言名称 */
    getLanguageName(code) {
      return this.languageMap[code] || code
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e8f5e9 100%);
  min-height: 100vh;
}

/* 翻译卡片通用样式 */
.translation-card {
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  transition: all 0.3s ease;
  height: 100%;
}

.translation-card:hover {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

/* 卡片头部 */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 24px;
  background: linear-gradient(135deg, #2E7D32 0%, #66BB6A 100%);
  border-bottom: none;
}

.target-header {
  background: linear-gradient(135deg, #0277BD 0%, #29B6F6 100%);
}

.history-header {
  background: linear-gradient(135deg, #5D4037 0%, #8D6E63 100%);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-icon {
  width: 36px;
  height: 36px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(10px);
}

.header-icon i {
  font-size: 18px;
  color: #ffffff;
}

.header-title {
  font-size: 16px;
  font-weight: 600;
  color: #ffffff;
}

.header-actions {
  display: flex;
  gap: 8px;
}

.clear-btn,
.action-btn,
.refresh-btn {
  color: rgba(255, 255, 255, 0.9) !important;
  font-size: 13px;
  padding: 6px 12px;
  border-radius: 6px;
  transition: all 0.3s ease;
}

.clear-btn:hover,
.action-btn:hover,
.refresh-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  color: #ffffff !important;
}

/* 卡片内容 */
.card-body {
  padding: 24px;
}

/* 表单样式 */
::v-deep .el-form-item__label {
  color: #5D4037;
  font-weight: 500;
}

::v-deep .el-select {
  width: 100%;
}

::v-deep .el-select .el-input__inner {
  border-radius: 10px;
  border: 2px solid #e8e8e8;
  transition: all 0.3s ease;
}

::v-deep .el-select .el-input__inner:focus {
  border-color: #66BB6A;
  box-shadow: 0 0 0 3px rgba(102, 187, 106, 0.1);
}

::v-deep .el-select .el-input.is-focus .el-input__inner {
  border-color: #66BB6A;
}

/* 文本框样式 */
::v-deep .custom-textarea .el-textarea__inner {
  border-radius: 12px;
  border: 2px solid #e8e8e8;
  padding: 16px;
  font-size: 14px;
  line-height: 1.6;
  transition: all 0.3s ease;
  resize: none;
}

::v-deep .custom-textarea .el-textarea__inner:focus {
  border-color: #66BB6A;
  box-shadow: 0 0 0 3px rgba(102, 187, 106, 0.1);
}

::v-deep .result-textarea .el-textarea__inner {
  background: linear-gradient(135deg, #f8fffe 0%, #f0f9ff 100%);
}

::v-deep .result-textarea .el-textarea__inner:focus {
  border-color: #29B6F6;
  box-shadow: 0 0 0 3px rgba(41, 182, 246, 0.1);
}

/* 按钮样式 */
.translate-btn {
  background: linear-gradient(135deg, #2E7D32 0%, #66BB6A 100%);
  border: none;
  color: #ffffff;
  padding: 12px 32px;
  border-radius: 10px;
  font-weight: 600;
  font-size: 14px;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(46, 125, 50, 0.3);
}

.translate-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(46, 125, 50, 0.4);
  background: linear-gradient(135deg, #1B5E20 0%, #4CAF50 100%);
}

.translate-btn:active {
  transform: translateY(0);
}

.swap-btn {
  background: #ffffff;
  border: 2px solid #66BB6A;
  color: #2E7D32;
  padding: 12px 24px;
  border-radius: 10px;
  font-weight: 600;
  font-size: 14px;
  transition: all 0.3s ease;
  margin-left: 12px;
}

.swap-btn:hover {
  background: linear-gradient(135deg, #E8F5E9 0%, #C8E6C9 100%);
  border-color: #4CAF50;
  transform: translateY(-2px);
}

/* 翻译信息标签 */
.translation-info {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 12px;
}

.info-tag {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
}

.confidence-tag {
  background: linear-gradient(135deg, #E8F5E9 0%, #C8E6C9 100%);
  color: #2E7D32;
}

.time-tag {
  background: linear-gradient(135deg, #E3F2FD 0%, #BBDEFB 100%);
  color: #0277BD;
}

.corpus-tag {
  background: linear-gradient(135deg, #FFF3E0 0%, #FFE0B2 100%);
  color: #E65100;
}

/* 历史记录卡片 */
.history-card {
  margin-top: 24px;
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}

/* 表格样式 */
::v-deep .custom-table {
  border-radius: 0;
}

::v-deep .custom-table .el-table__header-wrapper th {
  background: linear-gradient(135deg, #EFEBE9 0%, #D7CCC8 100%);
  color: #5D4037;
  font-weight: 600;
  padding: 14px 0;
  border-bottom: none;
}

::v-deep .custom-table .el-table__row {
  transition: all 0.3s ease;
  cursor: pointer;
}

::v-deep .custom-table .el-table__row:hover > td {
  background: linear-gradient(135deg, #f8fffe 0%, #f0f9ff 100%) !important;
}

::v-deep .custom-table td {
  padding: 14px 0;
  border-bottom: 1px solid #f0f0f0;
}

.history-text {
  max-height: 40px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  color: #424242;
  font-size: 13px;
  line-height: 1.5;
}

.language-tag {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 4px 12px;
  background: linear-gradient(135deg, #E8F5E9 0%, #C8E6C9 100%);
  color: #2E7D32;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 500;
}

.language-tag i {
  font-size: 10px;
}

.time-text {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: #757575;
  font-size: 13px;
}

.time-text i {
  color: #9e9e9e;
}

.status-tag {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 4px 12px;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 500;
}

.status-success {
  background: linear-gradient(135deg, #E8F5E9 0%, #C8E6C9 100%);
  color: #2E7D32;
}

.status-fail {
  background: linear-gradient(135deg, #FFEBEE 0%, #FFCDD2 100%);
  color: #C62828;
}

/* 响应式适配 */
@media (max-width: 1200px) {
  .el-col {
    margin-bottom: 20px;
  }
  
  .translation-info {
    gap: 8px;
  }
  
  .info-tag {
    padding: 4px 10px;
    font-size: 11px;
  }
}
</style>
