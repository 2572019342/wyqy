<template>
  <div class="topnav-wrapper">
    <div class="topnav-brand">
      <div class="brand-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
        </svg>
      </div>
      <span class="brand-text">智控中心</span>
    </div>
    
    <nav class="topnav-menu">
      <div 
        v-for="(item, index) in topMenus" 
        :key="index"
        class="nav-menu-item"
        :class="{ active: activeMenu === item.path }"
        @click="handleSelect(item.path)"
      >
        <svg-icon
          v-if="item.meta && item.meta.icon && item.meta.icon !== '#'"
          :icon-class="item.meta.icon"
          class="menu-icon"
        />
        <span class="menu-title">{{ item.meta.title }}</span>
        <div class="active-indicator" v-if="activeMenu === item.path"></div>
      </div>
      
      <!-- 更多菜单 -->
      <div 
        class="nav-menu-item more-menu" 
        v-if="topMenus.length > visibleNumber"
        @mouseenter="showMore = true"
        @mouseleave="showMore = false"
      >
        <span class="menu-title">更多菜单</span>
        <svg class="more-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <polyline points="6,9 12,15 18,9"/>
        </svg>
        
        <transition name="fade">
          <div class="more-dropdown" v-show="showMore">
            <div 
              v-for="(item, index) in topMenus.slice(visibleNumber)" 
              :key="index"
              class="dropdown-item"
              :class="{ active: activeMenu === item.path }"
              @click="handleSelect(item.path)"
            >
              <svg-icon
                v-if="item.meta && item.meta.icon && item.meta.icon !== '#'"
                :icon-class="item.meta.icon"
              />
              <span>{{ item.meta.title }}</span>
            </div>
          </div>
        </transition>
      </div>
    </nav>
    
    <div class="topnav-right">
      <div class="status-badge">
        <span class="status-dot pulse"></span>
        <span class="status-text">运行正常</span>
      </div>
    </div>
  </div>
</template>

<script>
import { constantRoutes } from "@/router"
import { isHttp } from "@/utils/validate"

// 隐藏侧边栏路由
const hideList = ['/index', '/user/profile']

