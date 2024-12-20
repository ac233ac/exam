package com.scut.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.scut.annotation.Cache;
import com.scut.dto.StudentExamRecordExcelDto;
import com.scut.entity.Exam;
import com.scut.entity.ExamQuestion;
import com.scut.entity.ExamRecord;
import com.scut.entity.Question;
import com.scut.entity.User;
import com.scut.exception.BusinessException;
import com.scut.exception.CommonErrorCode;
import com.scut.mapper.ExamMapper;
import com.scut.mapper.ExamQuestionMapper;
import com.scut.mapper.ExamRecordMapper;
import com.scut.mapper.QuestionMapper;
import com.scut.mapper.UserMapper;
import com.scut.service.ExamService;
import com.scut.utils.RedisUtil;
import com.scut.vo.AddExamByBankVo;
import com.scut.vo.AddExamByQuestionVo;
import com.scut.vo.ExamQueryVo;
import com.scut.vo.PageResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.scut.dto.StudentExamRecordExcelDto.from;
import static com.scut.utils.CommonUtils.setEqualsQueryWrapper;
import static com.scut.utils.CommonUtils.setLikeWrapper;

/**
 * @author by scut
 * @implNote 2024/10/20 9:05
 */
@Service
@RequiredArgsConstructor
public class ExamServiceImpl extends ServiceImpl<ExamMapper, Exam> implements ExamService {

    private final UserMapper userMapper;

    private final QuestionMapper questionMapper;

    private final ExamMapper examMapper;

    private final ExamRecordMapper examRecordMapper;

    private final ExamQuestionMapper examQuestionMapper;

    private final RedisUtil redisUtil;

    @Override
    public PageResponse<Exam> getExamPage(ExamQueryVo examQueryVo) {
        QueryWrapper<Exam> wrapper = new QueryWrapper<>();

        setEqualsQueryWrapper(wrapper, Collections.singletonMap("type", examQueryVo.getExamType()));
        setLikeWrapper(wrapper, Collections.singletonMap("exam_name", examQueryVo.getExamName()));
        if (examQueryVo.getStartTime() != null) {
            wrapper.gt("start_time", examQueryVo.getStartTime().substring(0, examQueryVo.getStartTime().indexOf("T")));
        }
        if (examQueryVo.getEndTime() != null) {
            wrapper.lt("end_time", examQueryVo.getEndTime().substring(0, examQueryVo.getEndTime().indexOf("T")));
        }
        IPage<Exam> page = examMapper.selectPage(new Page<>(examQueryVo.getPageNo(), examQueryVo.getPageSize()), wrapper);

        return PageResponse.<Exam>builder().data(page.getRecords()).total(page.getTotal()).build();
    }

    @Cache(prefix = "examInfo", suffix = "#examId", ttl = 4, randomTime = 2, timeUnit = TimeUnit.HOURS)
    @Override
    public AddExamByQuestionVo getExamInfoById(Integer examId) {
        // 构造传递给前端的考试组合对象
        Exam exam = Optional.ofNullable(examMapper.selectById(examId))
                .orElseThrow(() -> new BusinessException(CommonErrorCode.E_400001));
        AddExamByQuestionVo addExamByQuestionVo = AddExamByQuestionVo.builder()
                .examDesc(exam.getExamDesc())
                .examDuration(exam.getDuration())
                .examId(examId)
                .examName(exam.getExamName())
                .passScore(exam.getPassScore())
                .totalScore(exam.getTotalScore())
                .startTime(exam.getStartTime())
                .endTime(exam.getEndTime())
                .type(exam.getType())
                .password(exam.getPassword())
                .status(exam.getStatus())
                .build();

        // 考试中题目的对象
        ExamQuestion examQuestion = examQuestionMapper.selectOne(new QueryWrapper<ExamQuestion>().eq("exam_id", examId));
        addExamByQuestionVo.setQuestionIds(examQuestion.getQuestionIds());
        addExamByQuestionVo.setScores(examQuestion.getScores());
        return addExamByQuestionVo;
    }

