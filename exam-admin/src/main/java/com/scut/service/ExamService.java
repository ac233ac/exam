package com.scut.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.scut.dto.StudentExamRecordExcelDto;
import com.scut.entity.Exam;
import com.scut.vo.AddExamByBankVo;
import com.scut.vo.AddExamByQuestionVo;
import com.scut.vo.ExamQueryVo;
import com.scut.vo.PageResponse;

import java.util.List;

/**
 * @author by scut
 * @implNote 2024/11/4 10:09
 */
public interface ExamService extends IService<Exam> {

    PageResponse<Exam> getExamPage(ExamQueryVo examQueryVo);

    AddExamByQuestionVo getExamInfoById(Integer examId);

    void operationExam(Integer type, String ids);

    void addExamByBank(AddExamByBankVo addExamByBankVo);

    void addExamByQuestionList(AddExamByQuestionVo addExamByQuestionVo);

    void updateExamInfo(AddExamByQuestionVo addExamByQuestionVo);

    List<String> getExamPassRateEchartData();

    List<String> getExamNumbersEchartData();

    List<StudentExamRecordExcelDto> getAllStudentScoreByExamId(Integer examId);

}
