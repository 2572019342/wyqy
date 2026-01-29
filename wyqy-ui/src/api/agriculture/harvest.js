import request from '@/utils/request'

// 查询采摘记录列表
export function listHarvest(query) {
  return request({
    url: '/agriculture/harvest/list',
    method: 'get',
    params: query
  })
}

// 查询采摘记录详细
export function getHarvest(harvestId) {
  return request({
    url: '/agriculture/harvest/' + harvestId,
    method: 'get'
  })
}

// 新增采摘记录
export function addHarvest(data) {
  return request({
    url: '/agriculture/harvest',
    method: 'post',
    data: data
  })
}

// 修改采摘记录
export function updateHarvest(data) {
  return request({
    url: '/agriculture/harvest',
    method: 'put',
    data: data
  })
}

// 删除采摘记录
export function delHarvest(harvestId) {
  return request({
    url: '/agriculture/harvest/' + harvestId,
    method: 'delete'
  })
}

// 获取可采摘的种植记录
export function getHarvestablePlantings() {
  return request({
    url: '/agriculture/harvest/harvestable',
    method: 'get'
  })
}

// 检查种植记录是否可以采摘
export function checkHarvestable(plantingId) {
  return request({
    url: '/agriculture/harvest/check/' + plantingId,
    method: 'get'
  })
}

// 获取采摘统计
export function getHarvestStats(query) {
  return request({
    url: '/agriculture/harvest/stats',
    method: 'get',
    params: query
  })
}
