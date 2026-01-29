<template>
  <div class="login">
    <!-- 背景装饰 -->
    <div class="login-background">
      <div class="bg-overlay"></div>
      <div class="floating-elements">
        <div class="leaf leaf-1"></div>
        <div class="leaf leaf-2"></div>
        <div class="leaf leaf-3"></div>
        <div class="circle circle-1"></div>
        <div class="circle circle-2"></div>
      </div>
    </div>
    
    <!-- 登录表单容器 -->
    <div class="login-container">
      <div class="login-left">
        <div class="welcome-content">
          <div class="logo-section">
            <div class="logo-icon">
              <svg viewBox="0 0 80 80" fill="none" xmlns="http://www.w3.org/2000/svg">
                <!-- 叶子图标 -->
                <circle cx="40" cy="40" r="36" fill="rgba(255,255,255,0.15)" />
                <path d="M40 18C40 18 24 28 24 42C24 52 31 58 40 58C49 58 56 52 56 42C56 28 40 18 40 18Z" fill="rgba(255,255,255,0.9)"/>
                <path d="M40 22C40 22 40 42 40 54" stroke="#2D5A27" stroke-width="2.5" stroke-linecap="round"/>
                <path d="M40 32C44 28 48 28 52 30" stroke="#2D5A27" stroke-width="2" stroke-linecap="round"/>
                <path d="M40 40C36 36 32 36 28 38" stroke="#2D5A27" stroke-width="2" stroke-linecap="round"/>
              </svg>
            </div>
            <h1 class="system-title">智慧农业管理系统</h1>
            <p class="system-subtitle">Smart Agricultural Management System</p>
          </div>
          
          <div class="divider"></div>
          
          <div class="feature-list">
            <div class="feature-item">
              <div class="feature-icon-wrapper">
                <svg viewBox="0 0 24 24" fill="none" class="feature-svg">
                  <path d="M12 2L4 7V12C4 16.4 7.2 20.5 12 22C16.8 20.5 20 16.4 20 12V7L12 2Z" stroke="currentColor" stroke-width="1.5" fill="rgba(255,255,255,0.1)"/>
                  <path d="M9 12L11 14L15 10" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <div class="feature-text">
                <h3>智能监控</h3>
                <p>实时监测农田环境数据</p>
              </div>
            </div>
            <div class="feature-item">
              <div class="feature-icon-wrapper">
                <svg viewBox="0 0 24 24" fill="none" class="feature-svg">
                  <rect x="3" y="3" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.5" fill="rgba(255,255,255,0.1)"/>
                  <rect x="14" y="3" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.5" fill="rgba(255,255,255,0.1)"/>
                  <rect x="3" y="14" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.5" fill="rgba(255,255,255,0.1)"/>
                  <rect x="14" y="14" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.5" fill="rgba(255,255,255,0.1)"/>
                </svg>
              </div>
              <div class="feature-text">
                <h3>数据分析</h3>
                <p>可视化农业生产报表</p>
              </div>
            </div>
            <div class="feature-item">
              <div class="feature-icon-wrapper">
                <svg viewBox="0 0 24 24" fill="none" class="feature-svg">
                  <path d="M12 2V6M12 18V22M6 12H2M22 12H18M19.07 4.93L16.24 7.76M7.76 16.24L4.93 19.07M19.07 19.07L16.24 16.24M7.76 7.76L4.93 4.93" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                  <circle cx="12" cy="12" r="4" stroke="currentColor" stroke-width="1.5" fill="rgba(255,255,255,0.1)"/>
                </svg>
              </div>
              <div class="feature-text">
                <h3>精准农业</h3>
                <p>科学指导农业生产</p>
              </div>
            </div>
          </div>
          
          <div class="stats-row">
            <div class="stat-item">
              <span class="stat-number">10K+</span>
              <span class="stat-label">活跃用户</span>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <span class="stat-number">500+</span>
              <span class="stat-label">合作农场</span>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <span class="stat-number">99.9%</span>
              <span class="stat-label">稳定运行</span>
            </div>
          </div>
        </div>
      </div>
      
      <div class="login-right">
        <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form">
          <div class="form-header">
            <div class="welcome-back">
              <span class="wave-emoji">👋</span>
              <span>欢迎回来</span>
            </div>
            <h2 class="form-title">登录您的账户</h2>
            <p class="form-subtitle">请输入您的凭据以继续访问系统</p>
          </div>
          
          <div class="input-group">
            <label class="input-label">账号</label>
            <el-form-item prop="username">
              <el-input
                v-model="loginForm.username"
                type="text"
                auto-complete="off"
                placeholder="请输入您的账号"
                prefix-icon="el-icon-user"
                class="custom-input"
              />
            </el-form-item>
          </div>
          
          <div class="input-group">
            <label class="input-label">密码</label>
            <el-form-item prop="password">
              <el-input
                v-model="loginForm.password"
                type="password"
                auto-complete="off"
                placeholder="请输入您的密码"
                prefix-icon="el-icon-lock"
                class="custom-input"
                @keyup.enter.native="handleLogin"
              />
            </el-form-item>
          </div>
          
          <div class="form-options">
            <el-checkbox v-model="loginForm.rememberMe">
              <span class="remember-text">记住我</span>
            </el-checkbox>
            <a href="#" class="forgot-password" v-if="false">忘记密码？</a>
          </div>
          
          <el-form-item style="width:100%; margin-top: 24px;">
            <el-button
              :loading="loading"
              size="medium"
              type="primary"
              class="login-button"
              @click.native.prevent="handleLogin"
            >
              <span v-if="!loading" class="btn-content">
                <span>登 录</span>
                <svg class="arrow-icon" viewBox="0 0 24 24" fill="none">
                  <path d="M5 12H19M19 12L12 5M19 12L12 19" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </span>
              <span v-else>登录中...</span>
            </el-button>
            <div class="register-link" v-if="register">
              <span class="register-text">还没有账号？</span>
              <router-link class="link-type" :to="'/register'">立即注册</router-link>
            </div>
          </el-form-item>
          
          <div class="security-badge">
            <svg viewBox="0 0 24 24" fill="none" class="shield-icon">
              <path d="M12 2L4 6V12C4 16.4 7.2 20.5 12 22C16.8 20.5 20 16.4 20 12V6L12 2Z" stroke="currentColor" stroke-width="1.5"/>
              <path d="M9 12L11 14L15 10" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <span>您的数据受到安全保护</span>
          </div>
        </el-form>
      </div>
    </div>
    
    <!--  底部  -->
    <div class="el-login-footer">
      <span>{{ footerContent }}</span>
    </div>
  </div>
