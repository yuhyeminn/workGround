package com.kh.workground.notice.model.service;

import java.util.List;
import java.util.Map;

import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.CommunityComment;
import com.kh.workground.notice.model.vo.Notice;
import com.kh.workground.notice.model.vo.NoticeComment;

public interface NoticeService {

	List<Notice> selectNoticeList();

	List<Notice> selectPlanningDeptNoticeList();

	List<Notice> selectDesignDeptNoticeList();

	List<Notice> selectDevelopmentDeptNoticeList();

	List<Community> selectCommunityList();
	
	int insertNotice(Notice notice);

	int insertNoticeComment(Map<String, Object> noticeCommentMap);

	int deleteNoticeComment(int noticeCommentNo);

	int insertCommunityComment(Map<String, Object> communityCommentMap);

	int deleteCommunityComment(int communityCommentNo);

}
