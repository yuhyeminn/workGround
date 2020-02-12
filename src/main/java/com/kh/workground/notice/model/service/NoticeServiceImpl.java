package com.kh.workground.notice.model.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.notice.model.dao.NoticeDAO;
import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.CommunityComment;
import com.kh.workground.notice.model.vo.Notice;
import com.kh.workground.notice.model.vo.NoticeComment;

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
	public List<Notice> selectPlanningDeptNoticeList() {
		return noticeDAO.selectPlanningDeptNoticeList();
	}

	@Override
	public List<Notice> selectDesignDeptNoticeList() {
		return noticeDAO.selectDesignDeptNoticeList();
	}

	@Override
	public List<Notice> selectDevelopmentDeptNoticeList() {
		return noticeDAO.selectDevelopmentDeptNoticeList();
	}

	@Override
	public List<Community> selectCommunityList() {
		return noticeDAO.selectCommunityList();
	}
	
	@Override
	public int insertNotice(Notice notice) {
		return noticeDAO.insertNotice(notice);
	}

	@Override
	public int insertNoticeComment(Map<String, Object> noticeCommentMap) {
		return noticeDAO.insertNoticeComment(noticeCommentMap);
	}

	@Override
	public int deleteNoticeComment(int noticeCommentNo) {
		return noticeDAO.deleteNoticeComment(noticeCommentNo);
	}

	@Override
	public int insertCommunityComment(Map<String, Object> communityCommentMap) {
		return noticeDAO.insertCommunityComment(communityCommentMap);
	}

	@Override
	public int deleteCommunityComment(int communityCommentNo) {
		return noticeDAO.deleteCommunityComment(communityCommentNo);
	}




}
