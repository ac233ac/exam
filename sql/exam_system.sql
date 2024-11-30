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

 Date: 30/11/2024 15:16:02
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
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of answer
-- ----------------------------
INSERT INTO `answer` VALUES (1, '1,2', 'https://wangsiryun.oss-cn-beijing.aliyuncs.com/images/upload/2020-10-26/b1535亚索锐雯.jpg', '1', 5, '0');
INSERT INTO `answer` VALUES (15, '1', '', '1', 16, '0');
INSERT INTO `answer` VALUES (16, '4,3', '', '4', 17, '0');
INSERT INTO `answer` VALUES (22, '', '', '', 23, '0');
INSERT INTO `answer` VALUES (24, '①②③,①②④,①③④,②③④', '', '', 24, '3');
INSERT INTO `answer` VALUES (25, '张桂梅——坚持志愿服务十余载 群众心中的“活雷锋”,王兰花——点亮贫困山区女孩梦想的“校长妈妈”,孙景坤——公而忘私 永葆革命本色的战斗功臣,李宏塔——为国守海寸步不让 带领群众共同致富', '', '', 25, '2');
INSERT INTO `answer` VALUES (26, '1项,2项,3项,4项', '', '', 26, '1');
INSERT INTO `answer` VALUES (27, '现行标准下区域性整体贫困得到解决,“输血式”扶贫方针是中国特色减贫道路的鲜明特征,锻造形成了“上下同心、尽锐出战、精准务实、开拓创新、攻坚克难、不负人民”的脱贫攻坚精神,从集中资源支持脱贫攻坚转向巩固拓展脱贫攻坚成果和全面推进乡村振兴', '', '', 27, '1');

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
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam
-- ----------------------------
INSERT INTO `exam` VALUES (17, '行测随机测试', '行测随机测试', 1, NULL, 1, '2024-11-28', '2024-12-12', 3, 2, 1);
INSERT INTO `exam` VALUES (18, '行测随机测试2', '', 1, NULL, 5, '2024-11-20', '2024-12-06', 4, 2, 1);
INSERT INTO `exam` VALUES (19, '行测123', '', 1, NULL, 1, '2024-11-20', '2024-11-29', 4, 2, 1);
INSERT INTO `exam` VALUES (20, '行测4', '', 1, NULL, 1, '2024-11-28', '2024-11-29', 4, 2, 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_question
-- ----------------------------
INSERT INTO `exam_question` VALUES (16, '25,26,27', 17, '1,1,1');
INSERT INTO `exam_question` VALUES (17, '24,25,26,27', 18, '1,1,1,1');
INSERT INTO `exam_question` VALUES (18, '24,25,26,27', 19, '1,1,1,1');
INSERT INTO `exam_question` VALUES (19, '24,25,26,27', 20, '1,1,1,1');

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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_record
-- ----------------------------
INSERT INTO `exam_record` VALUES (1, 20, '0', ',', 16, 0, '2024-11-29 23:41:55', '24', 0, '24');
INSERT INTO `exam_record` VALUES (2, 20, '2-1-1', '', 17, 3, '2024-11-30 00:36:35', '25,26,27', 3, NULL);
INSERT INTO `exam_record` VALUES (3, 20, '2-2-1-1', '', 18, 3, '2024-11-30 00:40:25', '24,25,26,27', 3, '24');
INSERT INTO `exam_record` VALUES (4, 21, '2-0-0', '', 17, 1, '2024-11-30 00:42:39', '25,26,27', 1, '26,27');
INSERT INTO `exam_record` VALUES (5, 21, '2-2-2-1', '', 18, 2, '2024-11-30 00:43:10', '24,25,26,27', 2, '24,26');
INSERT INTO `exam_record` VALUES (6, 22, '2-2-1', '', 17, 2, '2024-11-30 00:45:57', '25,26,27', 2, '26');
INSERT INTO `exam_record` VALUES (7, 22, '0-0-0', '', 17, 0, '2024-11-30 00:46:56', '25,26,27', 0, '25,26,27');
INSERT INTO `exam_record` VALUES (8, 20, '2-2-1', ',', 17, 2, '2024-11-30 01:25:35', '25,26,27', 2, '26');
INSERT INTO `exam_record` VALUES (9, 20, '2-1-1', ',', 17, 3, '2024-11-30 01:28:22', '25,26,27', NULL, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `interview_participant` VALUES (12, '1fa206a0-54d3-433e-91c4-92e3f13c7e8a', 22, 'teacher', '2024-11-30 00:50:05', 0, 0);
INSERT INTO `interview_participant` VALUES (13, '1fa206a0-54d3-433e-91c4-92e3f13c7e8a', 20, 'teacher', '2024-11-30 01:20:21', 0, 0);

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
INSERT INTO `interview_room` VALUES ('3504f7bd-708e-4541-81b8-2b6def7af38c', '面试11', 19, 'teacher13', '2024-11-30 01:21:30', 'active');
INSERT INTO `interview_room` VALUES ('4954d7f0-ffae-4d83-b22c-5e0ffb283220', '公务员面试', 19, 'teacher123', '2024-11-30 01:18:39', 'active');
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
INSERT INTO `interview_room` VALUES ('9889809e-5caf-49cd-b4b9-b1c23cb1b06a', '面试11', 19, 'teacher123', '2024-11-30 01:23:31', 'active');
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
INSERT INTO `notice` VALUES (1, '<ul><li><font color=\"#c24f4a\">2024/11/18 更新:</font></li><ol><li>新增面试功能</li></ol></ul><hr/><ul><li><span style=\"color: rgb(194, 79, 74); text-align: initial;\">2023/11/13更新:</span></li></ul><ul><ol><li>注册验证码校验</li><li>主页面小屏样式更改</li><li>题库训练弹窗在小屏样式调整</li><li>修复添加考试时选择需要密码权限时,密码为空的情况</li><li>修复更新考试时选择需要密码权限时,密码为空的情况</li><li><span style=\"background-color: rgb(255, 255, 255);\"><font color=\"#7b5ba1\">新增公告功能</font>(管理员可改,其他用户可以查看公告)</span></li><li>修复考试提交试卷业务逻辑BUG</li></ol></ul><hr/><ul><li><font color=\"#c24f4a\">2021/11/08更新:</font><br/></li><ol><li><span style=\"background-color: rgb(255, 255, 255);\">新增测验通过之后的发放证书功能 (我的成绩模块中)</span></li><li>&nbsp;考试多选题结果数据过滤逻辑优化</li></ol></ul>', '2021-02-07 15:52:45', '2024-11-30 00:49:01', 1);
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
  `analysis` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '解析',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question
-- ----------------------------
INSERT INTO `question` VALUES (24, '习近平总书记在庆祝中国共产党成立100周年大会上的讲话指出，中国共产党团结带领中国人民，浴血奋战、百折不挠，创造了新民主主义革命的伟大成就。以下属于新民主主义革命的伟大成就的是：\n\n　　①彻底消灭了在中国延续几千年的封建剥削压迫制度\n\n　　②彻底结束了旧中国半殖民地半封建社会的历史\n\n　　③彻底结束了旧中国一盘散沙的局面\n\n　　④彻底废除了列强强加给中国的不平等条约和帝国主义在中国的一切特权', '2024-11-30 02:06:30', 'teacher123', 1, 2, NULL, '6,7,8,9', '行测,行测随机题库1,行测随机题库2,行测随机题库3', '第一步，本题考查时政。\n第二步，2021 年 7 月 1 日,习近平总书记在庆祝中国共产党成立 100 周年大会上的讲话指出，新民主主义革命的胜利，彻底结束了旧中国半殖民地半封建社会的历史，彻底结束了旧中国一盘散沙的局面，彻底废除了列强强加\n给中国的不平等条约和帝国主义在中国的一切特权，为实现中华民族伟大复兴创造了根本社会条件。②③④正确。因此，选择 D 选项。');
INSERT INTO `question` VALUES (25, '“七一勋章”获得者都来自人民、植根人民，是立足本职、默默奉献的平凡英雄。他们的事迹可学可做，他们的精神可追可及，以下“七一勋章”获得者与其先进事迹表述对应正确的是：', '2024-11-30 00:31:47', 'teacher123', 1, 1, NULL, '6,7,8', '行测,行测随机题库1,行测随机题库2', '第一步，本题考查时政。第二步，孙景坤，男，汉族，1924 年 10 月生，1949 年 1 月入党，辽宁庄河人，辽宁省丹东市元宝区金山镇山\n城村原第一生产队队长。永葆革命本色的战斗功臣，在革命战争年代冲锋陷阵、不怕牺牲。在解放战争中，先后\n参加四平、辽沈、平津、解放长沙、解放海南岛、抗美援朝等战役战争，荣立一等功一次、二等功两次、三等功\n两次。作为英雄报告团成员，受到毛主席等党和国家领导人亲切接见。退役后毅然回乡带领群众改变家乡面貌，\n是共产党员吃苦在前、公而忘私崇高品质的典范。1953 年荣获“抗美援朝一级战士荣誉勋章”。2020 年 10 月\n14 日被授予“时代楷模”称号。2021 年 6 月 29 日，中共中央授予孙景坤“七一勋章”。C 项对应正确，符合题意。');
INSERT INTO `question` VALUES (26, '进入新发展阶段，是中华民族伟大复兴历史进程的大跨越，以下关于新发展阶段的理解，正确的有几项：\n\n　　①新发展阶段是中国共产党带领人民迎来从站起来、富起来到强起来历史性跨域的新阶段\n\n　　②新发展阶段是基本实现社会主义现代化，全面建成小康社会的发展阶段\n\n　　③新发展阶段是超越社会主义初级阶段，迈入社会主义更高阶段的发展阶段\n\n　　④新发展阶段是实现第一个百年奋斗目标，向着第二个百年奋斗目标迈进的发展阶段', '2024-11-30 02:03:16', 'teacher123', 1, 2, NULL, '6,7,8,9', '行测,行测随机题库1,行测随机题库2,行测随机题库3', '第一步，本题考查时政。\n第二步，①：2021 年 1 月 11 日习总书记在省部级主要领导干部学习贯彻党的十九届五中全会精神专题研讨班开\n班式上发表重要讲话，指出新发展阶段是我们党带领人民迎来从站起来、富起来到强起来的历史性跨越的新阶段。\n①正确。\n④：习总书记在庆祝中国共产党成立 100 周年大会上的重要讲话中强调，“十四五”时期是我国全面建成小康社\n会、实现第一个百年奋斗目标之后，乘势而上开启全面建设社会主义现代化国家新征程、向第二个百年奋斗目标\n进军的第一个五年，我国进入新发展阶段。可以说，新发展阶段，既是我们全面建设社会主义现代化国家、向第\n二个百年奋斗目标进军的阶段，也是中华民族伟大复兴进入不可逆转的进程、实现大跨越的阶段。④正确。\n故有 2 项正确。');
INSERT INTO `question` VALUES (27, '在中国共产党成立一百周年的重要时刻，我国脱贫攻坚战取得了全面胜利。下列与之相关的说法错误的是:', '2024-11-30 00:34:22', 'teacher123', 1, 1, NULL, '6,7,8,9', '行测,行测随机题库1,行测随机题库2,行测随机题库3', '第一步，本题考查时政并选错误项。\n第二步，2021 年 2 月 25 日，习近平总书记在全国脱贫攻坚总结表彰大会上的讲话中指出“事实充分证明，精准扶贫是打赢脱贫攻坚战的制胜法宝，开发式扶贫方针是中国特色减贫道路的鲜明特征。”选项 B 表述为“输血式”扶贫方针是中国特色减贫道路的鲜明特征，说法错误。');

-- ----------------------------
-- Table structure for question_bank
-- ----------------------------
DROP TABLE IF EXISTS `question_bank`;
CREATE TABLE `question_bank`  (
  `bank_id` int NOT NULL AUTO_INCREMENT,
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`bank_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question_bank
-- ----------------------------
INSERT INTO `question_bank` VALUES (6, '行测');
INSERT INTO `question_bank` VALUES (7, '行测随机题库1');
INSERT INTO `question_bank` VALUES (8, '行测随机题库2');
INSERT INTO `question_bank` VALUES (9, '行测随机题库3');
INSERT INTO `question_bank` VALUES (10, '行测123');

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
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (16, 1, '123', '123', 'c456ec14d94a2873ff2be1d285dd73c0', '94d95f', 1, '2024-11-02 14:23:59');
INSERT INTO `user` VALUES (17, 1, '1234', 'x', '5036dc16f5d72f4406edac711050b68a', '4d78a0', 1, '2024-11-16 14:17:05');
INSERT INTO `user` VALUES (18, 3, 'admin123', 'Admin', '7e2aa2e6c397494c5814db9a8167aeef', 'c667d6', 1, '2024-11-19 15:55:43');
INSERT INTO `user` VALUES (19, 2, 'teacher123', 'ttt', '48bb963c57a6caec3ffaf8c16b0d2c1c', '3835b2', 1, '2024-11-19 16:06:13');
INSERT INTO `user` VALUES (20, 1, 'scut123', 'scut123', '9830837f4e10ec0237365fa1c822fa3a', 'abf907', 1, '2024-11-21 15:43:05');
INSERT INTO `user` VALUES (21, 1, 'xlf', 'xlf', '8d46f81f0effd92d6cf0998944e16658', '8b2098', 1, '2024-11-30 00:42:16');
INSERT INTO `user` VALUES (22, 1, 'student123', '123', '34209f2904787ecfbfea81bf995400c9', 'b0a01b', 1, '2024-11-30 00:45:41');

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
