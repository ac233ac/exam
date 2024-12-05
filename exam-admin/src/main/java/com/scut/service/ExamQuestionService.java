package com.scut.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.scut.entity.ExamQuestion;


 /**
 * @author by scut
 * @implNote 2024/11/4 10:09
 */
public interface ExamQuestionService extends IService<ExamQuestion> {

    ExamQuestion getExamQuestionByExamId(Integer examId);

}
