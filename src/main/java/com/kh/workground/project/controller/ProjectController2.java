package com.kh.workground.project.controller;


import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.exception.ProjectException;
import com.kh.workground.project.model.service.ProjectService2;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;

@Controller
public class ProjectController2 {
	// 혜민 컨트롤러
	private static final Logger logger = LoggerFactory.getLogger(ProjectController2.class);
	
	@Autowired
	ProjectService2 projectService;
	
	@RequestMapping("/project/addProject.do")
	public ModelAndView addProject(@RequestParam String projectTitle, @RequestParam(value="projectDesc", required=false) String projectDesc, @RequestParam String projectMember, HttpSession session
			,ModelAndView mav) {
		try {
			Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
			
			Project p = new Project();
			p.setProjectTitle(projectTitle);
			p.setProjectWriter(memberLoggedIn.getMemberId());
			p.setProjectDesc(projectDesc);
			
			String[] memberArr = projectMember.split(",");
			List<String> projectMemberList = new ArrayList<>(Arrays.asList(memberArr));
			
			//project 생성
			int result = projectService.insertProject(p, projectMemberList);
			
//			logger.debug("memberArr@Controller2={}",Arrays.toString(memberArr));
//			logger.debug("projectMemberList@Controller2={}",projectMemberList);
			
			mav.addObject("msg", result>0?"프로젝트 등록 성공!":"프로젝트 등록 실패!");
			mav.addObject("loc","/project/projectList.do");
			mav.setViewName("common/msg");
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 생성 오류!");
		}
		
		return mav;
	}
	
	@RequestMapping("/project/projectDeptMember.do")
	@ResponseBody
	public List<Member> projectDeptMember(HttpSession session){
		List<Member> list = null;
		try {
			Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
			list = projectService.selectMemberListByDeptCode(memberLoggedIn);
			
//			logger.debug("list@controller2={}",list);
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("부서별 프로젝트 멤버 조회 오류!");
		}
		
		return list;
	}
	
	@RequestMapping("/project/projectListByStatusCode.do")
	@ResponseBody
	public Map<String, List<Project>> projectListByStatusCode(HttpServletRequest request, HttpSession session){
		String statusCode = request.getParameter("statusCode");
		Map<String, List<Project>> projectMap = null; //조회한 프로젝트 리스트 담는 맵
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		logger.debug("statusCode= {}",statusCode);
		try {
			Map<String, Object> param = new HashMap<>();
			param.put("memberLoggedIn", memberLoggedIn);
			param.put("statusCode", statusCode);
			
			projectMap = projectService.selectProjectListByStatusCode(param);
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("상태코드별 프로젝트 정렬 오류!");
		}
		
		return projectMap;
	}
	
	@RequestMapping("/project/projectSetting.do")
	public ModelAndView projectSetting(ModelAndView mav, HttpServletRequest request) {
		int projectNo = Integer.parseInt(request.getParameter("projectNo"));
		
		try {
			//프로젝트 팀원 리스트에 팀장 포함이면 true, 제외하면 false
			boolean isIncludeManager = false;
			Project p = projectService.selectProjectOneForSetting(projectNo,isIncludeManager);
			
			Member pm = projectService.selectMemberOneByMemberId(p.getProjectWriter());
			
			mav.addObject("project", p);
			mav.addObject("projectManager", pm);
			mav.setViewName("/project/projectSettingSideBar");
			
		}catch(Exception e){
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 속성 조회 오류!");
		}
		
		return mav;
	}
	
	@RequestMapping("/project/projectManagerSetting.do")
	@ResponseBody
	public List<Member> projectManagerSetting(HttpServletRequest request){
		List<Member> managerList = null;
		try {
			String projectWriter = request.getParameter("projectWriter");
			
			managerList = projectService.selectProjectManagerByDept(projectWriter);
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 관리자 조회 오류!");
		}
		return managerList;
	}
	
	@RequestMapping("/project/projectMemberSetting.do")
	@ResponseBody
	public Map<String,List<Member>> projectMemberSetting(HttpServletRequest request){
		Map<String, List<Member>> map = null;
			try {
				int projectNo = Integer.parseInt(request.getParameter("projectNo"));
				map = new HashMap<>();
				
				//프로젝트 팀원 리스트에 팀장 포함이면 true, 제외하면 false
				boolean isIncludeManager = false;
				Project p = projectService.selectProjectOneForSetting(projectNo,isIncludeManager);
				
				//해당 프로젝트 팀원 리스트(팀장 제외되어있음)
				List<Member> projectMemberList = p.getProjectMemberList();
				
				//item리스트에 뿌려질 팀장과 같은 부서 팀원 리스트(팀장 제외)
				Member pm = projectService.selectMemberOneByMemberId(p.getProjectWriter());
				List<Member> deptMemberList = projectService.selectMemberListByDeptCode(pm);
				
				map.put("projectMemberList", projectMemberList);
				map.put("deptMemberList", deptMemberList);
				
			}catch(Exception e) {
				logger.error(e.getMessage(), e);
				throw new ProjectException("프로젝트 팀원 조회 오류!");
			}
		return map;
	}
	
