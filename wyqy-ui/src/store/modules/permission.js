import auth from '@/plugins/auth'
import router, { constantRoutes, dynamicRoutes } from '@/router'
import { getRouters } from '@/api/menu'
import Layout from '@/layout/index'
import ParentView from '@/components/ParentView'
import InnerLink from '@/layout/components/InnerLink'

// 预定义一些已知组件的映射
const componentMap = {
  // 后端返回的组件路径为 agriculture/ai-pest-detection/xxx，
  // 实际前端视图文件位于 @/views/ai-pest-detection 目录下
  'agriculture/ai-pest-detection/realtime': () => import('@/views/ai-pest-detection/realtime'),
  'agriculture/ai-pest-detection/index': () => import('@/views/ai-pest-detection/index'),
  // 天气监测页面，实际路径为 @/views/agriculture/weather/index.vue
  'agriculture/weather/index': () => import('@/views/agriculture/weather/index.vue'),
  // 土壤信息
  'agriculture/soil/index': () => import('@/views/agriculture/soil/index.vue'),
  // 地块管理
  'agriculture/land/index': () => import('@/views/agriculture/land/index.vue'),
  // 作物管理
  'agriculture/crop/index': () => import('@/views/agriculture/crop/index.vue'),
  // 种植记录列表
  'agriculture/planting/index': () => import('@/views/agriculture/planting/index.vue'),
  // 种植作业编排
  'agriculture/planting/operate': () => import('@/views/agriculture/planting/operate.vue'),
  // 为了兼容可能的组件路径，将 planting/record 映射到种植记录页面
  'agriculture/planting/record': () => import('@/views/agriculture/planting/index.vue'),
  // 农事管理
  'agriculture/farming/index': () => import('@/views/agriculture/farming/index.vue'),
  // 收获管理
  'agriculture/harvest/index': () => import('@/views/agriculture/harvest/index.vue'),
  // 兼容可能的组件路径，将 planting/farming 映射到农事管理页面
  'agriculture/planting/farming': () => import('@/views/agriculture/farming/index.vue'),
  
  // 病虫害识别模块
  'agriculture/pest-detection/photo': () => import('@/views/agriculture/pest-detection/photo.vue'),
  'agriculture/pest-detection/records': () => import('@/views/agriculture/pest-detection/records.vue'),

  // ===== 系统管理模块 =====
  'system/user/index': () => import('@/views/system/user/index.vue'),
  'system/role/index': () => import('@/views/system/role/index.vue'),
  'system/menu/index': () => import('@/views/system/menu/index.vue'),
  'system/dept/index': () => import('@/views/system/dept/index.vue'),
  'system/post/index': () => import('@/views/system/post/index.vue'),
  'system/dict/index': () => import('@/views/system/dict/index.vue'),
  'system/config/index': () => import('@/views/system/config/index.vue'),
  'system/notice/index': () => import('@/views/system/notice/index.vue'),
  'system/log/operlog': () => import('@/views/monitor/operlog/index.vue'),
  'system/log/logininfor': () => import('@/views/monitor/logininfor/index.vue'),

  // ===== 系统监控模块 =====
  'monitor/online/index': () => import('@/views/monitor/online/index.vue'),
  'monitor/job/index': () => import('@/views/monitor/job/index.vue'),
  'monitor/job/log': () => import('@/views/monitor/job/log.vue'),
  'monitor/druid/index': () => import('@/views/monitor/druid/index.vue'),
  'monitor/server/index': () => import('@/views/monitor/server/index.vue'),
  'monitor/cache/index': () => import('@/views/monitor/cache/index.vue'),
  'monitor/cache/list': () => import('@/views/monitor/cache/list.vue'),

  // ===== 系统工具模块 =====
  'tool/build/index': () => import('@/views/tool/build/index.vue'),
  'tool/gen/index': () => import('@/views/tool/gen/index.vue'),
  'tool/swagger/index': () => import('@/views/tool/swagger/index.vue'),

  // ===== 智能翻译模块 =====
  'translation/index': () => import('@/views/translation/index.vue'),
  'translation/record/index': () => import('@/views/translation/record/index.vue'),
  'translation/corpus/index': () => import('@/views/translation/corpus/index.vue'),
  // 可以继续添加其他已知组件
}

