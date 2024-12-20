package com.scut.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

/**
 * @author by scut
 * @implNote 2024/11/1 17:09
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class QuestionVo {

    @NotNull
    private Integer questionType;

    private Integer questionId;

    @NotNull
    private Integer questionLevel;

    private Integer[] bankId;

    @NotBlank
    private String questionContent;

    private String[] images;

    private String analysis;

    private String createPerson;

    private Answer[] Answer;

    //答案对象
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class Answer {

        private Integer id;

        private String isTrue;

        @NotBlank
        private String answer;

        private String[] images;

        private String analysis;
    }
}