</template>

<script>
import { getCodeImg } from "@/api/login"
import Cookies from "js-cookie"
import { encrypt, decrypt } from '@/utils/jsencrypt'
import defaultSettings from '@/settings'

export default {
  name: "Login",
  data() {
    return {
      title: process.env.VUE_APP_TITLE,
      footerContent: defaultSettings.footerContent,
      codeUrl: "",
      loginForm: {
        username: "admin",
        password: "admin123",
        rememberMe: false,
        code: "",
        uuid: ""
      },
      loginRules: {
        username: [
          { required: true, trigger: "blur", message: "请输入您的账号" }
        ],
        password: [
          { required: true, trigger: "blur", message: "请输入您的密码" }
        ]
      },
      loading: false,
      // 验证码开关
      captchaEnabled: false,
      // 注册开关
      register: false,
      redirect: undefined
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  created() {
    this.getCookie()
  },
  methods: {
    getCode() {
      getCodeImg().then(res => {
        this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
        if (this.captchaEnabled) {
          this.codeUrl = "data:image/gif;base64," + res.img
          this.loginForm.uuid = res.uuid
        }
      })
    },
    getCookie() {
      const username = Cookies.get("username")
      const password = Cookies.get("password")
      const rememberMe = Cookies.get('rememberMe')
      this.loginForm = {
        username: username === undefined ? this.loginForm.username : username,
        password: password === undefined ? this.loginForm.password : decrypt(password),
        rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
      }
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          if (this.loginForm.rememberMe) {
            Cookies.set("username", this.loginForm.username, { expires: 30 })
            Cookies.set("password", encrypt(this.loginForm.password), { expires: 30 })
            Cookies.set('rememberMe', this.loginForm.rememberMe, { expires: 30 })
          } else {
            Cookies.remove("username")
            Cookies.remove("password")
            Cookies.remove('rememberMe')
          }
          this.$store.dispatch("Login", this.loginForm).then(() => {
            this.$router.push({ path: this.redirect || "/" }).catch(()=>{})
          }).catch(() => {
            this.loading = false
          })
        }
      })
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
// 颜色变量
$primary-green: #2D5A27;
$light-green: #4A7C43;
$accent-green: #6B9F65;
$soft-green: #E8F5E6;
$cream: #FDFCF7;
$warm-white: #FFFEF9;
$text-dark: #1A1A1A;
$text-medium: #4A4A4A;
$text-light: #7A7A7A;
$border-color: #E5E5E5;

.login {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(145deg, $soft-green 0%, $cream 50%, $warm-white 100%);
  position: relative;
  overflow: hidden;
  padding: 20px;
}

.login-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 0;
  
  .bg-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: 
      radial-gradient(ellipse at 0% 0%, rgba($primary-green, 0.08) 0%, transparent 50%),
      radial-gradient(ellipse at 100% 100%, rgba($accent-green, 0.06) 0%, transparent 50%);
  }
  
  .floating-elements {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    pointer-events: none;
    
    .leaf {
      position: absolute;
      width: 60px;
      height: 60px;
      background: linear-gradient(135deg, rgba($accent-green, 0.15) 0%, rgba($light-green, 0.1) 100%);
      border-radius: 50% 0 50% 0;
      
      &.leaf-1 {
        top: 10%;
        left: 5%;
        animation: float1 8s ease-in-out infinite;
      }
      
      &.leaf-2 {
        top: 60%;
        right: 8%;
        width: 40px;
        height: 40px;
        animation: float2 10s ease-in-out infinite;
      }
      
      &.leaf-3 {
        bottom: 15%;
        left: 10%;
        width: 50px;
        height: 50px;
        animation: float3 12s ease-in-out infinite;
      }
    }
    
    .circle {
      position: absolute;
      border-radius: 50%;
      border: 1px solid rgba($primary-green, 0.1);
      
      &.circle-1 {
        width: 300px;
        height: 300px;
        top: -100px;
        right: -100px;
        animation: pulse-slow 8s ease-in-out infinite;
      }
      
      &.circle-2 {
        width: 200px;
        height: 200px;
        bottom: -50px;
        left: -50px;
        animation: pulse-slow 10s ease-in-out infinite reverse;
      }
    }
  }
}

