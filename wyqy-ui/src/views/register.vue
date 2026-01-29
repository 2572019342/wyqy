<template>
  <div class="register">
    <!-- 背景装饰 -->
    <div class="register-background">
      <div class="bg-pattern"></div>
      <div class="bg-gradient"></div>
    </div>
    
    <!-- 注册表单容器 -->
    <div class="register-container">
      <div class="register-left">
        <div class="welcome-content">
          <div class="logo-section">
            <div class="logo-icon">
              <svg viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M32 8L12 20V44L32 56L52 44V20L32 8Z" fill="#0575E6" opacity="0.2"/>
                <path d="M32 16L20 24V40L32 48L44 40V24L32 16Z" fill="#00F260" opacity="0.4"/>
                <circle cx="32" cy="32" r="8" fill="url(#grad1)"/>
                <path d="M28 28L30 30L36 24" stroke="white" stroke-width="2" stroke-linecap="round"/>
                <defs>
                  <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%">
                    <stop offset="0%" style="stop-color:#0575E6;stop-opacity:1" />
                    <stop offset="100%" style="stop-color:#00F260;stop-opacity:1" />
                  </linearGradient>
                </defs>
              </svg>
            </div>
            <h1 class="system-title">智慧农业管理系统</h1>
            <p class="system-subtitle">Smart Agricultural Management System</p>
          </div>
          <div class="feature-list">
            <div class="feature-item">
              <div class="feature-icon">🌱</div>
              <div class="feature-text">
                <h3>智能种植</h3>
                <p>科学管理农作物生长</p>
              </div>
            </div>
            <div class="feature-item">
              <div class="feature-icon">🚜</div>
              <div class="feature-text">
                <h3>农机调度</h3>
                <p>优化农业机械使用</p>
              </div>
            </div>
            <div class="feature-item">
              <div class="feature-icon">🌾</div>
              <div class="feature-text">
                <h3>产量预测</h3>
                <p>精准预测农业收成</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div class="register-right">
        <el-form ref="registerForm" :model="registerForm" :rules="registerRules" class="register-form">
          <div class="form-header">
            <h2 class="form-title">创建账户</h2>
            <p class="form-subtitle">加入智慧农业管理平台</p>
          </div>
          
          <el-form-item prop="username">
            <el-input 
              v-model="registerForm.username" 
              type="text" 
              auto-complete="off" 
              placeholder="请输入用户名"
              prefix-icon="el-icon-user"
              class="custom-input"
            />
          </el-form-item>
          
          <el-form-item prop="password">
            <el-input
              v-model="registerForm.password"
              type="password"
              auto-complete="off"
              placeholder="请输入密码"
              prefix-icon="el-icon-lock"
              class="custom-input"
              show-password
              @keyup.enter.native="handleRegister"
            />
          </el-form-item>
          
          <el-form-item prop="confirmPassword">
            <el-input
              v-model="registerForm.confirmPassword"
              type="password"
              auto-complete="off"
              placeholder="请确认密码"
              prefix-icon="el-icon-lock"
              class="custom-input"
              show-password
              @keyup.enter.native="handleRegister"
            />
          </el-form-item>
          
          <el-form-item prop="code" v-if="captchaEnabled">
            <el-input
              v-model="registerForm.code"
              auto-complete="off"
              placeholder="请输入验证码"
              prefix-icon="el-icon-picture"
              class="custom-input code-input"
              @keyup.enter.native="handleRegister"
            />
            <div class="register-code">
              <img :src="codeUrl" @click="getCode" class="register-code-img"/>
            </div>
          </el-form-item>
          
          <el-form-item style="width:100%; margin-top: 20px;">
            <el-button
              :loading="loading"
              size="medium"
              type="primary"
              class="register-button"
              @click.native.prevent="handleRegister"
            >
              <span v-if="!loading">立即注册</span>
              <span v-else>注册中...</span>
            </el-button>
            <div style="text-align: center; margin-top: 15px;">
              <router-link class="link-type" :to="'/login'">已有账户？立即登录</router-link>
            </div>
          </el-form-item>
        </el-form>
      </div>
    </div>
    
    <!--  底部  -->
    <div class="el-register-footer">
      <span>{{ footerContent }}</span>
    </div>
  </div>
