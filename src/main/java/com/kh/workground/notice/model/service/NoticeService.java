package com.kh.workground.notice.model.service;

import java.util.List;

import com.kh.workground.notice.model.vo.Notice;

public interface NoticeService {

	List<Notice> selectNoticeList();

	int insertNotice(Notice notice);

}
