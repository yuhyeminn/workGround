package com.kh.workground.project.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.exception.ProjectException;
import com.kh.workground.project.model.service.ProjectService;
import com.kh.workground.project.model.vo.Project;
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
			//1-1.부서 전체 프로젝트/중요 표시된 프로젝트/내가 속한 프로젝트(내 워크패드 포함)
			String sortType = "project_startdate";
			String statusCode = "ALL";
			
			Map<String, String> param = new HashMap<>();
			param.put("statusCode", statusCode);
			param.put("sortType", sortType);
			
			projectMap = projectService.selectProjectListAll(param, memberLoggedIn);
			
			//1-2.부서 전체 프로젝트 상태 카운트
			List<Project> listByDept = projectMap.get("listByDept");
			
			for(Project p: listByDept) {
				statusCode = p.getProjectStatusCode();
				
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
			mav.setViewName("/project/projectList"); 
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 목록 조회 오류!");
		}
		
		return mav;
	}
	
	@RequestMapping("/project/projectView.do")
	public ModelAndView projectView(ModelAndView mav, HttpSession session, HttpServletRequest request, @RequestParam int projectNo, 
									@RequestParam(defaultValue="work", required=false) String tab) {
		
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String loggedInMemberId = memberLoggedIn.getMemberId();
		
		try {
			//1.업무로직
			//1-1.해당 프로젝트 조회
			Project p = projectService.selectProjectWorklistAll(projectNo, loggedInMemberId);
			
			//1-2.프로젝트에 내가 속해있는지 여부
			boolean bool = false;
			List<Member> list = p.getProjectMemberList();
			List<Member> inMemList = new ArrayList<>(); //나간 멤버 제외한 리스트
			
			for(Member m: list) {
				String memId = m.getMemberId();
				String yn = m.getProjectQuitYn();
				if(loggedInMemberId.equals(memId) && yn.equals("N"))
					bool = true;
				
				if(yn.equals("N"))
					inMemList.add(m);
			}
			
			//1-3.관리자인 경우
			if("admin".equals(loggedInMemberId)) bool = true;
			
			//2.뷰모델 처리: 프로젝트 속함 여부에 따라 분기
			if(!bool) {
				String[] urlArr = request.getHeader("referer").split("/");
				logger.debug("urlArr={}", urlArr);
				mav.addObject("msg", "내가 속한 프로젝트가 아닙니다!");
				mav.addObject("loc", "/"+urlArr[4]+"/"+urlArr[5]);
				mav.setViewName("/common/msg");
			}
			else {
				mav.addObject("project", p);
				mav.addObject("allMemList", list);
				mav.addObject("inMemList", inMemList);
				mav.addObject("wlList", p.getWorklistList());
				
				//서브헤더 탭에 따라 분기
				if("work".equals(tab))
					mav.setViewName("/project/projectView");
				else if("attach".equals(tab))
					mav.setViewName("/project/projectAttachment");
				else if("timeline".equals(tab))
					mav.setViewName("/project/projectTimeline");
			}
			
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
	public ModelAndView insertWorklist(ModelAndView mav, HttpSession session, @RequestParam int projectNo, @RequestParam String worklistTitle, @RequestParam String projectManager) {
		
		try {
			//1.업무로직
			Map<String, Object> param = new HashMap<>();
			param.put("projectNo", projectNo);
			param.put("worklistTitle", worklistTitle);
			
			//1-1. 업무리스트 추가하고, 그 업무리스트 가져오기 
			Worklist wl = projectService.insertWorklist(param);
			
			//2.뷰모델 처리
			mav.addObject("wl", wl);
			mav.addObject("projectManager", projectManager);
			mav.setViewName("/project/ajaxWorklist");
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무리스트 생성 오류!");
		}
		
		return mav;
	}
	
	@PostMapping("/project/deleteWorklist.do")
	@ResponseBody
	public Map<String, Integer> deleteWorklist(@RequestParam int worklistNo) {
		Map<String, Integer> map = new HashMap<>();
		
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
	
	@PostMapping("/project/updateChklistCompleteYn.do")
	@ResponseBody
	public Map<String, Integer> updateChklistCompleteYn(@RequestParam String completeYn, @RequestParam int checklistNo) {
		Map<String, Integer> map = new HashMap<>();
		
		try {
			Map<String, Object> param = new HashMap<>();
			param.put("checklistNo", checklistNo);
			
			//체크리스트 완료하는 경우
			if("N".equals(completeYn)) {
				Date today = new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				
				param.put("completeYn", "Y");
				param.put("endDate", sdf.format(today));
			}
			//체크리스트 완료 해제하는 경우
			else {
				param.put("completeYn", "N");
				param.put("endDate", null);
			}
				
			//업무로직
			int result = projectService.updateChklistCompleteYn(param);
			map.put("result", result);	
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("체크리스트 완료여부 업데이트 오류!");
		}
		return map;
	}
	
	@RequestMapping("/project/searchWork")
	public ModelAndView searchWork(ModelAndView mav, @RequestParam int projectNo, @RequestParam String keyword, @RequestParam String memberId) {
		
		try {
			//1.업무로직
			Project p = projectService.searchWork(projectNo, keyword);
			
			//2.뷰모델 처리
			mav.addObject("keywordBefore", keyword);
			mav.addObject("project", p);
			mav.addObject("wlList", p.getWorklistList());
			mav.setViewName("/project/ajaxWorkSearch");
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무 검색 오류!");
		}
		
		return mav;
	}
	
	@PostMapping("/project/insertWork.do")
	public ModelAndView insertWork(ModelAndView mav, @RequestParam(value="projectManager") String projectManager,
										   @RequestParam(value="projectNo") int projectNo, 
									       @RequestParam(value="worklistNo") int worklistNo, 
										   @RequestParam(value="workTitle") String workTitle,
										   @RequestParam(value="workChargedMember[]", required=false) List<String> workChargedMember,
										   @RequestParam(value="workTag", required=false) String workTag,
										   @RequestParam(value="workDate[]", required=false) List<String> workDate){
		
		try {
			//1.업무로직
			//1-1.파라미터 map에 담기
			Map<String, Object> param = new HashMap<>();
			param.put("worklistNo", worklistNo);
			param.put("workTitle", workTitle);
			
			if(workChargedMember==null) param.put("workChargedMember", null);
			else param.put("workChargedMember", workChargedMember);
			
			if(workTag==null) param.put("workTag", null);
			else param.put("workTag", workTag);
			
			if(workDate==null) param.put("workDate", null);
			else param.put("workDate", workDate);
			
			//1-2.추가
			int result = projectService.insertWork(param);
			
			ajaxWorkSetView(mav, projectNo, worklistNo, projectManager);
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("새 업무 만들기 오류!");
		}
		
		return mav;
	}
	
	@PostMapping("/project/deleteWork.do")
	public ModelAndView deleteWork(ModelAndView mav, @RequestParam int projectNo, @RequestParam int worklistNo, @RequestParam int workNo,
									@RequestParam int cntChk, @RequestParam int cntComment, @RequestParam int cntFile,
									@RequestParam String projectManager) {
		
		try {
			//1.workNo를 참조하고 있는 체크리스트, 코멘트, 파일 삭제
			int delChkResult = 0;
			int delCommentResult = 0;
			int delAttachResult = 0;
			
			if(cntChk>0) {
				logger.debug("cntChk>0");
				delChkResult = projectService.deleteChecklistByWorkNo(workNo, cntChk);
			}
			if(cntComment>0)
				delCommentResult = projectService.deleteCommentByWorkNo(workNo, cntComment);
			if(cntFile>0)
				delAttachResult = projectService.deleteAttachByWorkNo(workNo, cntFile);
			
			//2.업무 삭제
			int result = 0;
			if(delChkResult==cntChk && delCommentResult==cntComment && delAttachResult==cntFile) {
				result = projectService.deleteWork(workNo);
			}
			
			ajaxWorkSetView(mav, projectNo, worklistNo, projectManager);
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무리스트 삭제 오류!");
		}
		
		return mav;
	}
	
	@PostMapping("/project/updateWorkCompleteYn.do")
	public ModelAndView updateWorkCompleteYn(ModelAndView mav, 
											 @RequestParam String projectManager, @RequestParam String completeYn, 
											 @RequestParam int projectNo, @RequestParam int worklistNo, @RequestParam int workNo) {
		
		try {
			//1.업무로직
			//1-1.파라미터 담기
			Map<String, Object> param = new HashMap<>();
			param.put("workNo", workNo);
			
			//업무 완료하는 경우
			if("N".equals(completeYn)) {
				Date today = new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				
				param.put("completeYn", "Y");
				param.put("realEndDate", sdf.format(today));
			}
			//완료 해제하는 경우
			else {
				param.put("completeYn", "N");
				param.put("realEndDate", null);
			}
			
			//1-2.완료여부 업데이트하기
			int result = projectService.updateWorkCompleteYn(param);
			
			ajaxWorkSetView(mav, projectNo, worklistNo, projectManager);
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무완료 업데이트 오류!");
		}
		
		return mav;
	}
	
	public void ajaxWorkSetView(ModelAndView mav, int projectNo, int worklistNo, String projectManager) {
		//1-3.변동된 worklist가져오기
		Worklist wl = projectService.selectWorklistOne(projectNo, worklistNo);
		
		//1-4.프로젝트에 속한 멤버
		List<Member> inMemList = projectService.selectProjectMemberListByQuitYn(projectNo);
		
		//1-5.프로젝트 private여부
		String privateYn = projectService.selectProjectPrivateYn(projectNo);
		
		//2.뷰모델 처리
		mav.addObject("projectNo", projectNo);
		mav.addObject("privateYn", privateYn);
		mav.addObject("wl", wl);
		mav.addObject("inMemList", inMemList);
		mav.addObject("projectManager", projectManager);
		mav.setViewName("/project/ajaxWork");
	}
	
	@RequestMapping("/project/downloadFile.do")
	public ModelAndView downloadFile(HttpServletRequest request, HttpServletResponse response, @RequestParam String projectNo,
									 @RequestParam String oName, @RequestParam String rName) throws Exception {
		
		//1.파일 찾기

		String saveDir = request.getSession().getServletContext().getRealPath("/resources/upload/project/"+projectNo);

		File downloadFile = new File(saveDir+File.separator+rName);
		
		if(!downloadFile.canRead())
			throw new ProjectException("다운로드할 파일을 찾을 수 없습니다!");
		
		//2.뷰모델처리
		ModelMap model = new ModelMap();
		model.put("downloadFile", downloadFile);
		model.put("oName", oName);
		
		return new ModelAndView("downloadView", "model", model);
	}
	
	@PostMapping("/project/deleteFile")
	@ResponseBody
	public Map<String, String> deleteFile(HttpServletRequest request, @RequestParam String projectNo, @RequestParam int attachNo, @RequestParam String rName){
		Map<String, String> map = new HashMap<>();
		
		try {
			//1.파일삭제

			String saveDir = request.getSession().getServletContext().getRealPath("/resources/upload/project/"+projectNo);

			File delFile = new File(saveDir+File.separator+rName);
			
			boolean bool = delFile.delete();
			int result = 0;
			
			//2.업무로직
			//파일삭제 성공한 경우
			if(bool) {
				result = projectService.deleteFile(attachNo);
				if(result==1)
					map.put("result", "success");
				else
					map.put("result", "fail");
			}
			//파일삭제 실패한 경우
			else {
				map.put("result", "fail");
			}
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("파일삭제 오류!");
		}
		
		return map;
	}
	
	@RequestMapping(value="/project/deleteProject.do", method= {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView deleteProject(ModelAndView mav, HttpSession session, @RequestParam int projectNo) {
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		
		try {
			//1.업무로직
			int result = projectService.deleteProject(projectNo);
			
			String viewName = "";
			//2. 뷰모델처리 
			if(result!=0) {
				//관리자인 경우
				if("admin".equals(memberLoggedIn.getMemberId())) {
					viewName = "redirect:/admin/adminProjectList.do";
				}
				//관리자 아닌 경우
				else {
					viewName = "redirect:/project/projectList.do";
				}
				mav.setViewName(viewName);
			}
			else {
				viewName = "/common/msg";
				mav.addObject("msg", "프로젝트 삭제에 실패했습니다!");
				mav.addObject("loc", "/project/projectList");
				mav.setViewName(viewName);
			}
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 삭제 오류!");
		}
		
		return mav;
	}
	
	@RequestMapping("/project/projectChatting.do")
	public ModelAndView projectChatting(ModelAndView mav, @RequestParam int projectNo) {
		
		try {
			
			mav.setViewName("project/projectChattingSideBar");
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 채팅창 조회 오류!");
		}
		
		return mav;
	}
		
	@RequestMapping("/project/sortProjectList.do")
	public ModelAndView sortProjectList(ModelAndView mav, HttpSession session, @RequestParam(value="statusCode",defaultValue="ALL") String statusCode,
			@RequestParam(value="sortType",defaultValue="project_startdate") String sortType) {
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		List<Member> memberListByDept = null; //부서 사람들 담는 리스트
		Map<String, List<Project>> projectMap = null; //조회한 프로젝트 리스트 담는 맵
		
		try {
			//1.업무로직
			//1-1.부서 전체 프로젝트/중요 표시된 프로젝트/내가 속한 프로젝트(내 워크패드 포함)
			Map<String, String> param = new HashMap<>();
			param.put("statusCode", statusCode);
			param.put("sortType", sortType);
			
			projectMap = projectService.selectProjectListAll(param,memberLoggedIn);
			
			//2.뷰모델 처리
			mav.addObject("projectMap", projectMap);
			mav.setViewName("/project/ajaxProjectSort"); 
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 목록 조회 오류!");
		}
		
		return mav;
	}
	
	@PostMapping("/project/resetWorklist.do")
	public ModelAndView resetWorklist(ModelAndView mav, @RequestParam int projectNo, @RequestParam int worklistNo,@RequestParam String projectManager) {
		
		try {
			
			ajaxWorkSetView(mav, projectNo, worklistNo, projectManager);
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("업무리스트 삭제 오류!");
		}
		
		return mav;
	}
	

}
