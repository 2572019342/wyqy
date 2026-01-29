<template>
  <div class="crop-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <h2 class="page-title">
          <i class="el-icon-s-opportunity"></i>
          作物种类管理
        </h2>
        <div class="header-actions">
          <el-button type="primary" icon="el-icon-plus" @click="handleAdd"
                     class="add-btn">新增作物</el-button>
        </div>
      </div>
    </div>


    <!-- 查询条件11 11-->
    <div class="search-section">
      <div class="section-card">
        <div class="card-header">
          <h3 class="section-title">
            <i class="el-icon-search"></i>
            查询条件
          </h3>
          <el-button type="primary" icon="el-icon-search" @click="getList"
                     class="search-btn">查询</el-button>
        </div>
        <div class="card-content">
          <el-form :model="queryParams" ref="queryForm" :inline="true" class="search-form">
            <el-form-item label="作物名称" prop="speciesName">
              <el-input v-model="queryParams.speciesName" placeholder="请输入作物名称"
                       clearable class="search-input" />
            </el-form-item>
            <el-form-item label="作物编码" prop="speciesCode">
              <el-input v-model="queryParams.speciesCode" placeholder="请输入作物编码"
                       clearable class="search-input" />
            </el-form-item>
            <el-form-item label="作物分类" prop="category">
              <el-select v-model="queryParams.category" placeholder="请选择作物分类"
                         clearable class="search-select">
                <el-option label="粮食作物" value="粮食作物" />
                <el-option label="经济作物" value="经济作物" />
                <el-option label="蔬菜作物" value="蔬菜作物" />
                <el-option label="水果作物" value="水果作物" />
              </el-select>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </div>

    <!-- 作物种类列表 -->
    <div class="crops-section">
      <div class="section-header">
        <h3 class="section-title">
          <i class="el-icon-list"></i>
          作物种类列表
        </h3>
        <div class="section-stats">
          <span class="stats-item">
            <i class="el-icon-data-analysis"></i>
            共 {{ total }} 种作物
          </span>
          <el-button-group class="action-group">
            <el-button type="danger" icon="el-icon-delete" :disabled="ids.length === 0"
                       @click="handleDelete" class="batch-delete-btn">批量删除</el-button>
          </el-button-group>
        </div>
      </div>

      <div v-loading="loading" class="crops-grid">
        <el-empty v-if="cropList.length === 0" description="暂无作物数据"
                  class="empty-state">
          <el-button type="primary" @click="handleAdd">新增作物</el-button>
        </el-empty>
        <div v-else class="cards-container">
          <el-row :gutter="20">
            <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="crop in cropList" :key="crop.speciesId" class="crop-card-col">
              <div class="crop-card" :class="{ 'card-selected': isSelected(crop.speciesId) }">
                <div class="card-header">
                  <el-checkbox
                    :value="isSelected(crop.speciesId)"
                    @change="toggleSelection(crop)"
                    class="card-checkbox"
                  ></el-checkbox>
                  <div class="crop-info">
                    <h4 class="crop-name">{{ crop.speciesName || '未命名作物' }}</h4>
                    <p class="crop-code">{{ crop.speciesCode || '无编码' }}</p>
                  </div>
                  <div class="crop-status">
                    <el-tag :type="crop.status === '0' ? 'success' : 'danger'" size="mini">
                      {{ crop.status === '0' ? '正常' : '停用' }}
                    </el-tag>
                  </div>
                </div>
                <!-- 作物图片 -->
                <div class="card-image" v-if="crop.imageUrl && crop.imageUrl.trim()">
                  <el-image
                    :src="getImageUrl(crop.imageUrl)"
                    fit="cover"
                    :preview-src-list="[getImageUrl(crop.imageUrl)]"
                    class="crop-image"
                    @error="handleImageError"
                    @load="handleImageLoad"
                  >
                    <div slot="error" class="image-slot">
                      <i class="el-icon-picture-outline"></i>
                      <span style="font-size: 12px; margin-top: 5px;">加载失败</span>
                    </div>
                  </el-image>
                </div>
                <div class="card-image" v-else style="background: #f5f7fa; display: flex; align-items: center; justify-content: center; color: #909399;">
                  <div style="text-align: center;">
                    <i class="el-icon-picture-outline" style="font-size: 40px;"></i>
                    <div style="font-size: 12px; margin-top: 5px;">暂无图片</div>
                  </div>
                </div>
                <div class="card-body">
                  <div class="data-grid">
                    <div class="data-item">
                      <div class="data-label">
                        <i class="el-icon-notebook-2"></i>
                        <span>学名</span>
                      </div>
                      <div class="data-value">{{ crop.scientificName || '--' }}</div>
                    </div>
                    <div class="data-item">
                      <div class="data-label">
                        <i class="el-icon-collection-tag"></i>
                        <span>分类</span>
                      </div>
                      <div class="data-value">
                        <el-tag size="mini" type="success">{{ crop.category || '--' }}</el-tag>
                      </div>
                    </div>
                    <div class="data-item">
                      <div class="data-label">
                        <i class="el-icon-time"></i>
                        <span>生长周期</span>
                      </div>
                      <div class="data-value">{{ crop.growthCycle != null ? crop.growthCycle + ' 天' : '--' }}</div>
                    </div>
                    <div class="data-item">
                      <div class="data-label">
                        <i class="el-icon-pie-chart"></i>
                        <span>预期产量</span>
                      </div>
                      <div class="data-value">{{ crop.estimatedYield != null ? crop.estimatedYield + ' kg/亩' : '--' }}</div>
                    </div>
                    <div class="data-item">
                      <div class="data-label">
                        <i class="el-icon-first-aid-kit"></i>
                        <span>抗病性</span>
                      </div>
                      <div class="data-value">
                        <el-rate
                          v-model="crop.diseaseResistance"
                          disabled
                          show-score
                          text-color="#ff9900"
                          score-template="{value}"
                          :max="5"
                        ></el-rate>
                      </div>
                    </div>
                    <div class="data-item">
                      <div class="data-label">
                        <i class="el-icon-info"></i>
                        <span>状态</span>
                      </div>
                      <div class="data-value">
                        <el-tag :type="crop.status === '0' ? 'success' : 'danger'" size="mini">
                          {{ crop.status === '0' ? '正常' : '停用' }}
                        </el-tag>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="card-footer">
                  <div class="card-actions">
                    <el-button size="mini" type="primary" icon="el-icon-edit"
                               @click="handleUpdate(crop)" class="action-btn edit-btn">修改</el-button>
                    <el-button size="mini" type="danger" icon="el-icon-delete"
                               @click="handleDelete(crop)" class="action-btn delete-btn">删除</el-button>
                  </div>
                </div>
              </div>
            </el-col>
          </el-row>
        </div>
      </div>

      <!-- 分页 -->
      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
        class="pagination"
      />
    </div>

    <!-- 添加或修改作物种类对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="900px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="120px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="作物名称" prop="speciesName">
              <el-input v-model="form.speciesName" placeholder="请输入作物名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="作物编号" prop="speciesCode">
              <el-input v-model="form.speciesCode" placeholder="请输入作物编号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="学名" prop="scientificName">
              <el-input v-model="form.scientificName" placeholder="请输入学名" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="作物分类" prop="category">
              <el-select v-model="form.category" placeholder="请选择作物分类" style="width: 100%">
                <el-option label="粮食作物" value="粮食作物" />
                <el-option label="经济作物" value="经济作物" />
                <el-option label="蔬菜作物" value="蔬菜作物" />
                <el-option label="水果作物" value="水果作物" />
                <el-option label="其他" value="其他" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="生长周期(天)" prop="growthCycle">
              <el-input-number v-model="form.growthCycle" :min="1" :max="365" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="种植密度(株/亩)" prop="plantingDensity">
              <el-input-number v-model="form.plantingDensity" :precision="2" :step="100" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="预期产量(kg/亩)" prop="estimatedYield">
              <el-input-number v-model="form.estimatedYield" :precision="2" :step="10" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-divider content-position="left">生长条件</el-divider>

        <el-row>
          <el-col :span="12">
            <el-form-item label="最适温度(℃)">
              <el-row>
                <el-col :span="12">
                  <el-input-number v-model="form.suitableTempMin" :precision="1" :step="0.5" :min="-20" :max="50" placeholder="最低" style="width: 100%" />
                </el-col>
                <el-col :span="12">
                  <el-input-number v-model="form.suitableTempMax" :precision="1" :step="0.5" :min="-20" :max="50" placeholder="最高" style="width: 100%" />
                </el-col>
              </el-row>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="最适湿度(%)">
              <el-row>
                <el-col :span="12">
                  <el-input-number v-model="form.suitableHumidityMin" :precision="1" :step="1" :min="0" :max="100" placeholder="最低" style="width: 100%" />
                </el-col>
                <el-col :span="12">
                  <el-input-number v-model="form.suitableHumidityMax" :precision="1" :step="1" :min="0" :max="100" placeholder="最高" style="width: 100%" />
                </el-col>
              </el-row>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="12">
            <el-form-item label="水分需求" prop="waterRequirement">
              <el-select v-model="form.waterRequirement" placeholder="请选择水分需求" style="width: 100%">
                <el-option label="低" value="低" />
                <el-option label="中等" value="中等" />
                <el-option label="较高" value="较高" />
                <el-option label="高" value="高" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="光照需求" prop="lightRequirement">
              <el-select v-model="form.lightRequirement" placeholder="请选择光照需求" style="width: 100%">
                <el-option label="弱光" value="弱光" />
                <el-option label="中等" value="中等" />
                <el-option label="充足" value="充足" />
                <el-option label="强光" value="强光" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="24">
            <el-form-item label="肥料需求" prop="fertilizerRequirement">
              <el-input v-model="form.fertilizerRequirement" placeholder="请输入肥料需求" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="24">
            <el-form-item label="土壤要求" prop="soilRequirement">
              <el-input v-model="form.soilRequirement" placeholder="请输入土壤要求" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-divider content-position="left">抗性特征</el-divider>

        <el-row>
          <el-col :span="12">
            <el-form-item label="抗病性" prop="diseaseResistance">
              <el-rate
                v-model="form.diseaseResistance"
                :max="5"
                show-score
                text-color="#ff9900"
                score-template="{value}"
              ></el-rate>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="抗虫性" prop="pestResistance">
              <el-input v-model="form.pestResistance" placeholder="请输入抗虫性" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="24">
            <el-form-item label="描述" prop="description">
              <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入描述" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <el-col :span="12">
            <el-form-item label="作物图片" prop="imageUrl">
              <image-upload
                v-model="form.imageUrl"
                :limit="1"
                :fileSize="5"
                :fileType="['png', 'jpg', 'jpeg', 'gif', 'bmp']"
                action="/common/upload/photo"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio label="0">正常</el-radio>
                <el-radio label="1">停用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="备注" prop="notes">
          <el-input v-model="form.notes" type="textarea" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
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
      open: false,
      title: "",
      form: {},
      rules: {
        speciesName: [
          { required: true, message: "作物名称不能为空", trigger: "blur" }
        ],
        speciesCode: [
          { required: true, message: "作物编号不能为空", trigger: "blur" }
        ],
        category: [
          { required: true, message: "作物分类不能为空", trigger: "change" }
        ]
      },
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
  watch: {
    // 监听form.imageUrl的变化，用于调试
    'form.imageUrl'(newVal) {
      console.log('图片URL已更新:', newVal);
    }
  },
  methods: {
    getList() {
      this.loading = true;
      listCrop(this.queryParams).then(response => {
        console.log('作物API返回数据:', response);
        if (response && response.rows) {
          this.cropList = response.rows || [];
          this.total = response.total || 0;
          // 调试：打印每个作物的图片URL
          this.cropList.forEach(crop => {
            console.log(`作物 ${crop.speciesName} (ID: ${crop.speciesId}):`, {
              imageUrl: crop.imageUrl,
              imageUrlType: typeof crop.imageUrl,
              imageUrlLength: crop.imageUrl ? crop.imageUrl.length : 0,
              processedUrl: this.getImageUrl(crop.imageUrl)
            });
          });
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
    // 判断是否选中（卡片用）
    isSelected(speciesId) {
      return this.ids.includes(speciesId)
    },
    // 切换选择状态（卡片用）
    toggleSelection(crop) {
      const index = this.ids.indexOf(crop.speciesId)
      if (index > -1) {
        this.ids.splice(index, 1)
      } else {
        this.ids.push(crop.speciesId)
      }
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "新增作物";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const speciesId = row.speciesId || (this.ids.length === 1 ? this.ids[0] : null);
      if (!speciesId) {
        this.$message.warning("请选择一条数据进行修改");
        return;
      }
      getCrop(speciesId).then(response => {
        this.form = response.data;
        // 确保抗病性是数字类型（如果是字符串需要转换）
        if (this.form.diseaseResistance && typeof this.form.diseaseResistance === 'string') {
          this.form.diseaseResistance = parseFloat(this.form.diseaseResistance) || 0;
        }
        // 调试：打印表单数据，特别是图片URL
        console.log('加载的作物数据:', this.form);
        console.log('图片URL:', this.form.imageUrl);
        this.open = true;
        this.title = "修改作物";
      }).catch(error => {
        this.$message.error("获取作物信息失败");
        console.error(error);
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          // 确保imageUrl正确保存
          console.log('提交表单数据:', this.form);
          console.log('图片URL:', this.form.imageUrl);

          if (this.form.speciesId != null) {
            updateCrop(this.form).then(response => {
              this.$message.success("修改成功");
              this.open = false;
              this.getList();
            }).catch(error => {
              this.$message.error("修改失败: " + (error.msg || error.message || "未知错误"));
              console.error('修改失败:', error);
            });
          } else {
            addCrop(this.form).then(response => {
              this.$message.success("新增成功");
              this.open = false;
              this.getList();
            }).catch(error => {
              this.$message.error("新增失败: " + (error.msg || error.message || "未知错误"));
              console.error('新增失败:', error);
            });
          }
        }
      });
    },
    /** 取消按钮 */
    cancel() {
      this.open = false;
      this.reset();
    },
    /** 表单重置 */
    reset() {
      this.form = {
        speciesId: null,
        speciesName: null,
        speciesCode: null,
        scientificName: null,
        category: null,
        growthCycle: null,
        suitableTempMin: null,
        suitableTempMax: null,
        suitableHumidityMin: null,
        suitableHumidityMax: null,
        waterRequirement: null,
        fertilizerRequirement: null,
        lightRequirement: null,
        soilRequirement: null,
        plantingDensity: null,
        estimatedYield: null,
        diseaseResistance: 0,
        pestResistance: null,
        description: null,
        imageUrl: null,
        status: "0",
        notes: null
      };
      this.resetForm("form");
    },
    /** 获取图片URL */
    getImageUrl(imageUrl) {
      if (!imageUrl || !imageUrl.trim()) {
        return '';
      }
      // 去除首尾空格
      imageUrl = imageUrl.trim();

      // 如果已经是完整URL，直接返回
      if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
        return imageUrl;
      }

      // 如果路径以/photo/开头，直接使用（不经过API代理，直接访问静态资源）
      if (imageUrl.startsWith('/photo/')) {
        // 直接返回，不添加base API，因为photo是静态资源路径
        const url = imageUrl;
        console.log('图片URL处理 - /photo/路径:', url);
        return url;
      }

      // 如果是profile路径，添加base API
      if (imageUrl.startsWith('/profile/')) {
        const url = process.env.VUE_APP_BASE_API + imageUrl;
        console.log('图片URL处理 - /profile/路径:', url);
        return url;
      }

      // 如果路径中包含photo，确保以/photo/开头
      if (imageUrl.includes('photo')) {
        let url;
        if (!imageUrl.startsWith('/')) {
          url = '/photo/' + imageUrl.replace(/^.*photo[\/\\]?/, '');
        } else {
          url = imageUrl;
        }
        console.log('图片URL处理 - 包含photo:', url);
        return url;
      }

      // 其他情况，假设是文件名，尝试从photo文件夹读取
      if (!imageUrl.includes('/')) {
        const url = '/photo/' + imageUrl;
        console.log('图片URL处理 - 文件名:', url);
        return url;
      }

      // 默认添加base API前缀
      const url = process.env.VUE_APP_BASE_API + '/' + imageUrl;
      console.log('图片URL处理 - 默认:', url);
      return url;
    },
    /** 图片加载成功处理 */
    handleImageLoad() {
      console.log('图片加载成功');
    },
    /** 图片加载错误处理 */
    handleImageError(event) {
      console.error('图片加载失败:', event);
      console.error('失败的图片URL:', event.target?.src);
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      let cropIds;
      let message;

      if (row && row.speciesId) {
        // 单个删除
        cropIds = row.speciesId;
        message = '是否确认删除作物"' + (row.speciesName || cropIds) + '"?';
      } else if (this.ids && this.ids.length > 0) {
        // 批量删除
        cropIds = this.ids;
        message = '是否确认删除选中的 ' + this.ids.length + ' 条数据?';
      } else {
        this.$message.warning("请选择要删除的数据");
        return;
      }

      this.$confirm(message, "警告", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      }).then(() => {
        // 如果是数组，需要转换为后端接受的格式
        const deleteIds = Array.isArray(cropIds) ? cropIds : [cropIds];
        return delCrop(deleteIds.join(',')).then(() => {
          this.getList();
          this.ids = []; // 清空选中项
          this.$message.success("删除成功");
        }).catch(error => {
          // 提取错误信息
          let errorMsg = "删除失败";
          if (error.response && error.response.data) {
            errorMsg = error.response.data.msg || error.response.data.message || errorMsg;
          } else if (error.msg) {
            errorMsg = error.msg;
          } else if (error.message) {
            errorMsg = error.message;
          }

          // 如果是外键约束错误，显示更友好的提示
          if (errorMsg.includes("外键约束") || errorMsg.includes("种植记录") || errorMsg.includes("引用") || errorMsg.includes("无法删除")) {
            this.$message({
              message: errorMsg,
              type: 'warning',
              duration: 5000,
              showClose: true
            });
          } else {
            this.$message.error(errorMsg);
          }
          console.error('删除失败:', error);
        });
      }).catch(() => {
        // 用户取消删除，不显示错误
      });
    }
  }
}
</script>

