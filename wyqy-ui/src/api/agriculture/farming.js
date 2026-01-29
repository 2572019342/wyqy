import request from '@/utils/request'

// 查询种植管理列表
export function listFarming(query) {
  return request({
    url: '/agriculture/farming/list',
    method: 'get',
    params: query
  })
}

// 查询种植管理详细
export function getFarming(managementId) {
  return request({
    url: '/agriculture/farming/' + managementId,
    method: 'get'
  })
}

// 新增种植管理
export function addFarming(data) {
  return request({
    url: '/agriculture/farming',
    method: 'post',
    data: data
  })
}

// 修改种植管理
export function updateFarming(data) {
  return request({
    url: '/agriculture/farming',
    method: 'put',
    data: data
  })
}

// 删除种植管理
export function delFarming(managementId) {
  return request({
    url: '/agriculture/farming/' + managementId,
    method: 'delete'
  })
}

// 获取种植管理统计
export function getFarmingStats(query) {
  return request({
    url: '/agriculture/farming/stats',
    method: 'get',
    params: query
  })
}

// 获取指定种植记录的管理历史
export function getPlantingFarmingHistory(plantingId) {
  return request({
    url: '/agriculture/farming/history/' + plantingId,
    method: 'get'
  })
}
