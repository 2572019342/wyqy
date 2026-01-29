<template>
  <div class="app-container">
    <h2>🌾 作物种类管理</h2>
    
    <!-- 查询条件 -->
    <el-card class="mb20">
      <div slot="header">
        <span>查询条件</span>
        <el-button style="float: right;" type="primary" @click="getList">查询</el-button>
      </div>
      <el-form :model="queryParams" ref="queryForm" :inline="true">
        <el-form-item label="作物名称">
          <el-input v-model="queryParams.speciesName" placeholder="请输入作物名称" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item label="作物编码">
          <el-input v-model="queryParams.speciesCode" placeholder="请输入作物编码" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item label="作物分类">
          <el-select v-model="queryParams.category" placeholder="请选择作物分类" clearable style="width: 200px">
            <el-option label="粮食作物" value="粮食作物" />
            <el-option label="经济作物" value="经济作物" />
            <el-option label="蔬菜作物" value="蔬菜作物" />
            <el-option label="水果作物" value="水果作物" />
          </el-select>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 作物种类列表 -->
    <el-card>
      <div slot="header">
        <span>作物种类列表</span>
        <el-button style="float: right;" type="primary" @click="handleAdd">新增</el-button>
      </div>
      
      <el-table :data="cropList" v-loading="loading" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column prop="speciesName" label="作物名称" />
        <el-table-column prop="speciesCode" label="作物编码" />
        <el-table-column prop="scientificName" label="学名" />
        <el-table-column prop="category" label="分类" />
        <el-table-column prop="growthCycle" label="生长周期(天)" />
        <el-table-column prop="estimatedYield" label="预期产量(kg/亩)" />
        <el-table-column prop="diseaseResistance" label="抗病性" />
        <el-table-column prop="status" label="状态">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === '0' ? 'success' : 'danger'">
              {{ scope.row.status === '0' ? '正常' : '停用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180">
          <template slot-scope="scope">
            <el-button size="mini" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <!-- 统计信息 -->
    <el-row :gutter="20" class="mt20">
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-title">总种类数</div>
            <div class="stat-value">{{ total }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-title">正常状态</div>
            <div class="stat-value">{{ normalCount }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-title">粮食作物</div>
            <div class="stat-value">{{ grainCount }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-title">经济作物</div>
            <div class="stat-value">{{ economicCount }}</div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { listCrop, getCrop, delCrop, addCrop, updateCrop } from "@/api/agriculture/crop";

export default {
  name: "Crop",
  data() {
    return {
      loading: false,
      ids: [],
      total: 0,
      cropList: [],
      normalCount: 0,
      grainCount: 0,
      economicCount: 0,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        speciesName: null,
        speciesCode: null,
        category: null
      }
    }
  },
  created() {
    console.log('作物种类页面初始化')
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listCrop(this.queryParams).then(response => {
        console.log('作物API返回数据:', response);
        if (response && response.rows) {
          this.cropList = response.rows || [];
          this.total = response.total || 0;
          this.calculateStats();
        } else {
          this.cropList = [];
          this.total = 0;
          this.normalCount = 0;
          this.grainCount = 0;
          this.economicCount = 0;
        }
        this.loading = false;
      }).catch(error => {
        console.error('作物API调用失败:', error);
        this.$message.error('获取作物种类失败');
        this.loading = false;
      });
    },
    calculateStats() {
      this.normalCount = this.cropList.filter(item => item.status === '0').length;
      this.grainCount = this.cropList.filter(item => item.category === '粮食作物').length;
      this.economicCount = this.cropList.filter(item => item.category === '经济作物').length;
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.speciesId)
    },
    handleAdd() {
      this.$message.info('新增作物功能待实现')
    },
    handleUpdate(row) {
      this.$message.info('修改作物功能待实现')
    },
    handleDelete(row) {
      const cropIds = row.speciesId || this.ids;
      this.$confirm('是否确认删除作物编号为"' + cropIds + '"的数据项?', "警告", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      }).then(() => {
        return delCrop(cropIds).then(() => {
          this.getList();
          this.$message.success("删除成功");
        });
      }).catch(() => {
        this.$message.error('删除失败');
      });
    }
  }
}
</script>

<style scoped>
.mb20 {
  margin-bottom: 20px;
}
.mt20 {
  margin-top: 20px;
}
.stat-card {
  text-align: center;
}
.stat-content {
  padding: 20px;
}
.stat-title {
  font-size: 14px;
  color: #666;
  margin-bottom: 10px;
}
.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #409eff;
}
</style>
