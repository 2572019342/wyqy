<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
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
      <el-form-item label="源语言" prop="sourceLanguage">
        <el-select v-model="queryParams.sourceLanguage" placeholder="请选择源语言" clearable>
          <el-option label="英语" value="en" />
          <el-option label="中文" value="zh" />
          <el-option label="日语" value="ja" />
          <el-option label="韩语" value="ko" />
          <el-option label="法语" value="fr" />
          <el-option label="德语" value="de" />
          <el-option label="西班牙语" value="es" />
        </el-select>
      </el-form-item>
      <el-form-item label="目标语言" prop="targetLanguage">
        <el-select v-model="queryParams.targetLanguage" placeholder="请选择目标语言" clearable>
          <el-option label="英语" value="en" />
          <el-option label="中文" value="zh" />
          <el-option label="日语" value="ja" />
          <el-option label="韩语" value="ko" />
          <el-option label="法语" value="fr" />
          <el-option label="德语" value="de" />
          <el-option label="西班牙语" value="es" />
        </el-select>
      </el-form-item>
      <el-form-item label="领域类型" prop="domainType">
        <el-select v-model="queryParams.domainType" placeholder="请选择领域类型" clearable>
          <el-option label="通用" value="general" />
          <el-option label="商务" value="business" />
          <el-option label="技术" value="technical" />
          <el-option label="医学" value="medical" />
          <el-option label="法律" value="legal" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option label="正常" value="0" />
          <el-option label="停用" value="1" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
        >修改</el-button>
      </el-col>
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
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="corpusList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="语料库ID" align="center" prop="corpusId" width="80" />
      <el-table-column label="原文" align="center" prop="sourceText" :show-overflow-tooltip="true" min-width="200" />
      <el-table-column label="译文" align="center" prop="targetText" :show-overflow-tooltip="true" min-width="200" />
      <el-table-column label="语言" align="center" width="120">
        <template slot-scope="scope">
          <el-tag size="mini">{{ getLanguageName(scope.row.sourceLanguage) }} → {{ getLanguageName(scope.row.targetLanguage) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="领域类型" align="center" prop="domainType" width="100">
        <template slot-scope="scope">
          <el-tag :type="getDomainTypeTag(scope.row.domainType)" size="mini">{{ getDomainTypeName(scope.row.domainType) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="使用次数" align="center" prop="usageCount" width="80" />
      <el-table-column label="准确度" align="center" width="100">
        <template slot-scope="scope">
          <el-progress :percentage="Math.round(scope.row.accuracyScore * 100)" :color="getAccuracyColor(scope.row.accuracyScore)" :stroke-width="6"></el-progress>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status" width="80">
        <template slot-scope="scope">
          <el-switch
            v-model="scope.row.status"
            active-value="0"
            inactive-value="1"
            @change="handleStatusChange(scope.row)"
          ></el-switch>
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
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
          >修改</el-button>
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

    <!-- 添加或修改语料库对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="源语言" prop="sourceLanguage">
              <el-select v-model="form.sourceLanguage" placeholder="请选择源语言">
                <el-option label="英语" value="en" />
                <el-option label="中文" value="zh" />
                <el-option label="日语" value="ja" />
                <el-option label="韩语" value="ko" />
                <el-option label="法语" value="fr" />
                <el-option label="德语" value="de" />
                <el-option label="西班牙语" value="es" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="目标语言" prop="targetLanguage">
              <el-select v-model="form.targetLanguage" placeholder="请选择目标语言">
                <el-option label="英语" value="en" />
                <el-option label="中文" value="zh" />
                <el-option label="日语" value="ja" />
                <el-option label="韩语" value="ko" />
                <el-option label="法语" value="fr" />
                <el-option label="德语" value="de" />
                <el-option label="西班牙语" value="es" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="领域类型" prop="domainType">
              <el-select v-model="form.domainType" placeholder="请选择领域类型">
                <el-option label="通用" value="general" />
                <el-option label="商务" value="business" />
                <el-option label="技术" value="technical" />
                <el-option label="医学" value="medical" />
                <el-option label="法律" value="legal" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="准确度评分" prop="accuracyScore">
              <el-input-number v-model="form.accuracyScore" :min="0" :max="1" :step="0.01" :precision="2" placeholder="0.00-1.00" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="原文" prop="sourceText">
          <el-input v-model="form.sourceText" type="textarea" :rows="4" placeholder="请输入原文" />
        </el-form-item>
        <el-form-item label="译文" prop="targetText">
          <el-input v-model="form.targetText" type="textarea" :rows="4" placeholder="请输入译文" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio label="0">正常</el-radio>
            <el-radio label="1">停用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listTranslationCorpus, getTranslationCorpus, delTranslationCorpus, addTranslationCorpus, updateTranslationCorpus } from "@/api/translation"

export default {
  name: "TranslationCorpus",
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
      // 语料库表格数据
      corpusList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        sourceText: null,
        targetText: null,
        sourceLanguage: null,
        targetLanguage: null,
        domainType: null,
        status: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        sourceText: [
          { required: true, message: "原文不能为空", trigger: "blur" }
        ],
        targetText: [
          { required: true, message: "译文不能为空", trigger: "blur" }
        ],
        sourceLanguage: [
          { required: true, message: "源语言不能为空", trigger: "change" }
        ],
        targetLanguage: [
          { required: true, message: "目标语言不能为空", trigger: "change" }
        ],
        domainType: [
          { required: true, message: "领域类型不能为空", trigger: "change" }
        ],
        accuracyScore: [
          { required: true, message: "准确度评分不能为空", trigger: "blur" }
        ]
      },
      
      // 语言映射
      languageMap: {
        'zh': '中文',
        'en': '英语',
        'ja': '日语',
        'ko': '韩语',
        'fr': '法语',
        'de': '德语',
        'es': '西班牙语'
      },
      
      // 领域类型映射
      domainTypeMap: {
        'general': '通用',
        'business': '商务',
        'technical': '技术',
        'medical': '医学',
        'legal': '法律'
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** 查询语料库列表 */
    getList() {
      this.loading = true
      listTranslationCorpus(this.queryParams).then(response => {
        this.corpusList = response.rows
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
        corpusId: null,
        sourceText: null,
        targetText: null,
        sourceLanguage: null,
        targetLanguage: null,
        domainType: null,
        usageCount: null,
        accuracyScore: 0.95,
        status: "0",
        delFlag: null,
        createBy: null,
        createTime: null,
        updateBy: null,
        updateTime: null,
        remark: null
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
      this.resetForm("queryForm")
      this.handleQuery()
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.corpusId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "添加语料库"
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset()
      const corpusId = row.corpusId || this.ids
      getTranslationCorpus(corpusId).then(response => {
        this.form = response.data
        this.open = true
        this.title = "修改语料库"
      })
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.corpusId != null) {
            updateTranslationCorpus(this.form).then(response => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addTranslationCorpus(this.form).then(response => {
              this.$modal.msgSuccess("新增成功")
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const corpusIds = row.corpusId || this.ids
      this.$modal.confirm('是否确认删除语料库编号为"' + corpusIds + '"的数据项？').then(function() {
        return delTranslationCorpus(corpusIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    /** 状态修改 */
    handleStatusChange(row) {
      let text = row.status === "0" ? "启用" : "停用"
      this.$modal.confirm('确认要"' + text + '""' + row.sourceText + '"语料库吗？').then(function() {
        return updateTranslationCorpus(row)
      }).then(() => {
        this.$modal.msgSuccess(text + "成功")
      }).catch(function() {
        row.status = row.status === "0" ? "1" : "0"
      })
    },
    /** 获取语言名称 */
    getLanguageName(code) {
      return this.languageMap[code] || code
    },
    /** 获取领域类型名称 */
    getDomainTypeName(type) {
      return this.domainTypeMap[type] || type
    },
    /** 获取领域类型标签 */
    getDomainTypeTag(type) {
      const tagMap = {
        'general': '',
        'business': 'success',
        'technical': 'warning',
        'medical': 'danger',
        'legal': 'info'
      }
      return tagMap[type] || ''
    },
    /** 获取准确度颜色 */
    getAccuracyColor(score) {
      if (score >= 0.9) return '#67c23a'
      if (score >= 0.7) return '#e6a23c'
      return '#f56c6c'
    }
  }
}
</script>
