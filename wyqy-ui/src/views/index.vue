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
          icon: "el-icon-s-operation",
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
  padding: 24px;
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
  min-height: calc(100vh - 84px);
}

.dashboard-header {
  margin-bottom: 28px;

  .welcome-panel {
    padding: 24px 28px;
    border-radius: 16px;
    background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
    color: #fff;
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    position: relative;
    overflow: hidden;
    transition: transform 0.3s ease, box-shadow 0.3s ease;

    &::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -50%;
      width: 200%;
      height: 200%;
      background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
      animation: shimmer 3s ease-in-out infinite;
    }

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 25px 30px -5px rgba(0, 0, 0, 0.15), 0 15px 15px -5px rgba(0, 0, 0, 0.06);
    }

    .title {
      margin: 0 0 12px;
      font-size: 26px;
      font-weight: 700;
      letter-spacing: 0.5px;
      text-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .subtitle {
      margin: 0;
      font-size: 15px;
      opacity: 0.95;
      line-height: 1.6;
      position: relative;
      z-index: 1;

      .highlight {
        font-weight: 600;
        background: linear-gradient(90deg, #fbbf24 0%, #f59e0b 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        padding: 0 2px;
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
  margin-bottom: 20px;
}

.stat-card {
  display: flex;
  align-items: center;
  border-radius: 16px;
  overflow: hidden;
  background: #ffffff;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(229, 231, 235, 0.5);
  position: relative;

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, transparent 0%, rgba(255,255,255,0.1) 100%);
    opacity: 0;
    transition: opacity 0.3s ease;
  }

  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    border-color: rgba(34, 197, 94, 0.3);

    &::before {
      opacity: 1;
    }

    .stat-icon {
      transform: scale(1.1);
    }
  }

  .stat-icon {
    width: 52px;
    height: 52px;
    border-radius: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 16px;
    font-size: 24px;
    color: #fff;
    transition: transform 0.3s ease;
    position: relative;
    box-shadow: 0 8px 16px -4px rgba(0, 0, 0, 0.15);

    &::before {
      content: '';
      position: absolute;
      inset: 0;
      border-radius: 18px;
      background: inherit;
      filter: blur(8px);
      opacity: 0.4;
      z-index: -1;
    }

    &.agriculture {
      background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    }

    &.translation {
      background: linear-gradient(135deg, #f59e0b 0%, #dc2626 100%);
    }
  }

  .stat-content {
    flex: 1;

    .stat-label {
      font-size: 13px;
      color: #6b7280;
      margin-bottom: 6px;
      font-weight: 500;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .stat-value {
      font-size: 22px;
      font-weight: 700;
      color: #1f2937;
      margin-bottom: 4px;
      line-height: 1.2;
      background: linear-gradient(135deg, #1f2937 0%, #374151 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .stat-desc {
      font-size: 12px;
      color: #9ca3af;
      line-height: 1.4;
    }
  }
}

.chart-row {
  margin-top: 20px;

  .chart-card {
    border-radius: 16px;
    background: #ffffff;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
    border: 1px solid rgba(229, 231, 235, 0.5);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);

    &:hover {
      box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
      border-color: rgba(34, 197, 94, 0.2);
    }

    .chart-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      font-size: 15px;
      font-weight: 600;
      color: #1f2937;
      padding: 16px 20px;
      border-bottom: 1px solid rgba(229, 231, 235, 0.5);
      background: linear-gradient(135deg, #f9fafb 0%, #f3f4f6 100%);
      border-radius: 16px 16px 0 0;
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
      border-left: 4px solid #10b981;
      background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
      
      .pest-header {
        .pest-title {
          display: inline-flex;
          align-items: center;
          gap: 10px;
          font-weight: 600;
          color: #1f2937;
          font-size: 15px;
          
          i {
            font-size: 20px;
            color: #10b981;
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
          }
        }
      }
      
      .pest-stats {
        display: flex;
        align-items: center;
        justify-content: space-around;
        padding: 16px 20px;
        margin-bottom: 12px;
        background: linear-gradient(135deg, rgba(16, 185, 129, 0.08) 0%, rgba(5, 150, 105, 0.04) 100%);
        border-radius: 12px;
        border: 1px solid rgba(16, 185, 129, 0.1);
        backdrop-filter: blur(10px);
      }
      
      .pest-stat-item {
        text-align: center;
        transition: transform 0.2s ease;
        
        &:hover {
          transform: scale(1.05);
        }
        
        .pest-stat-value {
          display: block;
          font-size: 18px;
          font-weight: 700;
          color: #10b981;
          line-height: 1.3;
          text-shadow: 0 1px 2px rgba(16, 185, 129, 0.1);
        }
        
        .pest-stat-label {
          font-size: 12px;
          color: #6b7280;
          font-weight: 500;
          margin-top: 2px;
        }
      }
      
      .pest-stat-divider {
        width: 1px;
        height: 32px;
        background: linear-gradient(180deg, transparent 0%, rgba(107, 114, 128, 0.3) 50%, transparent 100%);
      }
      
      .pest-tree-wrapper {
        max-height: 260px;
        padding: 8px;
        background: rgba(249, 250, 251, 0.5);
        border-radius: 8px;
        border: 1px solid rgba(229, 231, 235, 0.3);
      }
      
      .pest-tree {
        background: transparent;
        
        .el-tree-node__content {
          height: 40px;
          border-radius: 8px;
          margin: 3px 0;
          transition: all 0.2s ease;
          border: 1px solid transparent;
        }
        
        .el-tree-node__content:hover {
          background: linear-gradient(135deg, rgba(16, 185, 129, 0.08) 0%, rgba(5, 150, 105, 0.04) 100%);
          border-color: rgba(16, 185, 129, 0.2);
          transform: translateX(2px);
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
          width: 10px;
          height: 10px;
          border-radius: 50%;
          flex-shrink: 0;
          box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
          
          &.dot-pest {
            background: linear-gradient(135deg, #f59e0b 0%, #dc2626 100%);
          }
          
          &.dot-disease {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
          }
          
          &.dot-record {
            background: linear-gradient(135deg, #22c55e 0%, #10b981 100%);
          }
          
          &.dot-root {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
          }
          
          &.dot-default {
            background: linear-gradient(135deg, #9ca3af 0%, #6b7280 100%);
          }
        }
        
        .node-label {
          font-size: 14px;
          color: #374151;
          font-weight: 500;
        }
        
        .node-meta {
          font-size: 12px;
          color: #10b981;
          font-weight: 600;
          background: rgba(16, 185, 129, 0.1);
          padding: 2px 8px;
          border-radius: 12px;
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
    padding: 16px;
  }

  .chart-row .chart-card .chart-wrapper {
    height: 280px;
  }

  .dashboard-header .welcome-panel {
    padding: 20px;
    
    .title {
      font-size: 22px;
    }
    
    .subtitle {
      font-size: 14px;
    }
  }

  .stat-card {
    margin-bottom: 12px;
    
    .stat-icon {
      width: 48px;
      height: 48px;
      font-size: 22px;
    }
    
    .stat-content .stat-value {
      font-size: 20px;
    }
  }
}

@keyframes shimmer {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>

