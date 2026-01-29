import request from '@/utils/request'

// 查询天气信息列表
export function listWeather(query) {
  return request({
    url: '/agriculture/weather/list',
    method: 'get',
    params: query
  })
}

// 查询天气信息详细
export function getWeather(weatherId) {
  return request({
    url: '/agriculture/weather/' + weatherId,
    method: 'get'
  })
}

// 新增天气信息
export function addWeather(data) {
  return request({
    url: '/agriculture/weather',
    method: 'post',
    data: data
  })
}

// 修改天气信息
export function updateWeather(data) {
  return request({
    url: '/agriculture/weather',
    method: 'put',
    data: data
  })
}

// 删除天气信息
export function delWeather(weatherId) {
  return request({
    url: '/agriculture/weather/' + weatherId,
    method: 'delete'
  })
}

// 获取最新天气信息
export function getLatestWeather(location) {
  return request({
    url: '/agriculture/weather/latest',
    method: 'get',
    params: { location }
  })
}

// 获取天气统计信息
export function getWeatherStats(query) {
  return request({
    url: '/agriculture/weather/stats',
    method: 'get',
    params: query
  })
}
