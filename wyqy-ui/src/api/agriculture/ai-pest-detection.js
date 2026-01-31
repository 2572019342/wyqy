// 模拟数据生成器
const mockData = {
  // 生成模拟的检测记录
  generateMockList: (pageNum = 1, pageSize = 10) => {
    const records = []
    const pestTypes = ['pest', 'disease']
    const pestNames = [
      '蚜虫', '红蜘蛛', '白粉病', '霜霉病', '炭疽病', 
      '菜青虫', '潜叶蝇', '锈病', '枯萎病', '疫病'
    ]
    const landNames = ['东区1号田', '西区2号田', '南区3号田', '北区4号田', '温室A区']
    const speciesNames = ['番茄', '黄瓜', '辣椒', '白菜', '茄子']
    
    for (let i = 0; i < pageSize; i++) {
      const id = (pageNum - 1) * pageSize + i + 1
      const pestType = pestTypes[Math.floor(Math.random() * pestTypes.length)]
      const pestName = pestNames[Math.floor(Math.random() * pestNames.length)]
      
      records.push({
        detectionId: id,
        landId: Math.floor(Math.random() * 5) + 1,
        landName: landNames[Math.floor(Math.random() * landNames.length)],
        speciesId: Math.floor(Math.random() * 5) + 1,
        speciesName: speciesNames[Math.floor(Math.random() * speciesNames.length)],
        detectionType: pestType,
        pestName: pestName,
        confidence: (0.75 + Math.random() * 0.24).toFixed(2),
        frameTimestamp: Date.now() - Math.random() * 86400000,
        processStatus: Math.random() > 0.5 ? 'pending' : 'processed',
        recommendation: `${pestType === 'pest' ? '建议使用生物农药防治' : '建议使用专用杀菌剂'}，及时处理`,
        isProcessed: Math.random() > 0.5 ? '1' : '0',
        detectionTime: new Date(Date.now() - Math.random() * 86400000).toISOString(),
        imageUrl: `https://picsum.photos/seed/pest${id}/300/200.jpg`
      })
    }
    
    return {
      code: 200,
      msg: '查询成功',
      rows: records,
      total: 100 // 模拟总数
    }
  },
  
  // 生成统计数据
  generateMockStats: () => {
    return {
      code: 200,
      msg: '查询成功',
      data: {
        totalDetections: 68552,
        pendingCount: 47,
        processedCount: 133,
        todayCount: 8,
        pestDetections: 2082,
        diseaseDetections: 19965,
        pestCount: 2082,
        diseaseCount: 19965,
        weeklyTrend: [12, 15, 8, 20, 18, 25, 8],
        topPests: [
          { name: '蚜虫', count: 34, percentage: 21.8 },
          { name: '白粉病', count: 28, percentage: 17.9 },
          { name: '红蜘蛛', count: 22, percentage: 14.1 },
          { name: '霜霉病', count: 19, percentage: 12.2 },
          { name: '菜青虫', count: 15, percentage: 9.6 }
        ]
      }
    }
  },
  
  // 生成视频流信息
  generateVideoStream: () => {
    return {
      code: 200,
      msg: '查询成功',
      data: {
        videoUrl: 'http://192.168.1.103:8080/live/drone.flv',
        streamUrl: 'http://192.168.1.103:8080/live/drone.flv',
        snapshotUrl: 'http://192.168.1.103:8080/snapshot/drone.jpg'
      }
    }
  }
}

// 模拟延迟函数
const delay = (ms = 500) => new Promise(resolve => setTimeout(resolve, ms))

// 查询AI病虫害识别列表
export function listAiPestDetection(query) {
  return delay().then(() => {
    const pageNum = query.pageNum || 1
    const pageSize = query.pageSize || 10
    return mockData.generateMockList(pageNum, pageSize)
  })
}

// 查询AI病虫害识别详细
export function getAiPestDetection(detectionId) {
  return delay().then(() => {
    const mockList = mockData.generateMockList(1, 100)
    const record = mockList.rows.find(item => item.detectionId === detectionId)
    return {
      code: 200,
      msg: '查询成功',
      data: record || mockList.rows[0]
    }
  })
}

// 新增AI病虫害识别
export function addAiPestDetection(data) {
  return delay().then(() => {
    return {
      code: 200,
      msg: '添加成功'
    }
  })
}

// 修改AI病虫害识别
export function updateAiPestDetection(data) {
  return delay().then(() => {
    return {
      code: 200,
      msg: '修改成功'
    }
  })
}

// 删除AI病虫害识别
export function delAiPestDetection(detectionId) {
  return delay().then(() => {
    return {
      code: 200,
      msg: '删除成功'
    }
  })
}

// AI病虫害识别
export function detectPest(data) {
  return delay(1000).then(() => {
    const pestTypes = ['pest', 'disease']
    const pestNames = [
      '蚜虫', '红蜘蛛', '白粉病', '霜霉病', '炭疽病', 
      '菜青虫', '潜叶蝇', '锈病', '枯萎病', '疫病'
    ]
    
    const detectionType = pestTypes[Math.floor(Math.random() * pestTypes.length)]
    const pestName = pestNames[Math.floor(Math.random() * pestNames.length)]
    const confidence = (0.75 + Math.random() * 0.24).toFixed(2)
    
    // 固定推荐处理方案为对坏掉的果子进行采摘
    const recommendation = '对坏掉的果子进行采摘'
    
    return {
      code: 200,
      msg: '识别成功',
      data: {
        success: true,
        detectionId: Math.floor(Math.random() * 1000) + 1000,
        detectionType,
        pestName,
        confidence,
        recommendation,
        message: `识别到${detectionType === 'pest' ? '虫害' : '病害'}：${pestName}`
      }
    }
  })
}

// 获取视频流地址
export function getVideoStream() {
  return delay().then(() => {
    return mockData.generateVideoStream()
  })
}

// 获取识别统计
export function getDetectionStats() {
  return delay().then(() => {
    return mockData.generateMockStats()
  })
}

// 标记为已处理
export function markAsProcessed(detectionId) {
  return delay().then(() => {
    return {
      code: 200,
      msg: '标记成功'
    }
  })
}
