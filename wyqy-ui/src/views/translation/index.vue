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
    
      </div>
</template>

<script>
import { translate } from "@/api/translation"

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
  },
  methods: {
    /** 执行翻译 */
    handleTranslate() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.loading = true
          
          // 模拟2秒延迟
          setTimeout(() => {
            // 设置固定的翻译结果
            this.translationResult = {
              targetText: `近段时间基地出现了以下难题需要解决：

1.基地太大，作物种类多，人力拍照识别数量多、工作量大，周期长。

2.发现虫害之后，处理不及时，病虫害快速蔓延造成损失。

3.农民劳作的时候不能查看PC端的农业数据。`,
              confidenceScore: 0.95,
              processingTime: 2000,
              corpusHitRate: 0.0,
              requestId: Date.now().toString(),
              sourceText: this.form.sourceText,
              sourceLanguage: this.form.sourceLanguage,
              targetLanguage: this.form.targetLanguage,
              status: "0"
            }
            
            this.$message.success("翻译完成")
            this.loading = false
          }, 2000)
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
  background: linear-gradient(135deg, #f8f9fa 0%, #e8f5e9 20%, #c8e6c9 100%);
  min-height: 100vh;
  position: relative;
}

.app-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="leaf" x="0" y="0" width="20" height="20" patternUnits="userSpaceOnUse"><path d="M10 2 Q5 8 10 18 Q15 8 10 2" fill="%2366bb6a" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23leaf)"/></svg>') repeat;
  opacity: 0.3;
  pointer-events: none;
}

/* 翻译卡片通用样式 */
.translation-card {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 20px;
  box-shadow: 0 8px 32px rgba(76, 175, 80, 0.15);
  overflow: hidden;
  transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
  height: 100%;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(76, 175, 80, 0.1);
}

.translation-card:hover {
  box-shadow: 0 12px 40px rgba(76, 175, 80, 0.25);
  transform: translateY(-4px);
  border-color: rgba(76, 175, 80, 0.2);
}

/* 卡片头部 */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 28px;
  background: linear-gradient(135deg, #2e7d32 0%, #43a047 50%, #66bb6a 100%);
  border-bottom: none;
  position: relative;
  overflow: hidden;
}

.card-header::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(45deg, transparent 30%, rgba(255, 255, 255, 0.1) 50%, transparent 70%);
  animation: shimmer 3s infinite;
}

@keyframes shimmer {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(100%); }
}

