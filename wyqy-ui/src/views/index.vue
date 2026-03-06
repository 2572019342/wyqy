<template>
  

    <!-- 主内容区 -->
    <main class="main-content">
      <!-- 顶部全局信息栏 -->
      <header class="top-bar">
        <div class="top-bar-left">
          <h1 class="page-title">{{ t('综合管理驾驶舱') }}</h1>
          <span class="page-subtitle">{{ t('仪表板概览') }}</span>
        </div>
        <div class="top-bar-right">
          <div class="info-item">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <circle cx="12" cy="12" r="10"/>
              <polyline points="12,6 12,12 16,14"/>
            </svg>
            <span class="info-value">{{ currentTime }}</span>
          </div>
          <div class="info-item">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <path d="M12 2v4m0 12v4M4.93 4.93l2.83 2.83m8.48 8.48l2.83 2.83M2 12h4m12 0h4M4.93 19.07l2.83-2.83m8.48-8.48l2.83-2.83"/>
            </svg>
            <span class="info-value">{{ temperature }}°C</span>
          </div>
        </div>
      </header>

      <!-- 数据看板内容 -->
      <div class="dashboard-body">
        <!-- 统计卡片区 -->
        <div class="stats-grid">
          <div v-for="card in statCards" :key="card.key" class="stat-card" :class="card.theme">
            <div class="stat-card-icon">
              <i :class="card.icon"></i>
            </div>
            <div class="stat-card-content">
              <div class="stat-card-label">{{ t(card.label) }}</div>
              <div class="stat-card-value">
                <count-to :start-val="0" :end-val="card.value" :duration="1600" />
              </div>
              <div class="stat-card-desc">{{ t(card.desc) }}</div>
            </div>
            <div class="stat-card-indicator"></div>
          </div>
        </div>

        <!-- 环境监控与设备状态 -->
        <div class="monitor-section">
          <!-- 环境监控 - 环形图 -->
          <div class="monitor-card environment-card">
            <div class="card-header">
              <div class="card-title">
                <div class="title-icon env-icon">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                    <path d="M12 2.69l5.66 5.66a8 8 0 11-11.31 0z"/>
                  </svg>
                </div>
                <span>{{ t('环境监控') }}</span>
              </div>
              <div class="env-status">
                <span class="status-dot pulse"></span>
                <span class="status-text">{{ t('正常') }}</span>
              </div>
            </div>
            <div class="environment-gauges">
              <div class="gauge-item temp-item">
                <div class="gauge-bg">
                  <div ref="tempGauge" class="gauge-chart"></div>
                  <div class="gauge-icon temp-icon-small">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M14 14.76V3.5a2.5 2.5 0 00-5 0v11.26a4.5 4.5 0 105 0z"/>
                    </svg>
                  </div>
                </div>
                <div class="gauge-info">
                  <span class="gauge-label">{{ t('温度') }}</span>
                  <span class="gauge-value">{{ temperature }}°C</span>
                  <span class="gauge-status">{{ t('适宜') }}</span>
                </div>
              </div>
              <div class="divider"></div>
              <div class="gauge-item humidity-item">
                <div class="gauge-bg">
                  <div ref="humidityGauge" class="gauge-chart"></div>
                  <div class="gauge-icon humidity-icon-small">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M12 2.69l5.66 5.66a8 8 0 11-11.31 0z"/>
                    </svg>
                  </div>
                </div>
                <div class="gauge-info">
                  <span class="gauge-label">{{ t('湿度') }}</span>
                  <span class="gauge-value">{{ humidity }}%</span>
                  <span class="gauge-status">{{ t('舒适') }}</span>
                </div>
              </div>
            </div>
            <div class="env-footer">
              <div class="env-metric">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <path d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707"/>
                </svg>
                <span>{{ t('光照: 充足') }}</span>
              </div>
              <div class="env-metric">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <circle cx="12" cy="12" r="10"/>
                  <path d="M16.24 7.76l-2.12 6.36-6.36 2.12 2.12-6.36 6.36-2.12z"/>
                </svg>
                <span>{{ t('CO₂: 正常') }}</span>
              </div>
            </div>
          </div>

          <!-- 设备状态 - 柱状图 -->
          <div class="monitor-card device-card">
            <div class="card-header">
              <div class="card-title">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <rect x="4" y="4" width="16" height="16" rx="2" ry="2"/>
                  <rect x="9" y="9" width="6" height="6"/>
                  <line x1="9" y1="1" x2="9" y2="4"/>
                  <line x1="15" y1="1" x2="15" y2="4"/>
                  <line x1="9" y1="20" x2="9" y2="23"/>
                  <line x1="15" y1="20" x2="15" y2="23"/>
                  <line x1="20" y1="9" x2="23" y2="9"/>
                  <line x1="20" y1="14" x2="23" y2="14"/>
                  <line x1="1" y1="9" x2="4" y2="9"/>
                  <line x1="1" y1="14" x2="4" y2="14"/>
                </svg>
                <span>{{ t('设备状态') }}</span>
              </div>
            </div>
            <div class="device-chart-wrapper">
              <div ref="deviceChart" class="device-chart"></div>
            </div>
            <!-- 状态色块标签 -->
            <div class="device-status-legend">
              <div class="status-tag status-normal">
                <span class="status-dot"></span>
                <span>{{ t('正常') }}</span>
                <span class="status-count">45</span>
              </div>
              <div class="status-tag status-testing">
                <span class="status-dot"></span>
                <span>{{ t('检测中') }}</span>
                <span class="status-count">8</span>
              </div>
              <div class="status-tag status-lent">
                <span class="status-dot"></span>
                <span>{{ t('借出') }}</span>
                <span class="status-count">12</span>
              </div>
              <div class="status-tag status-damage">
                <span class="status-dot"></span>
                <span>{{ t('损坏') }}</span>
                <span class="status-count">3</span>
              </div>
              <div class="status-tag status-loss">
                <span class="status-dot"></span>
                <span>{{ t('丢失') }}</span>
                <span class="status-count">1</span>
              </div>
              <div class="status-tag status-scrap">
                <span class="status-dot"></span>
                <span>{{ t('报废') }}</span>
                <span class="status-count">2</span>
              </div>
            </div>
            <!-- 底部汇总信息 -->
            <div class="device-summary">
              <div class="summary-row summary-main">
                <div class="summary-left">
                  <span class="summary-label">{{ t('设备总数') }}</span>
                  <span class="summary-value">{{ deviceSummary.total }} {{ t('台') }}</span>
                </div>
                <div class="summary-right">
                  <span class="summary-meta">{{ t('正常占比') }} {{ deviceSummary.normalRate }}%</span>
                </div>
              </div>
              <div class="summary-row summary-extra">
                <span class="extra-item">
                  <span class="extra-label">{{ t('需关注设备') }}</span>
                  <span class="extra-value">{{ deviceSummary.attentionCount }} {{ t('台') }}</span>
                  <span class="extra-hint">{{ t('损坏/丢失/报废') }}</span>
                </span>
                <span class="extra-divider"></span>
                <span class="extra-item">
                  <span class="extra-label">{{ t('数据更新于') }}</span>
                  <span class="extra-value">{{ t(deviceSummary.updateTime) }}</span>
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- 农业生产结构与AI识别 -->
        <div class="chart-section">
          <div class="chart-card agriculture-card">
            <div class="card-header">
              <div class="card-title">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <path d="M12 2.69l5.66 5.66a8 8 0 11-11.31 0z"/>
                </svg>
                <span>{{ t('农业生产结构') }}</span>
              </div>
            </div>
            <div class="chart-content">
              <div ref="agricultureChart" class="chart-container"></div>
            </div>
          </div>

          <div class="chart-card pest-card">
            <div class="card-header">
              <div class="card-title">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <path d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z"/>
                </svg>
                <span>{{ t('AI 病虫害识别') }}</span>
              </div>
              <div class="status-badge status-testing">{{ t('检测中') }}</div>
            </div>
            <div class="pest-stats">
              <div class="pest-stat-item">
                <span class="pest-stat-value">28</span>
                <span class="pest-stat-label">{{ t('今日识别') }}</span>
              </div>
              <div class="pest-stat-item">
                <span class="pest-stat-value">94.2%</span>
                <span class="pest-stat-label">{{ t('平均置信度') }}</span>
              </div>
              <div class="pest-stat-item">
                <span class="pest-stat-value">156</span>
                <span class="pest-stat-label">{{ t('已处理') }}</span>
              </div>
            </div>
            <div class="tree-wrapper">
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
                    <span class="node-label">{{ t(data.label) }}</span>
                  </span>
                  <span class="node-meta" v-if="data.count !== undefined">
                    {{ data.count }} {{ t('次') }}
                  </span>
                </span>
              </el-tree>
            </div>
          </div>
        </div>

        <!-- 趋势图表 -->
        <div class="trend-section">
          <div class="trend-card">
            <div class="card-header">
              <div class="card-title">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <polyline points="22,12 18,12 15,21 9,3 6,12 2,12"/>
                </svg>
                <span>{{ t('翻译工作量趋势') }}</span>
              </div>
              <div class="card-actions">
                <button class="action-btn active">{{ t('周') }}</button>
                <button class="action-btn">{{ t('月') }}</button>
                <button class="action-btn">{{ t('年') }}</button>
              </div>
            </div>
            <div class="trend-chart-wrapper">
              <div ref="translationChart" class="trend-chart"></div>
            </div>
          </div>
        </div>
      </div>
    </main>