.login-container {
  display: flex;
  width: 100%;
  max-width: 1000px;
  min-height: 620px;
  background: white;
  border-radius: 24px;
  box-shadow: 
    0 4px 6px rgba(0, 0, 0, 0.02),
    0 12px 24px rgba($primary-green, 0.08),
    0 24px 48px rgba(0, 0, 0, 0.04);
  overflow: hidden;
  z-index: 1;
  position: relative;
}

.login-left {
  flex: 1.1;
  background: linear-gradient(160deg, $primary-green 0%, $light-green 50%, $accent-green 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 50px 40px;
  position: relative;
  overflow: hidden;
  
  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: 
      radial-gradient(circle at 20% 20%, rgba(255, 255, 255, 0.1) 0%, transparent 40%),
      radial-gradient(circle at 80% 80%, rgba(255, 255, 255, 0.08) 0%, transparent 40%);
  }
  
  &::after {
    content: '';
    position: absolute;
    bottom: -20%;
    right: -10%;
    width: 300px;
    height: 300px;
    background: rgba(255, 255, 255, 0.03);
    border-radius: 50%;
  }
}

.login-right {
  flex: 0.9;
  padding: 50px 45px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: $warm-white;
}

.welcome-content {
  text-align: center;
  color: white;
  position: relative;
  z-index: 1;
  width: 100%;
}

.logo-section {
  margin-bottom: 30px;
  
  .logo-icon {
    width: 90px;
    height: 90px;
    margin: 0 auto 20px;
    animation: float-gentle 4s ease-in-out infinite;
    filter: drop-shadow(0 8px 16px rgba(0, 0, 0, 0.15));
  }
  
  .system-title {
    font-size: 26px;
    font-weight: 700;
    margin: 0 0 8px 0;
    letter-spacing: 2px;
    text-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }
  
  .system-subtitle {
    font-size: 13px;
    opacity: 0.85;
    margin: 0;
    font-weight: 300;
    letter-spacing: 1px;
  }
}

