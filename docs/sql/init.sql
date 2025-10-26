/*
 Navicat Premium Dump SQL

 Source Server         : ebook_view
 Source Server Type    : MySQL
 Source Server Version : 80405 (8.4.5)
 Source Host           : localhost:3306
 Source Schema         : sky_take_out

 Target Server Type    : MySQL
 Target Server Version : 80405 (8.4.5)
 File Encoding         : 65001

 Date: 26/10/2025 23:08:31
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address_book
-- ----------------------------
DROP TABLE IF EXISTS `address_book`;
CREATE TABLE `address_book` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `consignee` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '收货人',
  `sex` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '性别',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '手机号',
  `province_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '省级区划编号',
  `province_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '省级名称',
  `city_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '市级区划编号',
  `city_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '市级名称',
  `district_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '区级区划编号',
  `district_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '区级名称',
  `detail` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '详细地址',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '标签',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '默认 0 否 1是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='地址簿';

-- ----------------------------
-- Records of address_book
-- ----------------------------
BEGIN;
INSERT INTO `address_book` (`id`, `user_id`, `consignee`, `sex`, `phone`, `province_code`, `province_name`, `city_code`, `city_name`, `district_code`, `district_name`, `detail`, `label`, `is_default`) VALUES (2, 4, 'WS', '0', '13812344321', '11', '北京市', '1101', '市辖区', '110102', '西城区', '幸福小区4单元401', '3', 1);
COMMIT;

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` int DEFAULT NULL COMMENT '类型   1 菜品分类 2 套餐分类',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '分类名称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '顺序',
  `status` int DEFAULT NULL COMMENT '分类状态 0:禁用，1:启用',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint DEFAULT NULL COMMENT '创建人',
  `update_user` bigint DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_category_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='菜品及套餐分类';

-- ----------------------------
-- Records of category
-- ----------------------------
BEGIN;
INSERT INTO `category` (`id`, `type`, `name`, `sort`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (24, 1, '寿司系', 1, 1, '2025-08-05 14:56:16', '2025-10-26 18:47:31', NULL, 1);
INSERT INTO `category` (`id`, `type`, `name`, `sort`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (36, 1, '丼物系', 2, 1, '2025-10-26 18:49:42', '2025-10-26 18:49:42', 1, 1);
INSERT INTO `category` (`id`, `type`, `name`, `sort`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (37, 1, '麺類系', 3, 1, '2025-10-26 18:49:56', '2025-10-26 18:49:56', 1, 1);
INSERT INTO `category` (`id`, `type`, `name`, `sort`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (40, 1, '定食・その他系', 4, 1, '2025-10-26 19:19:25', '2025-10-26 19:19:25', 1, 1);
INSERT INTO `category` (`id`, `type`, `name`, `sort`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (41, 2, '寿司盛り合わせセット', 5, 1, '2025-10-26 19:22:56', '2025-10-26 19:22:56', 1, 1);
INSERT INTO `category` (`id`, `type`, `name`, `sort`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (42, 2, '丼物セット', 6, 1, '2025-10-26 19:23:13', '2025-10-26 19:23:13', 1, 1);
INSERT INTO `category` (`id`, `type`, `name`, `sort`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (43, 2, '麺セット', 7, 1, '2025-10-26 19:23:24', '2025-10-26 19:23:24', 1, 1);
INSERT INTO `category` (`id`, `type`, `name`, `sort`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (44, 2, '定食セット', 8, 1, '2025-10-26 19:23:33', '2025-10-26 19:23:33', 1, 1);
INSERT INTO `category` (`id`, `type`, `name`, `sort`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (45, 2, 'セットメニュー', 9, 1, '2025-10-26 19:23:43', '2025-10-26 19:23:43', 1, 1);
INSERT INTO `category` (`id`, `type`, `name`, `sort`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (46, 1, '軽食セット', 10, 1, '2025-10-26 19:23:53', '2025-10-26 19:23:53', 1, 1);
COMMIT;

-- ----------------------------
-- Table structure for dish
-- ----------------------------
DROP TABLE IF EXISTS `dish`;
CREATE TABLE `dish` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '菜品名称',
  `category_id` bigint NOT NULL COMMENT '菜品分类id',
  `price` decimal(10,2) DEFAULT NULL COMMENT '菜品价格',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '图片',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '描述信息',
  `status` int DEFAULT '1' COMMENT '0 停售 1 起售',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint DEFAULT NULL COMMENT '创建人',
  `update_user` bigint DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_dish_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='菜品';

-- ----------------------------
-- Records of dish
-- ----------------------------
BEGIN;
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (75, 'マグロ寿司', 24, 580.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/fdf2f1b1-de2d-4946-8b80-0d0e6e1d202e.png', '新鮮な赤身のマグロを使用した伝統的な寿司', 1, '2025-10-26 19:44:05', '2025-10-26 21:09:40', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (76, 'サーモン寿司', 24, 580.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/e5cd2f61-b536-4f8a-9e98-798cc7348bfb.png', 'ノルウェー産の脂のりの良いサーモンを使用した寿司', 1, '2025-10-26 20:25:10', '2025-10-26 21:09:38', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (77, '海老天ぷら寿司', 24, 680.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/19aef716-5763-4ef5-83d9-6291494fc6f5.png', 'サクサクの天ぷらと酢飯の絶妙なハーモニー', 1, '2025-10-26 20:44:04', '2025-10-26 21:09:36', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (78, 'うなぎ寿司', 24, 980.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/9215a07f-c13e-4007-9ace-46512fa5af5f.png', '柔らかい蒲焼きうなぎを載せた贅沢な寿司', 1, '2025-10-26 20:44:38', '2025-10-26 21:09:35', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (79, '巻き寿司セット', 24, 980.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/27f76f51-851d-4e26-8452-021f0fb47513.png', '多様な具材を使用した8種類の巻き寿司セット', 1, '2025-10-26 20:45:21', '2025-10-26 21:09:33', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (80, '牛丼', 36, 580.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/f1163fcd-e757-43c4-a529-01280f6a467a.png', '特製の甘辛いタレで煮込んだ柔らかい牛肉丼', 1, '2025-10-26 20:46:54', '2025-10-26 21:09:32', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (81, '親子丼', 36, 680.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/d88ddecf-541d-449c-adeb-b90327aeff79.png', '鶏肉と卵を特製のダシで煮込んだ優しい味わいの丼', 1, '2025-10-26 20:47:43', '2025-10-26 21:09:30', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (82, 'カツ丼', 36, 980.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/9999ae42-42f7-459b-8e12-e2499414a884.png', 'ジューシーな豚カツと特製のタレで仕上げたボリューム満点の丼', 1, '2025-10-26 20:48:36', '2025-10-26 21:09:28', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (83, '天丼', 36, 1200.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/f81bc8d5-7e3b-4e87-99cc-8b1b1d8b6368.png', 'エビ天ぷらと野菜天ぷらのサクサクとした食感が楽しめる丼', 1, '2025-10-26 20:49:11', '2025-10-26 21:09:26', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (84, 'うなぎ丼', 36, 2200.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/f510e480-ab0b-447b-ba7a-ebd91692d84b.png', '秘伝のタレで焼き上げた旨味たっぷりの鰻をふわふわのご飯にのせた豪華な丼', 1, '2025-10-26 20:49:36', '2025-10-26 21:09:25', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (85, '塩ラーメン', 37, 780.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/1aaf2aaf-94f8-4c71-8b32-bb73846c1e47.png', 'あっさりとした塩味スープと上品な味わい', 1, '2025-10-26 20:50:15', '2025-10-26 21:09:21', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (86, '味噌ラーメン', 37, 780.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/d07d0319-e668-483f-9f8b-28056a711dd1.png', 'コクのある味噌スープが特徴の北海道風ラーメン', 1, '2025-10-26 20:50:47', '2025-10-26 21:09:20', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (87, '辛味噌ラーメン', 37, 880.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/ebfe1cb8-58a5-474c-9f77-5d75a0b861da.png', '辛味噌スープと特製の辛味噌入りチャーシュー', 1, '2025-10-26 20:51:19', '2025-10-26 21:09:18', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (88, 'うどん', 37, 580.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/db540a9a-6040-4f79-a872-1d0cd90246ee.png', 'もちもちとした食感の手打ちうどん', 1, '2025-10-26 20:51:53', '2025-10-26 21:09:17', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (89, '冷やし中華', 37, 680.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/4ff7b64c-83fc-4187-806b-bb32fbb1b59b.png', 'さっぱりとした冷たい麺と彩り豊かな野菜とチャーシュー', 1, '2025-10-26 20:52:31', '2025-10-26 21:09:15', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (90, '焼き鳥盛り合わせ', 46, 1200.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/e17cc033-3946-4352-91e5-a9ef0acb34cd.png', 'タレ、塩のバランスの取れた6本の焼き鳥セット', 1, '2025-10-26 20:53:02', '2025-10-26 21:09:14', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (91, '天ぷら定食', 40, 1500.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/263039bc-5bbf-43f3-89ee-341c95e343aa.png', 'エビ天ぷら、野菜天ぷらのサクサクとした食感の定食', 1, '2025-10-26 20:53:44', '2025-10-26 21:09:12', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (92, '唐揚げ定食', 40, 850.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/ade3c741-87e9-4ccb-a764-40409b24180b.png', 'ジューシーでサクサクの手作り唐揚げとサラダ', 1, '2025-10-26 20:54:53', '2025-10-26 21:09:10', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (93, '焼き魚定食', 40, 980.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/c3cd762c-7c2c-450b-a308-8fc641e06c44.png', '朝獲れの新鮮な魚を塩焼きにした定食', 1, '2025-10-26 20:55:17', '2025-10-26 21:09:09', 1, 1);
INSERT INTO `dish` (`id`, `name`, `category_id`, `price`, `image`, `description`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (94, 'カレーライス', 40, 680.00, 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/14a38f3d-7759-4d51-a2fc-2db9c97ea345.png', 'スパイス豊富な本格的な和風カレーライス', 1, '2025-10-26 20:56:10', '2025-10-26 21:09:07', 1, 1);
COMMIT;

-- ----------------------------
-- Table structure for dish_flavor
-- ----------------------------
DROP TABLE IF EXISTS `dish_flavor`;
CREATE TABLE `dish_flavor` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dish_id` bigint NOT NULL COMMENT '菜品',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '口味名称',
  `value` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '口味数据list',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='菜品口味关系表';

-- ----------------------------
-- Records of dish_flavor
-- ----------------------------
BEGIN;
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (40, 10, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (41, 7, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (42, 7, '温度', '[\"热饮\",\"常温\",\"去冰\",\"少冰\",\"多冰\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (45, 6, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (46, 6, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (47, 5, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (48, 5, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (49, 2, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (50, 4, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (51, 3, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (52, 3, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (107, 75, '甘味', '[\"少糖\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (108, 76, '甘味', '[\"多糖\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (109, 77, '甘味', '[\"少糖\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (110, 78, '甘味', '[\"無糖\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (111, 79, '甘味', '[\"少糖\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (112, 80, '辛さ', '[\"微辛\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (113, 81, '温度', '[\"常温\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (114, 82, '辛さ', '[\"微辛\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (115, 83, '温度', '[\"常温\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (116, 83, '辛さ', '[\"微辛\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (117, 84, '辛さ', '[\"辛くない\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (118, 85, 'アレルギー', '[\"ニンニク抜き\",\"香菜抜き\",\"辛さ抜き\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (119, 86, '辛さ', '[\"辛くない\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (120, 88, '甘味', '[\"無糖\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (121, 89, '辛さ', '[\"中辛\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (122, 90, '温度', '[\"ホット\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (123, 91, '甘味', '[\"少糖\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (124, 92, '甘味', '[\"多糖\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (125, 94, '辛さ', '[\"辛くない\",\"微辛\",\"中辛\"]');
INSERT INTO `dish_flavor` (`id`, `dish_id`, `name`, `value`) VALUES (126, 94, '温度', '[\"ホット\"]');
COMMIT;

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '姓名',
  `username` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '用户名',
  `password` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '密码',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '手机号',
  `sex` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '性别',
  `id_number` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '身份证号',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态 0:禁用，1:启用',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint DEFAULT NULL COMMENT '创建人',
  `update_user` bigint DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='员工信息';

-- ----------------------------
-- Records of employee
-- ----------------------------
BEGIN;
INSERT INTO `employee` (`id`, `name`, `username`, `password`, `phone`, `sex`, `id_number`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (1, '管理员', 'admin', 'e10adc3949ba59abbe56e057f20f883e', '13812312312', '1', '110101199001010047', 1, '2022-02-15 15:51:20', '2025-10-23 17:33:53', 10, 1);
INSERT INTO `employee` (`id`, `name`, `username`, `password`, `phone`, `sex`, `id_number`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (2, 'チョウ', 'zsf', 'e10adc3949ba59abbe56e057f20f883e', '13812344321', '1', '111222333444555666', 1, '2025-07-22 16:48:55', '2025-10-26 21:16:23', 10, 1);
INSERT INTO `employee` (`id`, `name`, `username`, `password`, `phone`, `sex`, `id_number`, `status`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (4, 'ジェク', 'jack', 'e10adc3949ba59abbe56e057f20f883e', '13812344321', '1', '111222333444555666', 1, '2025-07-24 14:33:57', '2025-10-26 21:16:03', NULL, 1);
COMMIT;

-- ----------------------------
-- Table structure for order_detail
-- ----------------------------
DROP TABLE IF EXISTS `order_detail`;
CREATE TABLE `order_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '名字',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '图片',
  `order_id` bigint NOT NULL COMMENT '订单id',
  `dish_id` bigint DEFAULT NULL COMMENT '菜品id',
  `setmeal_id` bigint DEFAULT NULL COMMENT '套餐id',
  `dish_flavor` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '口味',
  `number` int NOT NULL DEFAULT '1' COMMENT '数量',
  `amount` decimal(10,2) NOT NULL COMMENT '金额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='订单明细表';

-- ----------------------------
-- Records of order_detail
-- ----------------------------
BEGIN;
INSERT INTO `order_detail` (`id`, `name`, `image`, `order_id`, `dish_id`, `setmeal_id`, `dish_flavor`, `number`, `amount`) VALUES (5, '蒜蓉娃娃菜', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/4879ed66-3860-4b28-ba14-306ac025fdec.png', 5, 55, NULL, NULL, 1, 18.00);
INSERT INTO `order_detail` (`id`, `name`, `image`, `order_id`, `dish_id`, `setmeal_id`, `dish_flavor`, `number`, `amount`) VALUES (6, '炝炒圆白菜', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/22f59feb-0d44-430e-a6cd-6a49f27453ca.png', 5, 57, NULL, '不要葱', 1, 18.00);
INSERT INTO `order_detail` (`id`, `name`, `image`, `order_id`, `dish_id`, `setmeal_id`, `dish_flavor`, `number`, `amount`) VALUES (7, '香锅牛蛙', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/f5ac8455-4793-450c-97ba-173795c34626.png', 6, 63, NULL, NULL, 1, 88.00);
INSERT INTO `order_detail` (`id`, `name`, `image`, `order_id`, `dish_id`, `setmeal_id`, `dish_flavor`, `number`, `amount`) VALUES (8, '鮰鱼2斤', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/8cfcc576-4b66-4a09-ac68-ad5b273c2590.png', 7, 67, NULL, '不辣', 1, 70.00);
INSERT INTO `order_detail` (`id`, `name`, `image`, `order_id`, `dish_id`, `setmeal_id`, `dish_flavor`, `number`, `amount`) VALUES (9, '香锅牛蛙', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/f5ac8455-4793-450c-97ba-173795c34626.png', 8, 63, NULL, NULL, 1, 88.00);
INSERT INTO `order_detail` (`id`, `name`, `image`, `order_id`, `dish_id`, `setmeal_id`, `dish_flavor`, `number`, `amount`) VALUES (10, '炝炒圆白菜', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/22f59feb-0d44-430e-a6cd-6a49f27453ca.png', 9, 57, NULL, '不要葱', 1, 18.00);
INSERT INTO `order_detail` (`id`, `name`, `image`, `order_id`, `dish_id`, `setmeal_id`, `dish_flavor`, `number`, `amount`) VALUES (11, '蜀味水煮草鱼', 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/2008f660-44ba-4b86-8f85-6b5642058839.jpg', 10, 53, NULL, '不要葱,不辣', 1, 38.00);
INSERT INTO `order_detail` (`id`, `name`, `image`, `order_id`, `dish_id`, `setmeal_id`, `dish_flavor`, `number`, `amount`) VALUES (12, '香锅牛蛙', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/f5ac8455-4793-450c-97ba-173795c34626.png', 11, 63, NULL, NULL, 1, 88.00);
COMMIT;

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `number` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '订单号',
  `status` int NOT NULL DEFAULT '1' COMMENT '订单状态 1待付款 2待接单 3已接单 4派送中 5已完成 6已取消 7退款',
  `user_id` bigint NOT NULL COMMENT '下单用户',
  `address_book_id` bigint NOT NULL COMMENT '地址id',
  `order_time` datetime NOT NULL COMMENT '下单时间',
  `checkout_time` datetime DEFAULT NULL COMMENT '结账时间',
  `pay_method` int NOT NULL DEFAULT '1' COMMENT '支付方式 1微信,2支付宝',
  `pay_status` tinyint NOT NULL DEFAULT '0' COMMENT '支付状态 0未支付 1已支付 2退款',
  `amount` decimal(10,2) NOT NULL COMMENT '实收金额',
  `remark` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手机号',
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '地址',
  `user_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户名称',
  `consignee` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '收货人',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '订单取消原因',
  `rejection_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '订单拒绝原因',
  `cancel_time` datetime DEFAULT NULL COMMENT '订单取消时间',
  `estimated_delivery_time` datetime DEFAULT NULL COMMENT '预计送达时间',
  `delivery_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '配送状态  1立即送出  0选择具体时间',
  `delivery_time` datetime DEFAULT NULL COMMENT '送达时间',
  `pack_amount` int DEFAULT NULL COMMENT '打包费',
  `tableware_number` int DEFAULT NULL COMMENT '餐具数量',
  `tableware_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '餐具数量状态  1按餐量提供  0选择具体数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='订单表';

-- ----------------------------
-- Records of orders
-- ----------------------------
BEGIN;
INSERT INTO `orders` (`id`, `number`, `status`, `user_id`, `address_book_id`, `order_time`, `checkout_time`, `pay_method`, `pay_status`, `amount`, `remark`, `phone`, `address`, `user_name`, `consignee`, `cancel_reason`, `rejection_reason`, `cancel_time`, `estimated_delivery_time`, `delivery_status`, `delivery_time`, `pack_amount`, `tableware_number`, `tableware_status`) VALUES (4, '1757386495085', 6, 4, 2, '2025-09-09 11:54:55', NULL, 1, 0, 44.00, '', '13812344321', '幸福小区4单元401', NULL, 'WS', '支付超时，自动取消', NULL, '2025-10-06 10:43:00', '2025-09-09 12:54:00', 0, NULL, 2, 0, 0);
INSERT INTO `orders` (`id`, `number`, `status`, `user_id`, `address_book_id`, `order_time`, `checkout_time`, `pay_method`, `pay_status`, `amount`, `remark`, `phone`, `address`, `user_name`, `consignee`, `cancel_reason`, `rejection_reason`, `cancel_time`, `estimated_delivery_time`, `delivery_status`, `delivery_time`, `pack_amount`, `tableware_number`, `tableware_status`) VALUES (5, '1757386746800', 6, 4, 2, '2025-09-09 11:59:07', NULL, 1, 0, 44.00, '', '13812344321', '幸福小区4单元401', NULL, 'WS', '用户取消', NULL, '2025-09-09 14:33:24', '2025-09-09 12:59:00', 0, NULL, 2, 0, 0);
INSERT INTO `orders` (`id`, `number`, `status`, `user_id`, `address_book_id`, `order_time`, `checkout_time`, `pay_method`, `pay_status`, `amount`, `remark`, `phone`, `address`, `user_name`, `consignee`, `cancel_reason`, `rejection_reason`, `cancel_time`, `estimated_delivery_time`, `delivery_status`, `delivery_time`, `pack_amount`, `tableware_number`, `tableware_status`) VALUES (6, '1757396029940', 6, 4, 2, '2025-09-09 14:33:50', NULL, 1, 0, 95.00, '', '13812344321', '幸福小区4单元401', NULL, 'WS', '用户取消', NULL, '2025-09-09 14:47:49', '2025-09-09 15:33:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` (`id`, `number`, `status`, `user_id`, `address_book_id`, `order_time`, `checkout_time`, `pay_method`, `pay_status`, `amount`, `remark`, `phone`, `address`, `user_name`, `consignee`, `cancel_reason`, `rejection_reason`, `cancel_time`, `estimated_delivery_time`, `delivery_status`, `delivery_time`, `pack_amount`, `tableware_number`, `tableware_status`) VALUES (7, '1757400291986', 6, 4, 2, '2025-09-09 15:44:52', NULL, 1, 0, 77.00, '', '13812344321', '幸福小区4单元401', NULL, 'WS', '支付超时，自动取消', NULL, '2025-10-06 10:43:00', '2025-09-09 16:44:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` (`id`, `number`, `status`, `user_id`, `address_book_id`, `order_time`, `checkout_time`, `pay_method`, `pay_status`, `amount`, `remark`, `phone`, `address`, `user_name`, `consignee`, `cancel_reason`, `rejection_reason`, `cancel_time`, `estimated_delivery_time`, `delivery_status`, `delivery_time`, `pack_amount`, `tableware_number`, `tableware_status`) VALUES (8, '1757485378073', 6, 4, 2, '2025-09-10 15:22:58', NULL, 1, 0, 95.00, '', '13812344321', '幸福小区4单元401', NULL, 'WS', '用户取消', NULL, '2025-09-10 15:37:01', '2025-09-10 16:22:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` (`id`, `number`, `status`, `user_id`, `address_book_id`, `order_time`, `checkout_time`, `pay_method`, `pay_status`, `amount`, `remark`, `phone`, `address`, `user_name`, `consignee`, `cancel_reason`, `rejection_reason`, `cancel_time`, `estimated_delivery_time`, `delivery_status`, `delivery_time`, `pack_amount`, `tableware_number`, `tableware_status`) VALUES (9, '1758092935062', 6, 4, 2, '2025-09-17 16:08:55', NULL, 1, 0, 25.00, '', '13812344321', '幸福小区4单元401', NULL, 'WS', '支付超时，自动取消', NULL, '2025-10-06 10:43:00', '2025-09-17 17:08:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` (`id`, `number`, `status`, `user_id`, `address_book_id`, `order_time`, `checkout_time`, `pay_method`, `pay_status`, `amount`, `remark`, `phone`, `address`, `user_name`, `consignee`, `cancel_reason`, `rejection_reason`, `cancel_time`, `estimated_delivery_time`, `delivery_status`, `delivery_time`, `pack_amount`, `tableware_number`, `tableware_status`) VALUES (10, '1759716886454', 6, 4, 2, '2025-10-06 11:14:46', NULL, 1, 0, 45.00, '', '13812344321', '幸福小区4单元401', NULL, 'WS', '支付超时，自动取消', NULL, '2025-10-06 11:30:00', '2025-10-06 12:14:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` (`id`, `number`, `status`, `user_id`, `address_book_id`, `order_time`, `checkout_time`, `pay_method`, `pay_status`, `amount`, `remark`, `phone`, `address`, `user_name`, `consignee`, `cancel_reason`, `rejection_reason`, `cancel_time`, `estimated_delivery_time`, `delivery_status`, `delivery_time`, `pack_amount`, `tableware_number`, `tableware_status`) VALUES (11, '1761481348814', 6, 4, 2, '2025-10-26 21:22:29', NULL, 1, 0, 95.00, '', '13812344321', '幸福小区4单元401', NULL, 'WS', '支付超时，自动取消', NULL, '2025-10-26 21:40:59', '2025-10-26 22:21:00', 0, NULL, 1, 0, 0);
COMMIT;

-- ----------------------------
-- Table structure for setmeal
-- ----------------------------
DROP TABLE IF EXISTS `setmeal`;
CREATE TABLE `setmeal` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `category_id` bigint NOT NULL COMMENT '菜品分类id',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '套餐名称',
  `price` decimal(10,2) NOT NULL COMMENT '套餐价格',
  `status` int DEFAULT '1' COMMENT '售卖状态 0:停售 1:起售',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '描述信息',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '图片',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint DEFAULT NULL COMMENT '创建人',
  `update_user` bigint DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_setmeal_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='套餐';

-- ----------------------------
-- Records of setmeal
-- ----------------------------
BEGIN;
INSERT INTO `setmeal` (`id`, `category_id`, `name`, `price`, `status`, `description`, `image`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (34, 41, '寿司盛り合わせセット', 2500.00, 0, '新鮮な寿司を4種類組み合わせた贅沢なセット。マグロ、サーモン、天ぷら、うなぎの定番寿司をお楽しみいただけます。', 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/7f0f20e3-52b2-4ce2-ab0d-2e0826536a72.png', '2025-10-26 21:10:54', '2025-10-26 21:10:54', 1, 1);
INSERT INTO `setmeal` (`id`, `category_id`, `name`, `price`, `status`, `description`, `image`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (35, 42, '丼物セット', 1200.00, 0, '人気の牛丼と親子丼をセットにしたお得な組み合わせ。ボリュームたっぷりで大満足なセット。', 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/329a43ae-180c-4cf3-bfe5-04c657749429.png', '2025-10-26 21:11:47', '2025-10-26 21:11:47', 1, 1);
INSERT INTO `setmeal` (`id`, `category_id`, `name`, `price`, `status`, `description`, `image`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (36, 43, '麺類セット', 1500.00, 0, 'あっさり塩ラーメンとサクサク天ぷらを組み合わせたセット。麺と揚げ物の絶妙な組み合わせをお楽しみください。', 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/d102c565-19bf-40e1-ab4e-4d59db25ee3d.png', '2025-10-26 21:12:29', '2025-10-26 21:12:29', 1, 1);
INSERT INTO `setmeal` (`id`, `category_id`, `name`, `price`, `status`, `description`, `image`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (37, 44, '日本料理定食セット', 2800.00, 0, '焼き鳥、うどん、天ぷら定食をセットにした豪華な日本料理定食。様々な味をお楽しみいただける満足度の高いセット。', 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/13853c5a-c996-4efe-8f77-e9d28b617449.png', '2025-10-26 21:13:36', '2025-10-26 21:13:36', 1, 1);
INSERT INTO `setmeal` (`id`, `category_id`, `name`, `price`, `status`, `description`, `image`, `create_time`, `update_time`, `create_user`, `update_user`) VALUES (38, 45, '豪華セット', 3800.00, 0, '寿司、丼物、焼き鳥、ラーメンを組み合わせた超豪華なセットメニュー。お友達との食事会に最適なボリューム満点のセット。', 'https://take-out-program-weishu.oss-ap-northeast-1.aliyuncs.com/1b2efe0d-cd77-4033-92ac-78a59ba78a73.png', '2025-10-26 21:14:40', '2025-10-26 21:14:40', 1, 1);
COMMIT;

-- ----------------------------
-- Table structure for setmeal_dish
-- ----------------------------
DROP TABLE IF EXISTS `setmeal_dish`;
CREATE TABLE `setmeal_dish` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `setmeal_id` bigint DEFAULT NULL COMMENT '套餐id',
  `dish_id` bigint DEFAULT NULL COMMENT '菜品id',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '菜品名称 （冗余字段）',
  `price` decimal(10,2) DEFAULT NULL COMMENT '菜品单价（冗余字段）',
  `copies` int DEFAULT NULL COMMENT '菜品份数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='套餐菜品关系';

-- ----------------------------
-- Records of setmeal_dish
-- ----------------------------
BEGIN;
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (54, 34, 76, 'サーモン寿司', 580.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (55, 34, 77, '海老天ぷら寿司', 680.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (56, 34, 78, 'うなぎ寿司', 980.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (57, 34, 79, '巻き寿司セット', 980.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (58, 35, 80, '牛丼', 580.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (59, 35, 81, '親子丼', 680.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (60, 36, 91, '天ぷら定食', 1500.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (61, 36, 85, '塩ラーメン', 780.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (62, 36, 81, '親子丼', 680.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (63, 36, 80, '牛丼', 580.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (64, 37, 91, '天ぷら定食', 1500.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (65, 37, 88, 'うどん', 580.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (66, 37, 90, '焼き鳥盛り合わせ', 1200.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (67, 38, 91, '天ぷら定食', 1500.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (68, 38, 90, '焼き鳥盛り合わせ', 1200.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (69, 38, 83, '天丼', 1200.00, 1);
INSERT INTO `setmeal_dish` (`id`, `setmeal_id`, `dish_id`, `name`, `price`, `copies`) VALUES (70, 38, 79, '巻き寿司セット', 980.00, 1);
COMMIT;

-- ----------------------------
-- Table structure for shopping_cart
-- ----------------------------
DROP TABLE IF EXISTS `shopping_cart`;
CREATE TABLE `shopping_cart` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '商品名称',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '图片',
  `user_id` bigint NOT NULL COMMENT '主键',
  `dish_id` bigint DEFAULT NULL COMMENT '菜品id',
  `setmeal_id` bigint DEFAULT NULL COMMENT '套餐id',
  `dish_flavor` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '口味',
  `number` int NOT NULL DEFAULT '1' COMMENT '数量',
  `amount` decimal(10,2) NOT NULL COMMENT '金额',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='购物车';

-- ----------------------------
-- Records of shopping_cart
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `openid` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '微信用户唯一标识',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '姓名',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手机号',
  `sex` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '性别',
  `id_number` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '身份证号',
  `avatar` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL COMMENT '头像',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='用户信息';

-- ----------------------------
-- Records of user
-- ----------------------------
BEGIN;
INSERT INTO `user` (`id`, `openid`, `name`, `phone`, `sex`, `id_number`, `avatar`, `create_time`) VALUES (4, 'ohxFb11Lh3xVz39sn2YmZNeQWHT0', NULL, NULL, NULL, NULL, NULL, '2025-08-23 19:49:38');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