    @Override
    public void operationExam(Integer type, String ids) {
        String[] id = ids.split(",");
        switch (type) {
            case 1:
                setExamStatus(id, 1);
                break;
            case 2:
                setExamStatus(id, 2);
                break;
            case 3:
                Map<String, Object> map = new HashMap<>();
                for (String s : id) {
                    map.clear();
                    map.put("exam_id", Integer.parseInt(s));
                    examMapper.deleteByMap(map);
                    examQuestionMapper.deleteByMap(map);
                    redisUtil.del("examInfo:" + s);
                }
                break;
            default:
                throw new BusinessException(CommonErrorCode.E_100106);
        }
    }

    @Transactional
    @Override
    public void addExamByBank(AddExamByBankVo addExamByBankVo) {
        Exam exam = new Exam();
        exam.setStatus(addExamByBankVo.getStatus());
        exam.setDuration(addExamByBankVo.getExamDuration());
        if (addExamByBankVo.getEndTime() != null) exam.setEndTime(addExamByBankVo.getEndTime());
        if (addExamByBankVo.getStartTime() != null) exam.setStartTime(addExamByBankVo.getStartTime());
        exam.setExamDesc(addExamByBankVo.getExamDesc());
        exam.setExamName(addExamByBankVo.getExamName());
        exam.setPassScore(addExamByBankVo.getPassScore());
        exam.setType(addExamByBankVo.getType());
        // 设置密码如果有
        if (addExamByBankVo.getPassword() != null) {
            exam.setPassword(addExamByBankVo.getPassword());
        }
        // 设置id
        ExamQuestion examQuestion = buildExamQuestion(exam);
        // 设置题目id字符串
        HashSet<Integer> set = new HashSet<>();
        String[] bankNames = addExamByBankVo.getBankNames().split(",");

        for (String bankName : bankNames) {
            List<Question> questions = questionMapper.selectList(new QueryWrapper<Question>().like("qu_bank_name", bankName));
            for (Question question : questions) {
                set.add(question.getId());
            }
        }
        String quIds = set.toString().substring(1, set.toString().length() - 1).replaceAll(" ", "");
        System.out.println(quIds);
        examQuestion.setQuestionIds(quIds);
        // 设置每一题的分数
        String[] s = quIds.split(",");
        // 总分
        int totalScore = 0;
        StringBuilder sf = new StringBuilder();
        for (String s1 : s) {
            Question question = questionMapper.selectById(Integer.parseInt(s1));
            if (question.getQuType() == 1) {
                sf.append(addExamByBankVo.getSingleScore()).append(",");
                totalScore += addExamByBankVo.getSingleScore();
            } else if (question.getQuType() == 2) {
                sf.append(addExamByBankVo.getMultipleScore()).append(",");
                totalScore += addExamByBankVo.getMultipleScore();
            } else if (question.getQuType() == 3) {
                sf.append(addExamByBankVo.getJudgeScore()).append(",");
                totalScore += addExamByBankVo.getJudgeScore();
            } else if (question.getQuType() == 4) {
                sf.append(addExamByBankVo.getShortScore()).append(",");
                totalScore += addExamByBankVo.getShortScore();
            }
        }
        examQuestion.setScores(sf.substring(0, sf.toString().length() - 1));
        // 设置总成绩
        exam.setTotalScore(totalScore);

        examMapper.insert(exam);
        examQuestionMapper.insert(examQuestion);
    }