</template>

<script>
import * as echarts from "echarts";
import CountTo from "vue-count-to";
import { t as tLang } from "@/utils/locales";

export default {
  name: "Index",
  components: { CountTo },
  data() {
    return {
      version: "3.9.1",
      currentTime: "",
      temperature: 24.5,
      humidity: 62,
      // 语言选项（与顶部导航保持一致）
      langs: [
        { value: "zh", label: "中" },
        { value: "en", label: "EN" },
        { value: "lo", label: "ລາວ" },
        { value: "ja", label: "日本語" },
        { value: "ko", label: "한국어" },
        { value: "th", label: "ไทย" },
        { value: "vi", label: "Tiếng Việt" },
        { value: "es", label: "Español" }
      ],
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
        translation: null,
        tempGauge: null,
        humidityGauge: null,
        device: null
      },
      timer: null
    };
  },
  computed: {
    // 当前语言从全局设置中读取，保持与导航栏一致
    currentLang() {
      return this.$store.state.settings.lang || "zh";
    },
    deviceSummary() {
      const normal = 45;
      const damaged = 3;
      const lost = 1;
      const scrap = 2;
      const total = 45 + 8 + 12 + damaged + lost + scrap;
      const normalRate = ((normal / total) * 100).toFixed(1);
      const attentionCount = damaged + lost + scrap;
      return {
        total,
        normalRate,
        attentionCount,
        updateTime: '今日'
      };
    }
  },
  mounted() {
    this.updateTime();
    this.timer = setInterval(this.updateTime, 1000);
    this.$nextTick(() => {
      this.renderTempGauge();
      this.renderHumidityGauge();
      this.renderDeviceChart();
      this.renderAgricultureChart();
      this.renderTranslationChart();
      window.addEventListener("resize", this.handleResize);
    });
  },
  beforeDestroy() {
    clearInterval(this.timer);
    window.removeEventListener("resize", this.handleResize);
    Object.keys(this.charts).forEach(key => {
      if (this.charts[key]) {
        this.charts[key].dispose();
      }
    });
  },
  methods: {
    // 简单翻译函数：调用公共 locales 工具
    t(key) {
      return tLang(key, this.currentLang);
    },
    setLang() {
      this.renderDeviceChart();
      this.renderAgricultureChart();
      this.renderTranslationChart();
    },
    updateTime() {
      const now = new Date();
      this.currentTime = now.toLocaleTimeString('zh-CN', { 
        hour: '2-digit', 
        minute: '2-digit', 
        second: '2-digit',
        hour12: false 
      });
    },
    
    /** 温度环形图 */
    renderTempGauge() {
      const dom = this.$refs.tempGauge;
      if (!dom) return;
      
      if (!this.charts.tempGauge) {
        this.charts.tempGauge = echarts.init(dom);
      }
      
      const option = {
        series: [
          {
            type: 'gauge',
            startAngle: 180,
            endAngle: 0,
            min: 0,
            max: 50,
            splitNumber: 5,
            radius: '90%',
            center: ['50%', '70%'],
            itemStyle: {
              color: '#14b8a6'
            },
            progress: {
              show: true,
              width: 8
            },
            pointer: {
              show: false
            },
            axisLine: {
              lineStyle: {
                width: 8,
                color: [[1, '#e2e8f0']]
              }
            },
            axisTick: {
              show: false
            },
            splitLine: {
              show: false
            },
            axisLabel: {
              show: false
            },
            detail: {
              show: false
            },
            data: [{ value: this.temperature }]
          }
        ]
      };
      
      this.charts.tempGauge.setOption(option);
    },
    
    /** 湿度环形图 */
    renderHumidityGauge() {
      const dom = this.$refs.humidityGauge;
      if (!dom) return;
      
      if (!this.charts.humidityGauge) {
        this.charts.humidityGauge = echarts.init(dom);
      }
      
      const option = {
        series: [
          {
            type: 'gauge',
            startAngle: 180,
            endAngle: 0,
            min: 0,
            max: 100,
            splitNumber: 5,
            radius: '90%',
            center: ['50%', '70%'],
            itemStyle: {
              color: '#38bdf8'
            },
            progress: {
              show: true,
              width: 8
            },
            pointer: {
              show: false
            },
            axisLine: {
              lineStyle: {
                width: 8,
                color: [[1, '#e2e8f0']]
              }
            },
            axisTick: {
              show: false
            },
            splitLine: {
              show: false
            },
            axisLabel: {
              show: false
            },
            detail: {
              show: false
            },
            data: [{ value: this.humidity }]
          }
        ]
      };
      
      this.charts.humidityGauge.setOption(option);
    },
    
    /** 设备状态柱状图 */
    renderDeviceChart() {
      const dom = this.$refs.deviceChart;
      if (!dom) return;
      
      if (!this.charts.device) {
        this.charts.device = echarts.init(dom);
      }
      
      const option = {
        tooltip: {
          trigger: 'axis',
          axisPointer: { type: 'shadow' }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          top: '10%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: [
            this.t('正常'),
            this.t('检测中'),
            this.t('借出'),
            this.t('损坏'),
            this.t('丢失'),
            this.t('报废')
          ],
          axisLine: { show: false },
          axisTick: { show: false },
          axisLabel: {
            fontSize: 13,
            color: '#64748b'
          }
        },
        yAxis: {
          type: 'value',
          axisLine: { show: false },
          axisTick: { show: false },
          splitLine: {
            lineStyle: {
              color: '#e2e8f0',
              type: 'dashed'
            }
          },
          axisLabel: {
            fontSize: 13,
            color: '#64748b'
          }
        },
        series: [{
          type: 'bar',
          barWidth: '50%',
          data: [
            { value: 45, itemStyle: { color: '#14b8a6', borderRadius: [4, 4, 0, 0] } },
            { value: 8, itemStyle: { color: '#38bdf8', borderRadius: [4, 4, 0, 0] } },
            { value: 12, itemStyle: { color: '#a78bfa', borderRadius: [4, 4, 0, 0] } },
            { value: 3, itemStyle: { color: '#fb7185', borderRadius: [4, 4, 0, 0] } },
            { value: 1, itemStyle: { color: '#fbbf24', borderRadius: [4, 4, 0, 0] } },
            { value: 2, itemStyle: { color: '#94a3b8', borderRadius: [4, 4, 0, 0] } }
          ]
        }]
      };
      
      this.charts.device.setOption(option);
    },
    
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
          bottom: 0,
          icon: 'circle',
          itemWidth: 8,
          itemHeight: 8,
          textStyle: { 
            color: "#64748b",
            fontSize: 14
          }
        },
        color: ["#14b8a6", "#38bdf8", "#a78bfa", "#fbbf24"],
        series: [
          {
            name: this.t("作物类型占比"),
            type: "pie",
            radius: ["45%", "70%"],
            center: ["50%", "45%"],
            avoidLabelOverlap: false,
            itemStyle: {
              borderRadius: 6,
              borderColor: '#fff',
              borderWidth: 2
            },
            label: {
              show: false
            },
            emphasis: {
              label: {
                show: true,
                fontSize: 16,
                fontWeight: 'bold',
                color: '#1e293b'
              }
            },
            data: [
              { value: 45, name: this.t("蔬菜") },
              { value: 26, name: this.t("水果") },
              { value: 18, name: this.t("粮食") },
              { value: 11, name: this.t("经济作物") }
            ]
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
          top: "8%",
          containLabel: true
        },
        xAxis: {
          type: "category",
          boundaryGap: false,
          data: [
            this.t("周一"),
            this.t("周二"),
            this.t("周三"),
            this.t("周四"),
            this.t("周五"),
            this.t("周六"),
            this.t("周日")
          ],
          axisLine: {
            lineStyle: { color: '#e2e8f0' }
          },
          axisLabel: {
            color: '#64748b',
            fontSize: 14
          }
        },
        yAxis: {
          type: "value",
          axisLine: { show: false },
          axisTick: { show: false },
          splitLine: {
            lineStyle: {
              color: '#e2e8f0',
              type: 'dashed'
            }
          },
          axisLabel: {
            color: '#64748b',
            fontSize: 14
          }
        },
        series: [
          {
            name: this.t("完成任务数"),
            type: "line",
            smooth: true,
            symbol: "circle",
            symbolSize: 6,
            lineStyle: {
              color: "#14b8a6",
              width: 3
            },
            itemStyle: {
              color: "#14b8a6",
              borderWidth: 2,
              borderColor: '#fff'
            },
            areaStyle: {
              color: {
                type: 'linear',
                x: 0, y: 0, x2: 0, y2: 1,
                colorStops: [
                  { offset: 0, color: 'rgba(20,184,166,0.3)' },
                  { offset: 1, color: 'rgba(20,184,166,0.05)' }
                ]
              }
            },
            data: [96, 112, 138, 124, 158, 172, 146]
          }
        ]
      };

      this.charts.translation.setOption(option);
    },
    handleResize() {
      Object.keys(this.charts).forEach(key => {
        if (this.charts[key]) {
          this.charts[key].resize();
        }
      });
    }
  }
};
</script>

