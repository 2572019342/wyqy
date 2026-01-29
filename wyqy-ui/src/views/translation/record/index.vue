<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="用户名" prop="userName">
        <el-input
          v-model="queryParams.userName"
          placeholder="请输入用户名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="原文" prop="sourceText">
        <el-input
          v-model="queryParams.sourceText"
          placeholder="请输入原文"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="译文" prop="targetText">
        <el-input
          v-model="queryParams.targetText"
          placeholder="请输入译文"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option label="成功" value="0" />
          <el-option label="失败" value="1" />
        </el-select>
      </el-form-item>
      <el-form-item label="创建时间">
        <el-date-picker
          v-model="dateRange"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="recordList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="记录ID" align="center" prop="recordId" width="80" />
      <el-table-column label="用户名" align="center" prop="userName" width="100" />
      <el-table-column label="原文" align="center" prop="sourceText" :show-overflow-tooltip="true" min-width="200" />
      <el-table-column label="译文" align="center" prop="targetText" :show-overflow-tooltip="true" min-width="200" />
      <el-table-column label="语言" align="center" width="120">
        <template slot-scope="scope">
          <el-tag size="mini">{{ getLanguageName(scope.row.sourceLanguage) }} → {{ getLanguageName(scope.row.targetLanguage) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="置信度" align="center" width="100">
        <template slot-scope="scope">
          <el-progress :percentage="Math.round(scope.row.confidenceScore * 100)" :color="getConfidenceColor(scope.row.confidenceScore)" :stroke-width="6"></el-progress>
        </template>
      </el-table-column>
      <el-table-column label="耗时(ms)" align="center" prop="processingTime" width="80" />
      <el-table-column label="状态" align="center" prop="status" width="80">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="160">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="120">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleDetail(scope.row)"
          >详情</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 详情对话框 -->
    <el-dialog title="翻译记录详情" :visible.sync="open" width="800px" append-to-body>
      <el-form ref="form" :model="form" label-width="100px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="记录ID">
              <el-input v-model="form.recordId" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="请求ID">
              <el-input v-model="form.requestId" disabled />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="用户名">
              <el-input v-model="form.userName" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="IP地址">
              <el-input v-model="form.ipAddress" disabled />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="源语言">
              <el-input v-model="form.sourceLanguage" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="目标语言">
              <el-input v-model="form.targetLanguage" disabled />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="翻译类型">
              <el-input v-model="form.translationType" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="处理时间">
              <el-input :value="form.processingTime + ' ms'" disabled />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="置信度">
              <el-input :value="(form.confidenceScore * 100).toFixed(1) + '%'" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态">
              <dict-tag :options="dict.type.sys_normal_disable" :value="form.status"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="原文">
          <el-input v-model="form.sourceText" type="textarea" :rows="4" disabled />
        </el-form-item>
        <el-form-item label="译文">
          <el-input v-model="form.targetText" type="textarea" :rows="4" disabled />
        </el-form-item>
        <el-form-item label="语料库使用" v-if="form.corpusUsed">
          <el-input v-model="form.corpusUsed" type="textarea" :rows="3" disabled />
        </el-form-item>
        <el-form-item label="错误信息" v-if="form.errorMessage">
          <el-input v-model="form.errorMessage" type="textarea" :rows="2" disabled />
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="浏览器">
              <el-input v-model="form.browser" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="操作系统">
              <el-input v-model="form.os" disabled />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="创建时间">
          <el-input :value="parseTime(form.createTime)" disabled />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listTranslationRecord, getTranslationRecord, delTranslationRecord } from "@/api/translation"

export default {
  name: "TranslationRecord",
  dicts: ['sys_normal_disable'],
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
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 翻译记录表格数据
      recordList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 日期范围
      dateRange: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userName: null,
        sourceText: null,
        targetText: null,
        status: null,
      },
      // 表单参数
      form: {},
      
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
    this.getList()
  },
  methods: {
    /** 查询翻译记录列表 */
    getList() {
      this.loading = true
      listTranslationRecord(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
        this.recordList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    // 取消按钮
    cancel() {
      this.open = false
      this.reset()
    },
    // 表单重置
    reset() {
      this.form = {
        recordId: null,
        requestId: null,
        sourceText: null,
        targetText: null,
        sourceLanguage: null,
        targetLanguage: null,
        translationType: null,
        corpusUsed: null,
        processingTime: null,
        confidenceScore: null,
        userId: null,
        userName: null,
        ipAddress: null,
        browser: null,
        os: null,
        status: null,
        errorMessage: null,
        createTime: null,
      }
      this.resetForm("form")
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.dateRange = []
      this.resetForm("queryForm")
      this.handleQuery()
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.recordId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 详情按钮操作 */
    handleDetail(row) {
      this.reset()
      const recordId = row.recordId || this.ids
      getTranslationRecord(recordId).then(response => {
        this.form = response.data
        this.open = true
        this.title = "翻译记录详情"
      })
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const recordIds = row.recordId || this.ids
      this.$modal.confirm('是否确认删除翻译记录编号为"' + recordIds + '"的数据项？').then(function() {
        return delTranslationRecord(recordIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('system/translation/record/export', {
        ...this.queryParams
      }, `translation_record_${new Date().getTime()}.xlsx`)
    },
    /** 获取语言名称 */
    getLanguageName(code) {
      return this.languageMap[code] || code
    },
    /** 获取置信度颜色 */
    getConfidenceColor(score) {
      if (score >= 0.9) return '#67c23a'
      if (score >= 0.7) return '#e6a23c'
      return '#f56c6c'
    }
  }
}
</script>