export default {
  data() {
    return {
      visibleNumber: 6,
      currentIndex: undefined,
      showMore: false
    }
  },
  computed: {
    theme() {
      return this.$store.state.settings.theme
    },
    // 顶部显示菜单
    topMenus() {
      let topMenus = []
      this.routers.map((menu) => {
        if (menu.hidden !== true) {
          // 兼容顶部栏一级菜单内部跳转
          if (menu.path === '/' && menu.children) {
            topMenus.push(menu.children[0])
          } else {
            topMenus.push(menu)
          }
        }
      })
      return topMenus
    },
    // 所有的路由信息
    routers() {
      return this.$store.state.permission.topbarRouters
    },
    // 设置子路由
    childrenMenus() {
      var childrenMenus = []
      this.routers.map((router) => {
        for (var item in router.children) {
          if (router.children[item].parentPath === undefined) {
            if(router.path === "/") {
              router.children[item].path = "/" + router.children[item].path
            } else {
              if(!isHttp(router.children[item].path)) {
                router.children[item].path = router.path + "/" + router.children[item].path
              }
            }
            router.children[item].parentPath = router.path
          }
          childrenMenus.push(router.children[item])
        }
      })
      return constantRoutes.concat(childrenMenus)
    },
    // 默认激活的菜单
    activeMenu() {
      const path = this.$route.path
      let activePath = path
      if (path !== undefined && path.lastIndexOf("/") > 0 && hideList.indexOf(path) === -1) {
        const tmpPath = path.substring(1, path.length)
        if (!this.$route.meta.link) {
          activePath = "/" + tmpPath.substring(0, tmpPath.indexOf("/"))
          this.$store.dispatch('app/toggleSideBarHide', false)
        }
      } else if(!this.$route.children) {
        activePath = path
        this.$store.dispatch('app/toggleSideBarHide', true)
      }
      this.activeRoutes(activePath)
      return activePath
    },
  },
  beforeMount() {
    window.addEventListener('resize', this.setVisibleNumber)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.setVisibleNumber)
  },
  mounted() {
    this.setVisibleNumber()
  },
  methods: {
    // 根据宽度计算设置显示栏数
    setVisibleNumber() {
      const width = document.body.getBoundingClientRect().width
      this.visibleNumber = parseInt((width - 400) / 120)
    },
    // 菜单选择事件
    handleSelect(key, keyPath) {
      this.currentIndex = key
      const route = this.routers.find(item => item.path === key)
      if (isHttp(key)) {
        // http(s):// 路径新窗口打开
        window.open(key, "_blank")
      } else if (!route || !route.children) {
        // 没有子路由路径内部打开
        const routeMenu = this.childrenMenus.find(item => item.path === key)
        if (routeMenu && routeMenu.query) {
          let query = JSON.parse(routeMenu.query)
          this.$router.push({ path: key, query: query })
        } else {
          this.$router.push({ path: key })
        }
        this.$store.dispatch('app/toggleSideBarHide', true)
      } else {
        // 显示左侧联动菜单
        this.activeRoutes(key)
        this.$store.dispatch('app/toggleSideBarHide', false)
      }
    },
    // 当前激活的路由
    activeRoutes(key) {
      var routes = []
      if (this.childrenMenus && this.childrenMenus.length > 0) {
        this.childrenMenus.map((item) => {
          if (key == item.parentPath || (key == "index" && "" == item.path)) {
            routes.push(item)
          }
        })
      }
      if(routes.length > 0) {
        this.$store.commit("SET_SIDEBAR_ROUTERS", routes)
      } else {
        this.$store.dispatch('app/toggleSideBarHide', true)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
// 色彩系统
$color-primary: #14b8a6;
$color-primary-dark: #0d9488;
$color-text-primary: #0f172a;
$color-text-secondary: #475569;
$color-text-tertiary: #64748b;
$color-border: #e2e8f0;
$color-bg: #f8fafc;

.topnav-wrapper {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 64px;
  padding: 0 28px;
  background: white;
  border-bottom: 1px solid $color-border;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

// 品牌区域
.topnav-brand {
  display: flex;
  align-items: center;
  gap: 12px;
  
  .brand-icon {
    width: 36px;
    height: 36px;
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-dark 100%);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    box-shadow: 0 4px 12px rgba(20, 184, 166, 0.3);
    
    svg {
      width: 20px;
      height: 20px;
    }
  }
  
  .brand-text {
    font-size: 18px;
    font-weight: 600;
    color: $color-text-primary;
  }
}

// 菜单区域
.topnav-menu {
  display: flex;
  align-items: center;
  gap: 8px;
  flex: 1;
  justify-content: center;
  
  .nav-menu-item {
    position: relative;
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 18px;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.2s ease;
    
    &:hover {
      background: rgba(20, 184, 166, 0.08);
      
      .menu-title {
        color: $color-primary;
      }
    }
    
    &.active {
      background: rgba(20, 184, 166, 0.12);
      
      .menu-title {
        color: $color-primary;
        font-weight: 600;
      }
      
      .active-indicator {
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        width: 20px;
        height: 3px;
        background: $color-primary;
        border-radius: 2px;
      }
    }
    
    .menu-icon {
      width: 18px;
      height: 18px;
      color: $color-text-tertiary;
    }
    
    .menu-title {
      font-size: 14px;
      color: $color-text-secondary;
      transition: color 0.2s ease;
    }
  }
  
  // 更多菜单
  .more-menu {
    position: relative;
    
    .more-arrow {
      width: 14px;
      height: 14px;
      color: $color-text-tertiary;
      transition: transform 0.2s ease;
    }
    
    &:hover .more-arrow {
      transform: rotate(180deg);
    }
    
    .more-dropdown {
      position: absolute;
      top: calc(100% + 8px);
      right: 0;
      min-width: 160px;
      background: white;
      border-radius: 10px;
      border: 1px solid $color-border;
      box-shadow: 0 10px 40px rgba(0, 0, 0, 0.12);
      padding: 8px;
      z-index: 1000;
      
      .dropdown-item {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 14px;
        border-radius: 6px;
        cursor: pointer;
        transition: all 0.2s ease;
        
        &:hover {
          background: rgba(20, 184, 166, 0.08);
          
          span {
            color: $color-primary;
          }
        }
        
        &.active {
          background: rgba(20, 184, 166, 0.12);
          
          span {
            color: $color-primary;
            font-weight: 500;
          }
        }
        
        span {
          font-size: 13px;
          color: $color-text-secondary;
          white-space: nowrap;
        }
      }
    }
  }
}

// 右侧状态
.topnav-right {
  .status-badge {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 14px;
    background: rgba(20, 184, 166, 0.1);
    border-radius: 20px;
    border: 1px solid rgba(20, 184, 166, 0.2);
    
    .status-dot {
      width: 8px;
      height: 8px;
      background: $color-primary;
      border-radius: 50%;
      
      &.pulse {
        animation: pulse 2s ease-in-out infinite;
      }
    }
    
    .status-text {
      font-size: 13px;
      font-weight: 500;
      color: $color-primary;
    }
  }
}

// 动画
@keyframes pulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.6; transform: scale(1.2); }
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 0.2s, transform 0.2s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

// 响应式
@media (max-width: 768px) {
  .topnav-wrapper {
    padding: 0 16px;
  }
  
  .brand-text {
    display: none;
  }
  
  .topnav-menu {
    justify-content: flex-end;
  }
}
</style>
