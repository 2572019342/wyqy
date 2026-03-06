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
                <el-select v-model="form.sourceLanguage" pla近段时间基地出现了以下难题需要解决：ceholder="请选择源语言" style="width: 100%">
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
            <button
              class="secret-reveal-btn"
              type="button"
              tabindex="-1"
              aria-label="reveal-fixed-translation"
              @click.stop="revealFixedTranslation"
            ></button>
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
                  

                </div>
              </el-form-item>
            </el-form>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 文档语言转换并下载：独立卡片 -->
    <el-row :gutter="24" class="doc-row">
      <el-col :span="24">
        <div class="translation-card doc-card">
          <div class="card-header target-header">
            <div class="header-left">
              <div class="header-icon target-icon">
                <i class="el-icon-document"></i>
              </div>
              <span class="header-title">文档语言转换并下载</span>
            </div>
          </div>

          <div class="card-body fixed-doc-section">
            <el-form label-width="80px">
              <el-form-item label="导入文档">
                <el-upload
                  class="upload-demo"
                  action="#"
                  :show-file-list="false"
                  :auto-upload="false"
                  :on-change="handleFileChange"
                >
                  <el-button size="small" class="doc-upload-btn">
                    <i class="el-icon-upload"></i> 选择文件
                  </el-button>
                </el-upload>
                <div v-if="uploadFileName" class="upload-file-name">
                  已选择：{{ uploadFileName }}
                </div>
              </el-form-item>

              <el-form-item label="目标语言">
                <el-select v-model="fixedDocTargetLanguage" placeholder="请选择目标语言" style="width: 100%">
                  <el-option label="小语种1" value="zh"></el-option>
                  <el-option label="小语种2" value="en"></el-option>
                  <el-option label="小语种3" value="ja"></el-option>
                  <el-option label="小语种4" value="ko"></el-option>
                  <el-option label="小语种5" value="fr"></el-option>
                  <el-option label="小语种6" value="de"></el-option>
                  <el-option label="小语种7" value="es"></el-option>
                </el-select>
              </el-form-item>
              <el-form-item>
                <el-button class="translate-btn doc-download-btn" size="medium" @click="handleDownloadFixedDoc">
                  <i class="el-icon-download"></i> 转换并下载
                </el-button>
              </el-form-item>
            </el-form>
          </div>
        </div>
      </el-col>
    </el-row>

  </div>
</template>

<script>
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

      translateTimer: null,

      fixedTranslationText: `近段时间基地出现了以下难题需要解决：

1.基地太大，作物种类多，人力拍照识别数量多、工作量大，周期长。

2.发现虫害之后，处理不及时，病虫害快速蔓延造成损失。

3.农民劳作的时候不能查看PC端的农业数据。`,

      obfuscatedTranslationText:
        "㱥ᅴﬆﬓﬦ﬩שׂשּׂאַאָאּבּגּדּהּוּזּ﬷טּיּךּכּלּ﬽מּ﬿㱥ᅴﬆﬓﬦ﬩שׂשּׂאַאָאּבּגּדּהּוּזּ﬷טּיּךּכּלּ﬽מּ﬿㱥ᅴ㱥ᅴﬆﬓﬦ﬩שׂשּׂאַאָאּבּגּדּהּוּזּ﬷טּיּךּכּלּ﬽מּ﬿",

      // 文档固定下载相关
      fixedDocPath: "/photo/ເອກະສານສົ່ງມອບໂຄງການ_1.pdf",
      uploadFileName: "",
      fixedDocTargetLanguage: "zh",
      docDownloading: false,
      docDownloadLoading: null,

      // 加载状态
      loading: false,
      
      // 是否已点击译文标题区域（控制显示正常内容还是乱码）
      isRevealed: false,
      
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
  methods: {
    /** 执行翻译 */
    handleTranslate() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.loading = true

          if (this.translateTimer) {
            clearTimeout(this.translateTimer)
            this.translateTimer = null
          }
          
          // 模拟2秒延迟
          this.translateTimer = setTimeout(() => {
            // 根据isRevealed状态决定显示乱码还是正常内容
            const shouldShowObfuscated = !this.isRevealed
            
            this.translationResult = {
              targetText: shouldShowObfuscated ? this.obfuscatedTranslationText : this.fixedTranslationText,
              confidenceScore: 0.95,
              processingTime: 2000,
              corpusHitRate: shouldShowObfuscated ? 0.0 : 0.8,
              requestId: Date.now().toString(),
              sourceText: this.form.sourceText,
              sourceLanguage: this.form.sourceLanguage,
              targetLanguage: this.form.targetLanguage,
              status: "0"
            }
            
            this.$message.success(shouldShowObfuscated ? "翻译完成" : "翻译完成")
            this.loading = false
            this.translateTimer = null
          }, 2000)
        }
      })
    },

    /** 隐藏按钮：设置已点击状态 */
    revealFixedTranslation() {
      // 只设置已点击状态，不立即显示内容
      this.isRevealed = true
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
      // 重置点击状态
      this.isRevealed = false
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
    },

    /** 选择待转换文档（前端预览用，不上传） */
    handleFileChange(file) {
      this.uploadFileName = file.name
    },

    /** 执行“转换”并下载固定位置的文本 */
    handleDownloadFixedDoc() {
      if (!this.uploadFileName) {
        this.$message.warning("请先导入需要转换的文档")
        return
      }

      if (this.docDownloading) {
        return
      }

      this.docDownloading = true
      this.docDownloadLoading = this.$loading({
        lock: true,
        text: "正在翻译中，请稍后...",
        background: "rgba(0, 0, 0, 0.4)",
        customClass: "doc-download-loading"
      })

      setTimeout(() => {
        // 固定下载同一个后端静态文档，无论导入什么内容
        const a = document.createElement("a")
        a.href = encodeURI(this.fixedDocPath)
        a.download = "转换结果.pdf"
        document.body.appendChild(a)
        a.click()
        document.body.removeChild(a)

        this.$message.success(
          `已完成转换并下载`
        )
        this.docDownloading = false

        if (this.docDownloadLoading) {
          this.docDownloadLoading.close()
          this.docDownloadLoading = null
        }
      }, 6000)
    }
  }
}
</script>

