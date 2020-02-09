package com.kh.workground.notice.model.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.notice.model.dao.NoticeDAO;
import com.kh.workground.notice.model.vo.Notice;

@Service
public class NoticeServiceImpl implements NoticeService {
	
	static final Logger logger = LoggerFactory.getLogger(NoticeServiceImpl.class);
	
	@Autowired
	NoticeDAO noticeDAO;

	@Override
	public List<Notice> selectNoticeList() {
		return noticeDAO.selectNoticeList();
	}

	@Override
	public int insertNotice(Notice notice) {
		return noticeDAO.insertNotice(notice);
	}
	

}
