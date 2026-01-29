<template>
  <div class="app-container">
    <h1>土壤信息页面 - 测试版本</h1>
    <p>如果你能看到这个页面，说明路由配置正常</p>
    <el-button type="primary" @click="testAPI">测试API</el-button>
    <p v-if="apiResult">API返回结果: {{ apiResult }}</p>
  </div>
</template>

<script>
export default {
  name: "SoilTest",
  data() {
    return {
      apiResult: null
    }
  },
  methods: {
    testAPI() {
      this.$message.info('测试按钮点击成功')
      this.apiResult = 'API测试完成'
    }
  }
}
</script>