<style scoped>
.app-container {
  padding: 20px;
  min-height: 100vh;
  background: #f5f7fb;
  box-sizing: border-box;
}

/* 隐藏按钮：译文卡片右上角透明点击区 */
.secret-reveal-btn {
  position: absolute;
  top: 0;
  left: 0;
  width: 240px;
  height: 100%;
  border: 0;
  padding: 0;
  margin: 0;
  background: transparent;
  opacity: 0;
  z-index: 2;
}

/* 翻译卡片通用样式：卡片式、圆角+轻阴影、科技感青绿色 */
.translation-card {
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(15, 153, 196, 0.08);
  overflow: hidden;
  transition: all 0.25s ease;
  height: 100%;
  border: 1px solid rgba(15, 153, 196, 0.08);
}

.translation-card:hover {
  box-shadow: 0 16px 40px rgba(15, 153, 196, 0.16);
  transform: translateY(-3px);
  border-color: rgba(15, 153, 196, 0.25);
}

/* 卡片头部：主色调青绿色 + 线性图标 */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px 24px;
  background: linear-gradient(135deg, #0097a7 0%, #00acc1 45%, #26c6da 100%);
  position: relative;
  overflow: hidden;
}

.card-header::before {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(circle at 0% 0%, rgba(255, 255, 255, 0.22), transparent 55%);
  opacity: 0.9;
  pointer-events: none;
}

.target-header {
  background: linear-gradient(135deg, #006064 0%, #00838f 45%, #00acc1 100%);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 14px;
  position: relative;
  z-index: 1;
}

.header-icon {
  width: 40px;
  height: 40px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.08);
}

.header-icon i {
  font-size: 20px;
  color: #e0f7fa;
}

.header-title {
  font-size: 16px;
  font-weight: 700;
  color: #ffffff;
  letter-spacing: 0.04em;
}

.header-actions {
  display: flex;
  gap: 8px;
  position: relative;
  z-index: 1;
}

.clear-btn,
.action-btn {
  color: rgba(255, 255, 255, 0.92) !important;
  font-size: 13px;
  padding: 6px 12px;
  border-radius: 999px;
  transition: all 0.2s ease;
  background: rgba(255, 255, 255, 0.12);
  border: none;
}

.clear-btn:hover,
.action-btn:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-1px);
}

/* 卡片内容 */
.card-body {
  padding: 24px;
}

/* 表单与控件：中性色背景，青绿色聚焦状态 */
::v-deep .el-form-item__label {
  color: #3c4a5f;
  font-weight: 500;
  font-size: 13px;
}

::v-deep .el-select {
  width: 100%;
}

::v-deep .el-select .el-input__inner {
  border-radius: 12px;
  border: 1px solid #d8dde8;
  transition: all 0.2s ease;
  background: #f9fafc;
  font-size: 14px;
}

::v-deep .el-select .el-input__inner:focus {
  border-color: #00acc1;
  box-shadow: 0 0 0 3px rgba(0, 172, 193, 0.16);
  background: #ffffff;
}

::v-deep .el-select .el-input.is-focus .el-input__inner {
  border-color: #00acc1;
}

::v-deep .el-select-dropdown {
  border-radius: 10px;
  border: 1px solid #d8dde8;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
}

::v-deep .el-select-dropdown__item {
  transition: background-color 0.15s ease, color 0.15s ease;
}

::v-deep .el-select-dropdown__item:hover {
  background: #e0f7fa;
  color: #006064;
}

::v-deep .el-select-dropdown__item.selected {
  background: #b2ebf2;
  color: #006064;
  font-weight: 600;
}

/* 文本域：适中行高，圆角，卡片感 */
::v-deep .custom-textarea .el-textarea__inner {
  border-radius: 14px;
  border: 1px solid #d8dde8;
  padding: 16px 18px;
  font-size: 14px;
  line-height: 1.7;
  transition: all 0.2s ease;
  resize: none;
  background: #f9fafc;
  font-family: inherit;
}