<style scoped lang="scss">
// 色彩系统
$color-primary: #14b8a6;
$color-primary-light: #5eead4;
$color-primary-dark: #0d9488;
$color-blue: #38bdf8;
$color-purple: #a78bfa;
$color-red: #fb7185;
$color-yellow: #fbbf24;
$color-gray: #94a3b8;
$color-bg: #f1f5f9;
$color-surface: #ffffff;
$color-text-primary: #0f172a;
$color-text-secondary: #475569;
$color-text-tertiary: #64748b;
$color-border: #e2e8f0;

.industrial-dashboard {
  display: flex;
  min-height: 100vh;
  background: $color-bg;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
}

// 左侧导航栏
.sidebar {
  width: 200px;
  background: $color-surface;
  border-right: 1px solid $color-border;
  display: flex;
  flex-direction: column;
  position: fixed;
  height: 100vh;
  z-index: 100;

  .sidebar-logo {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 20px 24px;
    border-bottom: 1px solid $color-border;

    .logo-icon {
      width: 36px;
      height: 36px;
      background: linear-gradient(135deg, $color-primary 0%, $color-primary-dark 100%);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;

      svg {
        width: 20px;
        height: 20px;
      }
    }

    .logo-text {
      font-size: 18px;
      font-weight: 600;
      color: $color-text-primary;
    }
  }

  .sidebar-nav {
    padding: 16px 12px;

    .nav-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px 16px;
      border-radius: 8px;
      cursor: pointer;
      transition: all 0.2s ease;
      margin-bottom: 4px;

      svg {
        width: 18px;
        height: 18px;
        color: $color-text-tertiary;
        transition: color 0.2s ease;
      }

      span {
        font-size: 15px;
        color: $color-text-secondary;
        transition: color 0.2s ease;
      }

      &:hover {
        background: rgba(20, 184, 166, 0.08);

        svg, span {
          color: $color-primary;
        }
      }

      &.active {
        background: $color-primary;

        svg, span {
          color: white;
        }
      }
    }
  }
}

