package com.kh.workground.search.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.member.model.vo.Member;
import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.Notice;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.search.model.exception.SearchException;
import com.kh.workground.search.model.service.SearchService;

@Controller
public class SearchController {
	
	private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
	
	@Autowired
	SearchService searchService;
	
	@RequestMapping("/search/searchList.do")
	public ModelAndView searchList(ModelAndView mav, HttpSession session, @RequestParam String keyword) {
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId(); 
		String deptCode = memberLoggedIn.getDeptCode();
		
		Map<String, String> param = new HashMap<>();
		param.put("deptCode", memberLoggedIn.getDeptCode());
		param.put("keyword", keyword);
		param.put("memberId", memberId); //동호회 모달에서 가입을 위해 
		
		try {
			//1.업무로직
			//a-1.공지
			List<Notice> noticeList = searchService.selectTotalNoticeListByKeyword(keyword);
			//logger.debug("noticeList={}", noticeList);
			//logger.debug("noticeList.size={}", noticeList.size());
			
			//a-2.내 부서 게시글 
			List<Notice> deptNoticeList = searchService.selectDeptNoticeListByKeyword(param);
			
			//a-3.커뮤니티
			List<Community> communityList = searchService.selectCommuListByKeyword(keyword);
			
			//b.내 부서 프로젝트
			List<Project> projectList = searchService.selectProjectListByKeyword(param);
			
			//c.동호회 
			List<Club> clubList = searchService.selectClubListByKeyword(param);
			
			//d.멤버
			List<Member> memList = searchService.selectMemberListByKeyword(keyword);
			
			
			//2.뷰모델 처리
			mav.addObject("keyword", keyword);
			mav.addObject("noticeList", noticeList);
			mav.addObject("deptNoticeList", deptNoticeList); //목록 띄워줄용
			mav.addObject(deptCode.equals("D1")?"planningDeptNoticeList":deptCode.equals("D2")?"designDeptNoticeList":"developmentDeptNoticeList", deptNoticeList); //모달
			mav.addObject("communityList", communityList);
			mav.addObject("projectList", projectList);
			mav.addObject("clubList", clubList);
			mav.addObject("memList", memList);
			mav.setViewName("/search/searchList");
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new SearchException("전체 검색 오류!");
		}
		
		return mav;
	}
	
	@RequestMapping("/search/searchView.do")
	public ModelAndView searchView(ModelAndView mav, HttpSession session, 
									@RequestParam String keyword, @RequestParam String type, @RequestParam(defaultValue="1") int cPage) {
		
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberId = memberLoggedIn.getMemberId(); //추가
		String deptCode = memberLoggedIn.getDeptCode();
		
		Map<String, String> param = new HashMap<>();
		param.put("deptCode", memberLoggedIn.getDeptCode());
		param.put("keyword", keyword);
		param.put("memberId", memberId); //동호회 모달에서 가입을 위해
		final int numPerPage = 10; 
		
		try {
			//1.업무로직
			//공지인경우
			if("total".equals(type)) {
				List<Notice> totalNoticeList = searchService.selectTotalNoticeListByPageBar(cPage, numPerPage, keyword); //모두보기용(댓글 없는 뷰)	
				List<Notice> noticeList = searchService.selectNoticeListByPageBar(keyword); //공지 모달(댓글 있는 뷰)
				int totalContents = searchService.selectTotalNoticeTotalContents(keyword);
				
				mav.addObject("totalNoticeList", totalNoticeList);
				mav.addObject("noticeList", noticeList);
				mav.addObject("totalContents", totalContents);
			}
			//내 부서 게시글
			if("dept".equals(type)) {
				List<Notice> deptList = searchService.selectDeptNoticeListByPageBar(cPage, numPerPage, param); //모두보기용(댓글 없는 뷰)
				List<Notice> deptNoticeList = searchService.selectDeptNoticeList(param); //모달(댓글 있는 뷰)
				int totalContents = searchService.selectDeptNoticeTotalContents(param);
				
				mav.addObject(deptCode.equals("D1")?"planningDeptNoticeList":deptCode.equals("D2")?"designDeptNoticeList":"developmentDeptNoticeList", deptNoticeList);
				mav.addObject("deptList", deptList); //모두보기 띄울용
				mav.addObject("totalContents", totalContents);
			}
			//커뮤니티
			if("commu".equals(type)) {

				List<Community> list = searchService.selectCommuListByPageBar(cPage, numPerPage, keyword);
				int totalContents = searchService.selectCommuListTotalContents(keyword);
				
				mav.addObject("communityList", list);
				mav.addObject("totalContents", totalContents);
			}
			//내 부서 프로젝트
			if("project".equals(type)) {
				List<Project> list = searchService.selectProjectListByPageBar(cPage, numPerPage, param);
				int totalContents = searchService.selectProjectTotalContents(keyword);
				mav.addObject("list", list);
				mav.addObject("totalContents", totalContents);
			}
			//동호회
			if("club".equals(type)) {

				List<Club> list = searchService.selectClubListByPageBar(cPage, numPerPage, param);
				int totalContents = searchService.selectClubTotalContents(keyword);
				mav.addObject("clubList", list);
				mav.addObject("totalContents", totalContents);
			}
			//멤버
			if("member".equals(type)) {
				List<Member> list = searchService.selectMemberListByPageBar(cPage, numPerPage, keyword);
				int totalContents = searchService.selectMemberTotalContents(keyword);
				mav.addObject("list", list);
				mav.addObject("totalContents", totalContents);
			}
			
			
			//2.뷰모델처리
			mav.addObject("keyword", keyword);
			mav.addObject("type", type);
			mav.addObject("numPerPage", numPerPage);
			mav.addObject("cPage", cPage);
			mav.setViewName("/search/searchView");
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new SearchException("검색 상세보기 오류!");
		}
		
		return mav;
	}
}
