package com.kh.workground.search.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.member.model.vo.Member;
import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.Notice;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.search.model.dao.SearchDAO;
import com.kh.workground.search.model.exception.SearchException;


@Service
public class SearchServiceImpl implements SearchService {

	@Autowired
	SearchDAO searchDAO;

	@Override
	public List<Notice> selectTotalNoticeListByKeyword(String keyword) {
		List<Notice> list = searchDAO.selectTotalNoticeListByKeyword(keyword);
		
		if(list==null)
			throw new SearchException("키워드로 전체공지 조회 오류!");
		
		return list;
	}

	@Override
	public List<Notice> selectDeptNoticeListByKeyword(Map<String, String> param) {
		List<Notice> list = searchDAO.selectDeptNoticeListByKeyword(param);
		
		if(list==null)
			throw new SearchException("키워드로 부서별 게시글 조회 오류!");
		
		return list;
	}

	@Override
	public List<Community> selectCommuListByKeyword(String keyword) {
		List<Community> list = searchDAO.selectCommuListByKeyword(keyword);
		
		if(list==null)
			throw new SearchException("키워드로 커뮤니티 조회 오류!");
		
		return list;
	}

	@Override
	public List<Project> selectProjectListByKeyword(Map<String, String> param) {
		List<Project> list = searchDAO.selectProjectListByKeyword(param);
		
		if(list==null)
			throw new SearchException("키워드로 프로젝트 조회 오류!");
		
		return list;
	}

/*	@Override
	public List<Map<String, Object>> selectClubListByKeyword(String keyword) {
		List<Map<String, Object>> list = searchDAO.selectClubListByKeyword(keyword);
		
		if(list==null)
			throw new SearchException("키워드로 동호회 조회 오류!");
		
		return list;
	}
*/	
	@Override
	public List<Club> selectClubListByKeyword(Map<String, String> param) {
		List<Club> list = searchDAO.selectClubListByKeyword(param);
		
		if(list==null)
			throw new SearchException("키워드로 동호회 조회 오류!");
		
		return list;
	}

	@Override
	public List<Member> selectMemberListByKeyword(String keyword) {
		List<Member> list = searchDAO.selectMemberListByKeyword(keyword);
		
		if(list==null)
			throw new SearchException("키워드로 멤버 조회 오류!");
		
		return list;
	}

	@Override
	public List<Member> selectMemberListByPageBar(int cPage, int numPerPage, String keyword) {
		List<Member> list = searchDAO.selectMemberListByPageBar(cPage, numPerPage, keyword);
		
		if(list==null)
			throw new SearchException("멤버 조회 오류!");
		
		return list;
	}

	@Override
	public int selectMemberTotalContents(String keyword) {
		int totalContents = searchDAO.selectMemberTotalContents(keyword);
		
		if(totalContents<=0)
			throw new SearchException("멤버 조회 오류!");
		
		return totalContents;
	}

	@Override
	public List<Notice> selectTotalNoticeListByKeyword(int cPage, int numPerPage, String keyword) {
		List<Notice> list = searchDAO.selectTotalNoticeListByKeyword(cPage, numPerPage, keyword);
		
		if(list==null)
			throw new SearchException("전체공지 조회 오류!");
		
		return list;
	}
	
	@Override
	public int selectTotalNoticeTotalContents(String keyword) {
		int totalContents = searchDAO.selectTotalNoticeTotalContents(keyword);
		
		if(totalContents<=0)
			throw new SearchException("전체공지 조회 오류!");
		
		return totalContents;
	}

	@Override
	public List<Notice> selectDeptNoticeListByPageBar(int cPage, int numPerPage, Map<String, String> param) {
		List<Notice> list = searchDAO.selectDeptNoticeListByPageBar(cPage, numPerPage, param);
		
		if(list==null)
			throw new SearchException("부서게시글 조회 오류!");
		
		return list;
	}

/*<<<<<<< HEAD
	public int selectDeptNoticeTotalContents(Map<String, String> param) {
		int totalContents = searchDAO.selectDeptNoticeTotalContents(param);
=======
	public int selectDeptNoticeTotalContents(String keyword) {
		int totalContents = searchDAO.selectDeptNoticeTotalContents(keyword);
>>>>>>> master*/
	@Override
	public int selectDeptNoticeTotalContents(Map<String, String> param) {
		int totalContents = searchDAO.selectDeptNoticeTotalContents(param);
		
		if(totalContents<=0)
			throw new SearchException("부서게시글 조회 오류!");
		
		return totalContents;
	}

	@Override
	public List<Community> selectCommuListByPageBar(int cPage, int numPerPage, String keyword) {
		List<Community> list = searchDAO.selectCommuListByPageBar(cPage, numPerPage, keyword);
		
		if(list==null)
			throw new SearchException("커뮤니티 조회 오류!");
		
		return list;
	}
	
	@Override
	public int selectCommuListTotalContents(String keyword) {
		int totalContents = searchDAO.selectCommuListTotalContents(keyword);
		
		if(totalContents<=0)
			throw new SearchException("커뮤니티 조회 오류!");
		
		return totalContents;
	}

	@Override
	public List<Project> selectProjectListByPageBar(int cPage, int numPerPage, Map<String, String> param) {
		List<Project> list = searchDAO.selectProjectListByPageBar(cPage, numPerPage, param);
		
		if(list==null)
			throw new SearchException("프로젝트 조회 오류!");
		
		return list;
	}

	@Override
	public int selectProjectTotalContents(String keyword) {
		int totalContents = searchDAO.selectProjectTotalContents(keyword);
		
		if(totalContents<=0)
			throw new SearchException("프로젝트 조회 오류!");
		
		return totalContents;
	}

/*	@Override
	public List<Map<String, Object>> selectClubListByPageBar(int cPage, int numPerPage, String keyword) {
		List<Map<String, Object>> list = searchDAO.selectClubListByPageBar(cPage, numPerPage, keyword);
		
		if(list==null)
			throw new SearchException("동호회 조회 오류!");
		
		return list;
	} */
	@Override
	public List<Club> selectClubListByPageBar(int cPage, int numPerPage, Map<String, String> param) {
		List<Club> list = searchDAO.selectClubListByPageBar(cPage, numPerPage, param);
		
		if(list==null)
			throw new SearchException("동호회 조회 오류!");
		
		return list;
	}

	@Override
	public int selectClubTotalContents(String keyword) {
		int totalContents = searchDAO.selectClubTotalContents(keyword);
		
		if(totalContents<=0)
			throw new SearchException("동호회 조회 오류!");
		
		return totalContents;
	}

}