.divider {
  width: 60px;
  height: 3px;
  background: rgba(255, 255, 255, 0.3);
  margin: 25px auto;
  border-radius: 2px;
}

.feature-list {
  margin-bottom: 30px;
  
  .feature-item {
    display: flex;
    align-items: center;
    margin-bottom: 18px;
    padding: 14px 18px;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 14px;
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.15);
    transition: all 0.3s ease;
    opacity: 0;
    animation: slideIn 0.5s ease-out forwards;
    
    &:nth-child(1) { animation-delay: 0.1s; }
    &:nth-child(2) { animation-delay: 0.2s; }
    &:nth-child(3) { animation-delay: 0.3s; }
    
    &:hover {
      background: rgba(255, 255, 255, 0.18);
      transform: translateX(5px);
    }
    
    .feature-icon-wrapper {
      width: 42px;
      height: 42px;
      display: flex;
      align-items: center;
      justify-content: center;
      background: rgba(255, 255, 255, 0.15);
      border-radius: 10px;
      margin-right: 14px;
      flex-shrink: 0;
      
      .feature-svg {
        width: 22px;
        height: 22px;
        color: white;
      }
    }
    
    .feature-text {
      text-align: left;
      
      h3 {
        font-size: 15px;
        font-weight: 600;
        margin: 0 0 3px 0;
      }
      
      p {
        font-size: 12px;
        opacity: 0.8;
        margin: 0;
        font-weight: 300;
      }
    }
  }
}

.stats-row {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 14px;
  backdrop-filter: blur(10px);
  
  .stat-item {
    text-align: center;
    padding: 0 20px;
    
    .stat-number {
      display: block;
      font-size: 22px;
      font-weight: 700;
      margin-bottom: 2px;
    }
    
    .stat-label {
      font-size: 11px;
      opacity: 0.8;
      font-weight: 300;
    }
  }
  
  .stat-divider {
    width: 1px;
    height: 35px;
    background: rgba(255, 255, 255, 0.2);
  }
}

.login-form {
  width: 100%;
  max-width: 340px;
  
  .form-header {
    margin-bottom: 30px;
    
    .welcome-back {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: $soft-green;
      color: $primary-green;
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 500;
      margin-bottom: 16px;
      
      .wave-emoji {
        animation: wave 2s ease-in-out infinite;
      }
    }
    
    .form-title {
      font-size: 26px;
      font-weight: 700;
      color: $text-dark;
      margin: 0 0 8px 0;
      letter-spacing: -0.5px;
    }
    
    .form-subtitle {
      font-size: 14px;
      color: $text-light;
      margin: 0;
      line-height: 1.5;
    }
  }
  
  .input-group {
    margin-bottom: 20px;
    
    .input-label {
      display: block;
      font-size: 13px;
      font-weight: 600;
      color: $text-medium;
      margin-bottom: 8px;
    }
  }
  
  .custom-input {
    ::v-deep .el-input__inner {
      height: 50px;
      border: 2px solid $border-color;
      border-radius: 12px;
      padding: 0 16px 0 46px;
      font-size: 15px;
      transition: all 0.25s ease;
      background: white;
      color: $text-dark;
      
      &:hover {
        border-color: darken($border-color, 10%);
      }
      
      &:focus {
        border-color: $primary-green;
        background: white;
        box-shadow: 0 0 0 4px rgba($primary-green, 0.1);
      }
      
      &::placeholder {
        color: #B0B0B0;
      }
    }
    
    ::v-deep .el-input__prefix {
      left: 16px;
      color: $text-light;
      font-size: 18px;
    }
  }
  
  .form-options {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
    
    ::v-deep .el-checkbox {
      .el-checkbox__input {
        .el-checkbox__inner {
          width: 18px;
          height: 18px;
          border-radius: 5px;
          border-color: $border-color;
          
          &::after {
            height: 8px;
            left: 6px;
            top: 2px;
          }
        }
        
        &.is-checked .el-checkbox__inner {
          background-color: $primary-green;
          border-color: $primary-green;
        }
      }
    }
    
    .remember-text {
      color: $text-medium;
      font-size: 14px;
    }
    
    .forgot-password {
      color: $primary-green;
      text-decoration: none;
      font-size: 14px;
      font-weight: 500;
      transition: all 0.25s ease;
      
      &:hover {
        color: $light-green;
      }
    }
  }
  
  .login-button {
    width: 100%;
    height: 52px;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 600;
    background: linear-gradient(135deg, $primary-green 0%, $light-green 100%);
    border: none;
    transition: all 0.3s ease;
    box-shadow: 0 4px 12px rgba($primary-green, 0.25);
    
    .btn-content {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      
      .arrow-icon {
        width: 18px;
        height: 18px;
        transition: transform 0.3s ease;
      }
    }
    
    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 20px rgba($primary-green, 0.35);
      
      .arrow-icon {
        transform: translateX(4px);
      }
    }
    
    &:active {
      transform: translateY(0);
    }
  }
  
  .register-link {
    text-align: center;
    margin-top: 20px;
    
    .register-text {
      color: $text-light;
      font-size: 14px;
    }
    
    .link-type {
      color: $primary-green;
      text-decoration: none;
      font-weight: 600;
      font-size: 14px;
      margin-left: 4px;
      transition: all 0.25s ease;
      
      &:hover {
        color: $light-green;
        text-decoration: underline;
      }
    }
  }
  
  .security-badge {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    margin-top: 30px;
    padding-top: 24px;
    border-top: 1px solid $border-color;
    
    .shield-icon {
      width: 16px;
      height: 16px;
      color: $accent-green;
    }
    
    span {
      font-size: 12px;
      color: $text-light;
    }
  }
}

