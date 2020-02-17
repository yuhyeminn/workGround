package com.kh.workground.notice.model.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.notice.model.dao.NoticeDAO;
import com.kh.workground.notice.model.exception.NoticeException;
import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.Notice;

@Service
public class NoticeServiceImpl implements NoticeService {
	
	static final Logger logger = LoggerFactory.getLogger(NoticeServiceImpl.class);
	
	@Autowired
	NoticeDAO noticeDAO;

	@Override
	public List<Notice> selectNoticeList(Map<String, String> noticeMap) {
		List<Notice> list = noticeDAO.selectNoticeList(noticeMap);
		if(list == null)
			throw new NoticeException("공지 조회 오류!");
		return list;
	}

	@Override
	public List<Notice> selectPlanningDeptNoticeList(Map<String, String> noticeMap) {
		List<Notice> list = noticeDAO.selectPlanningDeptNoticeList(noticeMap);
		if(list == null)
			throw new NoticeException("기획부 게시글 조회 오류!");
		return list;
	}

	@Override
	public List<Notice> selectDesignDeptNoticeList(Map<String, String> noticeMap) {
		List<Notice> list = noticeDAO.selectDesignDeptNoticeList(noticeMap);
		if(list == null)
			throw new NoticeException("디자인부 게시글 조회 오류!");
		return list;
	}

	@Override
	public List<Notice> selectDevelopmentDeptNoticeList(Map<String, String> noticeMap) {
		List<Notice> list = noticeDAO.selectDevelopmentDeptNoticeList(noticeMap);
		if(list == null)
			throw new NoticeException("개발부 게시글 조회 오류!");
		return list;
	}

	@Override
	public List<Community> selectCommunityList(Map<String, String> commuMap) {
		List<Community> list = noticeDAO.selectCommunityList(commuMap);
		if(list == null)
			throw new NoticeException("커뮤니티 조회 오류!");
		return list;
	}
	
	@Override
	public int insertNotice(Notice notice) {
		int result = noticeDAO.insertNotice(notice);
		if(result == 0)
			throw new NoticeException("공지 추가 오류!");
		return result;
	}

	@Override
	public int deleteNotice(int noticeNo) {
		int result = noticeDAO.deleteNotice(noticeNo);
		if(result == 0)
			throw new NoticeException("공지 삭제 오류!");
		return result;
	}

	@Override
	public int insertCommunity(Community commu) {
		int result = noticeDAO.insertCommunity(commu);
		if(result == 0)
			throw new NoticeException("커뮤니티 추가 오류!");
		return result;
	}

	@Override
	public int deleteCommunity(int commuNo) {
		int result = noticeDAO.deleteCommunity(commuNo);
		if(result == 0)
			throw new NoticeException("커뮤니티 삭제 오류!");
		return result;
	}

	@Override
	public int updateNotice(Notice notice) {
		int result = noticeDAO.updateNotice(notice);
		if(result == 0)
			throw new NoticeException("공지 수정 오류!");
		return result;
	}

	@Override
	public int updateCommunity(Community commu) {
		int result = noticeDAO.updateCommunity(commu);
		if(result == 0)
			throw new NoticeException("커뮤니티 수정 오류!");
		return result;
	}
	
	@Override
	public int insertNoticeComment(Map<String, Object> noticeCommentMap) {
		int result = noticeDAO.insertNoticeComment(noticeCommentMap);
		if(result == 0)
			throw new NoticeException("공지 댓글 추가 오류!");
		return result;
	}

	@Override
	public int deleteNoticeComment(int noticeCommentNo) {
		int result = noticeDAO.deleteNoticeComment(noticeCommentNo);
		if(result == 0)
			throw new NoticeException("공지 댓글 삭제 오류!");
		return result;
	}

	@Override
	public int insertCommunityComment(Map<String, Object> communityCommentMap) {
		int result = noticeDAO.insertCommunityComment(communityCommentMap);
		if(result == 0)
			throw new NoticeException("커뮤니티 댓글 추가 오류!");
		return result;
	}

	@Override
	public int deleteCommunityComment(int communityCommentNo) {
		int result = noticeDAO.deleteCommunityComment(communityCommentNo);
		if(result == 0)
			throw new NoticeException("커뮤니티 댓글 삭제 오류!");
		return result;
	}

	@Override
	public List<Notice> searchNoticeList(Map<String, String> noticeMap) {
		List<Notice> list = noticeDAO.searchNoticeList(noticeMap);
		if(list == null)
			throw new NoticeException("공지 검색 오류!");
		return list;
	}

	@Override
	public List<Community> searchCommunityList(Map<String, String> commuMap) {
		List<Community> list = noticeDAO.searchCommunityList(commuMap);
		if(list == null)
			throw new NoticeException("커뮤니티 검색 오류!");
		return list;
	}

	@Override
	public List<Notice> searchPlanningDeptNoticeList(Map<String, String> noticeMap) {
		List<Notice> list = noticeDAO.searchPlanningDeptNoticeList(noticeMap);
		if(list == null)
			throw new NoticeException("기획부 게시글 검색 오류!");
		return list;
	}

	@Override
	public List<Notice> searchDesignDeptNoticeList(Map<String, String> noticeMap) {
		List<Notice> list = noticeDAO.searchDesignDeptNoticeList(noticeMap);
		if(list == null)
			throw new NoticeException("디자인부 게시글 검색 오류!");
		return list;
	}

	@Override
	public List<Notice> searchDevelopmentDeptNoticeList(Map<String, String> noticeMap) {
		List<Notice> list = noticeDAO.searchDevelopmentDeptNoticeList(noticeMap);
		if(list == null)
			throw new NoticeException("개발부 게시글 검색 오류!");
		return list;
	}


}
