import request from '@/utils/request'

// 查询作物物种列表
export function listCropSpecies(query) {
  return request({
    url: '/agriculture/crop/list',
    method: 'get',
    params: query
  })
}

export function listCrop(query) {
  return listCropSpecies(query)
}

// 查询作物物种详细
export function getCropSpecies(speciesId) {
  return request({
    url: '/agriculture/crop/' + speciesId,
    method: 'get'
  })
}

export function getCrop(speciesId) {
  return getCropSpecies(speciesId)
}

// 新增作物物种
export function addCropSpecies(data) {
  return request({
    url: '/agriculture/crop',
    method: 'post',
    data: data
  })
}

export function addCrop(data) {
  return addCropSpecies(data)
}

// 修改作物物种
export function updateCropSpecies(data) {
  return request({
    url: '/agriculture/crop',
    method: 'put',
    data: data
  })
}

export function updateCrop(data) {
  return updateCropSpecies(data)
}

// 删除作物物种
export function delCropSpecies(speciesId) {
  return request({
    url: '/agriculture/crop/' + speciesId,
    method: 'delete'
  })
}

export function delCrop(speciesId) {
  return delCropSpecies(speciesId)
}

// 获取作物分类统计
export function getCropCategoryStats() {
  return request({
    url: '/agriculture/crop/category-stats',
    method: 'get'
  })
}
