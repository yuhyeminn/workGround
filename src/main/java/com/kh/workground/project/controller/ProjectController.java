package com.kh.workground.project.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.exception.ProjectException;
import com.kh.workground.project.model.service.ProjectService;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;
import com.kh.workground.project.model.vo.Worklist;

@Controller
public class ProjectController {
	
	private static final Logger logger = LoggerFactory.getLogger(ProjectController.class);
	
	@Autowired
	ProjectService projectService;
	
	@RequestMapping("/project/projectList.do")
	public ModelAndView projectList(ModelAndView mav, HttpSession session) {
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		List<Member> memberListByDept = null; //부서 사람들 담는 리스트
		Map<String, List<Project>> projectMap = null; //조회한 프로젝트 리스트 담는 맵
		Map<String, Integer> statusCntMap = new HashMap<>(); //부서 전체 프로젝트의 상태별 카운트 담는 맵
		int ps1 = 0; //계획됨
		int ps2 = 0; //진행중
		int ps3 = 0; //완료됨
		int ps4 = 0; //상태없음
		
		
		try {
			//1.업무로직
			//1-1.부서 사람들 조회
			memberListByDept = projectService.selectMemberListByDept(memberLoggedIn.getDeptCode());
			
			//1-2.부서 전체 프로젝트/중요 표시된 프로젝트/내가 속한 프로젝트(내 워크패드 포함)
			projectMap = projectService.selectProjectListAll(memberLoggedIn);
			
			//1-3.부서 전체 프로젝트 상태 카운트
			List<Project> listByDept = projectMap.get("listByDept");
			
			for(Project p: listByDept) {
				String statusCode = p.getProjectStatusCode();
				
				if("PS1".equals(statusCode)) ps1++;
				else if("PS2".equals(statusCode)) ps2++;
				else if("PS3".equals(statusCode)) ps3++;
				else ps4++;
			}
			statusCntMap.put("계획됨", ps1);
			statusCntMap.put("진행중", ps2);
			statusCntMap.put("완료됨", ps3);
			statusCntMap.put("상태없음", ps4);
			
			//2.뷰모델 처리
			mav.addObject("projectMap", projectMap);
			mav.addObject("statusCntMap", statusCntMap);
			mav.addObject("memberListByDept", memberListByDept);
			mav.setViewName("/project/projectList"); 
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 목록 조회 오류!");
		}
		
		return mav;
	}
	
	@RequestMapping("/project/projectView.do")
	public ModelAndView projectView(ModelAndView mav, HttpSession session, @RequestParam int projectNo, 
									@RequestParam(defaultValue="work", required=false) String tab) {
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		logger.debug("tab={}", tab);
		
		try {
			//1. 업무로직
			Project p = projectService.selectProjectWorklistAll(projectNo, memberLoggedIn.getMemberId());
			
			//2. 뷰모델 처리
			mav.addObject("project", p);
			mav.addObject("pMemList", p.getProjectMemberList());
			mav.addObject("wlList", p.getWorklistList());
			
			//서브헤더 탭에 따라 분기
			if("work".equals(tab))
				mav.setViewName("/project/projectView");
			else if("attach".equals(tab))
				mav.setViewName("/project/projectAttachmentAjax");
			
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 상세 조회 오류!");
		}
		
		return mav;
	}
	
	@PostMapping("/project/projectStarCheck.do")
	@ResponseBody
	public Map<String, String> projectStartCheck(@RequestParam("memberId") String memberId, @RequestParam("projectNo") int projectNo){
		Map<String, String> map = new HashMap<>();
		String resultStr = "";
		int result = 0;
		
		try {
			//1.업무로직
			//1-1. 중요 프로젝트 테이블에 존재하는지 조회
			Map<String, Object> param = new HashMap<>();
			param.put("memberId", memberId);
			param.put("projectNo", projectNo);
			
			Map<String, Object> starMap = projectService.selectProjectImportantOne(param);
			
			//1-2. 존재하지 않으면 추가
			if(starMap==null) {
				result = projectService.insertProjectImportant(param);
				resultStr = "insert";
				map.put("result", resultStr);
			}
			//1-3. 존재하면 삭제
			else {
				int projectImportantNo = Integer.parseInt(String.valueOf(starMap.get("projectImportantNo")));
				result = projectService.deleteProjectImportant(projectImportantNo);
				resultStr = "delete";
				map.put("result", resultStr);
			}
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 중요표시 오류!");
		}
		
		return map;
	}
	
	@PostMapping("/project/addWorklist.do")
	@ResponseBody
	public Map<String, Integer> insertWorklist(@RequestParam int projectNo, @RequestParam String worklistTitle) {
		Map<String, Integer> map = new HashMap<>();
		
		try {
			//1.업무로직
			Map<String, Object> param = new HashMap<>();
			param.put("projectNo", projectNo);
			param.put("worklistTitle", worklistTitle);
			
			int result = projectService.insertWorklist(param);
			map.put("result", result);
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무리스트 생성 오류!");
		}
		
		return map;
	}
	
	@PostMapping("/project/deleteWorklist.do")
	@ResponseBody
	public Map<String, Integer> deleteWorklist(@RequestParam int worklistNo) {
		Map<String, Integer> map = new HashMap<>();
		logger.debug("worklistNo={}", worklistNo);
		
		try {
			//1.업무로직
			int result = projectService.deleteWorklist(worklistNo);
			map.put("result", result);
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무리스트 삭제 오류!");
		}
		
		return map;
	}
	
	@PostMapping("/project/insertWork")
	@ResponseBody
	public Map<String, Integer> insertWork(@RequestParam(value="worklistNo") int worklistNo, 
										   @RequestParam(value="workTitle") String workTitle,
										   @RequestParam(value="workChargedMember[]", required=false) List<String> workChargedMember,
										   @RequestParam(value="workTag", required=false) String workTag,
										   @RequestParam(value="workDate[]", required=false) List<String> workDate){
		
		Map<String, Integer> map = new HashMap<>();
		logger.debug("worklistNo={}", worklistNo);
		logger.debug("workTitle={}", workTitle);
		logger.debug("workChargedMember={}", workChargedMember);
		logger.debug("workTag={}", workTag);
		logger.debug("workDate={}", workDate);
		
		try {
			//1.업무로직
			//1-1.파라미터 map에 담기
			Map<String, Object> param = new HashMap<>();
			param.put("worklistNo", worklistNo);
			param.put("workTitle", workTitle);
			
			if(workChargedMember.size()==0) param.put("workChargedMember", null);
			else param.put("workChargedMember", workChargedMember);
			
			if(workTag==null) param.put("workTag", null);
			else param.put("workTag", workTag);
			
			if(workDate.size()==0) param.put("workDate", null);
			else param.put("workDate", workDate);
			
			//1-2.추가
			int result = projectService.insertWork(param);
			map.put("result", result);
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("새 업무 만들기 오류!");
		}
		
		return map;
	}
	
	/*@RequestMapping("/project/projectAttachment.do")
	public ModelAndView projectAttachment(ModelAndView mav) {
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		
		try {
			//1. 업무로직
			Project p = projectService.selectProjectWorklistAll(projectNo, memberLoggedIn.getMemberId());
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 파일탭 조회 오류!");
		}
		
		mav.setViewName("/project/projectAttachmentAjax");
		
		return mav;
	}*/
	
	@RequestMapping("/project/projectAnalysis.do")
	public ModelAndView projectAnalysis(ModelAndView mav) {
		
		mav.setViewName("/project/projectAnalysis");
		
		return mav;
	}
	
}
