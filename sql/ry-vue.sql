/*
 Navicat Premium Data Transfer

 Source Server         : zhinong
 Source Server Type    : MySQL
 Source Server Version : 80040
 Source Host           : localhost:3306
 Source Schema         : ry-vue

 Target Server Type    : MySQL
 Target Server Version : 80040
 File Encoding         : 65001

 Date: 26/01/2026 11:41:23
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for crop_species
-- ----------------------------
DROP TABLE IF EXISTS `crop_species`;
CREATE TABLE `crop_species`  (
  `species_id` bigint NOT NULL AUTO_INCREMENT COMMENT '物种ID',
  `species_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物种名称',
  `species_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物种编号',
  `scientific_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学名',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类',
  `growth_period` int NULL DEFAULT NULL COMMENT '生长周期(天)',
  `optimal_temperature_min` decimal(4, 2) NULL DEFAULT NULL COMMENT '最适温度最低值(℃)',
  `optimal_temperature_max` decimal(4, 2) NULL DEFAULT NULL COMMENT '最适温度最高值(℃)',
  `optimal_humidity_min` decimal(4, 2) NULL DEFAULT NULL COMMENT '最适湿度最低值(%)',
  `optimal_humidity_max` decimal(4, 2) NULL DEFAULT NULL COMMENT '最适湿度最高值(%)',
  `water_requirement` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '水分需求',
  `fertilizer_requirement` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '肥料需求',
  `light_requirement` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '光照需求',
  `soil_requirement` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '土壤要求',
  `planting_density` decimal(8, 2) NULL DEFAULT NULL COMMENT '种植密度(株/亩)',
  `expected_yield` decimal(10, 2) NULL DEFAULT NULL COMMENT '预期产量(kg/亩)',
  `disease_resistance` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '抗病性',
  `pest_resistance` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '抗虫性',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '描述',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片URL',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态(0正常 1停用)',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`species_id`) USING BTREE,
  UNIQUE INDEX `uk_species_code`(`species_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '作物物种表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of crop_species
-- ----------------------------
INSERT INTO `crop_species` VALUES (2, '黄瓜11', 'CROP002', 'Cucumis sativus', '蔬菜', 90, 20.50, 30.00, 70.00, 85.00, '较高', '有机肥+复合肥', '充足', '富含有机质', 3600.00, 4000.00, '3', NULL, NULL, '/photo/2026/01/26/f9010931a00f45c6a374326550d4a49d.jpg', '0', 'admin', '2026-01-22 17:20:28', '', '2026-01-26 10:50:07', NULL);
INSERT INTO `crop_species` VALUES (3, '玉米', 'CROP003', 'Zea mays', '粮食', 150, 15.00, 30.00, 55.00, 75.00, '中等', '氮肥为主', '充足', '排水良好', 4500.00, 600.00, '3', NULL, NULL, NULL, '0', 'admin', '2026-01-22 17:20:28', '', '2026-01-26 10:22:08', NULL);
INSERT INTO `crop_species` VALUES (4, '糯米', 'LAO001', 'Oryza sativa var. glutinosa', '粮食作物', 120, 22.00, 32.00, 70.00, 85.00, '高', '有机肥+氮肥', '充足', '水田土壤', 25000.00, 300.00, '4', '较强', '老挝传统主食，口感香糯', '/photo/2026/01/26/glutinous_rice.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '老挝国宝级作物');
INSERT INTO `crop_species` VALUES (5, '咖啡', 'LAO002', 'Coffea arabica', '经济作物', 365, 18.00, 25.00, 65.00, 75.00, '中等', '有机肥', '半阴', '火山土', 2000.00, 150.00, '3', '中等', '老挝高原咖啡品质优良', '/photo/2026/01/26/lao_coffee.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '主要出口农产品');
INSERT INTO `crop_species` VALUES (6, '香蕉', 'LAO003', 'Musa spp.', '水果作物', 365, 24.00, 30.00, 75.00, 90.00, '高', '钾肥为主', '充足', '肥沃土壤', 1500.00, 2000.00, '4', '较强', '老挝热带水果代表', '/photo/2026/01/26/lao_banana.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '全年可种植');
INSERT INTO `crop_species` VALUES (7, '木薯', 'LAO004', 'Manihot esculenta', '经济作物', 300, 20.00, 35.00, 60.00, 80.00, '低', '磷钾肥', '充足', '砂质土壤', 8000.00, 1500.00, '5', '强', '耐旱作物，适应性强', '/photo/2026/01/26/cassava.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '重要粮食作物');
INSERT INTO `crop_species` VALUES (8, '芒果', 'LAO005', 'Mangifera indica', '水果作物', 280, 22.00, 32.00, 60.00, 75.00, '中等', '有机肥', '充足', '排水良好', 100.00, 800.00, '3', '中等', '老挝芒果香甜可口', '/photo/2026/01/26/lao_mango.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '热带水果之王');
INSERT INTO `crop_species` VALUES (9, '甘蔗', 'LAO006', 'Saccharum officinarum', '经济作物', 365, 20.00, 35.00, 65.00, 85.00, '高', '氮磷钾复合肥', '充足', '深厚土壤', 8000.00, 5000.00, '4', '较强', '老挝重要经济作物', '/photo/2026/01/26/sugarcane.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '制糖原料');
INSERT INTO `crop_species` VALUES (10, '辣椒', 'LAO007', 'Capsicum annuum', '蔬菜作物', 150, 20.00, 30.00, 60.00, 80.00, '中等', '有机肥+复合肥', '充足', '肥沃土壤', 30000.00, 1200.00, '3', '中等', '老挝菜系重要调料', '/photo/2026/01/26/lao_chili.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '辛辣品种丰富');
INSERT INTO `crop_species` VALUES (11, '菠萝', 'LAO008', 'Ananas comosus', '水果作物', 365, 22.00, 32.00, 70.00, 85.00, '中等', '钾肥为主', '充足', '酸性土壤', 15000.00, 2500.00, '4', '较强', '老挝菠萝品质优良', '/photo/2026/01/26/lao_pineapple.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '热带特色水果');
INSERT INTO `crop_species` VALUES (12, '绿豆', 'LAO009', 'Vigna radiata', '粮食作物', 70, 25.00, 35.00, 55.00, 70.00, '中等', '磷钾肥', '充足', '砂质壤土', 20000.00, 80.00, '3', '中等', '老挝传统豆类作物', '/photo/2026/01/26/mung_bean.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '营养丰富');
INSERT INTO `crop_species` VALUES (13, '柚子', 'LAO010', 'Citrus maxima', '水果作物', 365, 20.00, 30.00, 65.00, 80.00, '中等', '有机肥', '充足', '排水良好', 200.00, 1500.00, '4', '较强', '老挝柚子清甜多汁', '/photo/2026/01/26/lao_pomelo.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '冬季水果');
INSERT INTO `crop_species` VALUES (14, '花生', 'LAO011', 'Arachis hypogaea', '经济作物', 120, 22.00, 32.00, 50.00, 70.00, '中等', '钙肥+磷肥', '充足', '砂质土壤', 15000.00, 200.00, '3', '中等', '老挝重要油料作物', '/photo/2026/01/26/peanut.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '营养价值高');
INSERT INTO `crop_species` VALUES (15, '椰子', 'LAO012', 'Cocos nucifera', '经济作物', 365, 24.00, 35.00, 70.00, 90.00, '高', '有机肥', '充足', '海滨土壤', 150.00, 2000.00, '5', '强', '老挝南部特色作物', '/photo/2026/01/26/coconut.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '全身是宝');
INSERT INTO `crop_species` VALUES (16, '茄子', 'LAO013', 'Solanum melongena', '蔬菜作物', 150, 22.00, 32.00, 65.00, 80.00, '中等', '有机肥+复合肥', '充足', '肥沃土壤', 8000.00, 2500.00, '3', '中等', '老挝常见蔬菜', '/photo/2026/01/26/eggplant.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '品种多样');
INSERT INTO `crop_species` VALUES (17, '橙子', 'LAO014', 'Citrus sinensis', '水果作物', 365, 18.00, 28.00, 60.00, 75.00, '中等', '有机肥', '充足', '排水良好', 400.00, 1200.00, '4', '较强', '老挝橙子酸甜适中', '/photo/2026/01/26/lao_orange.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '富含维生素C');
INSERT INTO `crop_species` VALUES (18, '红薯', 'LAO015', 'Ipomoea batatas', '粮食作物', 120, 20.00, 30.00, 55.00, 75.00, '中等', '钾肥为主', '充足', '砂质土壤', 20000.00, 1800.00, '4', '强', '老挝重要杂粮', '/photo/2026/01/26/sweet_potato.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '适应性强');
INSERT INTO `crop_species` VALUES (19, '柠檬', 'LAO016', 'Citrus limon', '水果作物', 365, 18.00, 28.00, 60.00, 75.00, '中等', '有机肥', '充足', '排水良好', 300.00, 800.00, '3', '中等', '老挝柠檬香味浓郁', '/photo/2026/01/26/lao_lemon.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '调味佳品');
INSERT INTO `crop_species` VALUES (20, '冬瓜', 'LAO017', 'Benincasa hispida', '蔬菜作物', 100, 22.00, 32.00, 65.00, 80.00, '中等', '有机肥+复合肥', '充足', '肥沃土壤', 3000.00, 3000.00, '4', '较强', '老挝夏季主要蔬菜', '/photo/2026/01/26/winter_melon.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '产量高');
INSERT INTO `crop_species` VALUES (21, '榴莲', 'LAO018', 'Durio zibethinus', '水果作物', 365, 24.00, 32.00, 75.00, 90.00, '高', '有机肥', '充足', '肥沃土壤', 80.00, 1500.00, '3', '中等', '老挝榴莲品质上乘', '/photo/2026/01/26/lao_durian.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '水果之王');
INSERT INTO `crop_species` VALUES (22, '豆角', 'LAO019', 'Vigna unguiculata', '蔬菜作物', 80, 22.00, 32.00, 60.00, 75.00, '中等', '有机肥+复合肥', '充足', '肥沃土壤', 15000.00, 1000.00, '3', '中等', '老挝常见豆类蔬菜', '/photo/2026/01/26/bean_pole.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '生长快速');
INSERT INTO `crop_species` VALUES (23, '龙眼', 'LAO020', 'Dimocarpus longan', '水果作物', 365, 20.00, 30.00, 65.00, 80.00, '中等', '有机肥', '充足', '排水良好', 200.00, 800.00, '4', '较强', '老挝龙眼清甜', '/photo/2026/01/26/lao_longan.jpg', '0', 'admin', '2026-01-26 11:09:53', '', '2026-01-26 11:09:53', '热带水果');

-- ----------------------------
-- Table structure for crop_species_copy1
-- ----------------------------
DROP TABLE IF EXISTS `crop_species_copy1`;
CREATE TABLE `crop_species_copy1`  (
  `species_id` bigint NOT NULL AUTO_INCREMENT COMMENT '物种ID',
  `species_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物种名称',
  `species_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物种编号',
  `scientific_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学名',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类',
  `growth_period` int NULL DEFAULT NULL COMMENT '生长周期(天)',
  `optimal_temperature_min` decimal(4, 2) NULL DEFAULT NULL COMMENT '最适温度最低值(℃)',
  `optimal_temperature_max` decimal(4, 2) NULL DEFAULT NULL COMMENT '最适温度最高值(℃)',
  `optimal_humidity_min` decimal(4, 2) NULL DEFAULT NULL COMMENT '最适湿度最低值(%)',
  `optimal_humidity_max` decimal(4, 2) NULL DEFAULT NULL COMMENT '最适湿度最高值(%)',
  `water_requirement` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '水分需求',
  `fertilizer_requirement` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '肥料需求',
  `light_requirement` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '光照需求',
  `soil_requirement` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '土壤要求',
  `planting_density` decimal(8, 2) NULL DEFAULT NULL COMMENT '种植密度(株/亩)',
  `expected_yield` decimal(10, 2) NULL DEFAULT NULL COMMENT '预期产量(kg/亩)',
  `disease_resistance` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '抗病性',
  `pest_resistance` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '抗虫性',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '描述',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片URL',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态(0正常 1停用)',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`species_id`) USING BTREE,
  UNIQUE INDEX `uk_species_code`(`species_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '作物物种表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of crop_species_copy1
-- ----------------------------
INSERT INTO `crop_species_copy1` VALUES (1, '西红柿', 'CROP001', 'Solanum lycopersicum', '蔬菜', 120, 18.00, 28.00, 60.00, 80.00, '中等', '氮磷钾复合肥', '充足', '疏松肥沃', 3000.00, 5000.00, '3', NULL, NULL, NULL, '0', 'admin', '2026-01-22 17:20:28', '', '2026-01-26 10:22:16', NULL);
INSERT INTO `crop_species_copy1` VALUES (2, '黄瓜', 'CROP002', 'Cucumis sativus', '蔬菜', 90, 20.50, 30.00, 70.00, 85.00, '较高', '有机肥+复合肥', '充足', '富含有机质', 3600.00, 4000.00, '3', NULL, NULL, '/photo/2026/01/26/f9010931a00f45c6a374326550d4a49d.jpg', '0', 'admin', '2026-01-22 17:20:28', '', '2026-01-26 10:50:07', NULL);
INSERT INTO `crop_species_copy1` VALUES (3, '玉米', 'CROP003', 'Zea mays', '粮食', 150, 15.00, 30.00, 55.00, 75.00, '中等', '氮肥为主', '充足', '排水良好', 4500.00, 600.00, '3', NULL, NULL, NULL, '0', 'admin', '2026-01-22 17:20:28', '', '2026-01-26 10:22:08', NULL);

-- ----------------------------
-- Table structure for farming_management
-- ----------------------------
DROP TABLE IF EXISTS `farming_management`;
CREATE TABLE `farming_management`  (
  `management_id` bigint NOT NULL AUTO_INCREMENT COMMENT '管理记录ID',
  `planting_id` bigint NOT NULL COMMENT '种植记录ID',
  `management_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '管理类型(fertilizer施肥 pesticide施药 irrigation灌溉 weeding除草 other其他)',
  `management_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '管理时间',
  `material_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料名称',
  `material_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料类型',
  `dosage` decimal(10, 2) NULL DEFAULT NULL COMMENT '用量',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位',
  `method` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '使用方法',
  `purpose` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '目的',
  `effect` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '效果',
  `cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '成本',
  `operator` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作人员',
  `weather_condition` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '天气条件',
  `next_management_date` date NULL DEFAULT NULL COMMENT '下次管理时间',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`management_id`) USING BTREE,
  INDEX `idx_planting_id`(`planting_id` ASC) USING BTREE,
  INDEX `idx_management_date`(`management_date` ASC) USING BTREE,
  INDEX `idx_management_type`(`management_type` ASC) USING BTREE,
  CONSTRAINT `fk_farming_planting` FOREIGN KEY (`planting_id`) REFERENCES `planting_record` (`planting_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '种植管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of farming_management
-- ----------------------------
INSERT INTO `farming_management` VALUES (1, 1, 'pesticide', '2026-01-22 19:26:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '健康状态:disease', 'admin', '2026-01-22 19:26:40', '', '2026-01-22 19:26:39');
INSERT INTO `farming_management` VALUES (2, 3, 'pesticide', '2026-01-26 11:36:32', '测试', '农药', 0.10, 'L', '测试', NULL, 'ces', 0.01, 'aa', 'ss', NULL, 'ces', '', '2026-01-26 11:37:02', '', '2026-01-26 11:37:02');
INSERT INTO `farming_management` VALUES (3, 4, 'fertilizer', '2026-01-26 12:00:00', '复合肥', '肥料', 25.00, 'kg', '撒施', '促进生长', '效果良好', 150.00, '张三', '晴天', '2026-02-10', '定期施肥', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (4, 5, 'irrigation', '2026-01-26 12:00:00', NULL, NULL, 50.00, 'm³', '滴灌', '保持土壤湿度', '土壤湿润', 30.00, '李四', '多云', '2026-01-28', '保持充足水分', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (5, 6, 'weeding', '2026-01-26 12:00:00', NULL, NULL, NULL, NULL, '人工除草', '清除杂草', '杂草清除干净', 80.00, '王五', '晴天', '2026-02-05', '定期除草', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (6, 7, 'pesticide', '2026-01-26 12:00:00', '杀虫剂', '农药', 0.50, 'L', '喷雾', '防治虫害', '虫害得到控制', 45.00, '赵六', '阴天', '2026-02-15', '注意安全间隔期', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (7, 8, 'fertilizer', '2026-01-26 12:00:00', '有机肥', '肥料', 100.00, 'kg', '沟施', '增加有机质', '土壤改良明显', 200.00, '孙七', '晴天', '2026-02-20', '有机肥效果持久', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (8, 9, 'irrigation', '2026-01-26 12:00:00', NULL, NULL, 35.00, 'm³', '喷灌', '补充水分', '灌溉均匀', 25.00, '周八', '多云', '2026-01-30', '注意排水', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (9, 10, 'pesticide', '2026-01-26 12:00:00', '杀菌剂', '农药', 0.30, 'L', '喷雾', '预防病害', '无病害发生', 35.00, '吴九', '晴天', '2026-02-12', '预防为主', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (10, 11, 'fertilizer', '2026-01-26 12:00:00', '氮肥', '肥料', 15.00, 'kg', '撒施', '促进叶片生长', '叶片茂盛', 60.00, '郑十', '晴天', '2026-02-08', '适量使用', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (11, 12, 'weeding', '2026-01-26 12:00:00', NULL, NULL, NULL, NULL, '机械除草', '清除杂草', '杂草减少', 50.00, '钱一', '多云', '2026-02-03', '定期维护', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (12, 13, 'irrigation', '2026-01-26 12:00:00', NULL, NULL, 28.00, 'm³', '滴灌', '保持湿度', '土壤湿润', 20.00, '孙二', '晴天', '2026-01-29', '控制水量', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (13, 14, 'pesticide', '2026-01-26 12:00:00', '除草剂', '农药', 0.20, 'L', '喷雾', '清除杂草', '杂草清除', 30.00, '李三', '阴天', '2026-02-10', '注意使用浓度', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (14, 15, 'fertilizer', '2026-01-26 12:00:00', '磷钾肥', '肥料', 20.00, 'kg', '穴施', '促进开花结果', '效果良好', 90.00, '王四', '晴天', '2026-02-18', '花期前使用', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (15, 16, 'irrigation', '2026-01-26 12:00:00', NULL, NULL, 42.00, 'm³', '沟灌', '充足供水', '水分充足', 28.00, '赵五', '多云', '2026-01-31', '避免积水', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (16, 17, 'pesticide', '2026-01-26 12:00:00', '生物农药', '农药', 0.40, 'L', '喷雾', '环保防治', '安全有效', 55.00, '周六', '晴天', '2026-02-14', '生物农药安全', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (17, 18, 'fertilizer', '2026-01-26 12:00:00', '复合肥', '肥料', 30.00, 'kg', '撒施', '全面营养', '生长良好', 120.00, '吴七', '晴天', '2026-02-25', '均衡施肥', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (18, 19, 'weeding', '2026-01-26 12:00:00', NULL, NULL, NULL, NULL, '人工除草', '精细管理', '杂草清除', 70.00, '郑八', '多云', '2026-02-07', '及时除草', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (19, 20, 'irrigation', '2026-01-26 12:00:00', NULL, NULL, 38.00, 'm³', '喷灌', '均匀灌溉', '灌溉效果佳', 26.00, '钱九', '晴天', '2026-02-02', '注意均匀度', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (20, 21, 'pesticide', '2026-01-26 12:00:00', '杀虫剂', '农药', 0.35, 'L', '喷雾', '防治害虫', '虫害减少', 40.00, '孙十', '阴天', '2026-02-16', '轮换使用', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (21, 22, 'fertilizer', '2026-01-26 12:00:00', '有机肥', '肥料', 80.00, 'kg', '沟施', '改良土壤', '土壤肥力提升', 180.00, '李一', '晴天', '2026-02-22', '长期效果', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `farming_management` VALUES (22, 23, 'irrigation', '2026-01-26 12:00:00', NULL, NULL, 33.00, 'm³', '滴灌', '精准灌溉', '节水高效', 22.00, '王二', '多云', '2026-02-04', '精准控制', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');

-- ----------------------------
-- Table structure for farming_task
-- ----------------------------
DROP TABLE IF EXISTS `farming_task`;
CREATE TABLE `farming_task`  (
  `task_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `planting_id` bigint NOT NULL COMMENT '种植记录ID',
  `task_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务类型(pesticide等)',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '任务内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态(0待办 1已完成)',
  `handler` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '处理人',
  `handled_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`task_id`) USING BTREE,
  INDEX `idx_task_planting_id`(`planting_id` ASC) USING BTREE,
  INDEX `idx_task_status`(`status` ASC) USING BTREE,
  INDEX `idx_task_type`(`task_type` ASC) USING BTREE,
  CONSTRAINT `fk_task_planting` FOREIGN KEY (`planting_id`) REFERENCES `planting_record` (`planting_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '农事待办任务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of farming_task
-- ----------------------------
INSERT INTO `farming_task` VALUES (1, 2, 'pesticide', '病虫害待处理', '健康状态:pest', '1', 'admin', '2026-01-22 19:58:36', 'admin', '2026-01-22 19:58:26', 'admin', '2026-01-22 19:58:36', NULL);
INSERT INTO `farming_task` VALUES (2, 2, 'pesticide', '病虫害待处理', '健康状态:pest', '1', 'admin', '2026-01-22 20:01:11', 'admin', '2026-01-22 20:00:34', 'admin', '2026-01-22 20:01:11', NULL);
INSERT INTO `farming_task` VALUES (3, 2, 'pesticide', '病虫害待处理', '健康状态:serious', '1', 'admin', '2026-01-22 20:05:51', 'admin', '2026-01-22 20:05:24', 'admin', '2026-01-22 20:05:51', NULL);
INSERT INTO `farming_task` VALUES (4, 3, 'pesticide', '病虫害待处理', '健康状态:serious', '1', 'admin', '2026-01-23 18:17:54', 'admin', '2026-01-23 18:17:22', 'admin', '2026-01-23 18:17:54', NULL);
INSERT INTO `farming_task` VALUES (5, 4, 'fertilizer', '施肥任务', '需要追肥', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '定期施肥');
INSERT INTO `farming_task` VALUES (6, 5, 'irrigation', '灌溉任务', '需要补充水分', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '保持土壤湿度');
INSERT INTO `farming_task` VALUES (7, 6, 'weeding', '除草任务', '杂草较多需要清除', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '及时除草');
INSERT INTO `farming_task` VALUES (8, 7, 'pesticide', '病虫害防治', '发现轻微虫害', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '预防为主');
INSERT INTO `farming_task` VALUES (9, 8, 'fertilizer', '追肥任务', '生长期需要追肥', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '促进生长');
INSERT INTO `farming_task` VALUES (10, 9, 'irrigation', '灌溉任务', '土壤干燥需要灌溉', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '保持水分');
INSERT INTO `farming_task` VALUES (11, 10, 'pesticide', '病害预防', '预防病害发生', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '提前预防');
INSERT INTO `farming_task` VALUES (12, 11, 'fertilizer', '施肥任务', '需要补充营养', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '营养均衡');
INSERT INTO `farming_task` VALUES (13, 12, 'weeding', '除草任务', '定期除草', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '定期维护');
INSERT INTO `farming_task` VALUES (14, 13, 'irrigation', '灌溉任务', '需要适量灌溉', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '控制水量');
INSERT INTO `farming_task` VALUES (15, 14, 'pesticide', '虫害防治', '发现虫害迹象', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '及时处理');
INSERT INTO `farming_task` VALUES (16, 15, 'fertilizer', '追肥任务', '花期前追肥', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '促进开花');
INSERT INTO `farming_task` VALUES (17, 16, 'irrigation', '灌溉任务', '保持土壤湿润', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '适量灌溉');
INSERT INTO `farming_task` VALUES (18, 17, 'pesticide', '病虫害防治', '预防病虫害', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '综合防治');
INSERT INTO `farming_task` VALUES (19, 18, 'fertilizer', '施肥任务', '生长期施肥', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '促进生长');
INSERT INTO `farming_task` VALUES (20, 19, 'weeding', '除草任务', '清除杂草', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '及时清理');
INSERT INTO `farming_task` VALUES (21, 20, 'irrigation', '灌溉任务', '补充水分', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '保持湿度');
INSERT INTO `farming_task` VALUES (22, 21, 'pesticide', '虫害防治', '防治害虫', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '及时防治');
INSERT INTO `farming_task` VALUES (23, 22, 'fertilizer', '施肥任务', '土壤改良', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '改良土壤');
INSERT INTO `farming_task` VALUES (24, 23, 'irrigation', '灌溉任务', '精准灌溉', '0', NULL, NULL, 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', '精准控制');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for harvest_record
-- ----------------------------
DROP TABLE IF EXISTS `harvest_record`;
CREATE TABLE `harvest_record`  (
  `harvest_id` bigint NOT NULL AUTO_INCREMENT COMMENT '采摘记录ID',
  `planting_id` bigint NOT NULL COMMENT '种植记录ID',
  `harvest_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '采摘时间',
  `harvest_area` decimal(10, 2) NULL DEFAULT NULL COMMENT '采摘面积(亩)',
  `harvest_quantity` decimal(10, 2) NULL DEFAULT NULL COMMENT '采摘数量(kg)',
  `quality_grade` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '质量等级',
  `unit_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '单价(元/kg)',
  `total_price` decimal(12, 2) NULL DEFAULT NULL COMMENT '总价(元)',
  `harvest_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '采摘方式',
  `storage_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '存储位置',
  `storage_conditions` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '存储条件',
  `buyer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收购方',
  `transport_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '运输方式',
  `operator` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作人员',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`harvest_id`) USING BTREE,
  UNIQUE INDEX `uk_harvest_planting_id`(`planting_id` ASC) USING BTREE,
  INDEX `idx_planting_id`(`planting_id` ASC) USING BTREE,
  INDEX `idx_harvest_date`(`harvest_date` ASC) USING BTREE,
  CONSTRAINT `fk_harvest_planting` FOREIGN KEY (`planting_id`) REFERENCES `planting_record` (`planting_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采摘记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of harvest_record
-- ----------------------------
INSERT INTO `harvest_record` VALUES (2, 2, '2026-01-22 20:40:07', 0.30, 0.20, '特等', 0.02, 0.00, '人工采摘', NULL, NULL, NULL, NULL, 'ss', NULL, '', '2026-01-22 20:40:15', '', '2026-01-22 20:40:15');
INSERT INTO `harvest_record` VALUES (3, 1, '2026-01-22 20:43:18', 0.30, 0.20, '特等', 0.02, 0.00, '人工采摘', NULL, NULL, NULL, NULL, 'aa', NULL, '', '2026-01-22 20:43:29', '', '2026-01-22 20:43:28');
INSERT INTO `harvest_record` VALUES (4, 3, '2026-01-23 18:18:38', 0.70, 0.30, '特等', 0.02, 0.01, NULL, NULL, NULL, NULL, NULL, '的撒旦', NULL, '', '2026-01-23 18:18:47', '', '2026-01-23 18:18:47');
INSERT INTO `harvest_record` VALUES (5, 4, '2026-05-20 08:00:00', 2.50, 750.00, '一等', 2.50, 1875.00, '机械收割', '仓库A区', '常温干燥', '本地收购商', '货车运输', '张师傅', '糯米品质优良', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (6, 5, '2027-01-18 09:00:00', 1.80, 270.00, '特等', 25.00, 6750.00, '人工采摘', '仓库B区', '阴凉干燥', '咖啡加工厂', '专用运输车', '李师傅', '咖啡豆品质上乘', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (7, 6, '2027-01-15 10:00:00', 3.20, 6400.00, '一等', 3.50, 22400.00, '人工采摘', '仓库C区', '常温保存', '水果批发市场', '冷藏车', '王师傅', '香蕉成熟度好', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (8, 7, '2026-11-07 11:00:00', 4.50, 6750.00, '一等', 1.20, 8100.00, '机械收获', '仓库D区', '干燥通风', '淀粉加工厂', '货车运输', '赵师傅', '木薯产量高', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (9, 8, '2026-10-17 12:00:00', 0.80, 640.00, '特等', 8.00, 5120.00, '人工采摘', '仓库E区', '常温保存', '水果超市', '冷藏车', '周师傅', '芒果香甜', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (10, 9, '2027-01-08 13:00:00', 5.20, 26000.00, '一等', 0.80, 20800.00, '机械收割', '仓库F区', '干燥保存', '制糖厂', '专用运输车', '吴师傅', '甘蔗含糖量高', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (11, 10, '2026-06-04 14:00:00', 1.50, 1800.00, '一等', 4.00, 7200.00, '人工采摘', '仓库G区', '常温保存', '蔬菜批发市场', '货车运输', '郑师傅', '辣椒品质好', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (12, 11, '2027-01-03 15:00:00', 2.80, 7000.00, '特等', 3.50, 24500.00, '人工采摘', '仓库H区', '常温保存', '水果加工厂', '冷藏车', '钱师傅', '菠萝新鲜', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (13, 12, '2026-03-12 16:00:00', 1.20, 96.00, '一等', 5.00, 480.00, '人工采摘', '仓库I区', '干燥保存', '豆类加工厂', '货车运输', '孙师傅', '绿豆饱满', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (14, 13, '2026-12-28 17:00:00', 0.60, 900.00, '特等', 6.00, 5400.00, '人工采摘', '仓库J区', '常温保存', '水果超市', '冷藏车', '李师傅', '柚子清甜', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (15, 14, '2026-04-24 18:00:00', 2.30, 460.00, '一等', 6.00, 2760.00, '机械收获', '仓库K区', '干燥保存', '油料加工厂', '货车运输', '王师傅', '花生饱满', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (16, 15, '2026-12-22 19:00:00', 0.40, 800.00, '特等', 8.00, 6400.00, '人工采摘', '仓库L区', '常温保存', '水果批发市场', '冷藏车', '赵师傅', '椰子新鲜', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (17, 16, '2026-05-19 20:00:00', 1.70, 4250.00, '一等', 2.50, 10625.00, '人工采摘', '仓库M区', '常温保存', '蔬菜批发市场', '货车运输', '周师傅', '茄子品质好', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (18, 17, '2026-12-18 21:00:00', 0.50, 600.00, '特等', 5.00, 3000.00, '人工采摘', '仓库N区', '常温保存', '水果超市', '冷藏车', '吴师傅', '橙子酸甜适中', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (19, 18, '2026-04-14 22:00:00', 2.10, 3780.00, '一等', 2.00, 7560.00, '机械收获', '仓库O区', '干燥保存', '粮食加工厂', '货车运输', '郑师傅', '红薯产量高', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (20, 19, '2026-12-12 23:00:00', 0.35, 280.00, '特等', 6.00, 1680.00, '人工采摘', '仓库P区', '常温保存', '水果批发市场', '冷藏车', '钱师傅', '柠檬香味浓郁', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (21, 20, '2026-03-20 08:30:00', 1.40, 4200.00, '一等', 1.50, 6300.00, '人工采摘', '仓库Q区', '常温保存', '蔬菜批发市场', '货车运输', '孙师傅', '冬瓜个大', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (22, 21, '2026-12-08 09:30:00', 0.25, 375.00, '特等', 12.00, 4500.00, '人工采摘', '仓库R区', '常温保存', '水果超市', '冷藏车', '李师傅', '榴莲品质上乘', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (23, 22, '2026-02-23 10:30:00', 1.60, 1600.00, '一等', 3.00, 4800.00, '人工采摘', '仓库S区', '常温保存', '蔬菜批发市场', '货车运输', '王师傅', '豆角新鲜', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');
INSERT INTO `harvest_record` VALUES (24, 23, '2026-12-03 11:30:00', 0.45, 360.00, '特等', 7.00, 2520.00, '人工采摘', '仓库T区', '常温保存', '水果超市', '冷藏车', '赵师傅', '龙眼清甜', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00');

-- ----------------------------
-- Table structure for land_info
-- ----------------------------
DROP TABLE IF EXISTS `land_info`;
CREATE TABLE `land_info`  (
  `land_id` bigint NOT NULL AUTO_INCREMENT COMMENT '地块ID',
  `land_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '地块名称',
  `land_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地块编号',
  `area` decimal(10, 2) NULL DEFAULT NULL COMMENT '面积(亩)',
  `location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '位置描述',
  `soil_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '土壤类型',
  `soil_ph` decimal(4, 2) NULL DEFAULT NULL COMMENT '土壤pH值',
  `soil_organic_matter` decimal(5, 2) NULL DEFAULT NULL COMMENT '有机质含量(%)',
  `soil_nitrogen` decimal(5, 2) NULL DEFAULT NULL COMMENT '氮含量(mg/kg)',
  `soil_phosphorus` decimal(5, 2) NULL DEFAULT NULL COMMENT '磷含量(mg/kg)',
  `soil_potassium` decimal(5, 2) NULL DEFAULT NULL COMMENT '钾含量(mg/kg)',
  `irrigation_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '灌溉方式',
  `drainage_condition` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '排水条件',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态(0正常 1停用)',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`land_id`) USING BTREE,
  UNIQUE INDEX `uk_land_code`(`land_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '地块信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of land_info
-- ----------------------------
INSERT INTO `land_info` VALUES (1, '东区一号地块', 'LAND001', 10.50, '农场东区', '壤土', 6.50, 2.80, 120.50, 45.20, 98.60, '滴灌', '良好', '0', 'admin', '2026-01-22 17:20:28', '', '2026-01-22 17:20:28', NULL);
INSERT INTO `land_info` VALUES (2, '西区二号地块', 'LAND002', 8.20, '农场西区', '沙壤土', 6.80, 2.50, 115.30, 42.80, 92.40, '喷灌', '一般', '0', 'admin', '2026-01-22 17:20:28', '', '2026-01-22 17:20:28', NULL);
INSERT INTO `land_info` VALUES (54, '北区四号地块', 'LAND004', 15.30, '农场北区', '沙土', 7.20, 1.80, 95.60, 38.90, 85.30, '滴灌', '较差', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (55, '中区五号地块', 'LAND005', 9.70, '农场中区', '壤土', 6.90, 2.90, 118.70, 46.30, 101.80, '喷灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (56, '东区六号地块', 'LAND006', 11.20, '农场东区东侧', '黏壤土', 6.40, 3.30, 128.90, 50.10, 108.70, '沟灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (57, '西区七号地块', 'LAND007', 7.80, '农场西区南侧', '沙质壤土', 7.10, 2.10, 105.40, 40.20, 88.90, '滴灌', '一般', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (58, '南区八号地块', 'LAND008', 13.50, '农场南区西侧', '粉砂壤土', 6.60, 2.70, 122.30, 44.70, 96.50, '喷灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (59, '北区九号地块', 'LAND009', 16.80, '农场北区北侧', '壤质砂土', 7.40, 1.60, 88.20, 35.80, 78.40, '漫灌', '较差', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (60, '中区十号地块', 'LAND010', 8.90, '农场中区中央', '壤土', 6.70, 3.00, 116.90, 47.10, 99.20, '滴灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (61, '东区十一号地块', 'LAND011', 14.20, '农场东区东北', '黏土', 6.10, 3.50, 132.60, 52.80, 112.30, '沟灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (62, '西区十二号地块', 'LAND012', 6.50, '农场西区西北', '砂壤土', 7.00, 2.30, 108.70, 41.50, 90.10, '喷灌', '一般', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (63, '南区十三号地块', 'LAND013', 11.70, '农场南区东南', '壤黏土', 6.30, 3.20, 126.40, 49.30, 106.80, '滴灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (64, '北区十四号地块', 'LAND014', 18.40, '农场北区西南', '砂土', 7.60, 1.40, 82.50, 33.20, 74.10, '漫灌', '较差', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (65, '中区十五号地块', 'LAND015', 10.10, '农场中区东侧', '粉壤土', 6.80, 2.80, 119.80, 45.90, 98.70, '喷灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (66, '东区十六号地块', 'LAND016', 12.60, '农场东区西侧', '黏壤土', 6.50, 3.40, 130.20, 51.40, 110.50, '沟灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (67, '西区十七号地块', 'LAND017', 9.30, '农场西区中央', '壤质砂土', 7.30, 1.90, 98.60, 39.40, 86.20, '滴灌', '一般', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (68, '南区十八号地块', 'LAND018', 15.90, '农场南区北侧', '砂质黏土', 6.00, 3.60, 135.10, 53.70, 114.90, '沟灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (69, '北区十九号地块', 'LAND019', 17.20, '农场北区东侧', '粉砂黏土', 6.20, 3.10, 124.70, 48.80, 105.60, '喷灌', '一般', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (70, '中区二十号地块', 'LAND020', 8.40, '农场中区西侧', '壤土', 6.90, 2.60, 114.50, 43.60, 94.30, '滴灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (71, '东区二十一号地块', 'LAND021', 13.80, '农场东区南侧', '黏土', 5.80, 3.80, 138.40, 55.20, 117.60, '沟灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (72, '西区二十二号地块', 'LAND022', 7.10, '农场西区北侧', '砂壤土', 7.20, 2.00, 102.30, 38.70, 84.50, '喷灌', '一般', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (73, '南区二十三号地块', 'LAND023', 14.60, '农场南区中央', '壤黏土', 6.40, 3.30, 128.90, 50.60, 108.20, '滴灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (74, '北区二十四号地块', 'LAND024', 19.50, '农场北区中央', '砂土', 7.80, 1.20, 76.80, 30.50, 68.90, '漫灌', '较差', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (75, '中区二十五号地块', 'LAND025', 11.40, '农场中区南侧', '粉壤土', 6.70, 2.90, 117.20, 46.20, 97.80, '喷灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (76, '东区二十六号地块', 'LAND026', 16.10, '农场东区北侧', '黏壤土', 6.30, 3.50, 131.80, 52.10, 111.70, '沟灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (77, '西区二十七号地块', 'LAND027', 5.90, '农场西区东侧', '壤质砂土', 7.50, 1.70, 91.40, 36.90, 79.80, '滴灌', '较差', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (78, '南区二十八号地块', 'LAND028', 12.30, '农场南区东侧', '砂质黏土', 6.10, 3.40, 133.60, 52.90, 113.40, '沟灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (79, '北区二十九号地块', 'LAND029', 20.70, '农场北区西侧', '粉砂黏土', 6.50, 3.00, 123.10, 47.50, 104.90, '喷灌', '一般', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (80, '中区三十号地块', 'LAND030', 9.80, '农场中区北侧', '壤土', 7.00, 2.40, 111.80, 42.80, 91.60, '滴灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (81, '东区三十一号地块', 'LAND031', 15.40, '农场东区中央', '黏土', 5.90, 3.70, 136.90, 54.50, 116.20, '沟灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (82, '西区三十二号地块', 'LAND032', 8.60, '农场西区西南', '砂壤土', 7.40, 1.80, 96.20, 37.50, 81.70, '喷灌', '一般', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (83, '南区三十三号地块', 'LAND033', 13.10, '农场南区西北', '壤黏土', 6.60, 3.20, 127.40, 49.80, 107.50, '滴灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (84, '北区三十四号地块', 'LAND034', 21.30, '农场北区东南', '砂土', 7.90, 1.10, 74.30, 28.90, 65.20, '漫灌', '较差', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (85, '中区三十五号地块', 'LAND035', 10.70, '农场中区西北', '粉壤土', 6.80, 2.70, 115.60, 44.30, 95.90, '喷灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (86, '东区三十六号地块', 'LAND036', 17.80, '农场东区西北', '黏壤土', 6.20, 3.60, 134.20, 53.30, 114.10, '沟灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (87, '西区三十七号地块', 'LAND037', 6.30, '农场西区东南', '壤质砂土', 7.60, 1.50, 89.70, 35.20, 76.40, '滴灌', '较差', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (88, '南区三十八号地块', 'LAND038', 14.90, '农场南区东北', '砂质黏土', 6.00, 3.80, 140.10, 56.10, 119.80, '沟灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (89, '北区三十九号地块', 'LAND039', 22.60, '农场北区东北', '粉砂黏土', 6.40, 2.90, 121.60, 46.90, 102.30, '喷灌', '一般', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (90, '中区四十号地块', 'LAND040', 11.90, '农场中区东南', '壤土', 7.10, 2.20, 108.90, 41.20, 87.80, '滴灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (91, '东区四十一号地块', 'LAND041', 18.10, '农场东区东南', '黏土', 5.70, 4.00, 142.70, 57.80, 122.50, '沟灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (92, '西区四十二号地块', 'LAND042', 7.50, '农场西区东北', '砂壤土', 7.70, 1.30, 84.50, 32.80, 71.30, '喷灌', '一般', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (93, '南区四十三号地块', 'LAND043', 16.40, '农场南区西南', '壤黏土', 6.50, 3.10, 125.90, 48.60, 106.10, '滴灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (94, '北区四十四号地块', 'LAND044', 23.80, '农场北区西北', '砂土', 8.10, 0.90, 68.70, 25.60, 58.70, '漫灌', '较差', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (95, '中区四十五号地块', 'LAND045', 12.20, '农场中区东北', '粉壤土', 6.90, 2.50, 112.40, 43.10, 89.50, '喷灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (96, '东区四十六号地块', 'LAND046', 19.30, '农场东区西南', '黏壤土', 6.10, 3.90, 139.50, 55.80, 118.70, '沟灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (97, '西区四十七号地块', 'LAND047', 8.10, '农场西区中央', '壤质砂土', 7.80, 1.60, 93.10, 36.20, 78.90, '滴灌', '一般', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-22 19:01:48', NULL);
INSERT INTO `land_info` VALUES (98, '南区四十八号地块', 'LAND048', 18.60, '农场南区中央', '砂质黏土', 6.80, 6.10, 145.30, 59.90, 124.60, '喷灌', '良好', '0', 'admin', '2026-01-22 19:01:48', '', '2026-01-26 10:15:28', NULL);
INSERT INTO `land_info` VALUES (99, '东区四十九号地块', 'LAND049', 12.80, '农场东区西北角', '壤土', 6.60, 2.85, 121.30, 46.50, 100.20, '滴灌', '良好', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (100, '西区五十号地块', 'LAND050', 9.50, '农场西区东南角', '沙壤土', 7.15, 2.15, 106.80, 40.60, 89.30, '喷灌', '一般', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (101, '南区五十一号地块', 'LAND051', 15.20, '农场南区西南角', '粉砂壤土', 6.55, 2.75, 123.60, 45.20, 97.80, '喷灌', '良好', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (102, '北区五十二号地块', 'LAND052', 17.60, '农场北区东北角', '壤质砂土', 7.35, 1.65, 89.40, 36.20, 79.60, '滴灌', '较差', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (103, '中区五十三号地块', 'LAND053', 10.30, '农场中区西南角', '壤土', 6.75, 2.95, 117.50, 46.80, 99.50, '滴灌', '良好', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (104, '东区五十四号地块', 'LAND054', 13.40, '农场东区东南角', '黏土', 6.05, 3.55, 133.20, 52.50, 111.80, '沟灌', '良好', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (105, '西区五十五号地块', 'LAND055', 8.70, '农场西区西南角', '砂壤土', 7.05, 2.25, 109.20, 41.80, 90.50, '喷灌', '一般', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (106, '南区五十六号地块', 'LAND056', 14.80, '农场南区东北角', '壤黏土', 6.25, 3.25, 127.80, 49.60, 107.20, '滴灌', '良好', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (107, '北区五十七号地块', 'LAND057', 19.20, '农场北区东南角', '砂土', 7.65, 1.25, 77.20, 31.00, 69.40, '漫灌', '较差', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (108, '中区五十八号地块', 'LAND058', 11.60, '农场中区东北角', '粉壤土', 6.85, 2.75, 118.40, 45.50, 98.20, '喷灌', '良好', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (109, '东区五十九号地块', 'LAND059', 16.50, '农场东区西南角', '黏壤土', 6.35, 3.45, 131.40, 51.80, 110.90, '沟灌', '良好', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (110, '西区六十号地块', 'LAND060', 7.30, '农场西区东北角', '壤质砂土', 7.55, 1.75, 92.80, 37.10, 80.20, '滴灌', '较差', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (111, '南区六十一号地块', 'LAND061', 15.70, '农场南区西北角', '砂质黏土', 6.15, 3.55, 134.50, 53.20, 113.60, '沟灌', '良好', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (112, '北区六十二号地块', 'LAND062', 20.40, '农场北区西南角', '粉砂黏土', 6.45, 2.95, 122.30, 47.20, 103.80, '喷灌', '一般', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (113, '中区六十三号地块', 'LAND063', 9.10, '农场中区东南角', '壤土', 7.05, 2.50, 112.60, 43.30, 92.10, '滴灌', '良好', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (114, '东区六十四号地块', 'LAND064', 17.20, '农场东区东北角', '黏土', 5.95, 3.75, 137.30, 54.20, 115.80, '沟灌', '良好', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (115, '西区六十五号地块', 'LAND065', 6.80, '农场西区西北角', '砂壤土', 7.65, 1.35, 85.90, 33.20, 72.60, '喷灌', '一般', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (116, '南区六十六号地块', 'LAND066', 13.60, '农场南区中央', '壤黏土', 6.55, 3.15, 126.20, 48.90, 106.40, '滴灌', '良好', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (117, '北区六十七号地块', 'LAND067', 21.80, '农场北区中央', '砂土', 8.05, 0.95, 69.20, 26.10, 59.20, '漫灌', '较差', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `land_info` VALUES (118, '中区六十八号地块', 'LAND068', 10.90, '农场中区中央', '粉壤土', 6.95, 2.60, 113.80, 44.00, 90.30, '喷灌', '良好', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);

-- ----------------------------
-- Table structure for planting_record
-- ----------------------------
DROP TABLE IF EXISTS `planting_record`;
CREATE TABLE `planting_record`  (
  `planting_id` bigint NOT NULL AUTO_INCREMENT COMMENT '种植记录ID',
  `land_id` bigint NOT NULL COMMENT '地块ID',
  `species_id` bigint NOT NULL COMMENT '物种ID',
  `planting_date` date NULL DEFAULT NULL COMMENT '种植日期',
  `expected_harvest_date` date NULL DEFAULT NULL COMMENT '预期收获日期',
  `actual_harvest_date` date NULL DEFAULT NULL COMMENT '实际收获日期',
  `planting_area` decimal(10, 2) NULL DEFAULT NULL COMMENT '种植面积(亩)',
  `planting_density` decimal(8, 2) NULL DEFAULT NULL COMMENT '种植密度(株/亩)',
  `seed_quantity` decimal(10, 2) NULL DEFAULT NULL COMMENT '种子用量(kg)',
  `seed_source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '种子来源',
  `growth_stage` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生长阶段',
  `health_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'healthy' COMMENT '健康状况',
  `disease_info` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '病害信息',
  `pest_info` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '虫害信息',
  `is_mature` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否成熟(0未成熟 1成熟)',
  `can_harvest` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '可采摘(0不可 1可)',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态(0正常 1停用)',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`planting_id`) USING BTREE,
  INDEX `idx_land_id`(`land_id` ASC) USING BTREE,
  INDEX `idx_species_id`(`species_id` ASC) USING BTREE,
  INDEX `idx_planting_date`(`planting_date` ASC) USING BTREE,
  CONSTRAINT `fk_planting_land` FOREIGN KEY (`land_id`) REFERENCES `land_info` (`land_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '种植记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of planting_record
-- ----------------------------
INSERT INTO `planting_record` VALUES (1, 98, 3, '2026-01-22', '0002-11-30', NULL, 0.10, 4500.00, NULL, NULL, '成熟期', 'healthy', NULL, NULL, '1', '1', '0', '', '2026-01-22 19:15:18', '', '2026-01-22 20:43:13', NULL);
INSERT INTO `planting_record` VALUES (2, 97, 2, '2026-01-22', '2026-01-22', NULL, 0.10, 3600.00, NULL, NULL, '成熟期', 'healthy', NULL, NULL, '1', '1', '0', '', '2026-01-22 19:58:15', 'admin', '2026-01-22 20:24:49', NULL);
INSERT INTO `planting_record` VALUES (3, 98, 2, '2026-01-23', '0002-11-30', NULL, 0.50, 3600.00, NULL, NULL, '成熟期', 'healthy', NULL, NULL, '1', '1', '0', '', '2026-01-23 18:17:00', 'admin', '2026-01-26 11:25:02', NULL);
INSERT INTO `planting_record` VALUES (4, 1, 4, '2026-01-20', '2026-05-20', NULL, 2.50, 25000.00, 50.00, '本地种子公司', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (5, 2, 5, '2026-01-18', '2027-01-18', NULL, 1.80, 2000.00, 3.60, '进口种子', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (6, 54, 6, '2026-01-15', '2027-01-15', NULL, 3.20, 1500.00, 4.80, '本地供应商', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (7, 55, 7, '2026-01-12', '2026-11-07', NULL, 4.50, 8000.00, 36.00, '本地种子公司', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (8, 56, 8, '2026-01-10', '2026-10-17', NULL, 0.80, 100.00, 0.08, '进口种子', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (9, 57, 9, '2026-01-08', '2027-01-08', NULL, 5.20, 8000.00, 41.60, '本地供应商', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (10, 58, 10, '2026-01-05', '2026-06-04', NULL, 1.50, 30000.00, 45.00, '本地种子公司', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (11, 59, 11, '2026-01-03', '2027-01-03', NULL, 2.80, 15000.00, 42.00, '进口种子', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (12, 60, 12, '2026-01-01', '2026-03-12', NULL, 1.20, 20000.00, 24.00, '本地供应商', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (13, 61, 13, '2025-12-28', '2026-12-28', NULL, 0.60, 200.00, 0.12, '本地种子公司', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (14, 62, 14, '2025-12-25', '2026-04-24', NULL, 2.30, 15000.00, 34.50, '进口种子', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (15, 63, 15, '2025-12-22', '2026-12-22', NULL, 0.40, 150.00, 0.06, '本地供应商', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (16, 64, 16, '2025-12-20', '2026-05-19', NULL, 1.70, 8000.00, 13.60, '本地种子公司', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (17, 65, 17, '2025-12-18', '2026-12-18', NULL, 0.50, 400.00, 0.20, '进口种子', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (18, 66, 18, '2025-12-15', '2026-04-14', NULL, 2.10, 20000.00, 42.00, '本地供应商', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (19, 67, 19, '2025-12-12', '2026-12-12', NULL, 0.35, 300.00, 0.11, '本地种子公司', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (20, 68, 20, '2025-12-10', '2026-03-20', NULL, 1.40, 3000.00, 4.20, '进口种子', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (21, 69, 21, '2025-12-08', '2026-12-08', NULL, 0.25, 80.00, 0.02, '本地供应商', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (22, 70, 22, '2025-12-05', '2026-02-23', NULL, 1.60, 15000.00, 24.00, '本地种子公司', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `planting_record` VALUES (23, 71, 23, '2025-12-03', '2026-12-03', NULL, 0.45, 200.00, 0.09, '进口种子', '生长期', 'healthy', NULL, NULL, '0', '0', '0', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-01-22 16:24:52', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-01-22 16:24:52', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-01-22 16:24:52', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'false', 'Y', 'admin', '2026-01-22 16:24:52', 'admin', '2026-01-22 16:38:39', '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2026-01-22 16:24:52', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-01-22 16:24:52', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2026-01-22 16:24:52', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-01-22 16:24:52', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-22 16:24:52', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-22 16:24:52', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-22 16:24:52', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-22 16:24:52', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-22 16:24:52', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-22 16:24:52', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-22 16:24:52', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-22 16:24:52', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-22 16:24:52', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-22 16:24:52', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2026-01-22 16:24:52', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 112 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '1', '验证码已失效', '2026-01-22 16:38:49');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-22 16:39:29');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-01-22 16:45:48');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-22 16:45:50');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-01-22 16:53:14');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-22 16:53:17');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-01-22 17:06:58');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-22 17:07:05');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-01-22 18:27:19');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-22 18:27:19');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-23 18:16:22');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-26 09:46:28');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2227 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2026-01-22 16:24:52', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2026-01-22 16:24:52', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2026-01-22 16:24:52', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '1', '0', '', 'guide', 'admin', '2026-01-22 16:24:52', 'admin', '2026-01-22 17:24:29', '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2026-01-22 16:24:52', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2026-01-22 16:24:52', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2026-01-22 16:24:52', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2026-01-22 16:24:52', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2026-01-22 16:24:52', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2026-01-22 16:24:52', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2026-01-22 16:24:52', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2026-01-22 16:24:52', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2026-01-22 16:24:52', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2026-01-22 16:24:52', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2026-01-22 16:24:52', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2026-01-22 16:24:52', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2026-01-22 16:24:52', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2026-01-22 16:24:52', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2026-01-22 16:24:52', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2026-01-22 16:24:52', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2026-01-22 16:24:52', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2026-01-22 16:24:52', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2026-01-22 16:24:52', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2026-01-22 16:24:52', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '翻译管理', 0, 8, 'translation', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'edit', 'admin', '2026-01-22 16:55:23', 'admin', '2026-01-22 17:04:30', '翻译管理模块');
INSERT INTO `sys_menu` VALUES (2001, '需求翻译', 2000, 1, 'index', 'translation/index', NULL, '', 1, 0, 'C', '0', '0', 'translation:index:view', 'form', 'admin', '2026-01-22 16:55:23', '', NULL, '需求翻译界面');
INSERT INTO `sys_menu` VALUES (2002, '翻译记录', 2000, 2, 'record', 'translation/record/index', NULL, '', 1, 0, 'C', '0', '0', 'translation:record:list', 'list', 'admin', '2026-01-22 16:55:23', '', NULL, '翻译记录管理');
INSERT INTO `sys_menu` VALUES (2003, '语料库管理', 2000, 3, 'corpus', 'translation/corpus/index', NULL, '', 1, 0, 'C', '0', '0', 'translation:corpus:list', 'education', 'admin', '2026-01-22 16:55:23', '', NULL, '语料库管理');
INSERT INTO `sys_menu` VALUES (2004, '翻译记录查询', 2002, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'translation:record:query', '#', 'admin', '2026-01-22 16:55:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2005, '翻译记录详情', 2002, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'translation:record:detail', '#', 'admin', '2026-01-22 16:55:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, '翻译记录删除', 2002, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'translation:record:remove', '#', 'admin', '2026-01-22 16:55:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2007, '翻译记录导出', 2002, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'translation:record:export', '#', 'admin', '2026-01-22 16:55:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2008, '语料库查询', 2003, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'translation:corpus:query', '#', 'admin', '2026-01-22 16:55:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2009, '语料库新增', 2003, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'translation:corpus:add', '#', 'admin', '2026-01-22 16:55:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '语料库修改', 2003, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'translation:corpus:edit', '#', 'admin', '2026-01-22 16:55:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '语料库删除', 2003, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'translation:corpus:remove', '#', 'admin', '2026-01-22 16:55:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2012, '语料库导出', 2003, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'translation:corpus:export', '#', 'admin', '2026-01-22 16:55:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2027, '地块信息查询', 2026, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:query', '#', 'admin', '2026-01-22 17:36:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2028, '地块信息新增', 2026, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:add', '#', 'admin', '2026-01-22 17:36:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2029, '地块信息修改', 2026, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:edit', '#', 'admin', '2026-01-22 17:36:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2030, '地块信息删除', 2026, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:remove', '#', 'admin', '2026-01-22 17:36:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2031, '地块信息导出', 2026, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:export', '#', 'admin', '2026-01-22 17:36:20', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2038, '种植管理', 2013, 5, 'planting', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'el-icon-s-grid', 'admin', '2026-01-22 17:36:20', '', NULL, '种植管理');
INSERT INTO `sys_menu` VALUES (2046, '种植管理', 2038, 3, 'farming', 'agriculture/farming/index', NULL, '', 1, 0, 'C', '0', '0', 'agriculture:farming:list', 'el-icon-setting', 'admin', '2026-01-22 17:36:20', '', NULL, '种植管理（施肥喷药）');
INSERT INTO `sys_menu` VALUES (2061, '地块信息查询', 2026, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:query', '#', 'admin', '2026-01-22 17:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2062, '地块信息新增', 2026, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:add', '#', 'admin', '2026-01-22 17:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2063, '地块信息修改', 2026, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:edit', '#', 'admin', '2026-01-22 17:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2064, '地块信息删除', 2026, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:remove', '#', 'admin', '2026-01-22 17:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2065, '地块信息导出', 2026, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:export', '#', 'admin', '2026-01-22 17:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2072, '种植管理', 2013, 5, 'planting', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'el-icon-s-grid', 'admin', '2026-01-22 17:37:25', '', NULL, '种植管理');
INSERT INTO `sys_menu` VALUES (2080, '种植管理', 2038, 3, 'farming', 'agriculture/farming/index', NULL, '', 1, 0, 'C', '0', '0', 'agriculture:farming:list', 'el-icon-setting', 'admin', '2026-01-22 17:37:25', '', NULL, '种植管理（施肥喷药）');
INSERT INTO `sys_menu` VALUES (2081, '种植管理查询', 2038, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:query', '#', 'admin', '2026-01-22 17:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2082, '种植管理新增', 2038, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:add', '#', 'admin', '2026-01-22 17:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2083, '种植管理修改', 2038, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:edit', '#', 'admin', '2026-01-22 17:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2084, '种植管理删除', 2038, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:remove', '#', 'admin', '2026-01-22 17:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2085, '种植管理导出', 2038, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:export', '#', 'admin', '2026-01-22 17:37:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2106, '地块信息查询', 2105, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:query', '#', 'admin', '2026-01-22 17:40:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2107, '地块信息新增', 2105, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:add', '#', 'admin', '2026-01-22 17:40:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2108, '地块信息修改', 2105, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:edit', '#', 'admin', '2026-01-22 17:40:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2109, '地块信息删除', 2105, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:remove', '#', 'admin', '2026-01-22 17:40:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2110, '地块信息导出', 2105, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:export', '#', 'admin', '2026-01-22 17:40:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2117, '种植管理', 2092, 5, 'planting', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'el-icon-s-grid', 'admin', '2026-01-22 17:40:54', '', NULL, '种植管理');
INSERT INTO `sys_menu` VALUES (2151, '地块信息查询', 2105, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:query', '#', 'admin', '2026-01-22 18:41:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2152, '地块信息新增', 2105, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:add', '#', 'admin', '2026-01-22 18:41:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2153, '地块信息修改', 2105, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:edit', '#', 'admin', '2026-01-22 18:41:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2154, '地块信息删除', 2105, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:remove', '#', 'admin', '2026-01-22 18:41:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2155, '地块信息导出', 2105, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:export', '#', 'admin', '2026-01-22 18:41:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2162, '种植管理', 2092, 5, 'planting', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'el-icon-s-grid', 'admin', '2026-01-22 18:41:45', '', NULL, '种植管理');
INSERT INTO `sys_menu` VALUES (2170, '种植管理', 2117, 3, 'farming', 'agriculture/farming/index', NULL, '', 1, 0, 'C', '0', '0', 'agriculture:farming:list', 'el-icon-setting', 'admin', '2026-01-22 18:41:45', '', NULL, '种植管理（施肥喷药）');
INSERT INTO `sys_menu` VALUES (2171, '种植管理查询', 2117, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:query', '#', 'admin', '2026-01-22 18:41:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2172, '种植管理新增', 2117, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:add', '#', 'admin', '2026-01-22 18:41:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2173, '种植管理修改', 2117, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:edit', '#', 'admin', '2026-01-22 18:41:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2174, '种植管理删除', 2117, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:remove', '#', 'admin', '2026-01-22 18:41:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2175, '种植管理导出', 2117, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:export', '#', 'admin', '2026-01-22 18:41:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2182, '农业管理', 0, 1, 'agriculture', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'el-icon-s-opportunity', 'admin', '2026-01-22 18:42:13', '', NULL, '农业管理系统');
INSERT INTO `sys_menu` VALUES (2183, '天气信息', 2182, 1, 'weather', 'agriculture/weather/index', NULL, '', 1, 0, 'C', '0', '0', 'agriculture:weather:list', 'el-icon-sunny', 'admin', '2026-01-22 18:42:13', '', NULL, '天气信息管理');
INSERT INTO `sys_menu` VALUES (2184, '天气信息查询', 2183, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:weather:query', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2185, '天气信息新增', 2183, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:weather:add', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2186, '天气信息修改', 2183, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:weather:edit', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2187, '天气信息删除', 2183, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:weather:remove', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2188, '天气信息导出', 2183, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:weather:export', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2189, '土壤信息', 2182, 2, 'soil', 'agriculture/soil/index', NULL, '', 1, 0, 'C', '0', '0', 'agriculture:soil:list', 'el-icon-connection', 'admin', '2026-01-22 18:42:13', '', NULL, '土壤信息管理');
INSERT INTO `sys_menu` VALUES (2190, '土壤信息查询', 2189, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:soil:query', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2191, '土壤信息新增', 2189, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:soil:add', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2192, '土壤信息修改', 2189, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:soil:edit', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2193, '土壤信息删除', 2189, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:soil:remove', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2194, '土壤信息导出', 2189, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:soil:export', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2195, '地块管理', 2182, 3, 'land', 'agriculture/land/index', NULL, '', 1, 0, 'C', '0', '0', 'agriculture:land:list', 'el-icon-location', 'admin', '2026-01-22 18:42:13', '', NULL, '地块信息管理');
INSERT INTO `sys_menu` VALUES (2196, '地块信息查询', 2195, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:query', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2197, '地块信息新增', 2195, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:add', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2198, '地块信息修改', 2195, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:edit', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2199, '地块信息删除', 2195, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:remove', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2200, '地块信息导出', 2195, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:land:export', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2201, '作物种类', 2182, 4, 'crop', 'agriculture/crop/index', NULL, '', 1, 0, 'C', '0', '0', 'agriculture:crop:list', 'el-icon-vegetables', 'admin', '2026-01-22 18:42:13', '', NULL, '作物种类管理');
INSERT INTO `sys_menu` VALUES (2202, '作物种类查询', 2201, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:crop:query', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2203, '作物种类新增', 2201, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:crop:add', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2204, '作物种类修改', 2201, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:crop:edit', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2205, '作物种类删除', 2201, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:crop:remove', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2206, '作物种类导出', 2201, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:crop:export', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2207, '种植管理', 2182, 5, 'planting', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'el-icon-s-grid', 'admin', '2026-01-22 18:42:13', '', NULL, '种植管理');
INSERT INTO `sys_menu` VALUES (2208, '种植记录', 2207, 1, 'record', 'agriculture/planting/index', NULL, '', 1, 0, 'C', '0', '0', 'agriculture:planting:list', 'el-icon-document', 'admin', '2026-01-22 18:42:13', '', NULL, '种植记录管理');
INSERT INTO `sys_menu` VALUES (2209, '种植记录查询', 2208, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:planting:query', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2210, '种植记录新增', 2208, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:planting:add', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2211, '种植记录修改', 2208, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:planting:edit', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2212, '种植记录删除', 2208, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:planting:remove', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2213, '种植记录导出', 2208, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:planting:export', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2214, '种植操作', 2207, 2, 'operate', 'agriculture/planting/operate', NULL, '', 1, 0, 'C', '0', '0', 'agriculture:planting:operate', 'el-icon-plus', 'admin', '2026-01-22 18:42:13', '', NULL, '种植操作');
INSERT INTO `sys_menu` VALUES (2215, '农事管理', 2207, 3, 'farming', 'agriculture/farming/index', NULL, '', 1, 0, 'C', '0', '0', 'agriculture:farming:list', 'el-icon-setting', 'admin', '2026-01-22 18:42:13', '', NULL, '种植管理（施肥喷药）');
INSERT INTO `sys_menu` VALUES (2216, '农事管理查询', 2215, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:query', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2217, '农事管理新增', 2215, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:add', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2218, '农事管理修改', 2215, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:edit', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2219, '农事管理删除', 2215, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:remove', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2220, '农事管理导出', 2215, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:farming:export', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2221, '采摘管理', 2182, 6, 'harvest', 'agriculture/harvest/index', NULL, '', 1, 0, 'C', '0', '0', 'agriculture:harvest:list', 'el-icon-s-finance', 'admin', '2026-01-22 18:42:13', '', NULL, '采摘管理');
INSERT INTO `sys_menu` VALUES (2222, '采摘管理查询', 2221, 1, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:harvest:query', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2223, '采摘管理新增', 2221, 2, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:harvest:add', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2224, '采摘管理修改', 2221, 3, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:harvest:edit', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2225, '采摘管理删除', 2221, 4, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:harvest:remove', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2226, '采摘管理导出', 2221, 5, '', '', NULL, '', 1, 0, 'F', '0', '0', 'agriculture:harvest:export', '#', 'admin', '2026-01-22 18:42:13', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2026-01-22 16:24:52', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2026-01-22 16:24:52', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 168 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-01-22 16:55:23\",\"icon\":\"edit\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"翻译管理\",\"menuType\":\"M\",\"orderNum\":8,\"params\":{},\"parentId\":0,\"path\":\"translation\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 17:04:30', 16);
INSERT INTO `sys_oper_log` VALUES (101, '语料库', 2, 'com.ruoyi.web.controller.system.TranslationController.editCorpus()', 'PUT', 1, 'admin', '研发部门', '/system/translation/corpus', '127.0.0.1', '内网IP', '{\"accuracyScore\":0.98,\"corpusId\":1,\"createBy\":\"admin\",\"createTime\":\"2026-01-22 16:55:37\",\"delFlag\":\"0\",\"domainType\":\"general\",\"params\":{},\"sourceLanguage\":\"en\",\"sourceText\":\"Hello World\",\"status\":\"0\",\"targetLanguage\":\"zh\",\"targetText\":\"你好世界\",\"updateBy\":\"\",\"usageCount\":1} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 17:22:56', 11);
INSERT INTO `sys_oper_log` VALUES (102, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-01-22 16:24:52\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 17:24:29', 16);
INSERT INTO `sys_oper_log` VALUES (103, '地块信息', 3, 'com.ruoyi.web.controller.agriculture.LandInfoController.remove()', 'DELETE', 1, 'admin', '研发部门', '/agriculture/land/3', '127.0.0.1', '内网IP', '[3] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 18:56:59', 11);
INSERT INTO `sys_oper_log` VALUES (104, '地块信息', 3, 'com.ruoyi.web.controller.agriculture.LandInfoController.remove()', 'DELETE', 1, 'admin', '研发部门', '/agriculture/land/100', '127.0.0.1', '内网IP', '[100] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 19:02:34', 9);
INSERT INTO `sys_oper_log` VALUES (105, '地块信息', 1, 'com.ruoyi.web.controller.agriculture.LandInfoController.add()', 'POST', 1, 'admin', '研发部门', '/agriculture/land', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-01-22 19:04:59\",\"drainageCondition\":\"良好\",\"landCode\":\"1\",\"landId\":101,\"landName\":\"1\",\"location\":\"1\",\"params\":{},\"soilPh\":1.0,\"soilType\":\"沙壤土\",\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 19:04:59', 20);
INSERT INTO `sys_oper_log` VALUES (106, '地块信息', 3, 'com.ruoyi.web.controller.agriculture.LandInfoController.remove()', 'DELETE', 1, 'admin', '研发部门', '/agriculture/land/101', '127.0.0.1', '内网IP', '[101] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 19:05:01', 6);
INSERT INTO `sys_oper_log` VALUES (107, '地块信息', 2, 'com.ruoyi.web.controller.agriculture.LandInfoController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/land', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-01-22 19:01:48\",\"drainageCondition\":\"一般\",\"irrigationMethod\":\"喷灌\",\"landArea\":24.5,\"landCode\":\"LAND049\",\"landId\":99,\"landName\":\"北区四十九号地块\",\"location\":\"农场北区中央\",\"nitrogenContent\":119.7,\"organicMatter\":2.8,\"params\":{},\"phosphorusContent\":45.7,\"potassiumContent\":98.4,\"soilPh\":6.6,\"soilType\":\"粉砂黏土\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-22 19:05:22\"} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'land_area\' in \'field list\'\r\n### The error may exist in file [D:\\云盘\\OneDrive\\桌面\\demo\\RuoYi-Vue-master\\ruoyi-system\\target\\classes\\mapper\\agriculture\\LandInfoMapper.xml]\r\n### The error may involve com.ruoyi.agriculture.mapper.LandInfoMapper.updateLandInfo-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update land_info          SET land_name = ?,             land_code = ?,             land_area = ?,             location = ?,             soil_type = ?,             soil_ph = ?,             organic_matter = ?,             nitrogen_content = ?,             phosphorus_content = ?,             potassium_content = ?,             irrigation_method = ?,             drainage_condition = ?,             status = ?,                                                    create_by = ?,             create_time = ?,                          update_time = ?          where land_id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'land_area\' in \'field list\'\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column \'land_area\' in \'field list\'', '2026-01-22 19:05:22', 81);
INSERT INTO `sys_oper_log` VALUES (108, '地块信息', 2, 'com.ruoyi.web.controller.agriculture.LandInfoController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/land', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-01-22 19:01:48\",\"drainageCondition\":\"一般\",\"irrigationMethod\":\"喷灌\",\"landArea\":24.5,\"landCode\":\"LAND049\",\"landId\":99,\"landName\":\"北区四十九号地块\",\"location\":\"农场北区中央\",\"nitrogenContent\":119.7,\"organicMatter\":2.8,\"params\":{},\"phosphorusContent\":45.8,\"potassiumContent\":98.4,\"soilPh\":6.6,\"soilType\":\"粉砂黏土\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-22 19:09:45\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 19:09:45', 26);
INSERT INTO `sys_oper_log` VALUES (109, '地块信息', 3, 'com.ruoyi.web.controller.agriculture.LandInfoController.remove()', 'DELETE', 1, 'admin', '研发部门', '/agriculture/land/99', '127.0.0.1', '内网IP', '[99] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 19:09:50', 18);
INSERT INTO `sys_oper_log` VALUES (110, '种植记录', 1, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.add()', 'POST', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-01-22 19:15:18\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"播种期\",\"healthStatus\":\"healthy\",\"landId\":98,\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":4500,\"plantingId\":1,\"remark\":\"\",\"seedSource\":\"\",\"speciesId\":3} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 19:15:18', 37);
INSERT INTO `sys_oper_log` VALUES (111, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-01-22 19:15:18\",\"diseaseInfo\":\"yachong\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"播种期\",\"healthStatus\":\"pest\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":4500,\"plantingId\":1,\"speciesId\":3,\"speciesName\":\"玉米\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-22 19:15:52\"} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'land_name\' in \'field list\'\r\n### The error may exist in file [D:\\云盘\\OneDrive\\桌面\\demo\\RuoYi-Vue-master\\ruoyi-system\\target\\classes\\mapper\\agriculture\\PlantingRecordMapper.xml]\r\n### The error may involve com.ruoyi.agriculture.mapper.PlantingRecordMapper.updatePlantingRecord-Inline\r\n### The error occurred while setting parameters\r\n### SQL: update planting_record          SET land_id = ?,             land_name = ?,             species_id = ?,             species_name = ?,             planting_area = ?,                          planting_date = ?,             expected_harvest_date = ?,                          growth_stage = ?,             health_status = ?,             maturity = ?,             disease_info = ?,                                       planting_density = ?,                                                    status = ?,                                       create_time = ?,                          update_time = ?          where planting_id = ?\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'land_name\' in \'field list\'\n; bad SQL grammar []; nested exception is java.sql.SQLSyntaxErrorException: Unknown column \'land_name\' in \'field list\'', '2026-01-22 19:15:52', 59);
INSERT INTO `sys_oper_log` VALUES (112, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-01-22 19:15:18\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"播种期\",\"healthStatus\":\"subhealthy\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":4500,\"plantingId\":1,\"speciesId\":3,\"speciesName\":\"玉米\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-22 19:19:06\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 19:19:06', 27);
INSERT INTO `sys_oper_log` VALUES (113, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-01-22 19:15:18\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"播种期\",\"healthStatus\":\"pest\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":4500,\"plantingId\":1,\"speciesId\":3,\"speciesName\":\"玉米\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-22 19:19:46\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 19:19:46', 12);
INSERT INTO `sys_oper_log` VALUES (114, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-01-22 19:15:18\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"播种期\",\"healthStatus\":\"disease\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":4500,\"plantingId\":1,\"speciesId\":3,\"speciesName\":\"玉米\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-22 19:26:39\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 19:26:39', 163);
INSERT INTO `sys_oper_log` VALUES (115, '种植记录', 1, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.add()', 'POST', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-01-22 19:58:15\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"播种期\",\"healthStatus\":\"healthy\",\"landId\":97,\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":3500,\"plantingId\":2,\"remark\":\"\",\"seedSource\":\"\",\"speciesId\":2} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 19:58:15', 143);
INSERT INTO `sys_oper_log` VALUES (116, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-01-22 19:58:15\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"播种期\",\"healthStatus\":\"pest\",\"landId\":97,\"landName\":\"西区四十七号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":3500,\"plantingId\":2,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-22 19:58:25\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 19:58:25', 27);
INSERT INTO `sys_oper_log` VALUES (117, '农事待办', 2, 'com.ruoyi.web.controller.agriculture.FarmingTaskController.markDone()', 'PUT', 1, 'admin', '研发部门', '/agriculture/task/done/1', '127.0.0.1', '内网IP', '1 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 19:58:36', 20);
INSERT INTO `sys_oper_log` VALUES (118, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-01-22 19:58:15\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"成熟期\",\"healthStatus\":\"pest\",\"landId\":97,\"landName\":\"西区四十七号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":3500,\"plantingId\":2,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-22 20:00:33\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:00:33', 11);
INSERT INTO `sys_oper_log` VALUES (119, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-01-22 19:58:15\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"幼苗期\",\"healthStatus\":\"pest\",\"landId\":97,\"landName\":\"西区四十七号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":3500,\"plantingId\":2,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-22 20:00:42\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:00:42', 17);
INSERT INTO `sys_oper_log` VALUES (120, '农事待办', 2, 'com.ruoyi.web.controller.agriculture.FarmingTaskController.markDone()', 'PUT', 1, 'admin', '研发部门', '/agriculture/task/done/2', '127.0.0.1', '内网IP', '2 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:01:10', 12);
INSERT INTO `sys_oper_log` VALUES (121, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-01-22 19:58:15\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"幼苗期\",\"healthStatus\":\"subhealthy\",\"landId\":97,\"landName\":\"西区四十七号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":3500,\"plantingId\":2,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-22 20:05:09\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:05:09', 48);
INSERT INTO `sys_oper_log` VALUES (122, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-01-22 19:58:15\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"幼苗期\",\"healthStatus\":\"serious\",\"landId\":97,\"landName\":\"西区四十七号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":3500,\"plantingId\":2,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-22 20:05:23\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:05:23', 46);
INSERT INTO `sys_oper_log` VALUES (123, '农事待办', 2, 'com.ruoyi.web.controller.agriculture.FarmingTaskController.markDone()', 'PUT', 1, 'admin', '研发部门', '/agriculture/task/done/3', '127.0.0.1', '内网IP', '3 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:05:51', 20);
INSERT INTO `sys_oper_log` VALUES (124, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-01-22 19:58:15\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"幼苗期\",\"healthStatus\":\"healthy\",\"landId\":97,\"landName\":\"西区四十七号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":3500,\"plantingId\":2,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-22 20:06:23\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:06:23', 18);
INSERT INTO `sys_oper_log` VALUES (125, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-01-22 19:58:15\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"幼苗期\",\"healthStatus\":\"healthy\",\"landId\":97,\"landName\":\"西区四十七号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":3500,\"plantingId\":2,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-22 20:06:32\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:06:32', 53);
INSERT INTO `sys_oper_log` VALUES (126, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"createBy\":\"\",\"createTime\":\"2026-01-22 19:58:15\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"幼苗期\",\"healthStatus\":\"healthy\",\"landId\":97,\"landName\":\"西区四十七号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":3600,\"plantingId\":2,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-22 20:06:50\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:06:50', 19);
INSERT INTO `sys_oper_log` VALUES (127, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"canHarvest\":\"0\",\"createBy\":\"\",\"createTime\":\"2026-01-22 19:58:15\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"成熟期\",\"healthStatus\":\"healthy\",\"isMature\":\"0\",\"landId\":97,\"landName\":\"西区四十七号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":3600,\"plantingId\":2,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-22 20:19:23\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:19:23', 48);
INSERT INTO `sys_oper_log` VALUES (128, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"canHarvest\":\"0\",\"createBy\":\"\",\"createTime\":\"2026-01-22 19:15:18\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"播种期\",\"healthStatus\":\"healthy\",\"isMature\":\"0\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":4500,\"plantingId\":1,\"speciesId\":3,\"speciesName\":\"玉米\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-22 20:19:29\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:19:29', 15);
INSERT INTO `sys_oper_log` VALUES (129, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"canHarvest\":\"0\",\"createBy\":\"\",\"createTime\":\"2026-01-22 19:58:15\",\"expectedHarvestDate\":\"2026-01-22\",\"growthStage\":\"成熟期\",\"healthStatus\":\"healthy\",\"isMature\":\"0\",\"landId\":97,\"landName\":\"西区四十七号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":3600,\"plantingId\":2,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-22 20:19:53\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:19:53', 14);
INSERT INTO `sys_oper_log` VALUES (130, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"canHarvest\":\"0\",\"createBy\":\"\",\"createTime\":\"2026-01-22 19:58:15\",\"expectedHarvestDate\":\"2026-01-22\",\"growthStage\":\"成熟期\",\"healthStatus\":\"healthy\",\"isMature\":\"0\",\"landId\":97,\"landName\":\"西区四十七号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":3600,\"plantingId\":2,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-22 20:20:04\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:20:04', 18);
INSERT INTO `sys_oper_log` VALUES (131, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"canHarvest\":\"1\",\"createBy\":\"\",\"createTime\":\"2026-01-22 19:58:15\",\"expectedHarvestDate\":\"2026-01-22\",\"growthStage\":\"成熟期\",\"healthStatus\":\"healthy\",\"isMature\":\"1\",\"landId\":97,\"landName\":\"西区四十七号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":3600,\"plantingId\":2,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-22 20:22:32\"} ', NULL, 1, '\r\n### Error querying database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'planting_id\' in where clause is ambiguous\r\n### The error may exist in file [D:\\云盘\\OneDrive\\桌面\\demo\\RuoYi-Vue-master\\ruoyi-system\\target\\classes\\mapper\\agriculture\\HarvestRecordMapper.xml]\r\n### The error may involve com.ruoyi.agriculture.mapper.HarvestRecordMapper.selectHarvestRecordList-Inline\r\n### The error occurred while setting parameters\r\n### SQL: select h.harvest_id, h.planting_id, l.land_name, s.species_name, h.harvest_date,                 h.harvest_area, h.harvest_quantity, h.quality_grade, h.unit_price, h.total_price,                 h.harvest_method, h.operator, h.storage_location, h.storage_conditions,                 h.buyer, h.transport_method, h.create_by, h.create_time, h.update_by,                 h.update_time, h.notes         from harvest_record h         left join planting_record p on h.planting_id = p.planting_id         left join land_info l on p.land_id = l.land_id         left join crop_species s on p.species_id = s.species_id                WHERE  planting_id = ?          order by harvest_date desc\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'planting_id\' in where clause is ambiguous\n; Column \'planting_id\' in where clause is ambiguous; nested exception is java.sql.SQLIntegrityConstraintViolationException: Column \'planting_id\' in where clause is ambiguous', '2026-01-22 20:22:32', 70);
INSERT INTO `sys_oper_log` VALUES (132, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"canHarvest\":\"1\",\"createBy\":\"\",\"createTime\":\"2026-01-22 19:58:15\",\"expectedHarvestDate\":\"2026-01-22\",\"growthStage\":\"成熟期\",\"healthStatus\":\"healthy\",\"isMature\":\"1\",\"landId\":97,\"landName\":\"西区四十七号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":3600,\"plantingId\":2,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-22 20:24:48\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:24:48', 181);
INSERT INTO `sys_oper_log` VALUES (133, '采摘记录', 1, 'com.ruoyi.web.controller.agriculture.HarvestRecordController.add()', 'POST', 1, 'admin', '研发部门', '/agriculture/harvest', '127.0.0.1', '内网IP', '{\"harvestArea\":0.2,\"harvestDate\":\"2026-01-22 20:39:54\",\"harvestMethod\":\"人工采摘\",\"harvestQuantity\":0.1,\"notes\":\"\",\"operator\":\"ss\",\"params\":{},\"plantingId\":2,\"qualityGrade\":\"特等\",\"totalPrice\":0.0,\"unitPrice\":0.01} ', NULL, 1, '该种植记录已存在采摘记录，不能重复采摘', '2026-01-22 20:40:02', 24);
INSERT INTO `sys_oper_log` VALUES (134, '采摘记录', 3, 'com.ruoyi.web.controller.agriculture.HarvestRecordController.remove()', 'DELETE', 1, 'admin', '研发部门', '/agriculture/harvest/1', '127.0.0.1', '内网IP', '[1] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:40:06', 20);
INSERT INTO `sys_oper_log` VALUES (135, '采摘记录', 1, 'com.ruoyi.web.controller.agriculture.HarvestRecordController.add()', 'POST', 1, 'admin', '研发部门', '/agriculture/harvest', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-01-22 20:40:15\",\"harvestArea\":0.3,\"harvestDate\":\"2026-01-22 20:40:07\",\"harvestId\":2,\"harvestMethod\":\"人工采摘\",\"harvestQuantity\":0.2,\"notes\":\"\",\"operator\":\"ss\",\"params\":{},\"plantingId\":2,\"qualityGrade\":\"特等\",\"totalPrice\":0.0,\"unitPrice\":0.02} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:40:15', 40);
INSERT INTO `sys_oper_log` VALUES (136, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"canHarvest\":\"1\",\"createBy\":\"\",\"createTime\":\"2026-01-22 19:15:18\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"成熟期\",\"healthStatus\":\"healthy\",\"isMature\":\"1\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.1,\"plantingDate\":\"2026-01-22\",\"plantingDensity\":4500,\"plantingId\":1,\"speciesId\":3,\"speciesName\":\"玉米\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-22 20:43:12\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:43:12', 43);
INSERT INTO `sys_oper_log` VALUES (137, '采摘记录', 1, 'com.ruoyi.web.controller.agriculture.HarvestRecordController.add()', 'POST', 1, 'admin', '研发部门', '/agriculture/harvest', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-01-22 20:43:28\",\"harvestArea\":0.3,\"harvestDate\":\"2026-01-22 20:43:18\",\"harvestId\":3,\"harvestMethod\":\"人工采摘\",\"harvestQuantity\":0.2,\"notes\":\"\",\"operator\":\"aa\",\"params\":{},\"plantingId\":1,\"qualityGrade\":\"特等\",\"totalPrice\":0.0,\"unitPrice\":0.02} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-22 20:43:28', 37);
INSERT INTO `sys_oper_log` VALUES (138, '种植记录', 1, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.add()', 'POST', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"canHarvest\":\"0\",\"createTime\":\"2026-01-23 18:16:59\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"播种期\",\"healthStatus\":\"healthy\",\"isMature\":\"0\",\"landId\":98,\"params\":{},\"plantingArea\":0.5,\"plantingDate\":\"2026-01-23\",\"plantingDensity\":3500,\"plantingId\":3,\"remark\":\"\",\"seedSource\":\"\",\"speciesId\":2} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 18:16:59', 42);
INSERT INTO `sys_oper_log` VALUES (139, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"canHarvest\":\"0\",\"createBy\":\"\",\"createTime\":\"2026-01-23 18:17:00\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"播种期\",\"healthStatus\":\"serious\",\"isMature\":\"0\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.5,\"plantingDate\":\"2026-01-23\",\"plantingDensity\":3500,\"plantingId\":3,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-23 18:17:22\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 18:17:22', 37);
INSERT INTO `sys_oper_log` VALUES (140, '农事待办', 2, 'com.ruoyi.web.controller.agriculture.FarmingTaskController.markDone()', 'PUT', 1, 'admin', '研发部门', '/agriculture/task/done/4', '127.0.0.1', '内网IP', '4 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 18:17:53', 20);
INSERT INTO `sys_oper_log` VALUES (141, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"canHarvest\":\"1\",\"createBy\":\"\",\"createTime\":\"2026-01-23 18:17:00\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"成熟期\",\"healthStatus\":\"healthy\",\"isMature\":\"1\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"maturity\":\"0\",\"params\":{},\"plantingArea\":0.5,\"plantingDate\":\"2026-01-23\",\"plantingDensity\":3500,\"plantingId\":3,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-23 18:18:16\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 18:18:16', 9);
INSERT INTO `sys_oper_log` VALUES (142, '采摘记录', 1, 'com.ruoyi.web.controller.agriculture.HarvestRecordController.add()', 'POST', 1, 'admin', '研发部门', '/agriculture/harvest', '127.0.0.1', '内网IP', '{\"createTime\":\"2026-01-23 18:18:47\",\"harvestArea\":0.7,\"harvestDate\":\"2026-01-23 18:18:38\",\"harvestId\":4,\"harvestQuantity\":0.3,\"notes\":\"\",\"operator\":\"的撒旦\",\"params\":{},\"plantingId\":3,\"qualityGrade\":\"特等\",\"totalPrice\":0.01,\"unitPrice\":0.02} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 18:18:47', 22);
INSERT INTO `sys_oper_log` VALUES (143, '天气信息', 2, 'com.ruoyi.web.controller.agriculture.WeatherInfoController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/weather', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-01-22 19:00:14\",\"dataSource\":\"SENSOR005\",\"humidity\":74.8,\"lightIntensity\":48000.0,\"location\":\"中区五号地块\",\"params\":{},\"pressure\":1014.9,\"rainfall\":0.8,\"recordTime\":\"2024-01-16 08:30:00\",\"soilHumidity\":77.9,\"soilTemperature\":23.8,\"temperature\":26.5,\"updateBy\":\"\",\"updateTime\":\"2026-01-26 09:57:06\",\"weatherId\":50,\"windDirection\":\"西风\",\"windSpeed\":2.7} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 09:57:06', 15);
INSERT INTO `sys_oper_log` VALUES (144, '天气信息', 2, 'com.ruoyi.web.controller.agriculture.WeatherInfoController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/weather', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-01-22 19:00:14\",\"dataSource\":\"SENSOR005\",\"humidity\":74.8,\"lightIntensity\":48000.0,\"location\":\"中区五号地块\",\"params\":{},\"pressure\":1014.9,\"rainfall\":0.8,\"recordTime\":\"2024-01-16 08:30:00\",\"soilHumidity\":77.9,\"soilTemperature\":23.8,\"temperature\":26.6,\"updateBy\":\"\",\"updateTime\":\"2026-01-26 09:59:02\",\"weatherId\":50,\"windDirection\":\"西风\",\"windSpeed\":2.7} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 09:59:02', 11);
INSERT INTO `sys_oper_log` VALUES (145, '地块信息', 2, 'com.ruoyi.web.controller.agriculture.LandInfoController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/land', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-01-22 19:01:48\",\"drainageCondition\":\"良好\",\"irrigationMethod\":\"沟灌\",\"landArea\":17.6,\"landCode\":\"LAND048\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"location\":\"农场南区中央\",\"nitrogenContent\":145.3,\"organicMatter\":5.1,\"params\":{},\"phosphorusContent\":58.9,\"potassiumContent\":124.6,\"soilPh\":5.8,\"soilType\":\"砂质黏土\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-26 10:12:13\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 10:12:13', 10);
INSERT INTO `sys_oper_log` VALUES (146, '地块信息', 2, 'com.ruoyi.web.controller.agriculture.LandInfoController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/land', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-01-22 19:01:48\",\"drainageCondition\":\"良好\",\"irrigationMethod\":\"沟灌\",\"landArea\":18.6,\"landCode\":\"LAND048\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"location\":\"农场南区中央\",\"nitrogenContent\":145.3,\"organicMatter\":5.1,\"params\":{},\"phosphorusContent\":58.9,\"potassiumContent\":124.6,\"soilPh\":5.8,\"soilType\":\"砂质黏土\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-26 10:14:56\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 10:14:56', 5);
INSERT INTO `sys_oper_log` VALUES (147, '地块信息', 2, 'com.ruoyi.web.controller.agriculture.LandInfoController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/land', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-01-22 19:01:48\",\"drainageCondition\":\"良好\",\"irrigationMethod\":\"沟灌\",\"landArea\":18.6,\"landCode\":\"LAND048\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"location\":\"农场南区中央\",\"nitrogenContent\":145.3,\"organicMatter\":6.1,\"params\":{},\"phosphorusContent\":58.9,\"potassiumContent\":124.6,\"soilPh\":5.8,\"soilType\":\"砂质黏土\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-26 10:14:59\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 10:14:59', 9);
INSERT INTO `sys_oper_log` VALUES (148, '地块信息', 2, 'com.ruoyi.web.controller.agriculture.LandInfoController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/land', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-01-22 19:01:48\",\"drainageCondition\":\"良好\",\"irrigationMethod\":\"沟灌\",\"landArea\":18.6,\"landCode\":\"LAND048\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"location\":\"农场南区中央\",\"nitrogenContent\":145.3,\"organicMatter\":6.1,\"params\":{},\"phosphorusContent\":58.9,\"potassiumContent\":124.6,\"soilPh\":6.8,\"soilType\":\"砂质黏土\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-26 10:15:03\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 10:15:03', 6);
INSERT INTO `sys_oper_log` VALUES (149, '地块信息', 2, 'com.ruoyi.web.controller.agriculture.LandInfoController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/land', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-01-22 19:01:48\",\"drainageCondition\":\"良好\",\"irrigationMethod\":\"沟灌\",\"landArea\":18.6,\"landCode\":\"LAND048\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"location\":\"农场南区中央\",\"nitrogenContent\":145.3,\"organicMatter\":6.1,\"params\":{},\"phosphorusContent\":59.9,\"potassiumContent\":124.6,\"soilPh\":6.8,\"soilType\":\"砂质黏土\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-26 10:15:07\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 10:15:07', 16);
INSERT INTO `sys_oper_log` VALUES (150, '地块信息', 2, 'com.ruoyi.web.controller.agriculture.LandInfoController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/land', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"createTime\":\"2026-01-22 19:01:48\",\"drainageCondition\":\"良好\",\"irrigationMethod\":\"喷灌\",\"landArea\":18.6,\"landCode\":\"LAND048\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"location\":\"农场南区中央\",\"nitrogenContent\":145.3,\"organicMatter\":6.1,\"params\":{},\"phosphorusContent\":59.9,\"potassiumContent\":124.6,\"soilPh\":6.8,\"soilType\":\"砂质黏土\",\"status\":\"0\",\"updateBy\":\"\",\"updateTime\":\"2026-01-26 10:15:27\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 10:15:27', 10);
INSERT INTO `sys_oper_log` VALUES (151, '作物种类', 3, 'com.ruoyi.web.controller.agriculture.CropSpeciesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/agriculture/crop/3', '127.0.0.1', '内网IP', '[3] ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)\r\n### The error may exist in file [D:\\云盘\\OneDrive\\桌面\\demo\\RuoYi-Vue-master\\ruoyi-system\\target\\classes\\mapper\\agriculture\\CropSpeciesMapper.xml]\r\n### The error may involve com.ruoyi.agriculture.mapper.CropSpeciesMapper.deleteCropSpeciesBySpeciesIds-Inline\r\n### The error occurred while setting parameters\r\n### SQL: delete from crop_species where species_id in           (               ?          )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)\n; Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT); nested exception is java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)', '2026-01-26 10:18:11', 107);
INSERT INTO `sys_oper_log` VALUES (152, '作物种类', 2, 'com.ruoyi.web.controller.agriculture.CropSpeciesController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/crop', '127.0.0.1', '内网IP', '{\"category\":\"蔬菜\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 17:20:28\",\"diseaseResistance\":\"0\",\"estimatedYield\":4000.0,\"fertilizerRequirement\":\"有机肥+复合肥\",\"growthCycle\":90,\"lightRequirement\":\"充足\",\"params\":{},\"plantingDensity\":3600.0,\"scientificName\":\"Cucumis sativus\",\"soilRequirement\":\"富含有机质\",\"speciesCode\":\"CROP002\",\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"suitableHumidityMax\":85.0,\"suitableHumidityMin\":70.0,\"suitableTempMax\":30.0,\"suitableTempMin\":20.0,\"updateBy\":\"\",\"updateTime\":\"2026-01-26 10:21:54\",\"waterRequirement\":\"较高\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 10:21:54', 10);
INSERT INTO `sys_oper_log` VALUES (153, '作物种类', 2, 'com.ruoyi.web.controller.agriculture.CropSpeciesController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/crop', '127.0.0.1', '内网IP', '{\"category\":\"粮食\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 17:20:28\",\"diseaseResistance\":\"3\",\"estimatedYield\":600.0,\"fertilizerRequirement\":\"氮肥为主\",\"growthCycle\":150,\"lightRequirement\":\"充足\",\"params\":{},\"plantingDensity\":4500.0,\"scientificName\":\"Zea mays\",\"soilRequirement\":\"排水良好\",\"speciesCode\":\"CROP003\",\"speciesId\":3,\"speciesName\":\"玉米\",\"status\":\"0\",\"suitableHumidityMax\":75.0,\"suitableHumidityMin\":55.0,\"suitableTempMax\":30.0,\"suitableTempMin\":15.0,\"updateBy\":\"\",\"updateTime\":\"2026-01-26 10:22:07\",\"waterRequirement\":\"中等\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 10:22:07', 11);
INSERT INTO `sys_oper_log` VALUES (154, '作物种类', 2, 'com.ruoyi.web.controller.agriculture.CropSpeciesController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/crop', '127.0.0.1', '内网IP', '{\"category\":\"蔬菜\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 17:20:28\",\"diseaseResistance\":\"3\",\"estimatedYield\":4000.0,\"fertilizerRequirement\":\"有机肥+复合肥\",\"growthCycle\":90,\"lightRequirement\":\"充足\",\"params\":{},\"plantingDensity\":3600.0,\"scientificName\":\"Cucumis sativus\",\"soilRequirement\":\"富含有机质\",\"speciesCode\":\"CROP002\",\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"suitableHumidityMax\":85.0,\"suitableHumidityMin\":70.0,\"suitableTempMax\":30.0,\"suitableTempMin\":20.0,\"updateBy\":\"\",\"updateTime\":\"2026-01-26 10:22:11\",\"waterRequirement\":\"较高\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 10:22:11', 7);
INSERT INTO `sys_oper_log` VALUES (155, '作物种类', 2, 'com.ruoyi.web.controller.agriculture.CropSpeciesController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/crop', '127.0.0.1', '内网IP', '{\"category\":\"蔬菜\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 17:20:28\",\"diseaseResistance\":\"3\",\"estimatedYield\":5000.0,\"fertilizerRequirement\":\"氮磷钾复合肥\",\"growthCycle\":120,\"lightRequirement\":\"充足\",\"params\":{},\"plantingDensity\":3000.0,\"scientificName\":\"Solanum lycopersicum\",\"soilRequirement\":\"疏松肥沃\",\"speciesCode\":\"CROP001\",\"speciesId\":1,\"speciesName\":\"西红柿\",\"status\":\"0\",\"suitableHumidityMax\":80.0,\"suitableHumidityMin\":60.0,\"suitableTempMax\":28.0,\"suitableTempMin\":18.0,\"updateBy\":\"\",\"updateTime\":\"2026-01-26 10:22:15\",\"waterRequirement\":\"中等\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 10:22:15', 5);
INSERT INTO `sys_oper_log` VALUES (156, '作物种类', 2, 'com.ruoyi.web.controller.agriculture.CropSpeciesController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/crop', '127.0.0.1', '内网IP', '{\"category\":\"蔬菜\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 17:20:28\",\"diseaseResistance\":\"3\",\"estimatedYield\":4000.0,\"fertilizerRequirement\":\"有机肥+复合肥\",\"growthCycle\":90,\"lightRequirement\":\"充足\",\"params\":{},\"plantingDensity\":3600.0,\"scientificName\":\"Cucumis sativus\",\"soilRequirement\":\"富含有机质\",\"speciesCode\":\"CROP002\",\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"suitableHumidityMax\":85.0,\"suitableHumidityMin\":70.0,\"suitableTempMax\":30.0,\"suitableTempMin\":20.5,\"updateBy\":\"\",\"updateTime\":\"2026-01-26 10:23:11\",\"waterRequirement\":\"较高\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 10:23:11', 7);
INSERT INTO `sys_oper_log` VALUES (157, '作物种类', 2, 'com.ruoyi.web.controller.agriculture.CropSpeciesController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/crop', '127.0.0.1', '内网IP', '{\"category\":\"蔬菜\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 17:20:28\",\"diseaseResistance\":\"3\",\"estimatedYield\":4000.0,\"fertilizerRequirement\":\"有机肥+复合肥\",\"growthCycle\":90,\"imageUrl\":\"/photo/2026/01/26/5bb34553694b4119be0bdb3c26a20de0.png\",\"lightRequirement\":\"充足\",\"params\":{},\"plantingDensity\":3600.0,\"scientificName\":\"Cucumis sativus\",\"soilRequirement\":\"富含有机质\",\"speciesCode\":\"CROP002\",\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"suitableHumidityMax\":85.0,\"suitableHumidityMin\":70.0,\"suitableTempMax\":30.0,\"suitableTempMin\":20.5,\"updateBy\":\"\",\"updateTime\":\"2026-01-26 10:48:18\",\"waterRequirement\":\"较高\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 10:48:18', 25);
INSERT INTO `sys_oper_log` VALUES (158, '作物种类', 2, 'com.ruoyi.web.controller.agriculture.CropSpeciesController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/crop', '127.0.0.1', '内网IP', '{\"category\":\"蔬菜\",\"createBy\":\"admin\",\"createTime\":\"2026-01-22 17:20:28\",\"diseaseResistance\":\"3\",\"estimatedYield\":4000.0,\"fertilizerRequirement\":\"有机肥+复合肥\",\"growthCycle\":90,\"imageUrl\":\"/photo/2026/01/26/f9010931a00f45c6a374326550d4a49d.jpg\",\"lightRequirement\":\"充足\",\"params\":{},\"plantingDensity\":3600.0,\"scientificName\":\"Cucumis sativus\",\"soilRequirement\":\"富含有机质\",\"speciesCode\":\"CROP002\",\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"suitableHumidityMax\":85.0,\"suitableHumidityMin\":70.0,\"suitableTempMax\":30.0,\"suitableTempMin\":20.5,\"updateBy\":\"\",\"updateTime\":\"2026-01-26 10:50:06\",\"waterRequirement\":\"较高\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 10:50:06', 24);
INSERT INTO `sys_oper_log` VALUES (159, '作物种类', 3, 'com.ruoyi.web.controller.agriculture.CropSpeciesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/agriculture/crop/1', '127.0.0.1', '内网IP', '[1] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 11:10:03', 11);
INSERT INTO `sys_oper_log` VALUES (160, '作物种类', 3, 'com.ruoyi.web.controller.agriculture.CropSpeciesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/agriculture/crop/2', '127.0.0.1', '内网IP', '[2] ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)\r\n### The error may exist in file [D:\\云盘\\OneDrive\\桌面\\demo\\RuoYi-Vue-master\\ruoyi-system\\target\\classes\\mapper\\agriculture\\CropSpeciesMapper.xml]\r\n### The error may involve com.ruoyi.agriculture.mapper.CropSpeciesMapper.deleteCropSpeciesBySpeciesIds-Inline\r\n### The error occurred while setting parameters\r\n### SQL: delete from crop_species where species_id in           (               ?          )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)\n; Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT); nested exception is java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)', '2026-01-26 11:10:04', 98);
INSERT INTO `sys_oper_log` VALUES (161, '作物种类', 3, 'com.ruoyi.web.controller.agriculture.CropSpeciesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/agriculture/crop/2', '127.0.0.1', '内网IP', '[2] ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)\r\n### The error may exist in file [D:\\云盘\\OneDrive\\桌面\\demo\\RuoYi-Vue-master\\ruoyi-system\\target\\classes\\mapper\\agriculture\\CropSpeciesMapper.xml]\r\n### The error may involve com.ruoyi.agriculture.mapper.CropSpeciesMapper.deleteCropSpeciesBySpeciesIds-Inline\r\n### The error occurred while setting parameters\r\n### SQL: delete from crop_species where species_id in           (               ?          )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)\n; Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT); nested exception is java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)', '2026-01-26 11:10:08', 18);
INSERT INTO `sys_oper_log` VALUES (162, '作物种类', 3, 'com.ruoyi.web.controller.agriculture.CropSpeciesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/agriculture/crop/3', '127.0.0.1', '内网IP', '[3] ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)\r\n### The error may exist in file [D:\\云盘\\OneDrive\\桌面\\demo\\RuoYi-Vue-master\\ruoyi-system\\target\\classes\\mapper\\agriculture\\CropSpeciesMapper.xml]\r\n### The error may involve com.ruoyi.agriculture.mapper.CropSpeciesMapper.deleteCropSpeciesBySpeciesIds-Inline\r\n### The error occurred while setting parameters\r\n### SQL: delete from crop_species where species_id in           (               ?          )\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)\n; Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT); nested exception is java.sql.SQLIntegrityConstraintViolationException: Cannot delete or update a parent row: a foreign key constraint fails (`ry-vue`.`planting_record`, CONSTRAINT `fk_planting_species` FOREIGN KEY (`species_id`) REFERENCES `crop_species` (`species_id`) ON DELETE RESTRICT ON UPDATE RESTRICT)', '2026-01-26 11:10:19', 6);
INSERT INTO `sys_oper_log` VALUES (163, '作物种类', 3, 'com.ruoyi.web.controller.agriculture.CropSpeciesController.remove()', 'DELETE', 1, 'admin', '研发部门', '/agriculture/crop/2', '127.0.0.1', '内网IP', '[2] ', '{\"msg\":\"无法删除作物种类【黄瓜】，该作物种类已被 2 条种植记录引用，请先删除相关的种植记录\",\"code\":500}', 0, NULL, '2026-01-26 11:11:41', 13);
INSERT INTO `sys_oper_log` VALUES (164, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"canHarvest\":\"1\",\"createBy\":\"\",\"createTime\":\"2026-01-23 18:17:00\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"成熟期\",\"healthStatus\":\"healthy\",\"isMature\":\"1\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"maturity\":\"1\",\"params\":{},\"plantingArea\":0.5,\"plantingDate\":\"2026-01-23\",\"plantingDensity\":3500,\"plantingId\":3,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-26 11:16:59\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 11:16:59', 28);
INSERT INTO `sys_oper_log` VALUES (165, '种植记录', 5, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.export()', 'POST', 1, 'admin', '研发部门', '/agriculture/planting/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-01-26 11:21:17', 870);
INSERT INTO `sys_oper_log` VALUES (166, '种植记录', 2, 'com.ruoyi.web.controller.agriculture.PlantingRecordController.edit()', 'PUT', 1, 'admin', '研发部门', '/agriculture/planting', '127.0.0.1', '内网IP', '{\"canHarvest\":\"1\",\"createBy\":\"\",\"createTime\":\"2026-01-23 18:17:00\",\"expectedHarvestDate\":\"0002-11-28\",\"growthStage\":\"成熟期\",\"healthStatus\":\"healthy\",\"isMature\":\"1\",\"landId\":98,\"landName\":\"南区四十八号地块\",\"maturity\":\"1\",\"params\":{},\"plantingArea\":0.5,\"plantingDate\":\"2026-01-23\",\"plantingDensity\":3600,\"plantingId\":3,\"speciesId\":2,\"speciesName\":\"黄瓜\",\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2026-01-26 11:25:02\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 11:25:02', 5);
INSERT INTO `sys_oper_log` VALUES (167, '种植管理', 1, 'com.ruoyi.web.controller.agriculture.FarmingManagementController.add()', 'POST', 1, 'admin', '研发部门', '/agriculture/farming', '127.0.0.1', '内网IP', '{\"cost\":0.01,\"createTime\":\"2026-01-26 11:37:02\",\"dosage\":0.1,\"effect\":\"ces\",\"farmingId\":2,\"managementDate\":\"2026-01-26 11:36:32\",\"managementType\":\"pesticide\",\"materialName\":\"测试\",\"materialType\":\"农药\",\"method\":\"测试\",\"notes\":\"ces\",\"operator\":\"aa\",\"params\":{},\"plantingId\":3,\"purpose\":\"\",\"unit\":\"L\",\"weatherCondition\":\"ss\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 11:37:02', 10);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2026-01-22 16:24:52', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2026-01-22 16:24:52', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2026-01-22 16:24:52', '', NULL, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 2000);
INSERT INTO `sys_role_menu` VALUES (1, 2001);
INSERT INTO `sys_role_menu` VALUES (1, 2002);
INSERT INTO `sys_role_menu` VALUES (1, 2003);
INSERT INTO `sys_role_menu` VALUES (1, 2004);
INSERT INTO `sys_role_menu` VALUES (1, 2005);
INSERT INTO `sys_role_menu` VALUES (1, 2006);
INSERT INTO `sys_role_menu` VALUES (1, 2007);
INSERT INTO `sys_role_menu` VALUES (1, 2008);
INSERT INTO `sys_role_menu` VALUES (1, 2009);
INSERT INTO `sys_role_menu` VALUES (1, 2010);
INSERT INTO `sys_role_menu` VALUES (1, 2011);
INSERT INTO `sys_role_menu` VALUES (1, 2012);
INSERT INTO `sys_role_menu` VALUES (1, 2182);
INSERT INTO `sys_role_menu` VALUES (1, 2183);
INSERT INTO `sys_role_menu` VALUES (1, 2189);
INSERT INTO `sys_role_menu` VALUES (1, 2195);
INSERT INTO `sys_role_menu` VALUES (1, 2201);
INSERT INTO `sys_role_menu` VALUES (1, 2207);
INSERT INTO `sys_role_menu` VALUES (1, 2221);
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-01-26 09:46:27', '2026-01-22 16:24:52', 'admin', '2026-01-22 16:24:52', '', NULL, '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-01-22 16:24:52', '2026-01-22 16:24:52', 'admin', '2026-01-22 16:24:52', '', NULL, '测试员');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);

-- ----------------------------
-- Table structure for translation_corpus
-- ----------------------------
DROP TABLE IF EXISTS `translation_corpus`;
CREATE TABLE `translation_corpus`  (
  `corpus_id` bigint NOT NULL AUTO_INCREMENT COMMENT '语料库ID',
  `source_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '原文',
  `target_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '译文',
  `source_language` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '源语言',
  `target_language` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'zh' COMMENT '目标语言',
  `domain_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '领域类型',
  `usage_count` int NULL DEFAULT 0 COMMENT '使用次数',
  `accuracy_score` decimal(3, 2) NULL DEFAULT 0.00 COMMENT '准确度评分',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`corpus_id`) USING BTREE,
  INDEX `idx_source_text`(`source_text`(100) ASC) USING BTREE,
  INDEX `idx_domain_type`(`domain_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '语料库表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of translation_corpus
-- ----------------------------
INSERT INTO `translation_corpus` VALUES (1, 'Hello World', '你好世界', 'en', 'zh', 'general', 1, 0.98, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);
INSERT INTO `translation_corpus` VALUES (2, 'Good Morning', '早上好', 'en', 'zh', 'general', 1, 0.98, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);
INSERT INTO `translation_corpus` VALUES (3, 'Thank you', '谢谢', 'en', 'zh', 'general', 1, 0.99, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);
INSERT INTO `translation_corpus` VALUES (4, 'How are you?', '你好吗？', 'en', 'zh', 'general', 1, 0.96, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);
INSERT INTO `translation_corpus` VALUES (5, 'Welcome to our company', '欢迎来到我们公司', 'en', 'zh', 'business', 1, 0.94, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);
INSERT INTO `translation_corpus` VALUES (6, 'Please contact us', '请联系我们', 'en', 'zh', 'business', 1, 0.97, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);
INSERT INTO `translation_corpus` VALUES (7, 'Product Information', '产品信息', 'en', 'zh', 'technical', 1, 0.93, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);
INSERT INTO `translation_corpus` VALUES (8, 'Technical Support', '技术支持', 'en', 'zh', 'technical', 1, 0.95, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);
INSERT INTO `translation_corpus` VALUES (9, 'User Manual', '用户手册', 'en', 'zh', 'technical', 1, 0.92, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);
INSERT INTO `translation_corpus` VALUES (10, 'System Configuration', '系统配置', 'en', 'zh', 'technical', 1, 0.94, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);
INSERT INTO `translation_corpus` VALUES (11, 'Quality Assurance', '质量保证', 'en', 'zh', 'business', 1, 0.96, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);
INSERT INTO `translation_corpus` VALUES (12, 'Customer Service', '客户服务', 'en', 'zh', 'business', 1, 0.95, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);
INSERT INTO `translation_corpus` VALUES (13, 'Development Team', '开发团队', 'en', 'zh', 'general', 1, 0.97, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);
INSERT INTO `translation_corpus` VALUES (14, 'Project Management', '项目管理', 'en', 'zh', 'business', 1, 0.94, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);
INSERT INTO `translation_corpus` VALUES (15, 'Data Analysis', '数据分析', 'en', 'zh', 'technical', 1, 0.93, '0', '0', 'admin', '2026-01-22 16:55:37', '', NULL, NULL);

-- ----------------------------
-- Table structure for translation_record
-- ----------------------------
DROP TABLE IF EXISTS `translation_record`;
CREATE TABLE `translation_record`  (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `request_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求ID',
  `source_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '原文',
  `target_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '译文',
  `source_language` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '源语言',
  `target_language` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'zh' COMMENT '目标语言',
  `translation_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'auto' COMMENT '翻译类型（auto自动 manual手动）',
  `corpus_used` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '使用的语料库片段（JSON格式）',
  `processing_time` int NULL DEFAULT 0 COMMENT '处理时间（毫秒）',
  `confidence_score` decimal(3, 2) NULL DEFAULT 0.00 COMMENT '置信度评分',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户名',
  `ip_address` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'IP地址',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0成功 1失败）',
  `error_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '错误信息',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`record_id`) USING BTREE,
  UNIQUE INDEX `uk_request_id`(`request_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '翻译记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of translation_record
-- ----------------------------
INSERT INTO `translation_record` VALUES (1, '51f7c46c28134335be21462d8a978321', '你好', '翻译：你好', 'auto', 'zh', 'auto', NULL, 5, 0.70, 1, 'admin', '127.0.0.1', 'Edge 144', 'Windows >=10', '0', NULL, '0', '2026-01-22 17:03:32', NULL);
INSERT INTO `translation_record` VALUES (2, 'fda4716d11b542299375a58e58f94cb0', 'hello', '你好', 'auto', 'zh', 'auto', NULL, 4, 0.70, 1, 'admin', '127.0.0.1', 'Edge 144', 'Windows >=10', '0', NULL, '0', '2026-01-22 17:03:39', NULL);
INSERT INTO `translation_record` VALUES (3, 'f597ce7fc5cc4efeb21fbfd5c3153974', 'apple', '翻译：apple', 'auto', 'zh', 'auto', NULL, 7, 0.70, 1, 'admin', '127.0.0.1', 'Edge 144', 'Windows >=10', '0', NULL, '0', '2026-01-22 17:03:52', NULL);
INSERT INTO `translation_record` VALUES (4, 'req_001', 'Hello World', '你好世界', 'en', 'zh', 'auto', '[{\"corpusId\":1,\"sourceText\":\"Hello World\",\"targetText\":\"你好世界\",\"matchScore\":1.0}]', 120, 0.95, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 09:00:00', NULL);
INSERT INTO `translation_record` VALUES (5, 'req_002', 'Good Morning', '早上好', 'en', 'zh', 'auto', '[{\"corpusId\":2,\"sourceText\":\"Good Morning\",\"targetText\":\"早上好\",\"matchScore\":1.0}]', 95, 0.98, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 09:05:00', NULL);
INSERT INTO `translation_record` VALUES (6, 'req_003', 'Thank you very much', '非常感谢', 'en', 'zh', 'auto', '[{\"corpusId\":3,\"sourceText\":\"Thank you\",\"targetText\":\"谢谢\",\"matchScore\":0.8}]', 150, 0.92, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 09:10:00', NULL);
INSERT INTO `translation_record` VALUES (7, 'req_004', 'How are you today?', '你今天好吗？', 'en', 'zh', 'auto', '[{\"corpusId\":4,\"sourceText\":\"How are you?\",\"targetText\":\"你好吗？\",\"matchScore\":0.9}]', 110, 0.94, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 09:15:00', NULL);
INSERT INTO `translation_record` VALUES (8, 'req_005', 'Welcome to our company', '欢迎来到我们公司', 'en', 'zh', 'auto', '[{\"corpusId\":5,\"sourceText\":\"Welcome to our company\",\"targetText\":\"欢迎来到我们公司\",\"matchScore\":1.0}]', 130, 0.96, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 09:20:00', NULL);
INSERT INTO `translation_record` VALUES (9, 'req_006', 'Please contact us', '请联系我们', 'en', 'zh', 'auto', '[{\"corpusId\":6,\"sourceText\":\"Please contact us\",\"targetText\":\"请联系我们\",\"matchScore\":1.0}]', 105, 0.97, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 09:25:00', NULL);
INSERT INTO `translation_record` VALUES (10, 'req_007', 'Product Information', '产品信息', 'en', 'zh', 'auto', '[{\"corpusId\":7,\"sourceText\":\"Product Information\",\"targetText\":\"产品信息\",\"matchScore\":1.0}]', 125, 0.93, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 09:30:00', NULL);
INSERT INTO `translation_record` VALUES (11, 'req_008', 'Technical Support', '技术支持', 'en', 'zh', 'auto', '[{\"corpusId\":8,\"sourceText\":\"Technical Support\",\"targetText\":\"技术支持\",\"matchScore\":1.0}]', 115, 0.95, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 09:35:00', NULL);
INSERT INTO `translation_record` VALUES (12, 'req_009', 'User Manual', '用户手册', 'en', 'zh', 'auto', '[{\"corpusId\":9,\"sourceText\":\"User Manual\",\"targetText\":\"用户手册\",\"matchScore\":1.0}]', 140, 0.92, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 09:40:00', NULL);
INSERT INTO `translation_record` VALUES (13, 'req_010', 'System Configuration', '系统配置', 'en', 'zh', 'auto', '[{\"corpusId\":10,\"sourceText\":\"System Configuration\",\"targetText\":\"系统配置\",\"matchScore\":1.0}]', 135, 0.94, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 09:45:00', NULL);
INSERT INTO `translation_record` VALUES (14, 'req_011', 'Quality Assurance', '质量保证', 'en', 'zh', 'auto', '[{\"corpusId\":11,\"sourceText\":\"Quality Assurance\",\"targetText\":\"质量保证\",\"matchScore\":1.0}]', 120, 0.96, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 09:50:00', NULL);
INSERT INTO `translation_record` VALUES (15, 'req_012', 'Customer Service', '客户服务', 'en', 'zh', 'auto', '[{\"corpusId\":12,\"sourceText\":\"Customer Service\",\"targetText\":\"客户服务\",\"matchScore\":1.0}]', 110, 0.95, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 09:55:00', NULL);
INSERT INTO `translation_record` VALUES (16, 'req_013', 'Development Team', '开发团队', 'en', 'zh', 'auto', '[{\"corpusId\":13,\"sourceText\":\"Development Team\",\"targetText\":\"开发团队\",\"matchScore\":1.0}]', 125, 0.97, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 10:00:00', NULL);
INSERT INTO `translation_record` VALUES (17, 'req_014', 'Project Management', '项目管理', 'en', 'zh', 'auto', '[{\"corpusId\":14,\"sourceText\":\"Project Management\",\"targetText\":\"项目管理\",\"matchScore\":1.0}]', 130, 0.94, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 10:05:00', NULL);
INSERT INTO `translation_record` VALUES (18, 'req_015', 'Data Analysis', '数据分析', 'en', 'zh', 'auto', '[{\"corpusId\":15,\"sourceText\":\"Data Analysis\",\"targetText\":\"数据分析\",\"matchScore\":1.0}]', 145, 0.93, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 10:10:00', NULL);
INSERT INTO `translation_record` VALUES (19, 'req_016', 'Business Meeting', '商务会议', 'en', 'zh', 'auto', '[]', 160, 0.88, 2, 'ry', '192.168.1.101', 'Firefox119', 'Windows11', '0', NULL, '0', '2025-01-22 10:15:00', NULL);
INSERT INTO `translation_record` VALUES (20, 'req_017', 'Marketing Strategy', '营销策略', 'en', 'zh', 'auto', '[]', 155, 0.85, 2, 'ry', '192.168.1.101', 'Firefox119', 'Windows11', '0', NULL, '0', '2025-01-22 10:20:00', NULL);
INSERT INTO `translation_record` VALUES (21, 'req_018', 'Financial Report', '财务报告', 'en', 'zh', 'auto', '[]', 140, 0.90, 2, 'ry', '192.168.1.101', 'Firefox119', 'Windows11', '0', NULL, '0', '2025-01-22 10:25:00', NULL);
INSERT INTO `translation_record` VALUES (22, 'req_019', 'Sales Performance', '销售业绩', 'en', 'zh', 'auto', '[]', 135, 0.87, 2, 'ry', '192.168.1.101', 'Firefox119', 'Windows11', '0', NULL, '0', '2025-01-22 10:30:00', NULL);
INSERT INTO `translation_record` VALUES (23, 'req_020', 'Market Research', '市场研究', 'en', 'zh', 'auto', '[]', 150, 0.86, 2, 'ry', '192.168.1.101', 'Firefox119', 'Windows11', '0', NULL, '0', '2025-01-22 10:35:00', NULL);
INSERT INTO `translation_record` VALUES (24, 'req_021', 'Complex technical document about artificial intelligence and machine learning algorithms', '', 'en', 'zh', 'auto', '[]', 500, 0.00, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '1', NULL, '0', '2025-01-22 10:40:00', NULL);
INSERT INTO `translation_record` VALUES (25, 'req_022', '', '翻译：', 'zh', 'en', 'auto', '[]', 80, 0.70, 2, 'ry', '192.168.1.101', 'Firefox119', 'Windows11', '1', NULL, '0', '2025-01-22 10:45:00', NULL);
INSERT INTO `translation_record` VALUES (26, 'req_023', 'Legal Contract Terms and Conditions', '', 'en', 'zh', 'auto', '[]', 600, 0.00, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '1', NULL, '0', '2025-01-22 10:50:00', NULL);
INSERT INTO `translation_record` VALUES (27, 'req_024', 'Software Development', '软件开发', 'en', 'zh', 'auto', '[]', 125, 0.89, 2, 'ry', '192.168.1.101', 'Firefox119', 'Windows11', '0', NULL, '0', '2025-01-22 10:55:00', NULL);
INSERT INTO `translation_record` VALUES (28, 'req_025', 'Network Security', '网络安全', 'en', 'zh', 'auto', '[]', 130, 0.91, 2, 'ry', '192.168.1.101', 'Firefox119', 'Windows11', '0', NULL, '0', '2025-01-22 11:00:00', NULL);
INSERT INTO `translation_record` VALUES (29, 'req_026', 'Database Design', '数据库设计', 'en', 'zh', 'auto', '[]', 140, 0.88, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 11:05:00', NULL);
INSERT INTO `translation_record` VALUES (30, 'req_027', 'Cloud Computing', '云计算', 'en', 'zh', 'auto', '[]', 115, 0.92, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 11:10:00', NULL);
INSERT INTO `translation_record` VALUES (31, 'req_028', 'Mobile Application', '移动应用', 'en', 'zh', 'auto', '[]', 120, 0.90, 1, 'admin', '192.168.1.100', 'Chrome120', 'Windows10', '0', NULL, '0', '2025-01-22 11:15:00', NULL);
INSERT INTO `translation_record` VALUES (32, 'req_029', 'Web Development', '网页开发', 'en', 'zh', 'auto', '[]', 135, 0.87, 2, 'ry', '192.168.1.101', 'Firefox119', 'Windows11', '0', NULL, '0', '2025-01-22 11:20:00', NULL);
INSERT INTO `translation_record` VALUES (33, 'req_030', 'API Integration', 'API集成', 'en', 'zh', 'auto', '[]', 125, 0.89, 2, 'ry', '192.168.1.101', 'Firefox119', 'Windows11', '0', NULL, '0', '2025-01-22 11:25:00', NULL);
INSERT INTO `translation_record` VALUES (34, 'd12109fa93014c1682934e43a81baebd', '大大的阿斯顿阿斯顿', '翻译：大大的阿斯顿阿斯顿', 'auto', 'zh', 'auto', NULL, 5, 0.70, 1, 'admin', '127.0.0.1', 'Edge 144', 'Windows >=10', '0', NULL, '0', '2026-01-23 18:19:24', NULL);

-- ----------------------------
-- Table structure for translation_statistics
-- ----------------------------
DROP TABLE IF EXISTS `translation_statistics`;
CREATE TABLE `translation_statistics`  (
  `stat_id` bigint NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `total_requests` int NULL DEFAULT 0 COMMENT '总请求数',
  `success_requests` int NULL DEFAULT 0 COMMENT '成功请求数',
  `failed_requests` int NULL DEFAULT 0 COMMENT '失败请求数',
  `total_characters` bigint NULL DEFAULT 0 COMMENT '总字符数',
  `avg_processing_time` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '平均处理时间（毫秒）',
  `corpus_hit_rate` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '语料库命中率（%）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID（为空表示全站统计）',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID（为空表示全站统计）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`stat_id`) USING BTREE,
  UNIQUE INDEX `uk_stat_date_user`(`stat_date` ASC, `user_id` ASC, `dept_id` ASC) USING BTREE,
  INDEX `idx_stat_date`(`stat_date` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_dept_id`(`dept_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '翻译统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of translation_statistics
-- ----------------------------

-- ----------------------------
-- Table structure for weather_info
-- ----------------------------
DROP TABLE IF EXISTS `weather_info`;
CREATE TABLE `weather_info`  (
  `weather_id` bigint NOT NULL AUTO_INCREMENT COMMENT '天气信息ID',
  `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '监测位置',
  `temperature` decimal(5, 2) NULL DEFAULT NULL COMMENT '温度(℃)',
  `humidity` decimal(5, 2) NULL DEFAULT NULL COMMENT '湿度(%)',
  `air_pressure` decimal(7, 2) NULL DEFAULT NULL COMMENT '气压(hPa)',
  `wind_speed` decimal(5, 2) NULL DEFAULT NULL COMMENT '风速(m/s)',
  `wind_direction` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '风向',
  `rainfall` decimal(6, 2) NULL DEFAULT NULL COMMENT '降雨量(mm)',
  `light_intensity` decimal(7, 2) NULL DEFAULT NULL COMMENT '光照强度(lux)',
  `soil_temperature` decimal(5, 2) NULL DEFAULT NULL COMMENT '土壤温度(℃)',
  `soil_moisture` decimal(5, 2) NULL DEFAULT NULL COMMENT '土壤湿度(%)',
  `record_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
  `sensor_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '传感器ID',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`weather_id`) USING BTREE,
  INDEX `idx_record_time`(`record_time` ASC) USING BTREE,
  INDEX `idx_location`(`location` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '天气信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of weather_info
-- ----------------------------
INSERT INTO `weather_info` VALUES (1, '东区一号地块', 25.50, 65.20, 1013.25, 3.20, '东南', 0.00, 45000.00, 22.80, 68.50, '2024-01-15 08:00:00', 'SENSOR001', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (2, '西区二号地块', 24.80, 70.10, 1012.80, 2.80, '东风', 0.00, 42000.00, 21.50, 72.30, '2024-01-15 08:30:00', 'SENSOR002', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (3, '南区三号地块', 26.20, 62.80, 1014.10, 4.10, '南风', 0.00, 48000.00, 23.20, 65.80, '2024-01-15 09:00:00', 'SENSOR003', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (4, '北区四号地块', 23.50, 75.30, 1011.50, 5.20, '西北', 2.50, 38000.00, 20.80, 78.20, '2024-01-15 09:30:00', 'SENSOR004', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (5, '中区五号地块', 27.10, 58.90, 1015.20, 2.10, '西风', 0.00, 52000.00, 24.50, 61.20, '2024-01-15 10:00:00', 'SENSOR005', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (6, '东区一号地块', 28.30, 55.60, 1016.80, 3.80, '西南', 0.00, 55000.00, 25.80, 58.90, '2024-01-15 10:30:00', 'SENSOR001', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (7, '西区二号地块', 27.60, 60.20, 1015.40, 2.90, '南风', 0.00, 51000.00, 24.90, 63.50, '2024-01-15 11:00:00', 'SENSOR002', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (8, '南区三号地块', 29.10, 52.30, 1017.50, 4.50, '东南', 0.00, 58000.00, 26.20, 55.10, '2024-01-15 11:30:00', 'SENSOR003', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (9, '北区四号地块', 26.40, 68.70, 1013.90, 6.10, '北风', 3.20, 44000.00, 23.70, 71.30, '2024-01-15 12:00:00', 'SENSOR004', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (10, '中区五号地块', 30.20, 48.50, 1018.30, 2.60, '东风', 0.00, 62000.00, 27.50, 51.80, '2024-01-15 12:30:00', 'SENSOR005', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (11, '东区一号地块', 31.50, 45.20, 1019.10, 3.30, '东北', 0.00, 65000.00, 28.80, 48.30, '2024-01-15 13:00:00', 'SENSOR001', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (12, '西区二号地块', 30.80, 50.10, 1018.60, 4.20, '西北', 0.00, 61000.00, 27.90, 53.60, '2024-01-15 13:30:00', 'SENSOR002', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (13, '南区三号地块', 32.40, 42.80, 1020.20, 5.70, '西风', 0.00, 68000.00, 29.50, 45.20, '2024-01-15 14:00:00', 'SENSOR003', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (14, '北区四号地块', 29.70, 58.30, 1016.70, 7.20, '西南', 1.80, 56000.00, 26.80, 61.70, '2024-01-15 14:30:00', 'SENSOR004', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (15, '中区五号地块', 33.10, 40.50, 1021.40, 3.10, '南风', 0.00, 70000.00, 30.20, 43.10, '2024-01-15 15:00:00', 'SENSOR005', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (16, '东区一号地块', 32.80, 43.70, 1020.80, 2.80, '东南', 0.00, 67000.00, 29.90, 46.40, '2024-01-15 15:30:00', 'SENSOR001', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (17, '西区二号地块', 31.90, 47.20, 1019.90, 3.90, '东风', 0.00, 63000.00, 29.10, 50.80, '2024-01-15 16:00:00', 'SENSOR002', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (18, '南区三号地块', 33.50, 39.60, 1021.80, 4.80, '北风', 0.00, 71000.00, 30.60, 42.30, '2024-01-15 16:30:00', 'SENSOR003', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (19, '北区四号地块', 30.80, 54.10, 1018.30, 6.30, '西北', 2.10, 59000.00, 27.90, 57.50, '2024-01-15 17:00:00', 'SENSOR004', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (20, '中区五号地块', 34.20, 38.30, 1022.50, 2.40, '西风', 0.00, 72000.00, 31.10, 41.20, '2024-01-15 17:30:00', 'SENSOR005', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (21, '东区一号地块', 31.60, 46.80, 1019.40, 3.60, '西南', 0.50, 64000.00, 28.70, 49.90, '2024-01-15 18:00:00', 'SENSOR001', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (22, '西区二号地块', 30.70, 51.30, 1018.70, 4.10, '南风', 0.80, 60000.00, 27.80, 54.70, '2024-01-15 18:30:00', 'SENSOR002', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (23, '南区三号地块', 32.10, 44.50, 1020.60, 5.20, '东南', 0.30, 66000.00, 29.20, 47.80, '2024-01-15 19:00:00', 'SENSOR003', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (24, '北区四号地块', 29.40, 59.20, 1017.10, 6.80, '东风', 1.50, 57000.00, 26.50, 62.80, '2024-01-15 19:30:00', 'SENSOR004', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (25, '中区五号地块', 33.80, 41.70, 1021.90, 2.90, '东北', 0.00, 69000.00, 30.70, 44.90, '2024-01-15 20:00:00', 'SENSOR005', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (26, '东区一号地块', 28.90, 62.40, 1016.20, 3.30, '北风', 3.80, 54000.00, 26.10, 65.30, '2024-01-15 20:30:00', 'SENSOR001', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (27, '西区二号地块', 28.10, 66.80, 1015.50, 2.70, '西北', 4.20, 50000.00, 25.30, 69.70, '2024-01-15 21:00:00', 'SENSOR002', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (28, '南区三号地块', 29.60, 58.90, 1017.80, 4.60, '西风', 3.10, 56000.00, 26.80, 62.10, '2024-01-15 21:30:00', 'SENSOR003', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (29, '北区四号地块', 26.90, 71.50, 1014.30, 5.90, '西南', 5.20, 48000.00, 24.20, 74.80, '2024-01-15 22:00:00', 'SENSOR004', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (30, '中区五号地块', 30.30, 55.10, 1018.90, 3.10, '南风', 2.80, 58000.00, 27.40, 58.60, '2024-01-15 22:30:00', 'SENSOR005', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (31, '东区一号地块', 27.20, 68.30, 1015.80, 2.40, '东南', 1.20, 51000.00, 24.50, 71.20, '2024-01-15 23:00:00', 'SENSOR001', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (32, '西区二号地块', 26.50, 72.60, 1015.10, 3.80, '东风', 1.80, 47000.00, 23.80, 75.50, '2024-01-15 23:30:00', 'SENSOR002', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (33, '南区三号地块', 27.80, 64.70, 1016.90, 4.30, '北风', 0.90, 53000.00, 25.10, 67.90, '2024-01-16 00:00:00', 'SENSOR003', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (34, '北区四号地块', 25.10, 77.20, 1013.40, 6.40, '西北', 2.50, 45000.00, 22.40, 80.10, '2024-01-16 00:30:00', 'SENSOR004', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (35, '中区五号地块', 28.60, 60.80, 1017.60, 2.90, '西风', 1.50, 55000.00, 25.90, 64.20, '2024-01-16 01:00:00', 'SENSOR005', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (36, '东区一号地块', 26.30, 73.90, 1014.70, 3.50, '西南', 3.60, 49000.00, 23.60, 76.80, '2024-01-16 01:30:00', 'SENSOR001', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (37, '西区二号地块', 25.70, 78.10, 1014.20, 4.10, '南风', 4.10, 46000.00, 23.00, 80.90, '2024-01-16 02:00:00', 'SENSOR002', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (38, '南区三号地块', 26.90, 70.20, 1015.80, 4.80, '东南', 2.80, 51000.00, 24.20, 73.40, '2024-01-16 02:30:00', 'SENSOR003', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (39, '北区四号地块', 24.20, 82.50, 1012.60, 5.70, '东风', 3.30, 43000.00, 21.50, 85.20, '2024-01-16 03:00:00', 'SENSOR004', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (40, '中区五号地块', 27.60, 65.40, 1016.40, 3.20, '东北', 1.90, 52000.00, 24.90, 68.70, '2024-01-16 03:30:00', 'SENSOR005', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (41, '东区一号地块', 25.80, 79.30, 1013.90, 2.60, '北风', 2.10, 47000.00, 23.10, 81.90, '2024-01-16 04:00:00', 'SENSOR001', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (42, '西区二号地块', 25.10, 83.60, 1013.40, 3.90, '西北', 2.70, 44000.00, 22.40, 85.80, '2024-01-16 04:30:00', 'SENSOR002', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (43, '南区三号地块', 26.40, 75.70, 1014.80, 4.50, '西风', 1.80, 49000.00, 23.70, 78.90, '2024-01-16 05:00:00', 'SENSOR003', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (44, '北区四号地块', 23.70, 87.90, 1011.90, 5.30, '西南', 3.90, 41000.00, 21.00, 90.20, '2024-01-16 05:30:00', 'SENSOR004', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (45, '中区五号地块', 27.10, 70.10, 1015.60, 3.00, '南风', 1.20, 50000.00, 24.40, 73.30, '2024-01-16 06:00:00', 'SENSOR005', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (46, '东区一号地块', 24.90, 84.20, 1013.20, 2.80, '东南', 1.50, 45000.00, 22.20, 86.50, '2024-01-16 06:30:00', 'SENSOR001', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (47, '西区二号地块', 24.30, 88.40, 1012.80, 3.60, '东风', 2.20, 42000.00, 21.60, 90.10, '2024-01-16 07:00:00', 'SENSOR002', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (48, '南区三号地块', 25.60, 80.50, 1014.10, 4.20, '北风', 1.00, 47000.00, 22.90, 83.60, '2024-01-16 07:30:00', 'SENSOR003', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (49, '北区四号地块', 22.90, 92.70, 1011.30, 4.90, '西北', 2.80, 39000.00, 20.20, 94.80, '2024-01-16 08:00:00', 'SENSOR004', 'admin', '2026-01-22 19:00:14', '', '2026-01-22 19:00:14', NULL);
INSERT INTO `weather_info` VALUES (50, '中区五号地块', 26.60, 74.80, 1014.90, 2.70, '西风', 0.80, 48000.00, 23.80, 77.90, '2024-01-16 08:30:00', 'SENSOR005', 'admin', '2026-01-22 19:00:14', '', '2026-01-26 09:59:03', NULL);
INSERT INTO `weather_info` VALUES (51, '东区一号地块', 24.20, 76.50, 1013.60, 3.20, '东南', 0.60, 46000.00, 21.50, 79.20, '2026-01-26 09:00:00', 'SENSOR001', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (52, '西区二号地块', 23.80, 79.20, 1013.20, 2.90, '东风', 0.90, 44000.00, 21.10, 81.80, '2026-01-26 09:30:00', 'SENSOR002', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (53, '南区三号地块', 25.40, 71.60, 1014.80, 4.20, '南风', 0.30, 50000.00, 22.70, 74.30, '2026-01-26 10:00:00', 'SENSOR003', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (54, '北区四号地块', 22.60, 82.30, 1011.80, 5.50, '西北', 1.80, 40000.00, 19.90, 85.10, '2026-01-26 10:30:00', 'SENSOR004', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (55, '中区五号地块', 26.80, 68.40, 1015.40, 2.50, '西风', 0.20, 53000.00, 24.10, 71.20, '2026-01-26 11:00:00', 'SENSOR005', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (56, '东区一号地块', 27.50, 64.80, 1016.20, 3.60, '西南', 0.00, 56000.00, 24.80, 67.50, '2026-01-26 11:30:00', 'SENSOR001', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (57, '西区二号地块', 26.90, 67.20, 1015.60, 3.10, '南风', 0.00, 54000.00, 24.20, 70.10, '2026-01-26 12:00:00', 'SENSOR002', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (58, '南区三号地块', 28.30, 61.50, 1017.20, 4.50, '东南', 0.00, 58000.00, 25.60, 64.20, '2026-01-26 12:30:00', 'SENSOR003', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (59, '北区四号地块', 25.20, 73.80, 1014.50, 6.20, '北风', 2.50, 48000.00, 22.50, 76.50, '2026-01-26 13:00:00', 'SENSOR004', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (60, '中区五号地块', 29.10, 58.20, 1018.30, 2.80, '东风', 0.00, 61000.00, 26.40, 61.00, '2026-01-26 13:30:00', 'SENSOR005', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (61, '东区一号地块', 30.40, 54.60, 1019.10, 3.40, '东北', 0.00, 64000.00, 27.70, 57.30, '2026-01-26 14:00:00', 'SENSOR001', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (62, '西区二号地块', 29.70, 57.90, 1018.50, 4.10, '西北', 0.00, 60000.00, 27.00, 60.60, '2026-01-26 14:30:00', 'SENSOR002', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (63, '南区三号地块', 31.20, 51.40, 1020.10, 5.60, '西风', 0.00, 67000.00, 28.50, 54.10, '2026-01-26 15:00:00', 'SENSOR003', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (64, '北区四号地块', 28.50, 65.70, 1016.60, 7.10, '西南', 1.50, 55000.00, 25.80, 68.40, '2026-01-26 15:30:00', 'SENSOR004', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (65, '中区五号地块', 32.00, 49.20, 1021.20, 3.20, '南风', 0.00, 69000.00, 29.30, 51.90, '2026-01-26 16:00:00', 'SENSOR005', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (66, '东区一号地块', 31.70, 52.60, 1020.70, 2.90, '东南', 0.00, 66000.00, 29.00, 55.30, '2026-01-26 16:30:00', 'SENSOR001', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (67, '西区二号地块', 30.80, 56.10, 1019.80, 3.80, '东风', 0.00, 62000.00, 28.10, 59.60, '2026-01-26 17:00:00', 'SENSOR002', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (68, '南区三号地块', 32.40, 48.30, 1021.70, 4.70, '北风', 0.00, 70000.00, 29.70, 51.00, '2026-01-26 17:30:00', 'SENSOR003', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (69, '北区四号地块', 29.70, 63.00, 1018.20, 6.40, '西北', 1.90, 58000.00, 26.90, 66.30, '2026-01-26 18:00:00', 'SENSOR004', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);
INSERT INTO `weather_info` VALUES (70, '中区五号地块', 33.10, 47.10, 1022.40, 2.60, '西风', 0.00, 71000.00, 30.20, 49.80, '2026-01-26 18:30:00', 'SENSOR005', 'admin', '2026-01-26 12:00:00', '', '2026-01-26 12:00:00', NULL);

SET FOREIGN_KEY_CHECKS = 1;
