package com.kh.workground.notice.model.service;

import java.util.List;
import java.util.Map;

import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.Notice;

public interface NoticeService {

	List<Notice> selectNoticeList(Map<String, String> noticeMap);

	List<Notice> selectPlanningDeptNoticeList(Map<String, String> noticeMap);

	List<Notice> selectDesignDeptNoticeList(Map<String, String> noticeMap);

	List<Notice> selectDevelopmentDeptNoticeList(Map<String, String> noticeMap);

	List<Community> selectCommunityList(Map<String, String> commuMap);
	
	int insertNotice(Notice notice);

	int deleteNotice(int noticeNo);

	int insertCommunity(Community commu);

	int deleteCommunity(int commuNo);

	int updateNotice(Notice notice);

	int updateCommunity(Community commu);
	
	int insertNoticeComment(Map<String, Object> noticeCommentMap);

	int deleteNoticeComment(int noticeCommentNo);

	int insertCommunityComment(Map<String, Object> communityCommentMap);

	int deleteCommunityComment(int communityCommentNo);

	List<Notice> searchNoticeList(Map<String, String> noticeMap);

	List<Community> searchCommunityList(Map<String, String> commuMap);

	List<Notice> searchPlanningDeptNoticeList(Map<String, String> noticeMap);

	List<Notice> searchDesignDeptNoticeList(Map<String, String> noticeMap);

	List<Notice> searchDevelopmentDeptNoticeList(Map<String, String> noticeMap);

	Notice selectNoticeOne(Map<String, Object> param);

	Community selectCommunityOne(Map<String, Object> param);


}
