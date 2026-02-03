<template>
  <div class="weather-container">
    <!-- 实时天气信息卡片 -->
    <el-row :gutter="20" class="mb20">
      <el-col :span="24">
        <div class="weather-card">
          <div class="card-header">
            <div class="header-content">
              <h3 class="card-title">
                <i class="el-icon-cloudy"></i>
                实时天气监测
              </h3>

            </div>
          </div>
          <el-row :gutter="20" v-loading="loading" class="weather-content">
            <el-col :span="6" v-for="(item, index) in weatherCards" :key="index">
              <div class="weather-item" :class="`item-${index}`">
                <div class="weather-icon">
                  <i :class="item.icon"></i>
                </div>
                <div class="weather-info">
                  <div class="weather-title">{{ item.title }}</div>
                  <div class="weather-value">{{ item.value }} {{ item.unit }}</div>
                  <div class="weather-desc">{{ item.desc }}</div>
                </div>
                <div class="item-decoration"></div>
              </div>
            </el-col>
          </el-row>
        </div>
      </el-col>
    </el-row>

    <!-- 查询条件 -->
    <div class="search-section" v-show="showSearch">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="68px">
        <el-form-item label="监测位置" prop="location">
          <el-input v-model="queryParams.location" placeholder="请输入监测位置" clearable 
                   class="search-input" @keyup.enter.native="handleQuery" />
        </el-form-item>
        <el-form-item label="记录时间">
          <el-date-picker v-model="dateRange" class="date-picker" value-format="yyyy-MM-dd" 
                          type="daterange" range-separator="-" start-placeholder="开始日期" 
                          end-placeholder="结束日期"></el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" 
                     class="search-btn">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery" 
                     class="reset-btn">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 操作按钮 -->
    <el-row :gutter="10" class="mb8 action-buttons">
      <el-col :span="1.5">
        <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAdd" 
                   v-hasPermi="['agriculture:weather:add']" class="action-btn add-btn">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" 
                   v-hasPermi="['agriculture:weather:edit']" class="action-btn edit-btn">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" 
                   v-hasPermi="['agriculture:weather:remove']" class="action-btn delete-btn">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" icon="el-icon-download" size="mini" @click="handleExport" 
                   v-hasPermi="['agriculture:weather:export']" class="action-btn export-btn">导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <!-- 数据卡片 -->
    <div v-loading="loading" class="cards-container">
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="(item, index) in weatherList" :key="item.weatherId" class="card-col">
          <el-card class="weather-data-card" :class="{ 'card-selected': isSelected(item.weatherId) }">
            <div slot="header" class="card-header">
              <el-checkbox 
                :value="isSelected(item.weatherId)" 
                @change="toggleSelection(item)"
                class="card-checkbox"
              ></el-checkbox>
              <div class="card-title">
                <i class="el-icon-location-outline"></i>
                <span>{{ item.location || '未知位置' }}</span>
              </div>
            </div>
            <div class="card-body">
              <div class="data-grid">
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-sunny"></i>
                    <span>温度</span>
                  </div>
                  <div class="data-value">{{ item.temperature !== null && item.temperature !== undefined ? item.temperature + ' ℃' : '--' }}</div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-cloudy"></i>
                    <span>湿度</span>
                  </div>
                  <div class="data-value">{{ item.humidity !== null && item.humidity !== undefined ? item.humidity + ' %' : '--' }}</div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-sort"></i>
                    <span>气压</span>
                  </div>
                  <div class="data-value">{{ item.pressure !== null && item.pressure !== undefined ? item.pressure + ' hPa' : '--' }}</div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-wind-power"></i>
                    <span>风速</span>
                  </div>
                  <div class="data-value">{{ item.windSpeed !== null && item.windSpeed !== undefined ? item.windSpeed + ' m/s' : '--' }}</div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-compass"></i>
                    <span>风向</span>
                  </div>
                  <div class="data-value">
                    <span class="wind-direction-text">{{ item.windDirection || '--' }}</span>
                  </div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-cloudy-and-sunny"></i>
                    <span>降雨量</span>
                  </div>
                  <div class="data-value">{{ item.rainfall !== null && item.rainfall !== undefined ? item.rainfall + ' mm' : '--' }}</div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-light-rain"></i>
                    <span>光照强度</span>
                  </div>
                  <div class="data-value">{{ item.lightIntensity !== null && item.lightIntensity !== undefined ? item.lightIntensity + ' lux' : '--' }}</div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-connection"></i>
                    <span>土壤温度</span>
                  </div>
                  <div class="data-value">{{ item.soilTemperature !== null && item.soilTemperature !== undefined ? item.soilTemperature + ' ℃' : '--' }}</div>
                </div>
                <div class="data-item">
                  <div class="data-label">
                    <i class="el-icon-water"></i>
                    <span>土壤湿度</span>
                  </div>
                  <div class="data-value">{{ item.soilHumidity !== null && item.soilHumidity !== undefined ? item.soilHumidity + ' %' : '--' }}</div>
                </div>
              </div>
              <div class="card-footer">
                <div class="record-time">
                  <i class="el-icon-time"></i>
                  <span>{{ parseTime(item.recordTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
                </div>
                <div class="card-actions">
                  <el-button size="mini" type="primary" icon="el-icon-edit" @click="handleUpdate(item)" 
                             v-hasPermi="['agriculture:weather:edit']" class="action-btn">修改</el-button>
                  <el-button size="mini" type="danger" icon="el-icon-delete" @click="handleDelete(item)" 
                             v-hasPermi="['agriculture:weather:remove']" class="action-btn">删除</el-button>
                </div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
      <div v-if="weatherList.length === 0" class="empty-state">
        <i class="el-icon-document"></i>
        <p>暂无数据</p>
      </div>
    </div>

    <!-- 分页 -->
    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" 
                :limit.sync="queryParams.pageSize" @pagination="getList" class="pagination" />

    <!-- 添加或修改天气信息对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" append-to-body 
               class="weather-dialog" :close-on-click-modal="false">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px" class="dialog-form">
        <el-row>
          <el-col :span="12">
            <el-form-item label="监测位置" prop="location">
              <el-input v-model="form.location" placeholder="请输入监测位置" class="form-input" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="传感器ID" prop="sensorId">
              <el-input v-model="form.sensorId" placeholder="请输入传感器ID" class="form-input" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="温度(℃)" prop="temperature">
              <el-input-number v-model="form.temperature" :precision="2" :step="0.1" :min="-50" :max="60" 
                               class="form-number" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="湿度(%)" prop="humidity">
              <el-input-number v-model="form.humidity" :precision="2" :step="0.1" :min="0" :max="100" 
                               class="form-number" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="气压(hPa)" prop="pressure">
              <el-input-number v-model="form.pressure" :precision="2" :step="0.1" :min="800" :max="1200" 
                               class="form-number" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="风速(m/s)" prop="windSpeed">
              <el-input-number v-model="form.windSpeed" :precision="2" :step="0.1" :min="0" :max="50" 
                               class="form-number" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="风向" prop="windDirection">
              <el-select v-model="form.windDirection" placeholder="请选择风向" class="form-select">
                <el-option label="北" value="北" />
                <el-option label="东北" value="东北" />
                <el-option label="东" value="东" />
                <el-option label="东南" value="东南" />
                <el-option label="南" value="南" />
                <el-option label="西南" value="西南" />
                <el-option label="西" value="西" />
                <el-option label="西北" value="西北" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="降雨量(mm)" prop="rainfall">
              <el-input-number v-model="form.rainfall" :precision="2" :step="0.1" :min="0" :max="500" 
                               class="form-number" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="光照强度(lux)" prop="lightIntensity">
              <el-input-number v-model="form.lightIntensity" :precision="2" :step="100" :min="0" :max="100000" 
                               class="form-number" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="土壤温度(℃)" prop="soilTemperature">
              <el-input-number v-model="form.soilTemperature" :precision="2" :step="0.1" :min="-20" :max="60" 
                               class="form-number" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="土壤湿度(%)" prop="soilHumidity">
              <el-input-number v-model="form.soilHumidity" :precision="2" :step="0.1" :min="0" :max="100" 
                               class="form-number" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="记录时间" prop="recordTime">
              <el-date-picker clearable v-model="form.recordTime" type="datetime" 
                              value-format="yyyy-MM-dd HH:mm:ss" placeholder="请选择记录时间" 
                              class="form-date-picker">
              </el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" 
                    class="form-textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel" class="cancel-btn">取 消</el-button>
        <el-button type="primary" @click="submitForm" class="submit-btn">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listWeather, getWeather, delWeather, addWeather, updateWeather, getLatestWeather } from "@/api/agriculture/weather";

export default {
  name: "Weather",
  dicts: [],
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
      // 天气信息表格数据
      weatherList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 日期范围
      dateRange: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        location: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        location: [
          { required: true, message: "监测位置不能为空", trigger: "blur" }
        ],
        temperature: [
          { required: true, message: "温度不能为空", trigger: "blur" }
        ],
        humidity: [
          { required: true, message: "湿度不能为空", trigger: "blur" }
        ],
      },
      // 天气卡片数据
      weatherCards: [],
      // 定时器
      weatherUpdateTimer: null,
      // 基础值（用于随机变化）
      baseValues: {
        humidity: null,
        soilTemperature: null,
        soilHumidity: null
      }
    };
  },
  created() {
    this.getList();
    this.getLatestWeatherData();
    // 启动随机变化定时器
    this.startRandomUpdate();
  },
  beforeDestroy() {
    // 清除定时器
    if (this.weatherUpdateTimer) {
      clearInterval(this.weatherUpdateTimer);
      this.weatherUpdateTimer = null;
    }
  },
  methods: {
    /** 查询天气信息列表 */
    getList() {
      this.loading = true;
      listWeather(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
        this.weatherList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 获取最新天气数据
    getLatestWeatherData() {
      getLatestWeather().then(response => {
        if (response.data) {
          // 保存基础值（用于随机变化）
          if (response.data.humidity) {
            this.baseValues.humidity = parseFloat(response.data.humidity);
          }
          if (response.data.soilTemperature) {
            this.baseValues.soilTemperature = parseFloat(response.data.soilTemperature);
          }
          if (response.data.soilHumidity) {
            this.baseValues.soilHumidity = parseFloat(response.data.soilHumidity);
          }
          
          // 初始化卡片数据，湿度、土壤温度、土壤湿度使用数值类型以便后续随机变化
          const humidity = response.data.humidity ? parseFloat(response.data.humidity) : null;
          const soilTemp = response.data.soilTemperature ? parseFloat(response.data.soilTemperature) : null;
          const soilHum = response.data.soilHumidity ? parseFloat(response.data.soilHumidity) : null;
          
          this.weatherCards = [
            {
              title: '温度',
              value: response.data.temperature || '--',
              unit: '℃',
              icon: 'el-icon-sunny',
              desc: '环境温度'
            },
            {
              title: '湿度',
              value: humidity !== null ? humidity : '--',
              unit: '%',
              icon: 'el-icon-cloudy',
              desc: '空气湿度'
            },
            {
              title: '土壤温度',
              value: soilTemp !== null ? soilTemp : '--',
              unit: '℃',
              icon: 'el-icon-connection',
              desc: '土壤温度'
            },
            {
              title: '土壤湿度',
              value: soilHum !== null ? soilHum : '--',
              unit: '%',
              icon: 'el-icon-water',
              desc: '土壤湿度'
            }
          ];
        }
      });
    },
    // 启动随机更新
    startRandomUpdate() {
      // 每3秒更新一次
      this.weatherUpdateTimer = setInterval(() => {
        this.updateRandomValues();
      }, 3000);
    },
    // 随机更新湿度、土壤温度、土壤湿度
    updateRandomValues() {
      if (this.weatherCards && this.weatherCards.length >= 4) {
        // 更新湿度（第二个卡片，索引1）
        if (this.baseValues.humidity !== null && this.weatherCards[1] && typeof this.weatherCards[1].value === 'number') {
          // 基于当前值，随机变化范围：-0.1 到 +0.1，保留1位小数
          const change = (Math.random() * 0.2 - 0.1).toFixed(1);
          const currentValue = this.weatherCards[1].value;
          const newValue = parseFloat((currentValue + parseFloat(change)).toFixed(1));
          // 确保值不会偏离基础值太远（±2范围内）
          if (Math.abs(newValue - this.baseValues.humidity) <= 2) {
            this.weatherCards[1].value = newValue;
          } else {
            // 如果偏离太远，向基础值回归
            const direction = this.baseValues.humidity > currentValue ? 0.1 : -0.1;
            this.weatherCards[1].value = parseFloat((currentValue + direction).toFixed(1));
          }
        }
        
        // 更新土壤温度（第三个卡片，索引2）
        if (this.baseValues.soilTemperature !== null && this.weatherCards[2] && typeof this.weatherCards[2].value === 'number') {
          // 基于当前值，随机变化范围：-0.1 到 +0.1，保留1位小数
          const change = (Math.random() * 0.2 - 0.1).toFixed(1);
          const currentValue = this.weatherCards[2].value;
          const newValue = parseFloat((currentValue + parseFloat(change)).toFixed(1));
          // 确保值不会偏离基础值太远（±2范围内）
          if (Math.abs(newValue - this.baseValues.soilTemperature) <= 2) {
            this.weatherCards[2].value = newValue;
          } else {
            // 如果偏离太远，向基础值回归
            const direction = this.baseValues.soilTemperature > currentValue ? 0.1 : -0.1;
            this.weatherCards[2].value = parseFloat((currentValue + direction).toFixed(1));
          }
        }
        
        // 更新土壤湿度（第四个卡片，索引3）
        if (this.baseValues.soilHumidity !== null && this.weatherCards[3] && typeof this.weatherCards[3].value === 'number') {
          // 基于当前值，随机变化范围：-0.1 到 +0.1，保留1位小数
          const change = (Math.random() * 0.2 - 0.1).toFixed(1);
          const currentValue = this.weatherCards[3].value;
          const newValue = parseFloat((currentValue + parseFloat(change)).toFixed(1));
          // 确保值不会偏离基础值太远（±2范围内）
          if (Math.abs(newValue - this.baseValues.soilHumidity) <= 2) {
            this.weatherCards[3].value = newValue;
          } else {
            // 如果偏离太远，向基础值回归
            const direction = this.baseValues.soilHumidity > currentValue ? 0.1 : -0.1;
            this.weatherCards[3].value = parseFloat((currentValue + direction).toFixed(1));
          }
        }
      }
    },
    // 刷新天气数据
    refreshWeather() {
      this.getLatestWeatherData();
      this.getList();
      // 重新启动随机更新
      if (this.weatherUpdateTimer) {
        clearInterval(this.weatherUpdateTimer);
      }
      this.startRandomUpdate();
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        weatherId: null,
        location: null,
        temperature: null,
        humidity: null,
        pressure: null,
        windSpeed: null,
        windDirection: null,
        rainfall: null,
        lightIntensity: null,
        soilTemperature: null,
        soilHumidity: null,
        recordTime: null,
        sensorId: null,
        remark: null
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.dateRange = [];
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据（表格用）
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.weatherId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    // 判断是否选中（卡片用）
    isSelected(weatherId) {
      return this.ids.includes(weatherId)
    },
    // 切换选择状态（卡片用）
    toggleSelection(item) {
      const index = this.ids.indexOf(item.weatherId)
      if (index > -1) {
        this.ids.splice(index, 1)
      } else {
        this.ids.push(item.weatherId)
      }
      this.single = this.ids.length !== 1
      this.multiple = this.ids.length === 0
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加天气信息";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const weatherId = row.weatherId || this.ids
      getWeather(weatherId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改天气信息";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.weatherId != null) {
            updateWeather(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addWeather(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const weatherIds = row.weatherId || this.ids;
      this.$modal.confirm('是否确认删除天气信息编号为"' + weatherIds + '"的数据项？').then(function() {
        return delWeather(weatherIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('agriculture/weather/export', {
        ...this.queryParams
      }, `weather_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>

<style scoped>
/* 主容器样式 */
.weather-container {
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
  min-height: 100vh;
  padding: 24px;
}

/* 天气卡片样式 */
.weather-card {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  border-radius: 16px;
  padding: 0;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  overflow: hidden;
  position: relative;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.weather-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 25px 30px -5px rgba(0, 0, 0, 0.15), 0 15px 15px -5px rgba(0, 0, 0, 0.06);
}

.weather-card::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
  animation: shimmer 3s ease-in-out infinite;
  pointer-events: none;
}

.card-header {
  padding: 28px 32px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.05) 100%);
  backdrop-filter: blur(10px);
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-title {
  color: white;
  margin: 0;
  font-size: 22px;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 12px;
  text-shadow: 0 2px 4px rgba(0,0,0,0.1);
  letter-spacing: 0.5px;
}

.card-title i {
  font-size: 24px;
}

.refresh-btn {
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  border-radius: 12px;
  padding: 10px 18px;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.refresh-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.weather-content {
  padding: 28px 32px;
}

.weather-item {
  display: flex;
  align-items: center;
  padding: 28px;
  background: rgba(255, 255, 255, 0.15);
  border-radius: 16px;
  backdrop-filter: blur(20px);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.weather-item:hover {
  transform: translateY(-6px);
  background: rgba(255, 255, 255, 0.25);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.15), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  border-color: rgba(255, 255, 255, 0.4);
}

.weather-icon {
  font-size: 52px;
  margin-right: 24px;
  color: rgba(255, 255, 255, 0.95);
  transition: transform 0.3s ease;
  text-shadow: 0 2px 8px rgba(0,0,0,0.2);
}

.weather-item:hover .weather-icon {
  transform: scale(1.1);
}

.weather-info {
  flex: 1;
  color: white;
}

.weather-title {
  font-size: 16px;
  opacity: 0.95;
  margin-bottom: 10px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.weather-value {
  font-size: 32px;
  font-weight: 700;
  margin-bottom: 8px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  background: linear-gradient(135deg, #ffffff 0%, #f0f9ff 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.weather-desc {
  font-size: 14px;
  opacity: 0.85;
  font-weight: 500;
}

.item-decoration {
  position: absolute;
  top: -50%;
  right: -20%;
  width: 100px;
  height: 100px;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.2) 0%, transparent 70%);
  border-radius: 50%;
  transition: all 0.3s ease;
}

.weather-item:hover .item-decoration {
  transform: scale(1.2);
}

/* 搜索区域样式 */
.search-section {
  background: #ffffff;
  border-radius: 16px;
  padding: 28px;
  margin-bottom: 24px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  border: 1px solid rgba(229, 231, 235, 0.5);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.search-section:hover {
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  border-color: rgba(34, 197, 94, 0.2);
}

.search-input,
.date-picker {
  border-radius: 12px;
  border: 1px solid rgba(229, 231, 235, 0.8);
  transition: all 0.3s ease;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
}

.search-input:focus,
.date-picker:focus {
  border-color: #22c55e;
  box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.1);
}

.search-btn {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  border: none;
  border-radius: 12px;
  color: white;
  font-weight: 600;
  transition: all 0.3s ease;
  padding: 10px 20px;
  box-shadow: 0 4px 6px -1px rgba(34, 197, 94, 0.3);
}

.search-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(34, 197, 94, 0.3), 0 10px 10px -5px rgba(34, 197, 94, 0.1);
}

.reset-btn {
  background: white;
  border: 1px solid rgba(229, 231, 235, 0.8);
  border-radius: 12px;
  color: #6b7280;
  transition: all 0.3s ease;
  padding: 10px 20px;
  font-weight: 500;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
}

.reset-btn:hover {
  border-color: #22c55e;
  color: #22c55e;
  background: rgba(34, 197, 94, 0.05);
  transform: translateY(-1px);
  box-shadow: 0 4px 6px -1px rgba(34, 197, 94, 0.2);
}

/* 操作按钮样式 */
.action-buttons {
  margin-bottom: 20px;
}

.action-btn {
  border-radius: 12px;
  font-weight: 600;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: none;
  padding: 10px 16px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.add-btn {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  color: white;
}

.add-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(34, 197, 94, 0.3), 0 10px 10px -5px rgba(34, 197, 94, 0.1);
}

.edit-btn {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: white;
}

.edit-btn:hover {
  background: linear-gradient(135deg, #059669 0%, #047857 100%);
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(16, 185, 129, 0.3), 0 10px 10px -5px rgba(16, 185, 129, 0.1);
}

.delete-btn {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: white;
}

.delete-btn:hover {
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(239, 68, 68, 0.3), 0 10px 10px -5px rgba(239, 68, 68, 0.1);
}

.export-btn {
  background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
  color: white;
}

.export-btn:hover {
  background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(245, 158, 11, 0.3), 0 10px 10px -5px rgba(245, 158, 11, 0.1);
}

/* 表格样式 */
.table-container {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(5, 117, 230, 0.1);
}

.weather-table {
  border-radius: 8px;
  overflow: hidden;
}

.weather-table th {
  background: #f8fafc;
  color: #1E293B;
  font-weight: 600;
  border-bottom: 2px solid #e2e8f0;
}

.weather-table td {
  color: #64748B;
  border-bottom: 1px solid #f1f5f9;
}

.weather-table tr:hover td {
  background: rgba(5, 117, 230, 0.05);
  color: #1E293B;
}

.table-action-btn {
  border-radius: 6px;
  font-size: 12px;
  padding: 4px 8px;
  transition: all 0.3s ease;
  border: none;
}

.table-action-btn.edit {
  background: #10b981;
  color: white;
}

.table-action-btn.edit:hover {
  background: #059669;
}

.table-action-btn.delete {
  background: #ef4444;
  color: white;
}

.table-action-btn.delete:hover {
  background: #dc2626;
}

/* 卡片容器样式 */
.cards-container {
  min-height: 400px;
  padding: 20px 0;
}

.card-col {
  margin-bottom: 20px;
}

.weather-data-card {
  border-radius: 16px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: 2px solid transparent;
  height: 100%;
  display: flex;
  flex-direction: column;
  background: #ffffff;
  overflow: hidden;
}

.weather-data-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  border-color: rgba(34, 197, 94, 0.2);
}

.weather-data-card.card-selected {
  border-color: #22c55e;
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.05) 0%, rgba(16, 163, 74, 0.05) 100%);
  box-shadow: 0 20px 25px -5px rgba(34, 197, 94, 0.15), 0 10px 10px -5px rgba(34, 197, 94, 0.05);
}

.weather-data-card >>> .el-card__body {
  padding: 0;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 20px 24px;
  border-bottom: 1px solid rgba(229, 231, 235, 0.5);
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  backdrop-filter: blur(10px);
}

.card-checkbox {
  margin-right: 8px;
}

.card-title {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: 600;
  color: #1f2937;
}

.card-title i {
  color: #22c55e;
  font-size: 18px;
}

.card-body {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.data-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  margin-bottom: 24px;
}

.data-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 16px;
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  border-radius: 12px;
  border: 1px solid rgba(229, 231, 235, 0.5);
  transition: all 0.3s ease;
}

.data-item:hover {
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.05) 0%, rgba(16, 163, 74, 0.02) 100%);
  border-color: rgba(34, 197, 94, 0.2);
  transform: translateY(-2px);
  box-shadow: 0 4px 6px -1px rgba(34, 197, 94, 0.1);
}

.data-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: #6b7280;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.data-label i {
  font-size: 14px;
  color: #22c55e;
}

.data-value {
  font-size: 14px;
  font-weight: 700;
  color: #1f2937;
  word-break: break-word;
  background: linear-gradient(135deg, #1f2937 0%, #374151 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* 风向文字样式 */
.weather-data-card .wind-direction-text {
  color: #000000 !important;
  font-weight: 700 !important;
  font-size: 14px !important;
}

.card-footer {
  margin-top: auto;
  padding-top: 20px;
  border-top: 1px solid rgba(229, 231, 235, 0.5);
  display: flex;
  flex-direction: column;
  gap: 16px;
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  border-radius: 0 0 16px 16px;
}

.record-time {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: #6b7280;
  font-weight: 500;
}

.record-time i {
  color: #22c55e;
}

.card-actions {
  display: flex;
  gap: 12px;
}

.card-actions .action-btn {
  flex: 1;
  border-radius: 8px;
  font-size: 12px;
  padding: 10px 16px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-weight: 600;
  box-shadow: 0 2px 4px -1px rgba(0, 0, 0, 0.1);
}

.card-actions .action-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 12px -2px rgba(0, 0, 0, 0.15);
}

.empty-state {
  text-align: center;
  padding: 80px 20px;
  color: #9ca3af;
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  border-radius: 16px;
  border: 2px dashed rgba(156, 163, 175, 0.3);
  margin: 20px 0;
}

.empty-state i {
  font-size: 72px;
  margin-bottom: 20px;
  opacity: 0.6;
  color: #22c55e;
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.empty-state p {
  font-size: 16px;
  margin: 0;
  font-weight: 500;
  color: #6b7280;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .data-grid {
    grid-template-columns: 1fr;
  }
  
  .card-actions {
    flex-direction: column;
  }
  
  .card-actions .action-btn {
    width: 100%;
  }
}

/* 分页样式 */
.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

/* 对话框样式 */
.weather-dialog {
  border-radius: 16px;
  overflow: hidden;
}

.weather-dialog .el-dialog__header {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  color: white;
  border-radius: 16px 16px 0 0;
  padding: 28px 32px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.weather-dialog .el-dialog__title {
  color: white;
  font-size: 18px;
  font-weight: 700;
  text-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.weather-dialog .el-dialog__body {
  padding: 32px;
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
}

.dialog-form .el-form-item__label {
  color: #1f2937;
  font-weight: 600;
  font-size: 14px;
}

.form-input,
.form-number,
.form-select,
.form-date-picker,
.form-textarea {
  border-radius: 12px;
  border: 1px solid rgba(229, 231, 235, 0.8);
  transition: all 0.3s ease;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
}

.form-input:focus,
.form-number:focus,
.form-select:focus,
.form-date-picker:focus,
.form-textarea:focus {
  border-color: #22c55e;
  box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.1);
}

.dialog-footer {
  text-align: right;
  padding: 24px 32px;
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  border-radius: 0 0 16px 16px;
  border-top: 1px solid rgba(229, 231, 235, 0.5);
}

.cancel-btn {
  background: white;
  border: 1px solid rgba(229, 231, 235, 0.8);
  border-radius: 12px;
  color: #6b7280;
  padding: 12px 24px;
  transition: all 0.3s ease;
  font-weight: 600;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
}

.cancel-btn:hover {
  border-color: #22c55e;
  color: #22c55e;
  background: rgba(34, 197, 94, 0.05);
  transform: translateY(-2px);
  box-shadow: 0 4px 6px -1px rgba(34, 197, 94, 0.2);
}

.submit-btn {
  background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
  border: none;
  border-radius: 12px;
  color: white;
  padding: 12px 24px;
  font-weight: 600;
  transition: all 0.3s ease;
  box-shadow: 0 4px 6px -1px rgba(34, 197, 94, 0.3);
}

.submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(34, 197, 94, 0.3), 0 10px 10px -5px rgba(34, 197, 94, 0.1);
}

/* 通用样式 */
.mb20 {
  margin-bottom: 20px;
}

.mb8 {
  margin-bottom: 8px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .weather-container {
    padding: 12px;
  }
  
  .card-header {
    padding: 16px 20px;
  }
  
  .weather-content {
    padding: 16px 20px;
  }
  
  .weather-item {
    padding: 16px;
    margin-bottom: 12px;
  }
  
  .weather-icon {
    font-size: 36px;
    margin-right: 16px;
  }
  
  .weather-value {
    font-size: 24px;
  }
}

/* 动画效果 */
@keyframes shimmer {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

.weather-item {
  animation: fadeInUp 0.6s ease-out;
}

.weather-item:nth-child(1) { animation-delay: 0.1s; }
.weather-item:nth-child(2) { animation-delay: 0.2s; }
.weather-item:nth-child(3) { animation-delay: 0.3s; }
.weather-item:nth-child(4) { animation-delay: 0.4s; }

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
