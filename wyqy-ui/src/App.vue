<template>
  <div id="app">
    <router-view />
    <theme-picker />
    <!-- 全局种植 AI 助手图标：除种植操作页外的所有页面显示 -->
    <global-planting-ai-icon v-if="$route.path !== '/agriculture/planting/operate' && $route.path !== '/login'" />
  </div>
</template>

<script>
import ThemePicker from "@/components/ThemePicker";
import GlobalPlantingAiIcon from "@/components/agriculture/GlobalPlantingAiIcon.vue";

export default {
  name: "App",
  components: { ThemePicker, GlobalPlantingAiIcon }
};
</script>
<style scoped>
#app .theme-picker {
  display: none;
}
</style>
