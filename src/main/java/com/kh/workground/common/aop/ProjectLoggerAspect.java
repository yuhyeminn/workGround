package com.kh.workground.common.aop;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.dao.ProjectDAO2;
import com.kh.workground.project.model.exception.ProjectException;
import com.kh.workground.project.model.service.ProjectService;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;
import com.kh.workground.project.model.vo.Worklist;

@Component
@Aspect
public class ProjectLoggerAspect {
	
	private static final Logger logger = LoggerFactory.getLogger(ProjectLoggerAspect.class);
	private HttpSession session;
	private int projectNo;
	private String memberName;
	private String worklistTitle;
	private String workTitle;
	private String chkContent;
	private String chkChargedMemberName;
	private List<String> addMemList;
	private List<String> delMemList;
	
	@Autowired
	ProjectService projectService;
	
	@Autowired
	ProjectDAO2 projectDAO;
	
	public String getTodayStr() {
		Date today = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		return sdf.format(today);
	}
	
	public void storeLog(String logType, String logContent, String logDate) {
		//로그 파일 저장
		logger.info("{}: {}", logType, logContent);
		
		//db 저장
		Map<String, Object> param = new HashMap<>();
		param.put("projectNo", projectNo);
		param.put("logType", logType);
		param.put("logContent", logContent);
		param.put("logDate", logDate);
		
		try {
			int result = projectService.insertProjectLog(param);
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 활동로그 추가 오류!");
		}
	}
	
