import request from '@/utils/request'

// 查询地块信息列表
export function listLand(query) {
  return request({
    url: '/agriculture/land/list',
    method: 'get',
    params: query
  })
}

// 查询地块信息详细
export function getLand(landId) {
  return request({
    url: '/agriculture/land/' + landId,
    method: 'get'
  })
}

// 新增地块信息
export function addLand(data) {
  return request({
    url: '/agriculture/land',
    method: 'post',
    data: data
  })
}

// 修改地块信息
export function updateLand(data) {
  return request({
    url: '/agriculture/land',
    method: 'put',
    data: data
  })
}

// 删除地块信息
export function delLand(landId) {
  return request({
    url: '/agriculture/land/' + landId,
    method: 'delete'
  })
}

// 获取地块土壤信息
export function getLandSoilInfo(landId) {
  return request({
    url: '/agriculture/land/soil/' + landId,
    method: 'get'
  })
}

// 更新地块土壤信息
export function updateLandSoilInfo(data) {
  return request({
    url: '/agriculture/land/soil',
    method: 'put',
    data: data
  })
}
