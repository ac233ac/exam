package com.scut.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.scut.entity.ExamQuestion;
import com.scut.mapper.ExamQuestionMapper;
import com.scut.service.ExamQuestionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * @author by scut
 * @implNote 2024/10/20 9:05
 */
@Service
@RequiredArgsConstructor
public class ExamQuestionServiceImpl extends ServiceImpl<ExamQuestionMapper, ExamQuestion> implements ExamQuestionService {

    private final ExamQuestionMapper examQuestionMapper;

    @Override
    public ExamQuestion getExamQuestionByExamId(Integer examId) {
        return examQuestionMapper.selectOne(new QueryWrapper<ExamQuestion>().eq("exam_id", examId));
    }
}
