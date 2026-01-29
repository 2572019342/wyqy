import request from '@/utils/request'

// 执行翻译
export function translate(data) {
  return request({
    url: '/system/translation/translate',
    method: 'post',
    data: data
  })
}

// 获取翻译历史
export function getTranslationHistory(limit) {
  return request({
    url: '/system/translation/history',
    method: 'get',
    params: { limit }
  })
}

// 查询翻译记录列表
export function listTranslationRecord(query) {
  return request({
    url: '/system/translation/record/list',
    method: 'get',
    params: query
  })
}

// 查询翻译记录详细
export function getTranslationRecord(recordId) {
  return request({
    url: '/system/translation/record/' + recordId,
    method: 'get'
  })
}

// 删除翻译记录
export function delTranslationRecord(recordId) {
  return request({
    url: '/system/translation/record/' + recordId,
    method: 'delete'
  })
}

// 查询语料库列表
export function listTranslationCorpus(query) {
  return request({
    url: '/system/translation/corpus/list',
    method: 'get',
    params: query
  })
}

// 查询语料库详细
export function getTranslationCorpus(corpusId) {
  return request({
    url: '/system/translation/corpus/' + corpusId,
    method: 'get'
  })
}

// 新增语料库
export function addTranslationCorpus(data) {
  return request({
    url: '/system/translation/corpus',
    method: 'post',
    data: data
  })
}

// 修改语料库
export function updateTranslationCorpus(data) {
  return request({
    url: '/system/translation/corpus',
    method: 'put',
    data: data
  })
}

// 删除语料库
export function delTranslationCorpus(corpusId) {
  return request({
    url: '/system/translation/corpus/' + corpusId,
    method: 'delete'
  })
}
