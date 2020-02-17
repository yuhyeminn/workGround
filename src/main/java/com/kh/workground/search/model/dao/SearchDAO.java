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

	List<Map<String, Object>> selectClubListByKeyword(String keyword);

	List<Member> selectMemberListByKeyword(String keyword);

	List<Member> selectMemberListByPageBar(int cPage, int numPerPage, String keyword);

	int selectMemberTotalContents();

	List<Notice> selectTotalNoticeListByKeyword(int cPage, int numPerPage, String keyword);

	int selectTotalNoticeTotalContents();

	List<Notice> selectDeptNoticeListByPageBar(int cPage, int numPerPage, Map<String, String> param);

	int selectDeptNoticeTotalContents();

	List<Community> selectCommuListByPageBar(int cPage, int numPerPage, String keyword);

	int selectCommuListTotalContents();

	List<Project> selectProjectListByPageBar(int cPage, int numPerPage, Map<String, String> param);

	int selectProjectTotalContents();

	List<Map<String, Object>> selectClubListByPageBar(int cPage, int numPerPage, String keyword);

	int selectClubTotalContents();

}