    @Transactional
    @Override
    public void addExamByQuestionList(AddExamByQuestionVo addExamByQuestionVo) {
        Exam exam = new Exam();
        exam.setTotalScore(addExamByQuestionVo.getTotalScore());
        exam.setType(addExamByQuestionVo.getType());
        exam.setPassScore(addExamByQuestionVo.getPassScore());
        if (addExamByQuestionVo.getEndTime() != null) exam.setEndTime(addExamByQuestionVo.getEndTime());
        if (addExamByQuestionVo.getStartTime() != null) exam.setStartTime(addExamByQuestionVo.getStartTime());
        exam.setExamDesc(addExamByQuestionVo.getExamDesc());
        exam.setExamName(addExamByQuestionVo.getExamName());
        exam.setDuration(addExamByQuestionVo.getExamDuration());
        // 设置密码如果有
        if (addExamByQuestionVo.getPassword() != null) {
            exam.setPassword(addExamByQuestionVo.getPassword());
        }
        exam.setStatus(addExamByQuestionVo.getStatus());
        // 设置id
        ExamQuestion examQuestion = buildExamQuestion(exam);
        examQuestion.setScores(addExamByQuestionVo.getScores());
        examQuestion.setQuestionIds(addExamByQuestionVo.getQuestionIds());

        examMapper.insert(exam);
        examQuestionMapper.insert(examQuestion);
    }

    @Override
    public void updateExamInfo(AddExamByQuestionVo addExamByQuestionVo) {
        Exam exam = new Exam();
        exam.setTotalScore(addExamByQuestionVo.getTotalScore());
        exam.setType(addExamByQuestionVo.getType());
        exam.setPassScore(addExamByQuestionVo.getPassScore());
        exam.setEndTime(addExamByQuestionVo.getEndTime());
        exam.setStartTime(addExamByQuestionVo.getStartTime());
        exam.setExamDesc(addExamByQuestionVo.getExamDesc());
        exam.setExamName(addExamByQuestionVo.getExamName());
        exam.setDuration(addExamByQuestionVo.getExamDuration());
        // 设置密码如果有
        if (addExamByQuestionVo.getPassword() != null) {
            exam.setPassword(addExamByQuestionVo.getPassword());
        } else {
            exam.setPassword(null);
        }
        exam.setStatus(addExamByQuestionVo.getStatus());
        exam.setExamId(addExamByQuestionVo.getExamId());
        // 设置考试的题目和分值信息
        ExamQuestion examQuestion = new ExamQuestion();
        examQuestion.setExamId(addExamByQuestionVo.getExamId());
        examQuestion.setScores(addExamByQuestionVo.getScores());
        examQuestion.setQuestionIds(addExamByQuestionVo.getQuestionIds());

        examMapper.update(exam, new UpdateWrapper<Exam>().eq("exam_id", exam.getExamId()));
        examQuestionMapper.update(examQuestion, new UpdateWrapper<ExamQuestion>().eq("exam_id", exam.getExamId()));
        // 移除缓存
        redisUtil.del("examInfo:" + exam.getExamId());
    }

    @Override
    public List<String> getExamPassRateEchartData() {
        List<Exam> exams = examMapper.selectList(null);
        List<ExamRecord> examRecords = examRecordMapper.selectList(new QueryWrapper<ExamRecord>().isNotNull("total_score"));
        // 考试的名称
        String[] examNames = new String[exams.size()];
        // 考试通过率
        double[] passRates = new double[exams.size()];

        double total;
        double pass;
        for (int i = 0; i < exams.size(); i++) {
            examNames[i] = exams.get(i).getExamName();
            total = 0;
            pass = 0;
            for (ExamRecord examRecord : examRecords) {
                if (Objects.equals(examRecord.getExamId(), exams.get(i).getExamId())) {
                    total++;
                    if (examRecord.getTotalScore() >= exams.get(i).getPassScore()) pass++;
                }
            }
            passRates[i] = pass / total;
        }
        for (int i = 0; i < passRates.length; i++) {
            if (Double.isNaN(passRates[i])) passRates[i] = 0;
        }
        List<String> list = new ArrayList<>();
        String res1 = Arrays.toString(examNames);
        String res2 = Arrays.toString(passRates);
        list.add(res1.substring(1, res1.length() - 1).replaceAll(" ", ""));
        list.add(res2.substring(1, res2.length() - 1).replaceAll(" ", ""));
        return list;
    }

