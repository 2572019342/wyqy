<template>
  <div class="app-container">
    <h2>🏞️ 地块信息管理</h2>
    
    <!-- 查询条件 -->
    <el-card class="mb20">
      <div slot="header">
        <span>查询条件</span>
        <el-button style="float: right;" type="primary" @click="getList">查询</el-button>
      </div>
      <el-form :model="queryParams" ref="queryForm" :inline="true">
        <el-form-item label="地块名称">
          <el-input v-model="queryParams.landName" placeholder="请输入地块名称" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item label="土壤类型">
          <el-select v-model="queryParams.soilType" placeholder="请选择土壤类型" clearable style="width: 200px">
            <el-option label="壤土" value="壤土" />
            <el-option label="沙壤土" value="沙壤土" />
            <el-option label="黏土" value="黏土" />
          </el-select>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 地块列表 -->
    <el-card>
      <div slot="header">
        <span>地块信息列表</span>
        <el-button style="float: right;" type="primary" @click="handleAdd">新增</el-button>
      </div>
      
      <el-table :data="landList" v-loading="loading" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column prop="landName" label="地块名称" />
        <el-table-column prop="landCode" label="地块编码" />
        <el-table-column prop="landArea" label="面积(亩)" />
        <el-table-column prop="soilType" label="土壤类型" />
        <el-table-column prop="soilPh" label="土壤pH" />
        <el-table-column prop="location" label="位置" />
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
  </div>
</template>

<script>
import { listLand, getLand, delLand, addLand, updateLand } from "@/api/agriculture/land";

export default {
  name: "Land",
  data() {
    return {
      loading: false,
      ids: [],
      total: 0,
      landList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        landName: null,
        soilType: null
      }
    }
  },
  created() {
    console.log('地块信息页面初始化')
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listLand(this.queryParams).then(response => {
        console.log('地块API返回数据:', response);
        if (response && response.rows) {
          this.landList = response.rows || [];
          this.total = response.total || 0;
        } else {
          this.landList = [];
          this.total = 0;
        }
        this.loading = false;
      }).catch(error => {
        console.error('地块API调用失败:', error);
        this.$message.error('获取地块信息失败');
        this.loading = false;
      });
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.landId)
    },
    handleAdd() {
      this.$message.info('新增地块功能待实现')
    },
    handleUpdate(row) {
      this.$message.info('修改地块功能待实现')
    },
    handleDelete(row) {
      const landIds = row.landId || this.ids;
      this.$confirm('是否确认删除地块编号为"' + landIds + '"的数据项?', "警告", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      }).then(() => {
        return delLand(landIds).then(() => {
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
</style>