<style scoped>
/* 主容器样式 */
.crop-container {
  background-color: #F7F9FC;
  min-height: 100vh;
  padding: 20px;
}

/* 页面头部 */
.page-header {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  border-radius: 16px;
  padding: 24px 32px;
  margin-bottom: 24px;
  box-shadow: 0 8px 32px rgba(5, 117, 230, 0.3);
  position: relative;
  overflow: hidden;
}

.page-header::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(45deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0.05) 100%);
  pointer-events: none;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: relative;
  z-index: 1;
}

.page-title {
  color: white;
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 12px;
}

.page-title i {
  font-size: 28px;
}

.add-btn {
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  border-radius: 8px;
  padding: 10px 20px;
  font-size: 14px;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.add-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

/* 统计信息区域 */
.stats-section {
  margin-bottom: 24px;
}

.stat-card {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(5, 117, 230, 0.1);
  display: flex;
  align-items: center;
  gap: 16px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(5, 117, 230, 0.15);
}

.stat-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #0575E6 0%, #00F260 100%);
}

.total-card .stat-icon {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
}

.normal-card .stat-icon {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
}

.grain-card .stat-icon {
  background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
}

.economic-card .stat-icon {
  background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
}

.stat-icon {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 24px;
  flex-shrink: 0;
}