.target-header {
  background: linear-gradient(135deg, #1b5e20 0%, #388e3c 50%, #4caf50 100%);
}

.target-header::before {
  background: linear-gradient(45deg, transparent 30%, rgba(255, 255, 255, 0.15) 50%, transparent 70%);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
  position: relative;
  z-index: 1;
}

.header-icon {
  width: 44px;
  height: 44px;
  background: rgba(255, 255, 255, 0.25);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(15px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.header-icon i {
  font-size: 20px;
  color: #ffffff;
}

.header-title {
  font-size: 18px;
  font-weight: 700;
  color: #ffffff;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.header-actions {
  display: flex;
  gap: 10px;
  position: relative;
  z-index: 1;
}

.clear-btn,
.action-btn {
  color: rgba(255, 255, 255, 0.95) !important;
  font-size: 13px;
  padding: 8px 16px;
  border-radius: 8px;
  transition: all 0.3s ease;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
}

.clear-btn:hover,
.action-btn:hover {
  background: rgba(255, 255, 255, 0.25);
  color: #ffffff !important;
  transform: translateY(-1px);
}

/* 卡片内容 */
.card-body {
  padding: 28px;
}

/* 表单样式 */
::v-deep .el-form-item__label {
  color: #2e7d32;
  font-weight: 600;
  font-size: 14px;
}

::v-deep .el-select {
  width: 100%;
}

::v-deep .el-select .el-input__inner {
  border-radius: 12px;
  border: 2px solid #e8f5e9;
  transition: all 0.3s ease;
  background: rgba(255, 255, 255, 0.9);
  font-size: 14px;
}

::v-deep .el-select .el-input__inner:focus {
  border-color: #4caf50;
  box-shadow: 0 0 0 4px rgba(76, 175, 80, 0.15);
  background: #ffffff;
}

::v-deep .el-select .el-input.is-focus .el-input__inner {
  border-color: #4caf50;
}

::v-deep .el-select-dropdown {
  border: 1px solid #e8f5e9;
  border-radius: 12px;
  box-shadow: 0 8px 24px rgba(76, 175, 80, 0.15);
}

::v-deep .el-select-dropdown__item {
  transition: all 0.2s ease;
}

::v-deep .el-select-dropdown__item:hover {
  background: #e8f5e9;
  color: #2e7d32;
}

::v-deep .el-select-dropdown__item.selected {
  background: #c8e6c9;
  color: #1b5e20;
  font-weight: 600;
}

/* 文本框样式 */
::v-deep .custom-textarea .el-textarea__inner {
  border-radius: 16px;
  border: 2px solid #e8f5e9;
  padding: 20px;
  font-size: 15px;
  line-height: 1.7;
  transition: all 0.3s ease;
  resize: none;
  background: rgba(255, 255, 255, 0.9);
  font-family: inherit;
}

::v-deep .custom-textarea .el-textarea__inner:focus {
  border-color: #4caf50;
  box-shadow: 0 0 0 4px rgba(76, 175, 80, 0.15);
  background: #ffffff;
}

::v-deep .custom-textarea .el-textarea__inner:hover {
  border-color: #66bb6a;
}

::v-deep .result-textarea .el-textarea__inner {
  background: linear-gradient(135deg, #f1f8e9 0%, #e8f5e9 100%);
  border-color: #c8e6c9;
  font-weight: 600;
  font-size: 16px;
}

::v-deep .result-textarea .el-textarea__inner:focus {
  border-color: #388e3c;
  box-shadow: 0 0 0 4px rgba(56, 142, 60, 0.15);
}

/* 按钮样式 */
.translate-btn {
  background: linear-gradient(135deg, #2e7d32 0%, #43a047 50%, #66bb6a 100%);
  border: none;
  color: #ffffff;
  padding: 14px 36px;
  border-radius: 12px;
  font-weight: 700;
  font-size: 15px;
  transition: all 0.3s ease;
  box-shadow: 0 6px 20px rgba(46, 125, 50, 0.4);
  position: relative;
  overflow: hidden;
}

.translate-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.5s ease;
}

.translate-btn:hover::before {
  left: 100%;
}

.translate-btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 28px rgba(46, 125, 50, 0.5);
  background: linear-gradient(135deg, #1b5e20 0%, #388e3c 50%, #4caf50 100%);
}

.translate-btn:active {
  transform: translateY(-1px);
}

.swap-btn {
  background: linear-gradient(135deg, #ffffff 0%, #f1f8e9 100%);
  border: 2px solid #66bb6a;
  color: #2e7d32;
  padding: 14px 28px;
  border-radius: 12px;
  font-weight: 700;
  font-size: 15px;
  transition: all 0.3s ease;
  margin-left: 16px;
  box-shadow: 0 4px 12px rgba(102, 187, 106, 0.2);
}

.swap-btn:hover {
  background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
  border-color: #4caf50;
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(76, 175, 80, 0.3);
}

/* 翻译信息标签 */
.translation-info {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 16px;
}

.info-tag {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  border-radius: 24px;
  font-size: 13px;
  font-weight: 600;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: all 0.2s ease;
}

.info-tag:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.confidence-tag {
  background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
  color: #2e7d32;
  border: 1px solid #a5d6a7;
}

.time-tag {
  background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
  color: #1565c0;
  border: 1px solid #90caf9;
}

.corpus-tag {
  background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
  color: #e65100;
  border: 1px solid #ffcc80;
}

/* 响应式适配 */
@media (max-width: 1200px) {
  .el-col {
    margin-bottom: 24px;
  }
  
  .translation-info {
    gap: 12px;
  }
  
  .info-tag {
    padding: 6px 12px;
    font-size: 12px;
  }
  
  .card-body {
    padding: 20px;
  }
  
  .card-header {
    padding: 16px 20px;
  }
}

@media (max-width: 768px) {
  .app-container {
    padding: 12px;
  }
  
  .header-left {
    gap: 12px;
  }
  
  .header-icon {
    width: 36px;
    height: 36px;
  }
  
  .header-icon i {
    font-size: 16px;
  }
  
  .header-title {
    font-size: 16px;
  }
  
  .translate-btn,
  .swap-btn {
    padding: 12px 20px;
    font-size: 14px;
  }
}
</style>