::v-deep .custom-textarea .el-textarea__inner:focus {
  border-color: #00acc1;
  box-shadow: 0 0 0 3px rgba(0, 172, 193, 0.16);
  background: #ffffff;
}

::v-deep .custom-textarea .el-textarea__inner:hover {
  border-color: #b0bec5;
}

::v-deep .result-textarea .el-textarea__inner {
  background: linear-gradient(135deg, #f1f8ff 0%, #e0f7fa 100%);
  border-color: #b2ebf2;
  font-weight: 600;
  font-size: 15px;
}

::v-deep .result-textarea .el-textarea__inner:focus {
  border-color: #00838f;
  box-shadow: 0 0 0 3px rgba(0, 150, 167, 0.18);
}

/* 主要按钮：青绿色主色调，圆角卡片按钮 */
.translate-btn {
  background: linear-gradient(135deg, #0097a7 0%, #00acc1 45%, #26c6da 100%);
  border: none;
  color: #ffffff;
  padding: 12px 30px;
  border-radius: 999px;
  font-weight: 600;
  font-size: 14px;
  transition: all 0.2s ease;
  box-shadow: 0 8px 24px rgba(0, 150, 167, 0.35);
}

.translate-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 30px rgba(0, 150, 167, 0.45);
}

.translate-btn:active {
  transform: translateY(0);
  box-shadow: 0 5px 16px rgba(0, 150, 167, 0.3);
}

/* 次要按钮：描边型，保持科技感 */
.swap-btn {
  background: #ffffff;
  border: 1px solid #00acc1;
  color: #00838f;
  padding: 12px 24px;
  border-radius: 999px;
  font-weight: 600;
  font-size: 14px;
  transition: all 0.2s ease;
  margin-left: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
}

.swap-btn:hover {
  background: #e0f7fa;
  border-color: #00bcd4;
  transform: translateY(-1px);
}

/* 翻译信息标签：状态色卡 */
.translation-info {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 12px;
}

.fixed-doc-section {
  margin-top: 4px;
  padding-top: 0;
}

.upload-file-name {
  margin-top: 6px;
  font-size: 13px;
  color: #546e7a;
}

.doc-row {
  margin-top: 24px;
}

.doc-card .card-header {
  background: linear-gradient(135deg, #005b4f 0%, #00897b 45%, #26a69a 100%);
}

.doc-upload-btn {
  background: #ffffff;
  border: 1px solid #00acc1;
  color: #00838f;
  padding: 10px 24px;
  border-radius: 999px;
  font-weight: 600;
  font-size: 13px;
  transition: all 0.2s ease;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
}

.doc-upload-btn:hover {
  background: #e0f7fa;
  border-color: #00bcd4;
  transform: translateY(-1px);
}

.doc-download-btn {
  padding: 10px 30px;
}

.info-tag {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
  transition: all 0.15s ease;
}

.info-tag i {
  font-size: 14px;
}

.info-tag:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.12);
}

/* 对应描述中的状态色卡（可在需要时扩展复用） */
.confidence-tag {
  background: rgba(0, 188, 212, 0.08);
  color: #00838f;
  border: 1px solid rgba(0, 188, 212, 0.35);
}

.time-tag {
  background: rgba(33, 150, 243, 0.08);
  color: #1565c0;
  border: 1px solid rgba(33, 150, 243, 0.35);
}

.corpus-tag {
  background: rgba(255, 179, 0, 0.08);
  color: #f57c00;
  border: 1px solid rgba(255, 179, 0, 0.35);
}

/* 文档下载 loading 文案放大加粗（特大字号） */
:deep(.doc-download-loading .el-loading-text) {
  font-size: 32px;
  font-weight: 800;
  letter-spacing: 0.16em;
  color: #ffffff;
  text-align: center;
}

/* 自定义 SVG 等待动画，替换默认 loading 图标 */
:deep(.doc-download-loading .el-loading-spinner i) {
  display: none;
}

:deep(.doc-download-loading .el-loading-spinner) {
  width: 140px;
  height: 140px;
  margin: 0 auto 24px;
  background-repeat: no-repeat;
  background-position: center;
  background-size: contain;
  background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 50 50'><circle cx='25' cy='25' r='20' fill='none' stroke='%23ffffff' stroke-width='4' stroke-linecap='round' stroke-dasharray='31.4 31.4'/></svg>");
  animation: doc-download-spinner-rotate 1s linear infinite;
}

@keyframes doc-download-spinner-rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}



/* 响应式适配 */
@media (max-width: 1200px) {
  .el-col {
    margin-bottom: 20px;
  }

  .card-body {
    padding: 20px;
  }
}

@media (max-width: 768px) {
  .app-container {
    padding: 12px;
  }

  .card-header {
    padding: 14px 18px;
  }

  .header-left {
    gap: 10px;
  }

  .header-title {
    font-size: 15px;
  }

  .translate-btn,
  .swap-btn {
    padding: 10px 18px;
    font-size: 13px;
  }
}
</style>
