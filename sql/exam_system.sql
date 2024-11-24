/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80037 (8.0.37)
 Source Host           : localhost:3306
 Source Schema         : exam_system

 Target Server Type    : MySQL
 Target Server Version : 80037 (8.0.37)
 File Encoding         : 65001

 Date: 24/11/2024 19:39:07
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for answer
-- ----------------------------
DROP TABLE IF EXISTS `answer`;
CREATE TABLE `answer`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '答案表的主键',
  `all_option` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '当前题目所有答案的信息',
  `images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '答案的图片路径',
  `analysis` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '答案解析',
  `question_id` int NOT NULL COMMENT '对应题目的id',
  `true_option` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '正确的选项对应的下标',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `question_id`(`question_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of answer
-- ----------------------------
INSERT INTO `answer` VALUES (1, '1,2', 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-10-26/b1535亚索锐雯.jpg', '1', 5, '0');
INSERT INTO `answer` VALUES (3, '语文,数学,英语,选修课', ',', NULL, 6, '0,1,2');
INSERT INTO `answer` VALUES (10, '0,1', '', '111', 11, '0');
INSERT INTO `answer` VALUES (11, '11,16', '', '16', 12, '1');
INSERT INTO `answer` VALUES (12, '9,8', '', '9', 13, '0');
INSERT INTO `answer` VALUES (13, '4,3', 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-10-27/1950327D.jpg', '4', 14, '0');
INSERT INTO `answer` VALUES (14, '18,11', 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-10-27/583a91522134986336591.jpg', '18', 15, '0');
INSERT INTO `answer` VALUES (15, '1', '', '1', 16, '0');
INSERT INTO `answer` VALUES (16, '4,3', '', '4', 17, '0');
INSERT INTO `answer` VALUES (17, '1,2,3,4', ',,,', NULL, 18, '0,1');
INSERT INTO `answer` VALUES (18, '奇数,偶数', '', '奇数', 19, '0');
INSERT INTO `answer` VALUES (19, '奇数,偶数', '', '奇数', 20, '0');
INSERT INTO `answer` VALUES (20, '111,222,333', '', NULL, 21, '0,1,2');
INSERT INTO `answer` VALUES (21, '1', '', '1', 22, '0');
INSERT INTO `answer` VALUES (22, '', '', '', 23, '0');

-- ----------------------------
-- Table structure for exam
-- ----------------------------
DROP TABLE IF EXISTS `exam`;
CREATE TABLE `exam`  (
  `exam_id` int NOT NULL AUTO_INCREMENT,
  `exam_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '考试名称',
  `exam_desc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '考试描述',
  `type` int NOT NULL DEFAULT 1 COMMENT '1完全公开  2需要密码',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '需要密码考试的密码',
  `duration` int NOT NULL COMMENT '考试时长',
  `start_time` date NULL DEFAULT NULL COMMENT '考试开始时间',
  `end_time` date NULL DEFAULT NULL COMMENT '考试结束时间',
  `total_score` int NOT NULL COMMENT '考试总分',
  `pass_score` int NOT NULL COMMENT '考试通过线',
  `status` int NOT NULL DEFAULT 1 COMMENT '1有效 2无效',
  PRIMARY KEY (`exam_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam
-- ----------------------------
INSERT INTO `exam` VALUES (9, '小学入学考试', '对小学生做一个评估', 2, NULL, 1, NULL, NULL, 10, 6, 1);
INSERT INTO `exam` VALUES (10, '多选题练习考试', '滴滴', 1, NULL, 1, NULL, NULL, 2, 1, 1);
INSERT INTO `exam` VALUES (11, '测试123', '2113', 2, '12345', 1, '2020-11-01', NULL, 1, 1, 1);
INSERT INTO `exam` VALUES (12, '全能考试', '啥都考', 1, NULL, 4, NULL, NULL, 12, 7, 1);
INSERT INTO `exam` VALUES (13, '过期的考试', '测试过期', 1, NULL, 1, '2020-10-31', '2020-11-01', 3, 1, 1);
INSERT INTO `exam` VALUES (14, '阿达', '阿达', 1, NULL, 1, '2021-01-04', '2021-01-22', 3, 1, 1);
INSERT INTO `exam` VALUES (15, 'test', 'desc', 1, NULL, 2, '2021-01-03', '2021-01-19', 10, 1, 1);

-- ----------------------------
-- Table structure for exam_question
-- ----------------------------
DROP TABLE IF EXISTS `exam_question`;
CREATE TABLE `exam_question`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `question_ids` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '考试的题目id列表',
  `exam_id` int NOT NULL COMMENT '考试的id',
  `scores` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '每一题的分数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_question
-- ----------------------------
INSERT INTO `exam_question` VALUES (5, '12,13,15,3,6,8,18,11,19,14', 9, '1,1,1,1,1,1,1,1,1,1');
INSERT INTO `exam_question` VALUES (6, '6,18', 10, '1,1');
INSERT INTO `exam_question` VALUES (7, '3', 11, '1');
INSERT INTO `exam_question` VALUES (8, '3,6,8,11,12,13,14,15,18,19,20,21', 12, '1,1,1,1,1,1,1,1,1,1,1,1');
INSERT INTO `exam_question` VALUES (9, '18,19,15', 13, '1,1,1');
INSERT INTO `exam_question` VALUES (12, '3,21,22', 14, '1,1,1');
INSERT INTO `exam_question` VALUES (13, '11,8,3,12,13,14,18,15,19,6', 15, '1,1,1,1,1,1,1,1,1,1');

-- ----------------------------
-- Table structure for exam_record
-- ----------------------------
DROP TABLE IF EXISTS `exam_record`;
CREATE TABLE `exam_record`  (
  `record_id` int NOT NULL AUTO_INCREMENT COMMENT '考试记录的id',
  `user_id` int NOT NULL COMMENT '考试用户的id',
  `user_answers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户的答案列表',
  `credit_img_url` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '考试诚信截图',
  `exam_id` int NOT NULL COMMENT '考试的id',
  `logic_score` int NULL DEFAULT NULL COMMENT '考试的逻辑得分(除简答)',
  `exam_time` datetime NOT NULL COMMENT '考试时间',
  `question_ids` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '考试的题目信息',
  `total_score` int NULL DEFAULT NULL COMMENT '考试总分数 (逻辑+简答)',
  `error_question_ids` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户考试的错题',
  PRIMARY KEY (`record_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_record
-- ----------------------------
INSERT INTO `exam_record` VALUES (1, 1, '1-1-0-1-0-1,2-1,2-1-java是全世界最好的语言.jpg-小学是童年', 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-11-05/b09d7examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-11-05/ab243examTakePhoto.png', 9, 3, '2020-11-05 19:28:40', '11,13,14,12,15,6,18,19,3,8', 5, '11,13,6,18,19,14');
INSERT INTO `exam_record` VALUES (2, 1, '1', 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-11-07/95c31examTakePhoto.png', 11, 0, '2020-11-07 11:34:50', '3', 1, NULL);
INSERT INTO `exam_record` VALUES (3, 1, '0-1-0-0-0-0,1,2-0,1-0,1,2-0-0-12345-56', 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-11-08/2d0e2examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-11-08/bbca9examTakePhoto.png', 12, 10, '2020-11-08 09:15:16', '11,12,13,14,15,6,18,21,19,20,3,8', 12, NULL);
INSERT INTO `exam_record` VALUES (4, 2, '0-0-0-1-0-0,1,2-0,1-0-wqe-eqweq', 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-11-08/411a8examTakePhoto.png', 9, 8, '2020-11-08 09:20:27', '11,13,14,12,15,6,18,19,3,8', 10, NULL);
INSERT INTO `exam_record` VALUES (5, 2, '0,1,2-1,2', 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-11-08/ebdd9examTakePhoto.png', 10, 1, '2020-11-08 10:57:00', '6,18', 1, '18');
INSERT INTO `exam_record` VALUES (6, 1, '0-0-0-0-1-1-2-1-23-156', 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/8c282examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/7fdf0examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/ca048examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/2cafcexamTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/bbf68examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/977b7examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/f8061examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/948c5examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/eff69examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/811aaexamTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/d9279examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/3fc0cexamTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/6ff2eexamTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/c4400examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/243b6examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/07a2fexamTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/f1176examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/07c1bexamTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/d0a45examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/b8037examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/95438examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/b185dexamTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/259b8examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/a8a37examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/08f17examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/329a5examTakePhoto.png', 9, 5, '2020-12-01 21:41:58', '11,15,13,14,12,18,6,19,3,8', NULL, '18,6,19');
INSERT INTO `exam_record` VALUES (7, 1, '0-0-0-1-0-0,1,2-0,1-0-java-大大', 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/41206examTakePhoto.png', 9, 8, '2020-12-01 21:45:30', '11,13,14,12,15,6,18,19,3,8', NULL, NULL);
INSERT INTO `exam_record` VALUES (9, 1, '0-1-0-0-0-1-2-1-是-sad', 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-12-01/0fe10examTakePhoto.png', 9, 3, '2020-12-01 21:48:45', '11,13,14,12,15,6,18,19,3,8', NULL, '13,12,6,18,19');
INSERT INTO `exam_record` VALUES (10, 1, '0-0-0-0-0-1,3-1,2,3-1-656', 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2021-01-14/b9f75examTakePhoto.png,https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2021-01-14/bc3f7examTakePhoto.png', 9, 4, '2021-01-14 18:45:42', '12,13,15,11,14,6,18,19,3,8', 6, '12,6,18,19');
INSERT INTO `exam_record` VALUES (14, 1, '0-1-0-1-1-1--1 -', 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2021-01-15/eb067examTakePhoto.png', 9, 1, '2021-01-15 10:25:05', '12,11,14,13,15,6,18,19,3,8', NULL, '12,11,13,15,6,18,19');
INSERT INTO `exam_record` VALUES (15, 2, '1-0-0 - - - - - -', '', 9, 2, '2021-01-15 10:18:54', '12,13,15,11,14,6,18,19,3,8', 4, '15,11,14,6,18,19');
INSERT INTO `exam_record` VALUES (16, 1, '- - - - - - - - - - - -  - - - - - - - - - - - -', '', 12, 0, '2021-02-08 13:31:19', '11,12,13,14,15,6,18,21,19,20,3,8', NULL, '11,12,13,14,15,6,18,21,19,20');
INSERT INTO `exam_record` VALUES (17, 1, '0------0,1,2----java web-php web', '', 12, 1, '2021-02-08 13:38:39', '11,12,13,14,15,6,18,21,19,20,3,8', NULL, '12,13,14,15,6,18,21,19,20');
INSERT INTO `exam_record` VALUES (18, 1, '0,1,2-0,1', '', 10, 2, '2021-02-08 13:38:57', '6,18', NULL, NULL);
INSERT INTO `exam_record` VALUES (23, 15, '0-0-1-0-0 - - - -', '', 9, 2, '2024-10-20 14:51:27', '11,12,13,14,15,6,18,19,3,8', NULL, '12,13,15,6,18,19');
INSERT INTO `exam_record` VALUES (24, 15, '0-1-0-0-0-0-0,1-0-34234-234', '', 9, 7, '2024-10-20 14:52:14', '11,12,13,14,15,6,18,19,3,8', NULL, '6');
INSERT INTO `exam_record` VALUES (25, 16, '0-1-0-0-0-0,1,2-0,1-1-11-11', '', 9, 7, '2024-11-02 14:25:03', '11,12,13,14,15,6,18,19,3,8', NULL, '19');

-- ----------------------------
-- Table structure for interview_participant
-- ----------------------------
DROP TABLE IF EXISTS `interview_participant`;
CREATE TABLE `interview_participant`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `room_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `user_id` int NOT NULL,
  `role` enum('teacher','student') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `joined_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `is_muted` tinyint(1) NULL DEFAULT 0,
  `is_kicked` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of interview_participant
-- ----------------------------
INSERT INTO `interview_participant` VALUES (1, '1fa206a0-54d3-433e-91c4-92e3f13c7e8a', 19, 'student', '2024-11-21 18:17:35', 0, 0);
INSERT INTO `interview_participant` VALUES (2, '1fa206a0-54d3-433e-91c4-92e3f13c7e8a', 19, 'student', '2024-11-21 18:17:38', 0, 0);
INSERT INTO `interview_participant` VALUES (3, '572629b8-c40f-4acd-bc24-1ad8edc71154', 19, 'student', '2024-11-21 18:17:44', 0, 0);
INSERT INTO `interview_participant` VALUES (4, '1fa206a0-54d3-433e-91c4-92e3f13c7e8a', 19, 'student', '2024-11-21 18:20:30', 0, 0);
INSERT INTO `interview_participant` VALUES (5, '580769ed-efe4-4202-9ffc-992af15442db', 19, 'student', '2024-11-21 18:23:37', 0, 0);
INSERT INTO `interview_participant` VALUES (6, '72a04f40-b535-4c98-9085-79046e04ead8', 19, 'student', '2024-11-21 18:35:31', 0, 0);
INSERT INTO `interview_participant` VALUES (7, '5ff0b74a-244a-46bd-8bf6-cd30cffaa1b4', 19, 'student', '2024-11-21 18:48:20', 0, 0);
INSERT INTO `interview_participant` VALUES (8, '943d4abc-9d00-4bbc-8c85-05cc79261f88', 19, 'student', '2024-11-21 18:56:19', 0, 0);
INSERT INTO `interview_participant` VALUES (9, 'c8127916-2582-40db-aa6f-156dbe6a487b', 19, 'student', '2024-11-21 18:56:21', 0, 0);
INSERT INTO `interview_participant` VALUES (10, 'd94ae59b-32dc-4f6c-aaf3-2653402bdc46', 19, 'student', '2024-11-21 18:56:24', 0, 0);
INSERT INTO `interview_participant` VALUES (11, '580769ed-efe4-4202-9ffc-992af15442db', 20, 'teacher', '2024-11-21 19:26:38', 0, 0);

-- ----------------------------
-- Table structure for interview_room
-- ----------------------------
DROP TABLE IF EXISTS `interview_room`;
CREATE TABLE `interview_room`  (
  `id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '随机ID',
  `room_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '房间名称',
  `creator_id` int NOT NULL COMMENT '创建者ID',
  `creator_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '教师昵称',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `status` enum('active','closed') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'active' COMMENT '房间状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of interview_room
-- ----------------------------
INSERT INTO `interview_room` VALUES ('0c5e6c07-8de7-4f2f-96f2-392592bcda9c', '123123', 19, '123', '2024-11-21 11:24:46', 'closed');
INSERT INTO `interview_room` VALUES ('1fa206a0-54d3-433e-91c4-92e3f13c7e8a', '123233', 19, '1234', '2024-11-21 10:44:29', 'active');
INSERT INTO `interview_room` VALUES ('572629b8-c40f-4acd-bc24-1ad8edc71154', '2', 19, '1', '2024-11-21 11:37:43', 'active');
INSERT INTO `interview_room` VALUES ('580769ed-efe4-4202-9ffc-992af15442db', 'w', 19, 'q', '2024-11-21 11:45:33', 'active');
INSERT INTO `interview_room` VALUES ('5a73a439-a4cc-4407-b74e-e2c5f85eae34', '333', 19, '123', '2024-11-21 10:49:45', 'active');
INSERT INTO `interview_room` VALUES ('5ff0b74a-244a-46bd-8bf6-cd30cffaa1b4', '123', 19, '123', '2024-11-21 11:19:22', 'active');
INSERT INTO `interview_room` VALUES ('709f8cc7-e3a7-42bf-aaaa-73cc64ae615a', '1', 19, '1', '2024-11-21 11:41:55', 'active');
INSERT INTO `interview_room` VALUES ('72a04f40-b535-4c98-9085-79046e04ead8', '3', 19, '3', '2024-11-21 11:43:38', 'active');
INSERT INTO `interview_room` VALUES ('744a8316-b6ee-4411-adfb-920d3d40cc9b', '123233', 19, '123', '2024-11-21 10:34:40', 'active');
INSERT INTO `interview_room` VALUES ('7750db37-76f1-4983-878d-4a704f62a7cd', '333', 19, '123', '2024-11-21 10:49:36', 'active');
INSERT INTO `interview_room` VALUES ('8ab2c231-c04b-4a3c-926a-5973ff1df40b', '123233', 19, '1234', '2024-11-21 10:38:14', 'active');
INSERT INTO `interview_room` VALUES ('943d4abc-9d00-4bbc-8c85-05cc79261f88', '1231231', 19, 'teacher123', '2024-11-21 11:14:36', 'active');
INSERT INTO `interview_room` VALUES ('a2376757-7047-4732-9e4d-8f69445fae58', '2', 19, '2', '2024-11-21 11:43:53', 'active');
INSERT INTO `interview_room` VALUES ('a8943281-1670-4ba2-8291-e821c1adae0a', '3', 19, '2', '2024-11-21 11:40:25', 'active');
INSERT INTO `interview_room` VALUES ('aa8929fe-f525-4075-be85-6d0ae5124e7e', '123', 19, '123333', '2024-11-21 18:34:37', 'active');
INSERT INTO `interview_room` VALUES ('b8e8c084-0037-474c-9b37-4590d953eaea', '123', 19, '13', '2024-11-21 10:46:28', 'active');
INSERT INTO `interview_room` VALUES ('bdc6d6bb-b793-4faf-b523-bed2c8a3273d', '3', 19, '2', '2024-11-21 18:48:46', 'active');
INSERT INTO `interview_room` VALUES ('c8127916-2582-40db-aa6f-156dbe6a487b', '2', 19, '2', '2024-11-21 11:45:24', 'active');
INSERT INTO `interview_room` VALUES ('c9036afb-e731-4958-ac0b-1939f9f67880', '11', 19, '11', '2024-11-21 10:51:39', 'active');
INSERT INTO `interview_room` VALUES ('cc75be72-d8de-4c3d-8abb-d7bae89a6434', '424', 19, '33242', '2024-11-21 11:44:12', 'active');
INSERT INTO `interview_room` VALUES ('cf76254b-e5c5-4716-aa1f-b607505cde2e', '22', 19, '22', '2024-11-21 11:37:19', 'active');
INSERT INTO `interview_room` VALUES ('d94ae59b-32dc-4f6c-aaf3-2653402bdc46', '1234', 19, '13', '2024-11-21 11:02:54', 'active');
INSERT INTO `interview_room` VALUES ('da397e8d-4ce5-4c99-a540-7371909bbf27', '333', 19, '123', '2024-11-21 10:51:32', 'closed');
INSERT INTO `interview_room` VALUES ('dc88abb1-3146-46f0-91cc-9a1db1565fdd', '123233', 19, '1234', '2024-11-21 10:38:21', 'closed');
INSERT INTO `interview_room` VALUES ('e2adf8b8-6529-4339-9d7d-6c8bc0c18253', '2', 19, 'q', '2024-11-21 11:42:09', 'closed');
INSERT INTO `interview_room` VALUES ('e7a3b118-e160-4652-a962-1fcd68866ca2', '2', 19, '2', '2024-11-21 11:45:58', 'closed');

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `n_id` int NOT NULL AUTO_INCREMENT COMMENT '系统公告id',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告内容',
  `create_time` datetime NULL DEFAULT NULL COMMENT '公告创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新此公告时间',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0(不是当前系统公告) 1(是当前系统公告)',
  PRIMARY KEY (`n_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '<ul><li><font color=\"#c24f4a\">2020/11/14 更新:</font></li><ol><li>网易云音乐线上体验地址:&nbsp;<a href=\"http://music.wzzz.fun/\" target=\"_blank\">http://music.wzzz.fun</a></li><li>博客系统线上体验地址:&nbsp;<a href=\"http://blog.wzzz.fun/\" target=\"_blank\">http://blog.wzzz.fun</a>&nbsp;&nbsp;<span style=\"background-color: rgb(249, 150, 59);\">(账号:wzz 密码:111)</span></li><li>考试系统线上体验地址:&nbsp;<a href=\"http://exam.wzzz.fun/\" target=\"_blank\">http://exam.wzzz.fun</a>&nbsp;<span style=\"background-color: rgb(249, 150, 59);\">(账号:wzz 密码:12345)</span></li></ol><p><span style=\"background-color: rgb(249, 150, 59);\">为了各位有良好的体验,请不要更改演示账号的权限以及密码</span></p></ul><hr/><ul><li><span style=\"color: rgb(194, 79, 74); text-align: initial;\">2021/02/07更新:</span></li></ul><ul><ol><li>注册验证码校验</li><li>主页面小屏样式更改</li><li>题库训练弹窗在小屏样式调整</li><li>修复添加考试时选择需要密码权限时,密码为空的情况</li><li>修复更新考试时选择需要密码权限时,密码为空的情况</li><li><font color=\"#f9963b\" style=\"background-color: rgb(238, 236, 224);\">新增</font><font color=\"#f9963b\" style=\"\"><span style=\"background-color: rgb(139, 170, 74);\">公告</span><span style=\"background-color: rgb(238, 236, 224);\">功能</span></font>(管理员可改,其他用户可以查看公告)</li><li>修复考试提交试卷业务逻辑BUG</li></ol></ul><hr/><ul><li><font color=\"#c24f4a\">2021/02/08更新:</font><br/></li><ol><li><span style=\"background-color: rgb(249, 150, 59);\">新增测验通过之后的</span><span style=\"background-color: rgb(139, 170, 74);\">发放证书</span><span style=\"background-color: rgb(249, 150, 59);\">功能 (我的成绩模块中)</span></li><li>&nbsp;考试多选题结果数据过滤逻辑优化</li></ol></ul>', '2021-02-07 15:52:45', '2021-02-08 14:10:45', 1);
INSERT INTO `notice` VALUES (4, '<p>发布公告测试<br/></p>', '2021-02-07 17:02:07', '2021-02-07 17:05:13', 0);

-- ----------------------------
-- Table structure for question
-- ----------------------------
DROP TABLE IF EXISTS `question`;
CREATE TABLE `question`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `qu_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '问题内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `qu_type` int NOT NULL COMMENT '问题类型 1单选 2多选 3判断 4简答',
  `level` int NOT NULL DEFAULT 1 COMMENT '题目难度 1简单 2中等 3困难',
  `image` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '图片',
  `qu_bank_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属题库id',
  `qu_bank_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属题库名称',
  `analysis` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '解析',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question
-- ----------------------------
INSERT INTO `question` VALUES (3, '实现web后端的语言', '2020-10-24 16:30:08', 'wzz', 4, 2, NULL, '1,2,5', '小学数学题库,生活小常识,java开发', '解析');
INSERT INTO `question` VALUES (6, '以下哪些语言是必修课', '2020-11-02 10:11:28', 'wzz', 2, 1, NULL, '1,5', '小学数学题库,java开发', '语文 数学 英语');
INSERT INTO `question` VALUES (8, '说说小学是什么样的?', '2020-11-02 10:12:02', 'wzz', 4, 3, NULL, '1,5', '小学数学题库,java开发', '说亲身经历即可');
INSERT INTO `question` VALUES (11, '1-1', '2020-10-27 14:35:33', 'wzz', 1, 1, NULL, '1,5', '小学数学题库,java开发', '0');
INSERT INTO `question` VALUES (12, '8+8', '2020-10-27 15:32:44', 'wzz', 1, 3, NULL, '1,5', '小学数学题库,java开发', '16');
INSERT INTO `question` VALUES (13, '1 * 9', '2020-10-27 15:13:38', 'wzz', 1, 1, NULL, '1,5', '小学数学题库,java开发', '9');
INSERT INTO `question` VALUES (14, '2+2', '2020-10-27 16:17:09', 'wzz', 1, 1, 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-10-27/e4f71d9b67b4a15ce2ec638c908b00dc506ab.png', '1,5', '小学数学题库,java开发', '4');
INSERT INTO `question` VALUES (15, '9+9', '2020-10-27 15:53:14', 'wzz', 1, 1, 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-10-27/47ccdd9b67b4a15ce2ec638c908b00dc506ab.png', '1,5', '小学数学题库,java开发', '18');
INSERT INTO `question` VALUES (18, '最接近0的两个数', '2020-11-02 10:09:13', 'wzz', 2, 2, NULL, '1', '小学数学题库', '1和2');
INSERT INTO `question` VALUES (19, '1是不是奇数', '2020-10-31 14:54:09', 'wzz', 3, 1, NULL, '1', '小学数学题库', '是');
INSERT INTO `question` VALUES (20, '9是奇数还是偶数', '2020-11-02 10:21:19', 'wzz', 3, 1, NULL, '1', '小学数学题库', '奇数');
INSERT INTO `question` VALUES (21, '哪几个是三位数', '2020-11-05 14:42:56', 'wzz', 2, 1, NULL, '1,2', '小学数学题库,生活小常识', '数数');
INSERT INTO `question` VALUES (22, '测试', '2020-12-27 21:03:31', 'wzz', 1, 1, NULL, '2', '生活小常识', '测试');

-- ----------------------------
-- Table structure for question_bank
-- ----------------------------
DROP TABLE IF EXISTS `question_bank`;
CREATE TABLE `question_bank`  (
  `bank_id` int NOT NULL AUTO_INCREMENT,
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`bank_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question_bank
-- ----------------------------
INSERT INTO `question_bank` VALUES (1, '小学数学题库');
INSERT INTO `question_bank` VALUES (2, '生活小常识');
INSERT INTO `question_bank` VALUES (5, 'java开发');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` int NOT NULL DEFAULT 1 COMMENT '1(学生) 2(教师) 3(管理员)',
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `true_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `salt` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` int NOT NULL DEFAULT 1 COMMENT '用户是否被禁用 1正常 2禁用',
  `create_date` datetime NOT NULL COMMENT '用户创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 3, 'wzz', 'GaryZhouz', '9499273223c7aca5949e3055eaa57f6f', 'c667d6', 1, '2020-10-22 15:05:15');
INSERT INTO `user` VALUES (2, 1, 'w', '学生王某', '9499273223c7aca5949e3055eaa57f6f', 'c667d6', 1, '2020-10-22 10:46:25');
INSERT INTO `user` VALUES (3, 2, 'zz', '教师', 'c45cd81a5f4f205bc6f5fbec7f42faaa', '304cba', 1, '2020-10-22 11:10:12');
INSERT INTO `user` VALUES (4, 1, 'lx', '刘', '98d4fa4da534339cbed32b62d7b246c7', 'ccb14b', 1, '2020-10-22 18:13:20');
INSERT INTO `user` VALUES (5, 1, 'mc', '马', '2a2176cb62f5a62d396dbb2bdeed294c', '605d1c', 1, '2020-10-22 15:51:51');
INSERT INTO `user` VALUES (6, 1, 'amao', '阿毛', '41b8d2eff6cd26fc425be6ab343de397', '8e2880', 1, '2020-10-22 15:52:30');
INSERT INTO `user` VALUES (8, 1, 'mq', 'sada', '6d0e86b7df3040a3de6b7dce73a7d818', '8097b9', 1, '2020-10-22 15:54:48');
INSERT INTO `user` VALUES (9, 1, 'shepi', '蛇皮', '4ba6f54cc49fac7afc907b0b5fbfd7ac', 'c6ce5f', 1, '2020-10-22 15:55:04');
INSERT INTO `user` VALUES (10, 1, 'zzb', '张', '62e9ce36958d0ee247a145d29caab889', '9a9d8c', 1, '2020-10-22 15:55:25');
INSERT INTO `user` VALUES (11, 1, 'pgl', '潘', 'f7dcc6093292b30c698ec73bca37a7a4', 'd6da4b', 1, '2020-10-22 15:55:52');
INSERT INTO `user` VALUES (12, 1, 'wjh', '王', 'c94de75b9de1b60e2c5261dfade215f2', '33641a', 1, '2020-10-23 09:54:55');
INSERT INTO `user` VALUES (13, 3, 'll', '丽丽', '0b600b5d50de0f1207a2a045bc22debf', '0824f0', 1, '2020-10-23 10:02:09');
INSERT INTO `user` VALUES (14, 1, 'xx', '小熊', 'e6c3cbb37ea43ed7f513546d997073e4', '72505b', 1, '2020-11-30 12:25:55');
INSERT INTO `user` VALUES (15, 1, '233', 'xlf', '7e4ded2f77a86d8b96c248e15417af4f', '989cda', 1, '2024-10-20 14:35:37');
INSERT INTO `user` VALUES (16, 1, '123', '123', 'c456ec14d94a2873ff2be1d285dd73c0', '94d95f', 1, '2024-11-02 14:23:59');
INSERT INTO `user` VALUES (17, 1, '1234', 'x', '5036dc16f5d72f4406edac711050b68a', '4d78a0', 1, '2024-11-16 14:17:05');
INSERT INTO `user` VALUES (18, 3, 'admin123', 'Admin', '7e2aa2e6c397494c5814db9a8167aeef', 'c667d6', 1, '2024-11-19 15:55:43');
INSERT INTO `user` VALUES (19, 2, 'teacher123', 'ttt', '48bb963c57a6caec3ffaf8c16b0d2c1c', '3835b2', 1, '2024-11-19 16:06:13');
INSERT INTO `user` VALUES (20, 1, 'scut123', 'scut123', '9830837f4e10ec0237365fa1c822fa3a', 'abf907', 1, '2024-11-21 15:43:05');

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role`  (
  `id` int NOT NULL,
  `role_id` int NOT NULL DEFAULT 1 COMMENT '1学生 2教师 3超级管理员',
  `role_name` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `menu_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主页的菜单信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_role
-- ----------------------------
INSERT INTO `user_role` VALUES (1, 1, '学生', '[\n  {\n    \"topMenuName\": \"在线考试\",\n    \"topIcon\": \"el-icon-menu\",\n    \"submenu\": [\n      {\n        \"name\": \"在线考试\",\n        \"icon\": \"el-icon-s-promotion\",\n        \"url\": \"/examOnline\"\n      },\n      {\n        \"name\": \"我的成绩\",\n        \"icon\": \"el-icon-trophy\",\n        \"url\": \"/myGrade\"\n      },\n      {\n        \"name\": \"我的题库\",\n        \"icon\": \"el-icon-notebook-2\",\n        \"url\": \"/myQuestionBank\"\n      },\n      {\n        \"name\": \"面试\",\n        \"icon\": \"el-icon-video-camera\",\n        \"url\": \"/video-interview\"\n      }\n    ]\n  }\n]');
INSERT INTO `user_role` VALUES (2, 2, '教师', '[\n    {\n        \"topMenuName\": \"考试管理\",\n        \"topIcon\": \"el-icon-bangzhu\",\n        \"submenu\": [\n            {\n                \"name\": \"题库管理\",\n                \"icon\": \"el-icon-aim\",\n                \"url\": \"/questionBankMange\"\n            },\n            {\n                \"name\": \"试题管理\",\n                \"icon\": \"el-icon-news\",\n                \"url\": \"/questionManage\"\n            },\n            {\n                \"name\": \"考试管理\",\n                \"icon\": \"el-icon-tickets\",\n                \"url\": \"/examManage\"\n            },\n            {\n                \"name\": \"阅卷管理\",\n                \"icon\": \"el-icon-view\",\n                \"url\": \"/markManage\"\n            },\n            {\n                \"name\": \"面试管理\",\n                \"icon\": \"el-icon-video-camera-solid\",\n                \"url\": \"/video-interview-management\"\n            }\n        ]\n    }\n]');
INSERT INTO `user_role` VALUES (3, 3, '超级管理员', '[{\"topMenuName\":\"产品介绍\",\"topIcon\":\"el-icon-odometer\",\"url\":\"/dashboard\"},{\"topMenuName\":\"在线考试\",\"topIcon\":\"el-icon-menu\",\"submenu\":[{\"name\":\"在线考试\",\"icon\":\"el-icon-s-promotion\",\"url\":\"/examOnline\"},{\"name\":\"我的成绩\",\"icon\":\"el-icon-trophy\",\"url\":\"/myGrade\"},{\"name\":\"我的题库\",\"icon\":\"el-icon-notebook-2\",\"url\":\"/myQuestionBank\"}]},{\"topMenuName\":\"考试管理\",\"topIcon\":\"el-icon-bangzhu\",\"submenu\":[{\"name\":\"题库管理\",\"icon\":\"el-icon-aim\",\"url\":\"/questionBankMange\"},{\"name\":\"试题管理\",\"icon\":\"el-icon-news\",\"url\":\"/questionManage\"},{\"name\":\"考试管理\",\"icon\":\"el-icon-tickets\",\"url\":\"/examManage\"},{\"name\":\"阅卷管理\",\"icon\":\"el-icon-view\",\"url\":\"/markManage\"}]},{\"topMenuName\":\"考试统计\",\"topIcon\":\"el-icon-pie-chart\",\"submenu\":[{\"name\":\"统计总览\",\"icon\":\"el-icon-data-line\",\"url\":\"/staticOverview\"}]},{\"topMenuName\":\"系统设置\",\"topIcon\":\"el-icon-setting\",\"submenu\":[{\"name\":\"公告管理\",\"icon\":\"el-icon-bell\",\"url\":\"/noticeManage\"},{\"name\":\"角色管理\",\"icon\":\"el-icon-s-custom\",\"url\":\"/roleManage\"},{\"name\":\"用户管理\",\"icon\":\"el-icon-user-solid\",\"url\":\"/userManage\"}]}]');

SET FOREIGN_KEY_CHECKS = 1;
