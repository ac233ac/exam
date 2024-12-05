package com.scut.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.scut.entity.Question;
import com.scut.vo.PageResponse;
import com.scut.vo.QuestionVo;

import java.util.List;

/**
 * @author by scut
 * @implNote 2024/11/4 10:09
 */
public interface QuestionService extends IService<Question> {

    PageResponse<Question> getQuestion(String questionType, String questionBank, String questionContent, Integer pageNo, Integer pageSize);

    QuestionVo getQuestionVoById(Integer id);

    PageResponse<QuestionVo> getQuestionVoByIds(List<Integer> ids);

    void deleteQuestionByIds(String questionIds);

    void addQuestion(QuestionVo questionVo);

    void updateQuestion(QuestionVo questionVo);

}
