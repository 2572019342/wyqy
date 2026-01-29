<template>
  <div class="app-container">
    <h1>🔧 土壤信息页面 - 调试版本</h1>
    <p>组件路径：agriculture/soil/debug.vue</p>
    <p>如果你能看到这个页面，说明组件加载正常</p>
    <el-button type="primary" @click="test">测试按钮</el-button>
  </div>
</template>

<script>
export default {
  name: "SoilDebug",
  methods: {
    test() {
      this.$message.success('调试页面工作正常!')
    }
  }
}
</script>