// 主内容区
.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

// 顶部信息栏
.top-bar {
  height: 64px;
  background: $color-surface;
  border-bottom: 1px solid $color-border;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 28px;
  position: sticky;
  top: 0;
  z-index: 50;

  .top-bar-left {
    display: flex;
    align-items: baseline;
    gap: 12px;

    .page-title {
      font-size: 22px;
      font-weight: 600;
      color: $color-text-primary;
      margin: 0;
    }

    .page-subtitle {
      font-size: 15px;
      color: $color-text-tertiary;
    }
  }

  .top-bar-right {
    display: flex;
    align-items: center;
    gap: 24px;

    .info-item {
      display: flex;
      align-items: center;
      gap: 8px;

      svg {
        width: 16px;
        height: 16px;
        color: $color-text-tertiary;
      }

      .info-value {
        font-size: 16px;
        font-weight: 500;
        color: $color-text-secondary;
        font-variant-numeric: tabular-nums;
      }
    }

    .right-menu {
      display: flex;
      align-items: center;
      gap: 8px;
      height: 100%;

      .right-menu-item {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 0 8px;
        height: 100%;
        font-size: 18px;
        color: $color-text-tertiary;
        cursor: pointer;
        transition: background 0.3s ease;
        border-radius: 6px;

        svg {
          width: 18px;
          height: 18px;
        }

        &.hover-effect {
          &:hover {
            background: rgba(0, 0, 0, 0.025);
            color: $color-primary;
          }
        }
      }

      .lang-switch {
        .lang-select {
          width: 120px;

          ::v-deep .el-input__inner {
            height: 36px;
            line-height: 36px;
            padding: 0 32px 0 12px;
            font-size: 15px;
            color: $color-text-secondary;
            border-color: $color-border;
            border-radius: 8px;
            transition: all 0.2s ease;

            &:hover {
              border-color: $color-primary;
            }
            &:focus {
              border-color: $color-primary;
              box-shadow: 0 0 0 2px rgba(20, 184, 166, 0.15);
            }
          }

          ::v-deep .el-input__suffix {
            .el-input__suffix-inner .el-icon-arrow-up {
              color: $color-text-tertiary;
              font-size: 13px;
            }
          }
        }
      }
    }
  }
}

