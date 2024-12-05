package com.scut.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.scut.entity.Notice;
import com.scut.vo.PageResponse;

/**
 * @author by scut
 * @implNote 2024/11/4 10:09
 */
public interface NoticeService extends IService<Notice> {
    // 将所有公告设置为历史公告
    boolean setAllNoticeIsHistoryNotice();

    String getCurrentNotice();

    PageResponse<Notice> getAllNotices(String content, Integer pageNo, Integer pageSize);

    void publishNotice(Notice notice);

    void deleteNoticeByIds(String noticeIds);

    void updateNotice(Notice notice);
}