    @Override
    public List<String> getExamNumbersEchartData() {
        List<Exam> exams = examMapper.selectList(null);
        List<ExamRecord> examRecords = examRecordMapper.selectList(null);
        // 考试的名称
        String[] examNames = new String[exams.size()];
        // 考试的考试次数
        String[] examNumbers = new String[exams.size()];

        int cur;
        for (int i = 0; i < exams.size(); i++) {
            examNames[i] = exams.get(i).getExamName();
            cur = 0;
            for (ExamRecord examRecord : examRecords) {
                if (Objects.equals(examRecord.getExamId(), exams.get(i).getExamId())) {
                    cur++;
                }
            }
            examNumbers[i] = cur + "";
        }
        List<String> list = new ArrayList<>();
        String res1 = Arrays.toString(examNames);
        String res2 = Arrays.toString(examNumbers);
        list.add(res1.substring(1, res1.length() - 1).replaceAll(" ", ""));
        list.add(res2.substring(1, res2.length() - 1).replaceAll(" ", ""));
        return list;
    }

    private ExamQuestion buildExamQuestion(Exam exam) {
        List<Exam> examList = examMapper.selectList(null);
        int id = 0;
        if (examList.size() != 0) {
            id = examList.get(examList.size() - 1).getExamId() + 1;
        }
        exam.setExamId(id);
        ExamQuestion examQuestion = new ExamQuestion();
        examQuestion.setExamId(id);
        return examQuestion;
    }

    private void setExamStatus(String[] id, int status) {
        for (String s : id) {
            Exam exam = examMapper.selectOne(new QueryWrapper<Exam>().eq("exam_id", Integer.parseInt(s)));
            exam.setStatus(status);
            examMapper.update(exam, new UpdateWrapper<Exam>().eq("exam_id", s));
        }
    }

    @Override
    public List<StudentExamRecordExcelDto> getAllStudentScoreByExamId(Integer examId) {
        Exam exam = examMapper.selectById(examId);

        QueryWrapper<ExamRecord> examRecordQueryWrapper = new QueryWrapper<>();
        examRecordQueryWrapper.eq("exam_id", examId)
                .isNotNull("total_score");
        List<ExamRecord> examRecords = examRecordMapper.selectList(examRecordQueryWrapper);
        if (CollectionUtils.isEmpty(examRecords)) {
            return Collections.emptyList();
        }
        List<Integer> uidList = examRecords.stream()
                .map(ExamRecord::getUserId)
                .collect(Collectors.toList());
        Map<Integer, User> studentExamUserMap = userMapper.selectBatchIds(uidList).stream()
                .filter(user -> user.getRoleId() == 1)
                .collect(Collectors.toMap(User::getId, Function.identity()));

        List<StudentExamRecordExcelDto> studentExamRecordExcelDtos = examRecords.stream()
                .filter(examRecord -> studentExamUserMap.containsKey(examRecord.getUserId()))
                .map(record -> from(record, exam.getExamName(), studentExamUserMap.get(record.getUserId()).getTrueName()))
                .sorted(Comparator.comparing(StudentExamRecordExcelDto::getExamTime).reversed())
                .collect(Collectors.toList());
        double objectiveAverage = studentExamRecordExcelDtos.stream()
                .mapToInt(StudentExamRecordExcelDto::getObjectiveScore)
                .average()
                .orElse(0D);
        double subjectiveAverage = studentExamRecordExcelDtos.stream()
                .mapToInt(StudentExamRecordExcelDto::getSubjectiveScore)
                .average()
                .orElse(0D);
        double totalScoreAverage = studentExamRecordExcelDtos.stream()
                .mapToInt(StudentExamRecordExcelDto::getTotalScore)
                .average()
                .orElse(0D);
        studentExamRecordExcelDtos.add(StudentExamRecordExcelDto.builder()
                .studentName("平均分")
                .objectiveScore((int) objectiveAverage)
                .subjectiveScore((int) subjectiveAverage)
                .totalScore((int) totalScoreAverage)
                .build());
        return studentExamRecordExcelDtos;
    }

}
