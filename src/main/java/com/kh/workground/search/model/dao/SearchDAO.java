package com.kh.workground.search.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.member.model.vo.Member;
import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.Notice;
import com.kh.workground.project.model.vo.Project;

public interface SearchDAO {

	List<Notice> selectTotalNoticeListByKeyword(String keyword);

	List<Notice> selectDeptNoticeListByKeyword(Map<String, String> param);

	List<Community> selectCommuListByKeyword(String keyword);

	List<Project> selectProjectListByKeyword(Map<String, String> param);

/*	List<Map<String, Object>> selectClubListByKeyword(String keyword); */
	List<Club> selectClubListByKeyword(Map<String, String> param);

	List<Member> selectMemberListByKeyword(String keyword);

	List<Member> selectMemberListByPageBar(int cPage, int numPerPage, String keyword);

	int selectMemberTotalContents(String keyword);

	List<Notice> selectTotalNoticeListByKeyword(int cPage, int numPerPage, String keyword);

	int selectTotalNoticeTotalContents(String keyword);

	List<Notice> selectDeptNoticeListByPageBar(int cPage, int numPerPage, Map<String, String> param);

/*<<<<<<< HEAD
	int selectDeptNoticeTotalContents(Map<String, String> param);
=======
	int selectDeptNoticeTotalContents(String keyword);
>>>>>>> master*/
	int selectDeptNoticeTotalContents(Map<String, String> param);

	List<Community> selectCommuListByPageBar(int cPage, int numPerPage, String keyword);

	int selectCommuListTotalContents(String keyword);

	List<Project> selectProjectListByPageBar(int cPage, int numPerPage, Map<String, String> param);

	int selectProjectTotalContents(String keyword);

/*	List<Map<String, Object>> selectClubListByPageBar(int cPage, int numPerPage, String keyword); */
	List<Club> selectClubListByPageBar(int cPage, int numPerPage, Map<String, String> param);

	int selectClubTotalContents(String keyword);

}