.stat-content {
  flex: 1;
}

.stat-title {
  color: #64748B;
  font-size: 14px;
  margin-bottom: 8px;
  font-weight: 500;
}

.stat-value {
  color: #1E293B;
  font-size: 28px;
  font-weight: bold;
}

/* 搜索区域 */
.search-section {
  margin-bottom: 24px;
}

.section-card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(5, 117, 230, 0.1);
  overflow: hidden;
}

.card-header {
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  padding: 20px 24px;
  border-bottom: 1px solid #f1f5f9;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.section-title {
  color: #1E293B;
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 8px;
}

.section-title i {
  color: #0575E6;
  font-size: 20px;
}

.search-btn {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  border: none;
  border-radius: 8px;
  color: white;
  font-weight: 500;
  transition: all 0.3s ease;
}

.search-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(5, 117, 230, 0.3);
}

.card-content {
  padding: 24px;
}

.search-form {
  display: flex;
  gap: 20px;
  align-items: flex-end;
  flex-wrap: wrap;
}

.search-input,
.search-select {
  min-width: 200px;
}

.search-input .el-input__inner,
.search-select .el-input__inner {
  border-radius: 8px;
  border: 1px solid #e2e8f0;
  transition: all 0.3s ease;
}

.search-input .el-input__inner:focus,
.search-select .el-input__inner:focus {
  border-color: #0575E6;
  box-shadow: 0 0 0 3px rgba(5, 117, 230, 0.1);
}

