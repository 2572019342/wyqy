<template>
  <div class="dashboard-container">
    <!-- 顶部欢迎区 -->
    <el-row :gutter="20" class="dashboard-header">
      <el-col :xs="24" :md="16">
        <div class="welcome-panel">
          <h2 class="title">沃野千言 综合管理驾驶舱</h2>
          <p class="subtitle">
            一眼洞察
            <span class="highlight">农业生产运行</span> 与
            <span class="highlight">翻译业务负载</span>
            的核心态势。
          </p>
        </div>
      </el-col>
 
    </el-row>

    <!-- 指标总览（静态演示数据） -->
    <el-row :gutter="20" class="stat-row">
      <el-col :xs="12" :sm="6" v-for="card in statCards" :key="card.key">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-icon" :class="card.theme">
            <i :class="card.icon"></i>
          </div>
          <div class="stat-content">
            <div class="stat-label">{{ card.label }}</div>
            <div class="stat-value">
              <count-to :start-val="0" :end-val="card.value" :duration="1600" />
            </div>
            <div class="stat-desc">{{ card.desc }}</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 中部：农业饼图 + AI 病虫害识别 -->
    <el-row :gutter="20" class="chart-row">
      <el-col :xs="24" :md="14">
        <el-card shadow="hover" class="chart-card">
          <div slot="header" class="chart-header">
            <span>农业生产结构</span>
          </div>
          <div class="chart-wrapper">
            <div ref="agricultureChart" class="chart-container"></div>
          </div>

        </el-card>
      </el-col>

      <el-col :xs="24" :md="10">
        <el-card shadow="hover" class="chart-card pest-card">
          <div slot="header" class="chart-header pest-header">
            <span class="pest-title">
              <i class="el-icon-cpu"></i>
              AI 病虫害识别
            </span>
          </div>
          <div class="pest-stats">
            <div class="pest-stat-item">
              <span class="pest-stat-value">28</span>
              <span class="pest-stat-label">今日识别</span>
            </div>
            <div class="pest-stat-divider"></div>
            <div class="pest-stat-item">
              <span class="pest-stat-value">94.2%</span>
              <span class="pest-stat-label">平均置信度</span>
            </div>
            <div class="pest-stat-divider"></div>
            <div class="pest-stat-item">
              <span class="pest-stat-value">156</span>
              <span class="pest-stat-label">已处理</span>
            </div>
          </div>
          <div class="tree-wrapper pest-tree-wrapper">
            <el-tree
              :data="pestTree"
              node-key="id"
              :props="{ children: 'children', label: 'label' }"
              default-expand-all
              highlight-current
              class="pest-tree"
            >
              <span slot-scope="{ data }" class="custom-tree-node">
                <span class="node-left">
                  <span class="node-dot" :class="'dot-' + (data.type || 'default')"></span>
                  <span class="node-label">{{ data.label }}</span>
                </span>
                <span class="node-meta" v-if="data.count !== undefined">
                  {{ data.count }} 次
                </span>
              </span>
            </el-tree>
          </div>

        </el-card>
      </el-col>
    </el-row>

    <!-- 底部：翻译工作量趋势折线图 -->
    <el-row :gutter="20" class="chart-row">
      <el-col :xs="24">
        <el-card shadow="hover" class="chart-card">
          <div slot="header" class="chart-header">
            <span>翻译工作量趋势</span>
          </div>
          <div class="chart-wrapper small">
            <div ref="translationChart" class="chart-container"></div>
          </div>

        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from "echarts";
import CountTo from "vue-count-to";

