package com.kh.workground.notice.model.dao;

import java.util.List;

import com.kh.workground.notice.model.vo.Notice;

public interface NoticeDAO {

	List<Notice> selectNoticeList();

}