/* 作物列表区域 */
.crops-section {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(5, 117, 230, 0.1);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid #f1f5f9;
}

.section-stats {
  display: flex;
  gap: 16px;
  align-items: center;
}

.stats-item {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #64748B;
  font-size: 14px;
}

.stats-item i {
  color: #0575E6;
}

.action-group {
  display: flex;
  gap: 8px;
}

.batch-delete-btn {
  background: #ef4444;
  border: none;
  border-radius: 8px;
  color: white;
  transition: all 0.3s ease;
}

.batch-delete-btn:hover {
  background: #dc2626;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
}

.crops-grid {
  min-height: 400px;
}

.cards-container {
  padding: 8px 0;
}

.crop-card-col {
  margin-bottom: 20px;
}

.crop-card {
  background: white;
  border-radius: 12px;
  border: 2px solid transparent;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
  cursor: pointer;
  overflow: hidden;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.crop-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(5, 117, 230, 0.15);
  border-color: rgba(5, 117, 230, 0.2);
}

.crop-card.card-selected {
  border-color: #0575E6;
  background: linear-gradient(135deg, rgba(5, 117, 230, 0.05) 0%, rgba(0, 242, 96, 0.05) 100%);
}

.crop-card .card-header {
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
  padding: 16px 20px;
  border-bottom: 1px solid #f1f5f9;
  display: flex;
  align-items: center;
  gap: 12px;
}