	public void setBeforeMemList(String memberStr, List<String> oldMemberList) {
		//모두 삭제하는 경우
		if("".equals(memberStr) || memberStr==null) {
			delMemList = new ArrayList<>();
			for(String oldMemberId: oldMemberList) {
				delMemList.add(projectService.selectMemberName(oldMemberId));
			}
		}
		else {
			//수정할 멤버리스트 
			List<String> newMemberList = new ArrayList<>(Arrays.asList(memberStr.split(",")));
			
			//멤버 추가하는 경우
			addMemList = new ArrayList<>();
			for(String newMemberId: newMemberList) {
				if(!oldMemberList.contains(newMemberId)) {
					addMemList.add(projectService.selectMemberName(newMemberId));
				}
			}
			
			//멤버 삭제하는 경우
			delMemList = new ArrayList<>();
			for(String oldMemberId: oldMemberList) {
				if(!newMemberList.contains(oldMemberId)) {
					delMemList.add(projectService.selectMemberName(oldMemberId));
				}
			}	
		} //end of else
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController.projectView(..))", 
			returning="returnObj")
	public void afterProjectView(JoinPoint joinPoint, Object returnObj) {
		ModelAndView mav = (ModelAndView)returnObj;
		Map<String, Object> map = mav.getModel();
		
		//프로젝트view페이지에 들어갈 때마다 프로젝트 번호가 저장된 세션을 필드에 저장
		if(map.containsKey("session")) {
			HttpSession session = (HttpSession)map.get("session");
			this.session = session;
			this.projectNo = (int)session.getAttribute("projectNo");
			this.memberName = ((Member)session.getAttribute("memberLoggedIn")).getMemberName();
		}
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController.insertWorklist(..))", 
					returning="returnObj")
	public void afterInsertWorklist(JoinPoint joinPoint, Object returnObj) {
		
		ModelAndView mav = (ModelAndView)returnObj;
		Map<String, Object> map = mav.getModel();
		
		if(map.containsKey("wl")) {
			Worklist wl = (Worklist)map.get("wl");
			String wlTitle = String.valueOf(wl.getWorklistTitle());
			
			String logType = "add";
			String logContent = memberName+"님이 ["+wlTitle+"]업무리스트를 작성했습니다.";
			String logDate = getTodayStr();
			
			storeLog(logType, logContent, logDate);
		}
	}
	
	@Before("execution(* com.kh.workground.project.controller.ProjectController.updateWorklistTitle(..))")
	public void beforeUpdateWorklistTitle(JoinPoint joinPoint) {
		Object[] obj = joinPoint.getArgs();
		this.worklistTitle = projectService.selectWorklistTitleByWlNo((int)obj[0]);
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController.updateWorklistTitle(..))", 
			returning="returnObj")
	public void afterUpdateWorklistTitle(JoinPoint joinPoint, Object returnObj) {
		Object[] obj = joinPoint.getArgs();
		String newWlTitle = String.valueOf(obj[1]);
		
		HashMap map = (HashMap)returnObj;
	
		if(map.containsKey("result") && (int)map.get("result")==1) {
			String logType = "modify";
			String logContent = memberName+"님이 업무리스트["+this.worklistTitle+"] 제목을 ["+newWlTitle+"]로 변경했습니다.";
			String logDate = getTodayStr();
			
			storeLog(logType, logContent, logDate);
			
			this.worklistTitle = "";
		}
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController.deleteWorklist(..))", 
			returning="returnObj")
	public void afterDeleteWorklist(JoinPoint joinPoint, Object returnObj) {
	
		Object[] obj = joinPoint.getArgs();
		int worklistNo = (int)obj[0];
		String wlTitle = String.valueOf(obj[1]).replaceAll("<", "&lt;").replaceAll(">", "&gt;");
		
		HashMap map = (HashMap)returnObj;
		
		if(map.containsKey("result") || 1==(int)map.get("result")) {
			
			String logType = "remove";
			String logContent = memberName+"님이 ["+wlTitle+"]업무리스트를 삭제했습니다.";
			String logDate = getTodayStr();
			
			storeLog(logType, logContent, logDate);
		}
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController.insertWork(..))", 
			returning="returnObj")
	public void afterInsertWork(JoinPoint joinPoint, Object returnObj) {
	
		Object[] obj = joinPoint.getArgs();
		String workTitle = String.valueOf(obj[4]).replaceAll("<", "&lt;").replaceAll(">", "&gt;");
  		
		ModelAndView mav = (ModelAndView)returnObj;
		Map<String, Object> map = mav.getModel();
		
		if(map.containsKey("wl")) {
			Worklist wl = (Worklist)map.get("wl");
			String wlTitle = String.valueOf(wl.getWorklistTitle());
			
			String logType = "add";
			String logContent = memberName+"님이 ["+workTitle+"]업무를 "+"["+wlTitle+"]업무리스트에 작성했습니다.";
			String logDate = getTodayStr();
			
			storeLog(logType, logContent, logDate);
		}
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController.deleteWork(..))", 
			returning="returnObj")
	public void afterDeleteWork(JoinPoint joinPoint, Object returnObj) {
	
		Object[] obj = joinPoint.getArgs();
		String workTitle = String.valueOf(obj[4]);
		
		ModelAndView mav = (ModelAndView)returnObj;
		Map<String, Object> map = mav.getModel();
		
		if(map.containsKey("wl")) {
			String logType = "remove";
			String logContent = memberName+"님이 ["+workTitle+"]업무를 삭제했습니다.";
			String logDate = getTodayStr();
			
			storeLog(logType, logContent, logDate);
		}
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController.updateWorkCompleteYn(..))", 
			returning="returnObj")
	public void afterUpdateWorkCompleteYn(JoinPoint joinPoint, Object returnObj) {
		
		Object[] obj = joinPoint.getArgs();
		String yn = String.valueOf(obj[2]);
		int workNo = (int)obj[5];
		String workTitle = projectService.selectWorkTitle(workNo);
		
		ModelAndView mav = (ModelAndView)returnObj;
		Map<String, Object> map = mav.getModel();
		
		if(map.containsKey("wl")) {
			String logType = "complete";
			String logDate = getTodayStr();
			String logContent = "";
			
			//완료하는 경우
			if("N".equals(yn))
				logContent = memberName+"님이 ["+workTitle+"]업무를 완료했습니다.";
			//취소하는 경우
			else
				logContent = memberName+"님이 ["+workTitle+"]업무 완료를 취소했습니다.";
			
			storeLog(logType, logContent, logDate);
		}
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController2.insertCheckList(..))", 
			returning="returnObj")
	public void afterInsertCheckList(JoinPoint joinPoint, Object returnObj) {
	
		Object[] obj = joinPoint.getArgs();
		String workTitle = projectService.selectWorkTitle((int)obj[0]);
		String chkContent = String.valueOf(obj[2]).replaceAll("<", "&lt;").replaceAll(">", "&gt;");
  		
		HashMap map = (HashMap)returnObj;
		
		if(map.get("checklist")!=null) {
			String logType = "add";
			String logContent = memberName+"님이 ["+workTitle+"]업무에 "+"["+chkContent+"]체크리스트를 추가했습니다.";
			String logDate = getTodayStr();
			
			storeLog(logType, logContent, logDate);
		}
	}

	@Before("execution(* com.kh.workground.project.controller.ProjectController2.deleteChecklist(..))")
	public void beforeDeleteChecklist(JoinPoint joinPoint) {
		Object[] obj = joinPoint.getArgs();
		Map<String, String> map = projectService.selectChecklistContent((int)obj[0]);
		
		this.workTitle = map.get("workTitle");
		this.chkContent = map.get("chkContent");
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController2.deleteChecklist(..))", 
			returning="returnObj")
	public void afterDeleteChecklist(JoinPoint joinPoint, Object returnObj) {
	
		HashMap map = (HashMap)returnObj;
		
		if(map.containsKey("isUpdated") && true==(boolean)map.get("isUpdated")) {
			String logType = "remove";
			String logContent = memberName+"님이 ["+this.workTitle+"]업무의 "+"["+this.chkContent+"]체크리스트를 삭제했습니다.";
			String logDate = getTodayStr();
			
			storeLog(logType, logContent, logDate);
			
			this.workTitle = "";
			this.chkContent = "";
		}
	}
	
	@Before("execution(* com.kh.workground.project.controller.ProjectController2.updateChklist(..))")
	public void beforeUpdateChklist(JoinPoint joinPoint) {
		Object[] obj = joinPoint.getArgs();
		this.chkContent = projectService.selectChkContentOne(Integer.parseInt((String)obj[1]));
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController2.updateChklist(..))", 
			returning="returnObj")
	public void afterUpdateChklist(JoinPoint joinPoint, Object returnObj) {
		Object[] obj = joinPoint.getArgs();
		String newChkContent = String.valueOf(obj[0]);
		
		HashMap map = (HashMap)returnObj;
	
		if(map.containsKey("isUpdated") && (boolean)map.get("isUpdated")) {
			String logType = "modify";
			String logContent = memberName+"님이 체크리스트["+this.chkContent+"]를 ["+newChkContent+"]로 변경했습니다.";
			String logDate = getTodayStr();
			
			storeLog(logType, logContent, logDate);
			
			this.chkContent = "";
		}
	}

	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController.updateChklistCompleteYn(..))", 
			returning="returnObj")
	public void afterUpdateChklistCompleteYn(JoinPoint joinPoint, Object returnObj) {
		
		Object[] obj = joinPoint.getArgs();
		Map<String, String> result = projectService.selectChecklistContent((int)obj[1]);
		
		String yn = String.valueOf(obj[0]);
		String workTitle = result.get("workTitle");
		String chkContent = result.get("chkContent");
		
		HashMap map = (HashMap)returnObj;
		
		if(map.containsKey("result") && 1==(int)map.get("result")) {
			String logType = "complete";
			String logDate = getTodayStr();
			String logContent = "";
			
			//완료하는 경우
			if("N".equals(yn))
				logContent = memberName+"님이 ["+workTitle+"]업무의 "+"["+chkContent+"]체크리스트를 완료했습니다.";
			//취소하는 경우
			else
				logContent = memberName+"님이 ["+workTitle+"]업무의 "+"["+chkContent+"]체크리스트 완료를 취소했습니다.";
			
			storeLog(logType, logContent, logDate);
		}
	}

	@Before("execution(* com.kh.workground.project.controller.ProjectController2.updateChkChargedMember(..))")
	public void beforeUpdateChkChargedMember(JoinPoint joinPoint) {
		Object[] obj = joinPoint.getArgs();
		int checklistNo = Integer.parseInt(String.valueOf(obj[0]));
		String chkChargedMemberId = String.valueOf(obj[1]);
		
		//배정된 멤버 제거하는 경우, 제거되는 멤버 이름 가져오기  
		if(chkChargedMemberId.equals("") || chkChargedMemberId==null) 
			this.chkChargedMemberName = projectService.selectChkChargedMemberName(checklistNo);
		//배정하는 경우, 배정되는 멤버 이름 가져오기
		else
			this.chkChargedMemberName = projectService.selectMemberName(chkChargedMemberId);
		
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController2.updateChkChargedMember(..))", 
			returning="returnObj")
	public void afterUpdateChkChargedMember(JoinPoint joinPoint, Object returnObj) {
		
		Object[] obj = joinPoint.getArgs();
		int checklistNo = Integer.parseInt(String.valueOf(obj[0]));
		Map<String, String> result = projectService.selectChecklistContent(checklistNo);
		
		String workTitle = result.get("workTitle");
		String chkContent = result.get("chkContent");
		String chkChargedMemberId = String.valueOf(obj[1]);
		
		HashMap map = (HashMap)returnObj;
		
		if(map.containsKey("isUpdated") && (boolean)map.get("isUpdated")) {
			String logType = "member";
			String logDate = getTodayStr();
			String logContent = "";
			
			//배정된 멤버 제거하는 경우
			if(chkChargedMemberId.equals("") || chkChargedMemberId==null) 
				logContent = memberName+"님이 ["+this.chkChargedMemberName+"]님을 ["+workTitle+"]업무의 "+"["+chkContent+"]체크리스트에서 제거했습니다.";
			//배정하는 경우
			else
				logContent = memberName+"님이 ["+this.chkChargedMemberName+"]님을 ["+workTitle+"]업무의 "+"["+chkContent+"]체크리스트에 배정했습니다.";
			
			storeLog(logType, logContent, logDate);
			
			this.chkChargedMemberName = "";
		}
	}

	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController2.updateDesc(..))", 
			returning="returnObj")
	public void afterUpdateDesc(JoinPoint joinPoint, Object returnObj) {
		
		Object[] obj = joinPoint.getArgs();
		String type = String.valueOf(obj[2]);
		
		if("work".equals(type)) {
			int workNo = Integer.parseInt(String.valueOf(obj[0]));
			String workTitle = projectService.selectWorkTitle(workNo);
			
			HashMap map = (HashMap)returnObj;
			
			if(map.containsKey("isUpdated") && (boolean)map.get("isUpdated")) {
				String logType = "modify";
				String logDate = getTodayStr();
				String logContent =  memberName+"님이 업무["+workTitle+"]의 설명을 수정했습니다.";
				
				storeLog(logType, logContent, logDate);
			}
		}
	}

	@Before("execution(* com.kh.workground.project.controller.ProjectController2.updateTitle(..))")
	public void beforeuUpdateTitle(JoinPoint joinPoint) {
		Object[] obj = joinPoint.getArgs();
		String type = String.valueOf(obj[2]);
		
		if("work".equals(type)) {
			int workNo = Integer.parseInt(String.valueOf(obj[0]));
			this.workTitle = projectService.selectWorkTitle(workNo);
		}
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController2.updateTitle(..))", 
			returning="returnObj")
	public void afterUpdateTitle(JoinPoint joinPoint, Object returnObj) {
		
		Object[] obj = joinPoint.getArgs();
		String type = String.valueOf(obj[2]);
		
		if("work".equals(type)) {
			String workTitle = String.valueOf(obj[1]).replaceAll("<", "&lt;").replaceAll(">", "&gt;");
			
			HashMap map = (HashMap)returnObj;
			
			if(map.containsKey("isUpdated") && (boolean)map.get("isUpdated")) {
				String logType = "modify";
				String logDate = getTodayStr();
				String logContent =  memberName+"님이 업무["+this.workTitle+"]의 제목을 ["+workTitle+"]로 수정했습니다.";
				
				storeLog(logType, logContent, logDate);
				
				this.workTitle = "";
 			}
		}
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController2.updateWorkDate(..))", 
			returning="returnObj")
	public void afterUpdateWorkDate(JoinPoint joinPoint, Object returnObj) {
		
		Object[] obj = joinPoint.getArgs();
		
		int workNo = Integer.parseInt(String.valueOf(obj[2]));
		String workTitle = projectService.selectWorkTitle(workNo);
		String date = String.valueOf(obj[0]);
		String type = String.valueOf(obj[1]);
		
		HashMap map = (HashMap)returnObj;
		
		if(map.containsKey("isUpdated") && (boolean)map.get("isUpdated")) {
			String logType = "date";
			String logDate = getTodayStr();
			String logContent = "";
			
			//시작일인 경우
			if("work_startdate".equals(type)) {
				if("".equals(date) || date==null)
					logContent =  memberName+"님이 ["+workTitle+"]업무의 시작일을 제거했습니다.";
				else
					logContent =  memberName+"님이 ["+workTitle+"]업무의 시작일을 ["+date+"]로 수정했습니다.";
					
				storeLog(logType, logContent, logDate);
			}
			//마감일인 경우
			else {
				if("".equals(date) || date==null)
					logContent =  memberName+"님이 ["+workTitle+"]업무의 마감일을 제거했습니다.";
				else
					logContent =  memberName+"님이 ["+workTitle+"]업무의 마감일을 ["+date+"]로 수정했습니다.";
				
				storeLog(logType, logContent, logDate);
			}
		}
		
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController2.updateWorkTag(..))", 
			returning="returnObj")
	public void afterUpdateWorkTag(JoinPoint joinPoint, Object returnObj) {
		
		Object[] obj = joinPoint.getArgs();
		
		String workTag = String.valueOf(obj[0]);
		int workNo = (int)obj[1];
		String workTitle = projectService.selectWorkTitle(workNo);
		
		HashMap map = (HashMap)returnObj;
		
		if(map.containsKey("isUpdated") && (boolean)map.get("isUpdated")) {
			String logType = "tag";
			String logDate = getTodayStr();
			String logContent = "";
			
			if("".equals(workTag) || workTag==null) {
				logContent =  memberName+"님이 태그를 ["+workTitle+"]업무에서 제거했습니다.";
			}
			else {
				workTag = "WT1".equals(workTag)?"priority":"WT2".equals(workTag)?"important":"review";
				logContent =  memberName+"님이 태그 ["+workTag+"]를 ["+workTitle+"]업무에 설정했습니다.";
			}
				
			storeLog(logType, logContent, logDate);
		}
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController2.updateWorkPoint(..))", 
			returning="returnObj")
	public void afterUpdateWorkPoint(JoinPoint joinPoint, Object returnObj) {
		
		Object[] obj = joinPoint.getArgs();
		
		int workPoint = (int)obj[0];
		int workNo = (int)obj[1];
		String workTitle = projectService.selectWorkTitle(workNo);
		
		HashMap map = (HashMap)returnObj;
		
		if(map.containsKey("isUpdated") && (boolean)map.get("isUpdated")) {
			String logType = "point";
			String logDate = getTodayStr();
			String logContent = memberName+"님이 포인트["+workPoint+"]점을 ["+workTitle+"]업무에 설정했습니다.";
			
			storeLog(logType, logContent, logDate);
		}
	}

	@Before("execution(* com.kh.workground.project.controller.ProjectController2.updateWorkMember(..))")
	public void beforeUpdateWorkMember(JoinPoint joinPoint) {
		Object[] obj = joinPoint.getArgs();
		
		int workNo = (int)obj[1];
		Work work = projectDAO.selectOneWorkForSetting(workNo);
		
		//수정할 멤버리스트 
		String memberStr = String.valueOf(obj[0]);
		
		//기존멤버 리스트
		List<String> oldMemberList = new ArrayList<>();
		for(Member m : work.getWorkChargedMemberList()) {
			oldMemberList.add(m.getMemberId());
		}
		
		setBeforeMemList(memberStr, oldMemberList);
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController2.updateWorkMember(..))", 
			returning="returnObj")
	public void afterUpdateWorkMember(JoinPoint joinPoint, Object returnObj) {
		
		Object[] obj = joinPoint.getArgs();
		
		int workNo = (int)obj[1];
		String workTitle = projectService.selectWorkTitle(workNo);
		
		HashMap map = (HashMap)returnObj;
		
		if(map.containsKey("isUpdated") && (boolean)map.get("isUpdated")) {
			String logType = "member";
			String logDate = getTodayStr();
			String logContent = "";
			
			//멤버 추가하는 경우
			if(addMemList!=null && !addMemList.isEmpty()) {
				for(String name: addMemList) {
					logContent = memberName+"님이 ["+name+"]님을 ["+workTitle+"]업무에 배정했습니다.";
					storeLog(logType, logContent, logDate);
				}
			}
			
			//멤버 삭제하는 경우
			if(delMemList!=null && !delMemList.isEmpty()) {
				for(String name: delMemList) {
					logContent = memberName+"님이 ["+name+"]님을 ["+workTitle+"]업무에서 제거했습니다.";
					storeLog(logType, logContent, logDate);
				}
			}
			
			addMemList.clear();
			delMemList.clear();
			
		} //end of if
	}
	
	
	@Before("execution(* com.kh.workground.project.controller.ProjectController2.updateWorkLocation(..))")
	public void beforeUpdateWorkLocation(JoinPoint joinPoint) {
		Object[] obj = joinPoint.getArgs();
		int workNo = (int)obj[0];
		String worklistTitle = projectService.selectWorklistTitle(workNo);
		this.worklistTitle = worklistTitle;
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController2.updateWorkLocation(..))", 
			returning="returnObj")
	public void afterUpdateWorkLocation(JoinPoint joinPoint, Object returnObj) {
		
		Object[] obj = joinPoint.getArgs();
		
		int workNo = (int)obj[0];
		int worklistNo = (int)obj[1];
		String workTitle = projectService.selectWorkTitle(workNo);
		String worklistTitle = projectService.selectWorklistTitleByWlNo(worklistNo);
		
		HashMap map = (HashMap)returnObj;
		
		if(map.containsKey("isUpdated") && (boolean)map.get("isUpdated")) {
			String logType = "modify";
			String logDate = getTodayStr();
			String logContent = memberName+"님이 ["+workTitle+"]업무를 ["+this.worklistTitle+"]에서 ["+worklistTitle+"]로 이동시켰습니다.";
			
			storeLog(logType, logContent, logDate);
		}
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController2.quitProject(..))", 
			returning="returnObj")
	public void afterQuitProject(JoinPoint joinPoint, Object returnObj) {
		
		Object[] obj = joinPoint.getArgs();
		
		ModelAndView mav = (ModelAndView)returnObj;
		Map<String, Object> map = mav.getModel();
		
		if(map.containsKey("msg") && "성공적으로 처리되었습니다.".equals(map.get("msg"))) {
			String logType = "member";
			String logDate = getTodayStr();
			String logContent = memberName+"님이 프로젝트를 나갔습니다.";
			
			storeLog(logType, logContent, logDate);
		}
		
	}

	@Before("execution(* com.kh.workground.project.controller.ProjectController2.updateProjectMember(..))")
	public void beforeUpdateProjectMember(JoinPoint joinPoint) {
		Object[] obj = joinPoint.getArgs();
		
		//수정할 멤버리스트 
		String memberStr = String.valueOf(obj[0]);
		
		//기존멤버 리스트
		List<Member> pMemList = projectDAO.selectProjectMemberList(projectNo);
		List<String> oldMemberList = new ArrayList<>();
		for(Member m : pMemList) {
			//매니저가 아닌 팀원만
			if("N".equals(m.getManagerYn()))
				oldMemberList.add(m.getMemberId());
		}
		
		setBeforeMemList(memberStr, oldMemberList);
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController2.updateProjectMember(..))", 
			returning="returnObj")
	public void afterUpdateProjectMember(JoinPoint joinPoint, Object returnObj) {
		
		Object[] obj = joinPoint.getArgs();
		
		HashMap map = (HashMap)returnObj;
		
		if(map.containsKey("isUpdated") && (boolean)map.get("isUpdated")) {
			String logType = "member";
			String logDate = getTodayStr();
			String logContent = "";
			
			//멤버 추가하는 경우
			if(addMemList!=null && !addMemList.isEmpty()) {
				for(String name: addMemList) {
					logContent = memberName+"님이 ["+name+"]님을 프로젝트 팀원으로 추가했습니다.";
					storeLog(logType, logContent, logDate);
				}
			}
			
			//멤버 삭제하는 경우
			if(delMemList!=null && !delMemList.isEmpty()) {
				for(String name: delMemList) {
					logContent = memberName+"님이 ["+name+"]님을 프로젝트 팀원에서 제거했습니다.";
					storeLog(logType, logContent, logDate);
				}
			}
			
			addMemList.clear();
			delMemList.clear();
			
		} //end of if
	}
	
	@Before("execution(* com.kh.workground.project.controller.ProjectController2.updateProjectManager(..))")
	public void beforeUpdateProjectManager(JoinPoint joinPoint) {
		Object[] obj = joinPoint.getArgs();
		
		//수정할 멤버리스트 
		String memberStr = String.valueOf(obj[0]);
		
		//기존멤버 리스트
		List<Member> pMemList = projectDAO.selectProjectMemberList(projectNo);
		List<String> oldMemberList = new ArrayList<>();
		for(Member m : pMemList) {
			//매니저만
			if("Y".equals(m.getManagerYn()))
				oldMemberList.add(m.getMemberId());
		}
		
		setBeforeMemList(memberStr, oldMemberList);
	}
	
	@AfterReturning(pointcut="execution(* com.kh.workground.project.controller.ProjectController2.updateProjectManager(..))", 
			returning="returnObj")
	public void afterUpdateProjectManager(JoinPoint joinPoint, Object returnObj) {
		
		Object[] obj = joinPoint.getArgs();
		
		HashMap map = (HashMap)returnObj;
		
		if(map.containsKey("isUpdated") && (boolean)map.get("isUpdated")) {
			String logType = "member";
			String logDate = getTodayStr();
			String logContent = "";
			
			//멤버 추가하는 경우
			if(addMemList!=null && !addMemList.isEmpty()) {
				for(String name: addMemList) {
					logContent = memberName+"님이 ["+name+"]님에게 관리자 권한을 부여했습니다.";
					storeLog(logType, logContent, logDate);
				}
			}
			
			//멤버 삭제하는 경우
			if(delMemList!=null && !delMemList.isEmpty()) {
				for(String name: delMemList) {
					logContent = memberName+"님이 ["+name+"]님에게서 관리자 권한을 해제했습니다.";
					storeLog(logType, logContent, logDate);
				}
			}
			
			addMemList.clear();
			delMemList.clear();
			
		} //end of if
	}
	
}