// 语言选择下拉框样式（非 scoped，用于 popper）
// 数据看板主体
.dashboard-body {
  padding: 24px 28px;
  flex: 1;
}

// 统计卡片
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 24px;

  @media (max-width: 1200px) {
    grid-template-columns: repeat(2, 1fr);
  }

  @media (max-width: 768px) {
    grid-template-columns: 1fr;
  }
}

.stat-card {
  background: $color-surface;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: flex-start;
  gap: 16px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  border: 1px solid $color-border;
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  }

  .stat-card-icon {
    width: 48px;
    height: 48px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 26px;
    color: white;
    flex-shrink: 0;

    i {
      font-weight: 500;
    }
  }

  &.agriculture .stat-card-icon {
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-dark 100%);
  }

  &.translation .stat-card-icon {
    background: linear-gradient(135deg, $color-blue 0%, $color-purple 100%);
  }

  .stat-card-content {
    flex: 1;

    .stat-card-label {
      font-size: 14px;
      color: $color-text-tertiary;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-bottom: 6px;
    }

    .stat-card-value {
      font-size: 28px;
      font-weight: 700;
      color: $color-text-primary;
      line-height: 1.2;
      margin-bottom: 4px;
    }

    .stat-card-desc {
      font-size: 14px;
      color: $color-text-secondary;
      line-height: 1.4;
    }
  }

  .stat-card-indicator {
    position: absolute;
    top: 0;
    left: 0;
    width: 3px;
    height: 100%;
  }

  &.agriculture .stat-card-indicator {
    background: $color-primary;
  }

  &.translation .stat-card-indicator {
    background: $color-blue;
  }
}

