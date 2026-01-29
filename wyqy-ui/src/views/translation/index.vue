<template>
  <div class="app-container">
    <el-row :gutter="20">
      <!-- 左侧：原文输入区 -->
      <el-col :span="12">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>原文</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="clearSource">清空</el-button>
          </div>
          
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
              ></el-input>
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" @click="handleTranslate" :loading="loading" size="medium">
                <i class="el-icon-s-promotion"></i> 翻译
              </el-button>
              <el-button @click="handleSwap" size="medium">
                <i class="el-icon-refresh"></i> 交换语言
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
      
      <!-- 右侧：译文显示区 -->
      <el-col :span="12">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>译文</span>
            <div style="float: right;">
              <el-button style="padding: 3px 0" type="text" @click="copyTarget">复制</el-button>
              <el-button style="padding: 3px 0; margin-left: 10px" type="text" @click="clearTarget">清空</el-button>
            </div>
          </div>
          
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
              ></el-input>
            </el-form-item>
            
            <el-form-item v-if="translationResult.confidenceScore">
              <div class="translation-info">
                <el-tag type="success" size="mini">
                  置信度: {{ (translationResult.confidenceScore * 100).toFixed(1) }}%
                </el-tag>
                <el-tag type="info" size="mini" style="margin-left: 10px">
                  耗时: {{ translationResult.processingTime }}ms
                </el-tag>
                <el-tag v-if="translationResult.corpusHitRate > 0" type="warning" size="mini" style="margin-left: 10px">
                  语料匹配: {{ (translationResult.corpusHitRate * 100).toFixed(1) }}%
                </el-tag>
              </div>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- 翻译历史 -->
    <el-row style="margin-top: 20px">
      <el-col :span="24">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>翻译历史</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="refreshHistory">刷新</el-button>
          </div>
          
          <el-table
            v-loading="historyLoading"
            :data="historyList"
            style="width: 100%"
            @row-click="handleHistoryClick"
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
              width="100"
              align="center"
            >
              <template slot-scope="scope">
                <el-tag size="mini">{{ getLanguageName(scope.row.sourceLanguage) }} → {{ getLanguageName(scope.row.targetLanguage) }}</el-tag>
              </template>
            </el-table-column>
            
            <el-table-column
              prop="createTime"
              label="时间"
              width="160"
              align="center"
            >
              <template slot-scope="scope">
                <span>{{ parseTime(scope.row.createTime) }}</span>
              </template>
            </el-table-column>
            
            <el-table-column
              prop="status"
              label="状态"
              width="80"
              align="center"
            >
              <template slot-scope="scope">
                <el-tag v-if="scope.row.status === '0'" type="success" size="mini">成功</el-tag>
                <el-tag v-else type="danger" size="mini">失败</el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
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
.box-card {
  height: 100%;
}

.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}

.clearfix:after {
  clear: both;
}

.translation-info {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
}

.history-text {
  max-height: 40px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.el-table .el-table__row:hover {
  cursor: pointer;
}
</style>