.card-checkbox {
  margin-right: 8px;
}

.crop-info {
  flex: 1;
}

.crop-info h4 {
  color: #1E293B;
  margin: 0 0 4px 0;
  font-size: 16px;
  font-weight: 600;
}

.crop-info p {
  color: #64748B;
  margin: 0;
  font-size: 12px;
}

.crop-status {
  display: flex;
  align-items: center;
}

/* 作物图片区域 */
.card-image {
  width: 100%;
  height: 200px;
  overflow: hidden;
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid #f1f5f9;
}

.crop-image {
  width: 100%;
  height: 100%;
  transition: transform 0.3s ease;
}

.crop-image:hover {
  transform: scale(1.05);
}

.crop-image ::v-deep .el-image__inner {
  width: 100%;
  height: 100%;
  object-fit: cover;
  cursor: pointer;
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  color: #909399;
  font-size: 40px;
}

.crop-card .card-body {
  padding: 20px;
  flex: 1;
}

.data-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.data-item {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.data-label {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: #64748B;
  font-weight: 500;
}

.data-label i {
  font-size: 14px;
  color: #0575E6;
}

.data-value {
  font-size: 14px;
  font-weight: 600;
  color: #1E293B;
  word-break: break-word;
}

.crop-card .card-footer {
  padding: 16px 20px;
  border-top: 1px solid #f1f5f9;
  background: #f8fafc;
}

.card-actions {
  display: flex;
  gap: 8px;
}

.action-btn {
  flex: 1;
  border-radius: 6px;
  font-size: 12px;
  padding: 8px 12px;
  transition: all 0.3s ease;
  border: none;
}

.action-btn.edit-btn {
  background: #10b981;
  color: white;
}

.action-btn.edit-btn:hover {
  background: #059669;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
}

.action-btn.delete-btn {
  background: #ef4444;
  color: white;
}

.action-btn.delete-btn:hover {
  background: #dc2626;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 60px 20px;
}

/* 分页样式 */
.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .crop-container {
    padding: 12px;
  }

  .page-header {
    padding: 20px;
  }

  .header-content {
    flex-direction: column;
    gap: 16px;
    text-align: center;
  }

  .stat-card {
    padding: 16px;
  }

  .stat-icon {
    width: 48px;
    height: 48px;
    font-size: 20px;
  }

  .stat-value {
    font-size: 24px;
  }

  .search-form {
    flex-direction: column;
    gap: 16px;
  }

  .search-input,
  .search-select {
    width: 100%;
  }

  .section-header {
    flex-direction: column;
    gap: 16px;
    text-align: center;
  }

  .data-grid {
    grid-template-columns: 1fr;
  }

  .card-actions {
    flex-direction: column;
  }

  .action-btn {
    width: 100%;
  }
}