// 监控区
.monitor-section {
  display: grid;
  grid-template-columns: 1fr 1.5fr;
  gap: 20px;
  margin-bottom: 24px;

  @media (max-width: 1024px) {
    grid-template-columns: 1fr;
  }
}

.monitor-card {
  background: $color-surface;
  border-radius: 12px;
  border: 1px solid $color-border;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

// 设备状态卡片（整体外观微调，更接近设计稿）
.device-card {
  border-radius: 16px;
  border-color: rgba(148, 163, 184, 0.45);
  box-shadow: 0 10px 26px rgba(15, 23, 42, 0.08);

  .card-header {
    padding: 14px 20px 10px;
    border-bottom: none;

    .card-title {
      font-size: 16px;

      svg {
        width: 18px;
        height: 18px;
        color: $color-primary;
      }
    }
  }
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-bottom: 1px solid $color-border;

  .card-title {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 17px;
    font-weight: 600;
    color: $color-text-primary;

    svg {
      width: 18px;
      height: 18px;
      color: $color-primary;
    }
  }
}

// 状态徽章
.status-badge {
  padding: 4px 10px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 500;

  &.status-normal {
    background: rgba(20, 184, 166, 0.12);
    color: $color-primary;
  }

  &.status-testing {
    background: rgba(56, 189, 248, 0.12);
    color: $color-blue;
  }
}

// 环境监控卡片美化
.environment-card {
  position: relative;
  overflow: hidden;
  
  .card-header {
    position: relative;
    z-index: 1;
    
    .card-title {
      .title-icon {
        width: 32px;
        height: 32px;
        background: linear-gradient(135deg, $color-primary 0%, $color-primary-dark 100%);
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 4px 12px rgba(20, 184, 166, 0.3);
        
        svg {
          width: 18px;
          height: 18px;
          color: white;
        }
        
        &.env-icon {
          animation: subtle-pulse 3s ease-in-out infinite;
        }
      }
    }
    
    .env-status {
      display: flex;
      align-items: center;
      gap: 6px;
      padding: 6px 12px;
      background: rgba(20, 184, 166, 0.1);
      border-radius: 20px;
      border: 1px solid rgba(20, 184, 166, 0.2);
      
      .status-dot {
        width: 8px;
        height: 8px;
        background: $color-primary;
        border-radius: 50%;
        
        &.pulse {
          animation: pulse-dot 2s ease-in-out infinite;
        }
      }
      
      .status-text {
        font-size: 14px;
        font-weight: 600;
        color: $color-primary;
      }
    }
  }
}

.environment-gauges {
  display: flex;
  padding: 28px 20px;
  gap: 0;
  position: relative;
  z-index: 1;
  
  .divider {
    width: 1px;
    background: linear-gradient(180deg, transparent 0%, $color-border 20%, $color-border 80%, transparent 100%);
    margin: 20px 0;
  }

  .gauge-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 0 16px;
    
    &.temp-item:hover .gauge-bg {
      box-shadow: 0 8px 24px rgba(20, 184, 166, 0.2);
    }
    
    &.humidity-item:hover .gauge-bg {
      box-shadow: 0 8px 24px rgba(56, 189, 248, 0.2);
    }
    
    .gauge-bg {
      position: relative;
      width: 120px;
      height: 120px;
      border-radius: 50%;
      background: linear-gradient(145deg, #ffffff 0%, #f8fafc 100%);
      box-shadow: 
        0 4px 16px rgba(0, 0, 0, 0.06),
        inset 0 2px 4px rgba(255, 255, 255, 0.8);
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;
      
      .gauge-chart {
        width: 100%;
        height: 100%;
      }
      
      .gauge-icon {
        position: absolute;
        width: 36px;
        height: 36px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        bottom: 8px;
        
        &.temp-icon-small {
          background: linear-gradient(135deg, rgba(20, 184, 166, 0.15) 0%, rgba(20, 184, 166, 0.05) 100%);
          color: $color-primary;
          
          svg {
            width: 18px;
            height: 18px;
          }
        }
        
        &.humidity-icon-small {
          background: linear-gradient(135deg, rgba(56, 189, 248, 0.15) 0%, rgba(56, 189, 248, 0.05) 100%);
          color: $color-blue;
          
          svg {
            width: 18px;
            height: 18px;
          }
        }
      }
    }

    .gauge-info {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 6px;
      margin-top: 16px;

      .gauge-label {
        font-size: 15px;
        color: $color-text-tertiary;
        font-weight: 500;
      }

      .gauge-value {
        font-size: 28px;
        font-weight: 700;
        color: $color-text-primary;
        line-height: 1;
        font-variant-numeric: tabular-nums;
      }
      
      .gauge-status {
        font-size: 13px;
        padding: 3px 10px;
        border-radius: 12px;
        background: rgba(20, 184, 166, 0.1);
        color: $color-primary;
        font-weight: 500;
      }
    }
  }
}

.env-footer {
  display: flex;
  justify-content: center;
  gap: 24px;
  padding: 16px 20px 20px;
  border-top: 1px solid rgba(20, 184, 166, 0.1);
  background: linear-gradient(180deg, rgba(20, 184, 166, 0.02) 0%, transparent 100%);
  position: relative;
  z-index: 1;
  
  .env-metric {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 14px;
    background: white;
    border-radius: 20px;
    border: 1px solid $color-border;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
    transition: all 0.2s ease;
    
    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
      border-color: rgba(20, 184, 166, 0.3);
    }
    
    svg {
      width: 16px;
      height: 16px;
      color: $color-primary;
    }
    
    span {
      font-size: 14px;
      color: $color-text-secondary;
      font-weight: 500;
    }
  }
}

