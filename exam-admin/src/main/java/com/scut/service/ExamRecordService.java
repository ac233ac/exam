package com.scut.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.scut.entity.ExamRecord;
import com.scut.vo.PageResponse;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


 /**
 * @author by scut
 * @implNote 2024/11/4 10:09
 */
public interface ExamRecordService extends IService<ExamRecord> {

    PageResponse<ExamRecord> getUserGrade(String username, Integer examId, Integer pageNo, Integer pageSize);

    void createExamCertificate(HttpServletResponse response, String examName, Integer examRecordId);

    ExamRecord getExamRecordById(Integer recordId);

    Integer addExamRecord(ExamRecord examRecord, HttpServletRequest request);

    PageResponse<ExamRecord> getExamRecord(Integer examId, Integer pageNo, Integer pageSize);

    void setObjectQuestionScore(Integer totalScore, Integer examRecordId);
}