.el-login-footer {
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
  padding: 16px;
  color: $text-light;
  font-size: 12px;
  letter-spacing: 0.5px;
  background: linear-gradient(to top, rgba(255, 255, 255, 0.95) 0%, transparent 100%);
}

// 动画
@keyframes float-gentle {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-8px); }
}

@keyframes float1 {
  0%, 100% { transform: translate(0, 0) rotate(0deg); }
  50% { transform: translate(20px, -20px) rotate(10deg); }
}

@keyframes float2 {
  0%, 100% { transform: translate(0, 0) rotate(0deg); }
  50% { transform: translate(-15px, 15px) rotate(-15deg); }
}

@keyframes float3 {
  0%, 100% { transform: translate(0, 0) rotate(0deg); }
  50% { transform: translate(10px, -10px) rotate(5deg); }
}

@keyframes pulse-slow {
  0%, 100% { transform: scale(1); opacity: 0.5; }
  50% { transform: scale(1.05); opacity: 0.3; }
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateX(-20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes wave {
  0%, 100% { transform: rotate(0deg); }
  25% { transform: rotate(15deg); }
  75% { transform: rotate(-15deg); }
}

// 响应式设计
@media (max-width: 900px) {
  .login-container {
    flex-direction: column;
    max-width: 450px;
    min-height: auto;
  }
  
  .login-left {
    padding: 40px 30px;
    
    .logo-section {
      margin-bottom: 20px;
      
      .logo-icon {
        width: 70px;
        height: 70px;
      }
      
      .system-title {
        font-size: 22px;
      }
    }
    
    .feature-list {
      display: none;
    }
    
    .stats-row {
      .stat-item {
        padding: 0 15px;
        
        .stat-number {
          font-size: 18px;
        }
      }
    }
  }
  
  .login-right {
    padding: 35px 25px;
  }
  
  .login-form {
    .form-header {
      .form-title {
        font-size: 22px;
      }
    }
  }
}

@media (max-width: 480px) {
  .login {
    padding: 10px;
  }
  
  .login-container {
    border-radius: 20px;
  }
  
  .login-left {
    padding: 30px 20px;
  }
  
  .login-right {
    padding: 30px 20px;
  }
  
  .stats-row {
    flex-wrap: wrap;
    gap: 15px;
    
    .stat-divider {
      display: none;
    }
  }
}
</style>