@keyframes subtle-pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.05); }
}

@keyframes pulse-dot {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.7; transform: scale(1.2); }
}

// 设备状态
.device-chart-wrapper {
  padding: 4px 20px 0;
  height: 200px;
}

.device-chart {
  width: 100%;
  height: 100%;
}

// 状态色块标签
.device-status-legend {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  padding: 10px 20px 16px;
  border-top: 1px dashed rgba(226, 232, 240, 0.9);
  margin-top: 6px;

  .status-tag {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    border-radius: 999px;
    font-size: 13px;
    font-weight: 500;

    .status-dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
    }

    .status-count {
      font-weight: 600;
      margin-left: 2px;
      font-variant-numeric: tabular-nums;
    }

    &.status-normal {
      background: rgba(20, 184, 166, 0.06);
      color: #0d9488;
      border: 1px solid rgba(20, 184, 166, 0.25);
      .status-dot { background: $color-primary; }
    }

    &.status-testing {
      background: rgba(56, 189, 248, 0.06);
      color: #0284c7;
      border: 1px solid rgba(56, 189, 248, 0.25);
      .status-dot { background: $color-blue; }
    }

    &.status-lent {
      background: rgba(167, 139, 250, 0.06);
      color: #7c3aed;
      border: 1px solid rgba(167, 139, 250, 0.25);
      .status-dot { background: $color-purple; }
    }

    &.status-damage {
      background: rgba(251, 113, 133, 0.06);
      color: #e11d48;
      border: 1px solid rgba(251, 113, 133, 0.25);
      .status-dot { background: $color-red; }
    }

    &.status-loss {
      background: rgba(251, 191, 36, 0.06);
      color: #d97706;
      border: 1px solid rgba(251, 191, 36, 0.25);
      .status-dot { background: $color-yellow; }
    }

    &.status-scrap {
      background: rgba(148, 163, 184, 0.06);
      color: #64748b;
      border: 1px solid rgba(148, 163, 184, 0.25);
      .status-dot { background: $color-gray; }
    }
  }
}

