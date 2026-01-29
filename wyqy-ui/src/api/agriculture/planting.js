import request from '@/utils/request'

// 查询种植记录列表
export function listPlanting(query) {
  return request({
    url: '/agriculture/planting/list',
    method: 'get',
    params: query
  })
}

// 查询种植记录详细
export function getPlanting(plantingId) {
  return request({
    url: '/agriculture/planting/' + plantingId,
    method: 'get'
  })
}

// 新增种植记录
export function addPlanting(data) {
  return request({
    url: '/agriculture/planting',
    method: 'post',
    data: data
  })
}

// 修改种植记录
export function updatePlanting(data) {
  return request({
    url: '/agriculture/planting',
    method: 'put',
    data: data
  })
}

// 删除种植记录
export function delPlanting(plantingId) {
  return request({
    url: '/agriculture/planting/' + plantingId,
    method: 'delete'
  })
}

// 获取种植统计信息
export function getPlantingStats(query) {
  return request({
    url: '/agriculture/planting/stats',
    method: 'get',
    params: query
  })
}

// 获取地块种植情况
export function getLandPlantingInfo(landId) {
  return request({
    url: '/agriculture/planting/land/' + landId,
    method: 'get'
  })
}

// 更新生长阶段
export function updateGrowthStage(data) {
  return request({
    url: '/agriculture/planting/growth-stage',
    method: 'put',
    data: data
  })
}

// 更新健康状况
export function updateHealthStatus(data) {
  return request({
    url: '/agriculture/planting/health-status',
    method: 'put',
    data: data
  })
}

// 创建虫害报警
export function createPestAlert(data) {
  return request({
    url: '/agriculture/planting/createPestAlert',
    method: 'post',
    data: data
  })
}

// 获取未读的虫害报警
export function getPestAlert() {
  return request({
    url: '/agriculture/planting/getPestAlert',
    method: 'get'
  })
}

// 标记报警为已读
export function markPestAlertRead(data) {
  return request({
    url: '/agriculture/planting/markPestAlertRead',
    method: 'post',
    data: data
  })
}