	@RequestMapping("/project/workSetting.do")
	@ResponseBody
	public ModelAndView workSetting(ModelAndView mav, HttpServletRequest request) {
		int workNo = Integer.parseInt(request.getParameter("workNo"));
		String worklistTitle = request.getParameter("worklistTitle");
		int projectNo = Integer.parseInt(request.getParameter("projectNo"));
		
		try {
			//프로젝트 팀원 리스트에 팀장 포함이면 true, 제외하면 false
			boolean isIncludeManager = true;
			Project p = projectService.selectProjectOneForSetting(projectNo,isIncludeManager);
			
			Work work = projectService.selectOneWorkForSetting(workNo);
			
			mav.addObject("project", p);
			mav.addObject("work", work);
			mav.addObject("worklistTitle",worklistTitle);
			mav.setViewName("/project/workSettingSideBar");
			
		}catch(Exception e){
			
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 속성 조회 오류!");
			
		}
		
		return mav;
	}
	
	@RequestMapping("/project/workChargedMemberSetting.do")
	@ResponseBody
	public Map<String,List<Member>> workChargedMemberSetting(HttpServletRequest request){
		Map<String, List<Member>> map = null;
			try {
				int projectNo = Integer.parseInt(request.getParameter("projectNo"));
				int workNo = Integer.parseInt(request.getParameter("workNo"));
				
				map = new HashMap<>();
				//프로젝트 팀원 리스트에 팀장 포함이면 true, 제외하면 false
				boolean isIncludeManager = true;
				Project p = projectService.selectProjectOneForSetting(projectNo,isIncludeManager);
				Work work = projectService.selectOneWorkForSetting(workNo);
				
				//프로젝트 팀원 리스트
				List<Member> projectMemberList = p.getProjectMemberList();
				
				//업무에 배정된 멤버 리스트
				List<Member> workChargedMemberList = work.getWorkChargedMemberList();
				
				map.put("projectMemberList", projectMemberList);
				map.put("workChargedMemberList", workChargedMemberList);
				
			}catch(Exception e) {
				logger.error(e.getMessage(), e);
				throw new ProjectException("프로젝트 팀원 조회 오류!");
			}
		return map;
	}
	
	@RequestMapping("/project/updateStatusCode.do")
	@ResponseBody
	public Map<String, Object> updateStatusCode(@RequestParam String statusCode, @RequestParam int projectNo){
		Map<String, Object> map = new HashMap<>();
		
		try {
			
			Map<String, Object> param = new HashMap<>();
			param.put("projectNo", projectNo);
			param.put("statusCode", statusCode);
			
			int result = projectService.updateStatusCode(param);
			
			boolean isUpdated = result>0?true:false;
			map.put("isUpdated",isUpdated );
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 상태코드 수정 오류!");
		}
		
		return map;
	}
	
	@RequestMapping("/project/updateProjectDate.do")
	@ResponseBody
	public Map<String, Object> updateProjectDate(@RequestParam String date, @RequestParam String dateType,@RequestParam String projectNo){
			Map<String, Object> map = new HashMap<>();
		
		try {
			logger.debug("date={}",date);
			logger.debug("dateType={}",dateType);
			logger.debug("projectNo={}",projectNo);
			Map<String, String> param = new HashMap<>();
			param.put("date", date);
			param.put("dateType", dateType);
			param.put("projectNo", projectNo);
			
			int result = projectService.updateProjectDate(param);
			
			boolean isUpdated = result>0?true:false;
			map.put("isUpdated",isUpdated );
			
		}catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 팀원 조회 오류!");
		}
		
		return map;
	}
	
	@RequestMapping("/project/updateProjectMember.do")
	@ResponseBody
	public ModelAndView updateProjectMember(@RequestParam String updateMemberStr, @RequestParam int projectNo, ModelAndView mav) {
		logger.debug("updateProjectMember={}",updateMemberStr);
		logger.debug("projectNo={}",projectNo);
		
		try {
			
			int result = projectService.updateProjectMember(updateMemberStr, projectNo);
			
		}catch(Exception e) {
			
		}
		return mav;
	}
	
	
}