// 设备汇总信息条
.device-summary {
  padding: 10px 20px 14px;
  background: linear-gradient(180deg, #f9fafb 0%, #edf2ff 100%);
  border-top: 1px solid rgba(226, 232, 240, 0.9);

  .summary-row {
    display: flex;
    align-items: center;
    justify-content: space-between;

    &.summary-main {
      margin-bottom: 10px;
    }
  }

  .summary-left {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .summary-right {
    font-size: 14px;
    color: $color-text-tertiary;
  }

  .summary-label {
    font-size: 14px;
    color: $color-text-tertiary;
  }

  .summary-value {
    font-size: 16px;
    font-weight: 600;
    color: $color-text-primary;
  }

  .summary-meta {
    font-size: 14px;
    font-weight: 500;
    color: $color-primary;
  }

  .summary-extra {
    padding-top: 10px;
    border-top: 1px dashed rgba(148, 163, 184, 0.35);
    gap: 16px;
    flex-wrap: wrap;
  }

  .extra-item {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    color: $color-text-secondary;
  }

  .extra-label {
    color: $color-text-tertiary;
  }

  .extra-value {
    font-weight: 600;
    color: $color-text-primary;
  }

  .extra-hint {
    font-size: 12px;
    color: $color-text-tertiary;
    margin-left: 2px;
  }

  .extra-divider {
    width: 1px;
    height: 14px;
    background: $color-border;
    flex-shrink: 0;
  }
}

// 图表区
.chart-section {
  display: grid;
  grid-template-columns: 1.2fr 1fr;
  gap: 20px;
  margin-bottom: 24px;

  @media (max-width: 1024px) {
    grid-template-columns: 1fr;
  }
}

.chart-card {
  background: $color-surface;
  border-radius: 12px;
  border: 1px solid $color-border;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.chart-content {
  padding: 20px;
  height: 280px;
}

.chart-container {
  width: 100%;
  height: 100%;
}

// AI病虫害卡片
.pest-card {
  .pest-stats {
    display: flex;
    padding: 16px 20px;
    gap: 16px;
    border-bottom: 1px solid $color-border;

    .pest-stat-item {
      flex: 1;
      text-align: center;
      padding: 12px;
      background: rgba(20, 184, 166, 0.05);
      border-radius: 8px;

      .pest-stat-value {
        display: block;
        font-size: 24px;
        font-weight: 700;
        color: $color-primary;
        margin-bottom: 4px;
      }

      .pest-stat-label {
        font-size: 14px;
        color: $color-text-tertiary;
      }
    }
  }

  .tree-wrapper {
    max-height: 220px;
    overflow: auto;
    padding: 12px 20px;
  }

  .pest-tree {
    background: transparent;

    :deep(.el-tree-node__content) {
      height: 36px;
      border-radius: 6px;
      margin: 2px 0;
      transition: all 0.2s ease;

      &:hover {
        background: rgba(20, 184, 166, 0.08);
      }
    }
  }

  .custom-tree-node {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;

    .node-left {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .node-dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      flex-shrink: 0;

      &.dot-pest { background: $color-blue; }
      &.dot-disease { background: $color-purple; }
      &.dot-record { background: $color-primary; }
      &.dot-root { background: $color-primary; }
      &.dot-default { background: $color-gray; }
    }

    .node-label {
      font-size: 15px;
      color: $color-text-secondary;
    }

    .node-meta {
      font-size: 14px;
      color: $color-primary;
      font-weight: 500;
      background: rgba(20, 184, 166, 0.1);
      padding: 2px 8px;
      border-radius: 10px;
    }
  }
}

// 趋势区
trend-section {
  margin-bottom: 24px;
}

.trend-card {
  background: $color-surface;
  border-radius: 12px;
  border: 1px solid $color-border;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden;

  .card-actions {
    display: flex;
    gap: 4px;

    .action-btn {
      padding: 6px 12px;
      border: none;
      background: transparent;
      color: $color-text-tertiary;
      font-size: 14px;
      font-weight: 500;
      border-radius: 6px;
      cursor: pointer;
      transition: all 0.2s ease;

      &:hover {
        background: rgba(20, 184, 166, 0.08);
        color: $color-primary;
      }

      &.active {
        background: $color-primary;
        color: white;
      }
    }
  }
}

.trend-chart-wrapper {
  padding: 20px;
  height: 260px;
}

.trend-chart {
  width: 100%;
  height: 100%;
}

// 响应式
@media (max-width: 768px) {
  .top-bar {
    padding: 0 16px;

    .page-subtitle {
      display: none;
    }
  }

  .dashboard-body {
    padding: 16px;
  }
}
</style>

<style lang="scss">
/* 语言选择下拉框（popper 挂载在 body，需全局样式） */
.lang-select-dropdown {
  .el-select-dropdown__item {
    font-size: 15px;
    padding: 0 12px;
    height: 38px;
    line-height: 38px;

    &.selected {
      color: #14b8a6;
      font-weight: 500;
    }
    &:hover {
      background: rgba(20, 184, 166, 0.08);
      color: #14b8a6;
    }
  }
}
</style>