export default {
  name: "Index",
  components: { CountTo },
  data() {
    return {
      version: "3.9.1",
      // 顶部卡片静态演示数据
      statCards: [
        {
          key: "land",
          label: "在管地块",
          value: 1280,
          icon: "el-icon-location-outline",
          theme: "agriculture",
          desc: "覆盖多种地块类型与种植模式"
        },
        {
          key: "crop",
          label: "作物品类",
          value: 367,
          icon: "el-icon-vegetables",
          theme: "agriculture",
          desc: "蔬菜、水果、粮食及经济作物"
        },
        {
          key: "translation",
          label: "年度翻译任务",
          value: 84265,
          icon: "el-icon-collection",
          theme: "translation",
          desc: "覆盖多语种多领域的翻译需求"
        },
        {
          key: "corpus",
          label: "语料库条目",
          value: 152305,
          icon: "el-icon-collection-tag",
          theme: "translation",
          desc: "高质量术语与双语句对沉淀"
        }
      ],
      // AI 病虫害识别树状结构静态演示数据
      pestTree: [
        {
          id: 1,
          label: "AI 病虫害识别",
          type: "root",
          children: [
            {
              id: 11,
              label: "虫害识别",
              type: "pest",
              count: 126,
              children: [
                { id: 111, label: "蚜虫", count: 42, type: "pest" },
                { id: 112, label: "红蜘蛛", count: 28, type: "pest" },
                { id: 113, label: "粉虱", count: 24, type: "pest" },
                { id: 114, label: "蓟马", count: 32, type: "pest" }
              ]
            },
            {
              id: 12,
              label: "病害识别",
              type: "disease",
              count: 84,
              children: [
                { id: 121, label: "叶斑病", count: 26, type: "disease" },
                { id: 122, label: "霜霉病", count: 18, type: "disease" },
                { id: 123, label: "白粉病", count: 22, type: "disease" },
                { id: 124, label: "炭疽病", count: 18, type: "disease" }
              ]
            },
            {
              id: 13,
              label: "识别记录",
              type: "record",
              count: 210,
              children: [
                { id: 131, label: "待处理", count: 54, type: "record" },
                { id: 132, label: "已处理", count: 156, type: "record" }
              ]
            }
          ]
        }
      ],
      charts: {
        agriculture: null,
        translation: null
      }
    };
  },
  mounted() {
    this.$nextTick(() => {
      this.renderAgricultureChart();
      this.renderTranslationChart();
      window.addEventListener("resize", this.handleResize);
    });
  },
  beforeDestroy() {
    window.removeEventListener("resize", this.handleResize);
    if (this.charts.agriculture) {
      this.charts.agriculture.dispose();
    }
    if (this.charts.translation) {
      this.charts.translation.dispose();
    }
  },
  methods: {
    /** 农业：作物类型占比饼图（静态演示数据） */
    renderAgricultureChart() {
      const dom = this.$refs.agricultureChart;
      if (!dom) return;

      if (!this.charts.agriculture) {
        this.charts.agriculture = echarts.init(dom);
      }

      const option = {
        tooltip: {
          trigger: "item"
        },
        legend: {
          top: 10,
          textStyle: { color: "#666" }
        },
        color: ["#67C23A", "#409EFF", "#E6A23C", "#F56C6C"],
        series: [
          {
            name: "作物类型占比",
            type: "pie",
            radius: ["35%", "70%"],
            center: ["50%", "60%"],
            data: [
              { value: 45, name: "蔬菜" },
              { value: 26, name: "水果" },
              { value: 18, name: "粮食" },
              { value: 11, name: "经济作物" }
            ],
            label: {
              formatter: "{b}\n{d}%",
              fontSize: 12
            }
          }
        ]
      };

      this.charts.agriculture.setOption(option);
    },
    /** 翻译：工作量趋势折线图（静态演示数据） */
    renderTranslationChart() {
      const dom = this.$refs.translationChart;
      if (!dom) return;

      if (!this.charts.translation) {
        this.charts.translation = echarts.init(dom);
      }

      const option = {
        tooltip: {
          trigger: "axis"
        },
        grid: {
          left: "3%",
          right: "4%",
          bottom: "5%",
          containLabel: true
        },
        xAxis: {
          type: "category",
          boundaryGap: false,
          data: ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
        },
        yAxis: {
          type: "value"
        },
        series: [
          {
            name: "完成任务数",
            type: "line",
            smooth: true,
            symbol: "circle",
            symbolSize: 6,
            lineStyle: {
              color: "#409EFF",
              width: 3
            },
            itemStyle: {
              color: "#409EFF"
            },
            areaStyle: {
              color: "rgba(64,158,255,0.18)"
            },
            data: [96, 112, 138, 124, 158, 172, 146]
          }
        ]
      };

      this.charts.translation.setOption(option);
    },
    handleResize() {
      if (this.charts.agriculture) {
        this.charts.agriculture.resize();
      }
      if (this.charts.translation) {
        this.charts.translation.resize();
      }
    }
  }
};
</script>

<style scoped lang="scss">
.dashboard-container {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 84px);
}

.dashboard-header {
  margin-bottom: 20px;

  .welcome-panel {
    padding: 18px 20px;
    border-radius: 14px;
    background: radial-gradient(circle at top left, #42b983, #1d8cf8);
    color: #fff;
    box-shadow: 0 12px 20px -10px rgba(29, 140, 248, 0.6);

    .title {
      margin: 0 0 10px;
      font-size: 22px;
      font-weight: 600;
    }

    .subtitle {
      margin: 0;
      font-size: 14px;
      opacity: 0.9;

      .highlight {
        font-weight: 600;
        border-bottom: 1px dashed rgba(255, 255, 255, 0.7);
      }
    }
  }

  .version-card {
    border-radius: 14px;

    .version-main {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
      margin-bottom: 8px;

      .label {
        font-size: 13px;
        color: #909399;
      }

      .value {
        font-size: 20px;
        font-weight: 600;
        color: #303133;
      }
    }

    .version-extra {
      font-size: 12px;
      color: #909399;
      display: flex;
      align-items: center;

      .dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        margin-right: 6px;

        &.online {
          background: #67c23a;
          box-shadow: 0 0 0 6px rgba(103, 194, 58, 0.25);
        }
      }
    }
  }
}

