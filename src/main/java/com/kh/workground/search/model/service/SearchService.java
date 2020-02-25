package com.kh.workground.search.model.service;

import java.util.List;
import java.util.Map;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.member.model.vo.Member;
import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.Notice;
import com.kh.workground.project.model.vo.Project;

public interface SearchService {

	List<Notice> selectTotalNoticeListByKeyword(String keyword);

	List<Notice> selectDeptNoticeListByKeyword(Map<String, String> param);

	List<Community> selectCommuListByKeyword(String keyword);

	List<Project> selectProjectListByKeyword(Map<String, String> param);

	List<Club> selectClubListByKeyword(Map<String, String> param);

	List<Member> selectMemberListByKeyword(String keyword);

	List<Member> selectMemberListByPageBar(int cPage, int numPerPage, String keyword);

	int selectMemberTotalContents(String keyword);

	List<Notice> selectNoticeListByPageBar(String keyword); //공지 리스트

	List<Notice> selectDeptNoticeListByPageBar(int cPage, int numPerPage, Map<String, String> param);

	int selectDeptNoticeTotalContents(Map<String, String> param);

	List<Community> selectCommuListByPageBar(int cPage, int numPerPage, String keyword); //커뮤니티 리스트

	List<Project> selectProjectListByPageBar(int cPage, int numPerPage, Map<String, String> param);

	int selectProjectTotalContents(String keyword);

	List<Club> selectClubListByPageBar(int cPage, int numPerPage, Map<String, String> param);

	int selectClubTotalContents(String keyword);

	int selectTotalNoticeTotalContents(String keyword); //공지토탈콘텐츠

	int selectCommuListTotalContents(String keyword); //커뮤토탈콘텐츠

	List<Notice> selectTotalNoticeListByPageBar(int cPage, int numPerPage, String keyword); //공지목록(댓글 없는 뷰)

	List<Notice> selectDeptNoticeList(Map<String, String> param); //부서별게시글모달


}