/* 动画效果 */
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

.crop-card {
  animation: fadeInUp 0.6s ease-out;
}

.crop-card:nth-child(1) { animation-delay: 0.1s; }
.crop-card:nth-child(2) { animation-delay: 0.2s; }
.crop-card:nth-child(3) { animation-delay: 0.3s; }
.crop-card:nth-child(4) { animation-delay: 0.4s; }

.stat-card {
  animation: fadeInUp 0.6s ease-out;
}

.stat-card:nth-child(1) { animation-delay: 0.1s; }
.stat-card:nth-child(2) { animation-delay: 0.2s; }
.stat-card:nth-child(3) { animation-delay: 0.3s; }
.stat-card:nth-child(4) { animation-delay: 0.4s; }

/* 对话框样式 */
::v-deep .el-dialog {
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
}

::v-deep .el-dialog__header {
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  padding: 20px 24px;
  border-radius: 12px 12px 0 0;
}

::v-deep .el-dialog__title {
  color: white;
  font-size: 18px;
  font-weight: 600;
}

::v-deep .el-dialog__headerbtn .el-dialog__close {
  color: white;
  font-size: 20px;
}

::v-deep .el-dialog__headerbtn:hover .el-dialog__close {
  color: rgba(255, 255, 255, 0.8);
}

::v-deep .el-dialog__body {
  padding: 24px;
  max-height: 70vh;
  overflow-y: auto;
}

::v-deep .el-dialog__footer {
  padding: 16px 24px;
  border-top: 1px solid #f1f5f9;
  background: #f8fafc;
  border-radius: 0 0 12px 12px;
}

::v-deep .el-form-item__label {
  font-weight: 500;
  color: #1E293B;
}

::v-deep .el-divider__text {
  background-color: white;
  color: #0575E6;
  font-weight: 600;
}
</style>