</template>

<script>
import { getCodeImg, register } from "@/api/login"
import defaultSettings from '@/settings'

export default {
  name: "Register",
  data() {
    const equalToPassword = (rule, value, callback) => {
      if (this.registerForm.password !== value) {
        callback(new Error("两次输入的密码不一致"))
      } else {
        callback()
      }
    }
    return {
      title: process.env.VUE_APP_TITLE,
      footerContent: defaultSettings.footerContent,
      codeUrl: "",
      registerForm: {
        username: "",
        password: "",
        confirmPassword: "",
        code: "",
        uuid: ""
      },
      registerRules: {
        username: [
          { required: true, trigger: "blur", message: "请输入您的账号" },
          { min: 2, max: 20, message: '用户账号长度必须介于 2 和 20 之间', trigger: 'blur' }
        ],
        password: [
          { required: true, trigger: "blur", message: "请输入您的密码" },
          { min: 5, max: 20, message: "用户密码长度必须介于 5 和 20 之间", trigger: "blur" },
          { pattern: /^[^<>"'|\\]+$/, message: "不能包含非法字符：< > \" ' \\\ |", trigger: "blur" }
        ],
        confirmPassword: [
          { required: true, trigger: "blur", message: "请再次输入您的密码" },
          { required: true, validator: equalToPassword, trigger: "blur" }
        ],
        code: [{ required: true, trigger: "change", message: "请输入验证码" }]
      },
      loading: false,
      captchaEnabled: true
    }
  },
  created() {
    this.getCode()
  },
  methods: {
    getCode() {
      getCodeImg().then(res => {
        this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
        if (this.captchaEnabled) {
          this.codeUrl = "data:image/gif;base64," + res.img
          this.registerForm.uuid = res.uuid
        }
      })
    },
    handleRegister() {
      this.$refs.registerForm.validate(valid => {
        if (valid) {
          this.loading = true
          register(this.registerForm).then(res => {
            const username = this.registerForm.username
            this.$alert("<font color='red'>恭喜你，您的账号 " + username + " 注册成功！</font>", '系统提示', {
              dangerouslyUseHTMLString: true,
              type: 'success'
            }).then(() => {
              this.$router.push("/login")
            }).catch(() => {})
          }).catch(() => {
            this.loading = false
            if (this.captchaEnabled) {
              this.getCode()
            }
          })
        }
      })
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
.register {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-color: #F7F9FC;
  position: relative;
  overflow: hidden;
}

.register-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 0;
  
  .bg-pattern {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-image: 
      radial-gradient(circle at 20% 80%, rgba(5, 117, 230, 0.1) 0%, transparent 50%),
      radial-gradient(circle at 80% 20%, rgba(0, 242, 96, 0.1) 0%, transparent 50%),
      radial-gradient(circle at 40% 40%, rgba(5, 117, 230, 0.05) 0%, transparent 50%);
    animation: float 6s ease-in-out infinite;
  }
  
  .bg-gradient {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, 
      rgba(5, 117, 230, 0.03) 0%, 
      rgba(0, 242, 96, 0.03) 100%);
  }
}

.register-container {
  display: flex;
  width: 900px;
  height: 600px;
  background: white;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  z-index: 1;
  position: relative;
}

.register-left {
  flex: 1;
  background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
  position: relative;
  overflow: hidden;
  
  &::before {
    content: '';
    position: absolute;
    top: -50%;
    right: -50%;
    width: 200%;
    height: 200%;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
    animation: rotate 20s linear infinite;
  }
}

.register-right {
  flex: 1;
  padding: 60px 50px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.welcome-content {
  text-align: center;
  color: white;
  position: relative;
  z-index: 1;
}

.logo-section {
  margin-bottom: 40px;
  
  .logo-icon {
    width: 80px;
    height: 80px;
    margin: 0 auto 20px;
    animation: pulse 2s ease-in-out infinite;
  }
  
  .system-title {
    font-size: 28px;
    font-weight: 700;
    margin: 0 0 8px 0;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
  
  .system-subtitle {
    font-size: 14px;
    opacity: 0.9;
    margin: 0;
  }
}

.feature-list {
  .feature-item {
    display: flex;
    align-items: center;
    margin-bottom: 24px;
    text-align: left;
    opacity: 0;
    animation: fadeInUp 0.6s ease-out forwards;
    
    &:nth-child(1) { animation-delay: 0.2s; }
    &:nth-child(2) { animation-delay: 0.4s; }
    &:nth-child(3) { animation-delay: 0.6s; }
    
    .feature-icon {
      font-size: 32px;
      margin-right: 16px;
      animation: bounce 2s ease-in-out infinite;
      
      &:nth-child(odd) {
        animation-delay: 0.3s;
      }
    }
    
    .feature-text {
      h3 {
        font-size: 16px;
        font-weight: 600;
        margin: 0 0 4px 0;
      }
      
      p {
        font-size: 14px;
        opacity: 0.8;
        margin: 0;
      }
    }
  }
}

.register-form {
  width: 100%;
  
  .form-header {
    text-align: center;
    margin-bottom: 32px;
    
    .form-title {
      font-size: 28px;
      font-weight: 700;
      color: #1E293B;
      margin: 0 0 8px 0;
    }
    
    .form-subtitle {
      font-size: 14px;
      color: #64748B;
      margin: 0;
    }
  }
  
  .custom-input {
    margin-bottom: 16px;
    
    ::v-deep .el-input__inner {
      height: 48px;
      border: 2px solid #E2E8F0;
      border-radius: 12px;
      padding: 0 16px 0 44px;
      font-size: 15px;
      transition: all 0.3s ease;
      background: #F8FAFC;
      
      &:focus {
        border-color: #0575E6;
        background: white;
        box-shadow: 0 0 0 3px rgba(5, 117, 230, 0.1);
      }
      
      &::placeholder {
        color: #94A3B8;
      }
    }
    
    ::v-deep .el-input__prefix {
      left: 16px;
      color: #64748B;
    }
  }
  
  .code-input {
    ::v-deep .el-input__inner {
      padding-right: 120px;
    }
  }
  
  .register-code {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
    width: 90px;
    height: 36px;
    border-radius: 8px;
    overflow: hidden;
    cursor: pointer;
    transition: all 0.3s ease;
    
    &:hover {
      transform: translateY(-50%) scale(1.05);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }
    
    .register-code-img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
  }
  
  .register-button {
    width: 100%;
    height: 48px;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 600;
    background: linear-gradient(135deg, #0575E6 0%, #00F260 100%);
    border: none;
    transition: all 0.3s ease;
    
    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 20px rgba(5, 117, 230, 0.3);
    }
    
    &:active {
      transform: translateY(0);
    }
  }
  
  .link-type {
    color: #0575E6;
    text-decoration: none;
    font-weight: 500;
    transition: all 0.3s ease;
    
    &:hover {
      color: #00F260;
      text-decoration: underline;
    }
  }
}

.el-register-footer {
  height: 40px;
  line-height: 40px;
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
  color: #1E293B;
  font-family: Arial;
  font-size: 12px;
  letter-spacing: 1px;
  background: rgba(247, 249, 252, 0.9);
  backdrop-filter: blur(10px);
}

.register-code-img {
  height: 38px;
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-20px); }
}

@keyframes rotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@keyframes pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.05); }
}

@keyframes bounce {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

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

// 响应式设计
@media (max-width: 768px) {
  .register-container {
    flex-direction: column;
    width: 95%;
    height: auto;
    max-height: 90vh;
    overflow-y: auto;
  }
  
  .register-left {
    padding: 30px;
    min-height: 300px;
  }
  
  .register-right {
    padding: 30px 20px;
  }
}
</style>