.stat-row {
  margin-bottom: 10px;
}

.stat-card {
  display: flex;
  align-items: center;
  border-radius: 14px;
  overflow: hidden;

  .stat-icon {
    width: 46px;
    height: 46px;
    border-radius: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 14px;
    font-size: 22px;
    color: #fff;

    &.agriculture {
      background: linear-gradient(135deg, #67c23a, #3eb575);
    }

    &.translation {
      background: linear-gradient(135deg, #e6a23c, #f56c6c);
    }
  }

  .stat-content {
    flex: 1;

    .stat-label {
      font-size: 13px;
      color: #909399;
      margin-bottom: 4px;
    }

    .stat-value {
      font-size: 20px;
      font-weight: 600;
      color: #303133;
      margin-bottom: 2px;
      line-height: 1.2;
    }

    .stat-desc {
      font-size: 12px;
      color: #c0c4cc;
    }
  }
}

.chart-row {
  margin-top: 10px;

  .chart-card {
    border-radius: 14px;

    .chart-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      font-size: 14px;
      font-weight: 500;
    }

    .chart-wrapper {
      position: relative;
      height: 320px;

      &.small {
        height: 260px;
      }
    }

    .chart-container {
      width: 100%;
      height: 100%;
    }

    .tree-wrapper {
      max-height: 320px;
      overflow: auto;
      padding: 4px 0;
    }

    .translation-tree {
      background: transparent;
    }

    /* AI 病虫害识别卡片样式 */
    &.pest-card {
      border-left: 4px solid #67c23a;
      .pest-header {
        .pest-title {
          display: inline-flex;
          align-items: center;
          gap: 8px;
          font-weight: 600;
          color: #303133;
          i {
            font-size: 18px;
            color: #67c23a;
          }
        }
      }
      .pest-stats {
        display: flex;
        align-items: center;
        justify-content: space-around;
        padding: 12px 16px;
        margin-bottom: 8px;
        background: linear-gradient(135deg, rgba(103, 194, 58, 0.08), rgba(64, 158, 255, 0.06));
        border-radius: 10px;
      }
      .pest-stat-item {
        text-align: center;
        .pest-stat-value {
          display: block;
          font-size: 16px;
          font-weight: 600;
          color: #67c23a;
          line-height: 1.3;
        }
        .pest-stat-label {
          font-size: 11px;
          color: #909399;
        }
      }
      .pest-stat-divider {
        width: 1px;
        height: 28px;
        background: rgba(144, 147, 153, 0.25);
      }
      .pest-tree-wrapper {
        max-height: 240px;
      }
      .pest-tree {
        background: transparent;
        .el-tree-node__content {
          height: 36px;
          border-radius: 6px;
          margin: 2px 0;
        }
        .el-tree-node__content:hover {
          background: rgba(103, 194, 58, 0.08);
        }
      }
      .custom-tree-node {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
        .node-left {
          display: inline-flex;
          align-items: center;
          gap: 8px;
        }
        .node-dot {
          width: 8px;
          height: 8px;
          border-radius: 50%;
          flex-shrink: 0;
          &.dot-pest {
            background: linear-gradient(135deg, #e6a23c, #f56c6c);
          }
          &.dot-disease {
            background: linear-gradient(135deg, #f56c6c, #c45656);
          }
          &.dot-record {
            background: linear-gradient(135deg, #409eff, #67c23a);
          }
          &.dot-root {
            background: linear-gradient(135deg, #67c23a, #3eb575);
          }
          &.dot-default {
            background: #c0c4cc;
          }
        }
        .node-label {
          font-size: 13px;
          color: #606266;
        }
        .node-meta {
          font-size: 12px;
          color: #67c23a;
          font-weight: 500;
        }
      }
    }

    .custom-tree-node {
      display: flex;
      justify-content: space-between;
      align-items: center;
      width: 100%;

      .node-label {
        font-size: 13px;
        color: #606266;
      }

      .node-meta {
        font-size: 12px;
        color: #909399;
      }
    }

    .chart-footer {
      margin-top: 10px;
      font-size: 12px;
      color: #c0c4cc;
    }
  }
}

@media (max-width: 768px) {
  .dashboard-container {
    padding: 10px;
  }

  .chart-row .chart-card .chart-wrapper {
    height: 260px;
  }
}
</style>

