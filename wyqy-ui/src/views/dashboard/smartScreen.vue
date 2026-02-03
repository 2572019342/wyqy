<template>
  <div class="smart-screen-container">
    <div class="loading-container" v-if="loading">
      <el-loading-spinner></el-loading-spinner>
      <p>正在加载智慧大屏...</p>
    </div>
    <div class="iframe-container" v-else>
      <iframe
        :src="smartScreenUrl"
        frameborder="0"
        width="100%"
        height="100%"
        @load="handleIframeLoad"
        @error="handleIframeError"
      ></iframe>
    </div>
    <div class="error-container" v-if="error">
      <el-alert
        title="加载失败"
        type="error"
        :description="errorMessage"
        show-icon
        :closable="false"
      >
      </el-alert>
      <el-button type="primary" @click="retry" class="retry-btn">重试</el-button>
    </div>
  </div>
</template>

<script>
export default {
  name: "SmartScreen",
  data() {
    return {
      loading: true,
      error: false,
      errorMessage: "",
      smartScreenUrl: "http://192.168.1.105:1145"
    };
  },
  created() {
    // 预检查连接
    this.checkConnection();
  },
  methods: {
    checkConnection() {
      // 可以添加连接检查逻辑
      this.loading = false;
    },
    handleIframeLoad() {
      this.loading = false;
      this.error = false;
      console.log("智慧大屏加载成功");
    },
    handleIframeError() {
      this.loading = false;
      this.error = true;
      this.errorMessage = "无法连接到智慧大屏服务器，请检查网络连接或服务器状态。";
      console.error("智慧大屏加载失败");
    },
    retry() {
      this.loading = true;
      this.error = false;
      this.checkConnection();
    }
  }
};
</script>

<style scoped>
.smart-screen-container {
  width: 100%;
  height: calc(100vh - 120px);
  position: relative;
  background: #f5f5f5;
}

.loading-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100%;
  color: #666;
}

.loading-container p {
  margin-top: 20px;
  font-size: 16px;
}

.iframe-container {
  width: 100%;
  height: 100%;
  position: relative;
}

.iframe-container iframe {
  width: 100%;
  height: 100%;
  border: none;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.error-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100%;
  padding: 20px;
}

.error-container .el-alert {
  max-width: 600px;
  margin-bottom: 20px;
}

.retry-btn {
  margin-top: 10px;
}
</style>
