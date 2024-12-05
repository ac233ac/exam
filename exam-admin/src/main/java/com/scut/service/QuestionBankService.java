package com.scut.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.scut.entity.QuestionBank;
import com.scut.vo.BankHaveQuestionSum;
import com.scut.vo.PageResponse;
import com.scut.vo.QuestionVo;

import java.util.List;

/**
 * @author by scut
 * @implNote 2024/11/4 10:09
 */
public interface QuestionBankService extends IService<QuestionBank> {

    PageResponse<BankHaveQuestionSum> getBankHaveQuestionSumByType(String bankName, Integer pageNo, Integer pageSize);

    List<QuestionVo> getQuestionsByBankId(Integer bankId);

    List<QuestionVo> getQuestionByBankIdAndType(Integer bankId, Integer type);

    List<QuestionBank> getAllQuestionBanks();

    void addQuestionToBank(String questionIds, String banks);

    void removeBankQuestion(String questionIds, String banks);

    void deleteQuestionBank(String ids);

    void addQuestionBank(QuestionBank questionBank);
}