const permission = {
  state: {
    routes: [],
    addRoutes: [],
    defaultRoutes: [],
    topbarRouters: [],
    sidebarRouters: []
  },
  mutations: {
    SET_ROUTES: (state, routes) => {
      state.addRoutes = routes
      state.routes = constantRoutes.concat(routes)
    },
    SET_DEFAULT_ROUTES: (state, routes) => {
      state.defaultRoutes = constantRoutes.concat(routes)
    },
    SET_TOPBAR_ROUTES: (state, routes) => {
      state.topbarRouters = routes
    },
    SET_SIDEBAR_ROUTERS: (state, routes) => {
      state.sidebarRouters = routes
    },
  },
  actions: {
    // 生成路由
    GenerateRoutes({ commit }) {
      return new Promise(resolve => {
        // 向后端请求路由数据
        getRouters().then(res => {
          const sdata = JSON.parse(JSON.stringify(res.data))
          const rdata = JSON.parse(JSON.stringify(res.data))
          const sidebarRoutes = filterAsyncRouter(sdata)
          const rewriteRoutes = filterAsyncRouter(rdata, false, true)
          const asyncRoutes = filterDynamicRoutes(dynamicRoutes)
          rewriteRoutes.push({ path: '*', redirect: '/404', hidden: true })
          router.addRoutes(asyncRoutes)
          commit('SET_ROUTES', rewriteRoutes)
          commit('SET_SIDEBAR_ROUTERS', constantRoutes.concat(sidebarRoutes))
          commit('SET_DEFAULT_ROUTES', sidebarRoutes)
          commit('SET_TOPBAR_ROUTES', sidebarRoutes)
          resolve(rewriteRoutes)
        })
      })
    }
  }
}

// 遍历后台传来的路由字符串，转换为组件对象
function filterAsyncRouter(asyncRouterMap, lastRouter = false, type = false) {
  return asyncRouterMap.filter(route => {
    if (type && route.children) {
      route.children = filterChildren(route.children)
    }
    if (route.component) {
      // Layout ParentView 组件特殊处理
      if (route.component === 'Layout') {
        route.component = Layout
      } else if (route.component === 'ParentView') {
        route.component = ParentView
      } else if (route.component === 'InnerLink') {
        route.component = InnerLink
      } else {
        route.component = loadView(route.component)
      }
    }
    if (route.children != null && route.children && route.children.length) {
      route.children = filterAsyncRouter(route.children, route, type)
    } else {
      delete route['children']
      delete route['redirect']
    }
    return true
  })
}

function filterChildren(childrenMap, lastRouter = false) {
  var children = []
  childrenMap.forEach(el => {
    el.path = lastRouter ? lastRouter.path + '/' + el.path : el.path
    if (el.children && el.children.length && el.component === 'ParentView') {
      children = children.concat(filterChildren(el.children, el))
    } else {
      children.push(el)
    }
  })
  return children
}

// 动态路由遍历，验证是否具备权限
export function filterDynamicRoutes(routes) {
  const res = []
  routes.forEach(route => {
    if (route.permissions) {
      if (auth.hasPermiOr(route.permissions)) {
        res.push(route)
      }
    } else if (route.roles) {
      if (auth.hasRoleOr(route.roles)) {
        res.push(route)
      }
    }
  })
  return res
}

// 动态加载视图组件
export const loadView = (view) => {
  try {
    // 处理路径
    const componentPath = view.startsWith('/') ? view.slice(1) : view
    
    // 首先检查预定义的组件映射
    if (componentMap[componentPath]) {
      return componentMap[componentPath]
    }
    
    // 如果映射中没有，尝试动态导入
    return () => import(/* webpackChunkName: "views-[request]" */ `@/views/${componentPath}`)
      .catch(error => {
        console.error(`Failed to load component: ${componentPath}`, error)
        // 返回404页面作为fallback
        return import('@/views/error/404')
      })
  } catch (error) {
    console.error('Error in loadView:', error)
    return () => import('@/views/error/404')
  }
}

export default permission
