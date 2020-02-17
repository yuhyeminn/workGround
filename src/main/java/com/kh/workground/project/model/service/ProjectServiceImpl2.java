package com.kh.workground.project.model.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.controller.ProjectController2;
import com.kh.workground.project.model.dao.ProjectDAO2;
import com.kh.workground.project.model.exception.ProjectException;
import com.kh.workground.project.model.vo.Attachment;
import com.kh.workground.project.model.vo.Checklist;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;
import com.kh.workground.project.model.vo.WorkComment;
import com.kh.workground.project.model.vo.Worklist;
@Service
public class ProjectServiceImpl2 implements ProjectService2 {
	@Autowired
	ProjectDAO2 projectDAO;
	private static final Logger logger = LoggerFactory.getLogger(ProjectController2.class);
	
	@Override
	public int insertProject(Project p, List<String> projectMemberList) {
		int result = 0;
		//1.프로젝트 생성
		result = projectDAO.insertProject(p);
		if(result == 0)
			throw new ProjectException("프로젝트 생성 오류!");
		
		//2.프로젝트 팀장 추가(memberLoggedIn)
		//selectKey로 p에 projectNo 추가됨
		result = projectDAO.insertProjectManager(p);
		if(result == 0)
			throw new ProjectException("프로젝트 팀장 추가 오류!");
		
		//3.프로젝트 멤버 추가
		for(String memberId:projectMemberList) {
			Map<String, String> param = new HashMap<>();
			param.put("projectNo", Integer.toString(p.getProjectNo()));
			param.put("projectMember", memberId);
			result = projectDAO.insertProjectMember(param);
			
			if(result == 0)
				throw new ProjectException("팀원 추가 오류!");
		}
		
		//4.업무리스트 기본 3 개 생성(해야할 일, 진행중, 완료됨)
		List<String> worklistTitle = new ArrayList<>();
		Map<String, Object> param = new HashMap<>();
		param.put("projectNo", p.getProjectNo());
		worklistTitle.add("해야할 일");
		worklistTitle.add("진행중");
		worklistTitle.add("완료됨");
		param.put("worklistTitle", worklistTitle);
		result = projectDAO.insertDefaultWorkList(param);
		
		return result;
	}

	@Override
	public List<Member> selectMemberListByManagerId(String projectWriter) {
		List<Member> list = projectDAO.selectMemberListByManagerId(projectWriter);
		
		if(list==null) 
			throw new ProjectException("팀원 조회 오류!");
		
		return list;
	}

	@Override
	public Map<String, List<Project>> selectProjectListByStatusCode(Map<String, Object> param) {
		Map<String, List<Project>> map = new HashMap<>();
		
		//1. 부서 전체 프로젝트(최근 프로젝트) 조회
		List<Project> listByDept = projectDAO.selectListByDeptAndStatusCode(param);
		
		if(listByDept==null)
			throw new ProjectException("최근 프로젝트 조회 오류!");
		else
			map.put("listByDept", listByDept);
		
		//2. 중요 표시된 프로젝트 조회
		List<Project> listByImportant = projectDAO.selectListByImportantAndStatusCode(param);
		
		if(listByImportant==null)
			throw new ProjectException("중요 표시된 프로젝트 조회 오류!");
		else 
			map.put("listByImportant", listByImportant);
		
		//3. 내가 속한 프로젝트(내 워크패드 제외) 조회	
		List<Project> listByInclude = new ArrayList<>();
		
		//3-2. 1번에서 구한 프로젝트 리스트에서 내가 포함된 리스트만 listByInclude에 추가
		boolean bool = false; //내가 포함됐는지 여부
		if(!listByDept.isEmpty()) {
			for(Project p: listByDept) {
				bool = false;
				List<Member> memList = p.getProjectMemberList();
				logger.debug("memList={}",memList);
				for(Member m: memList) {
					String pMemId = m.getMemberId();
					Member member = (Member)param.get("memberLoggedIn");
					if((member.getMemberId()).equals(pMemId)) {
						bool = true;
					}
				}
				
				//포함됐으면 list에 추가
				if(bool) 
					listByInclude.add(p);
			}
		}
		
		map.put("listByInclude", listByInclude);
		
		return map;
	}

	@Override
	public Project selectProjectOneForSetting(int projectNo,boolean isIncludeManager) {
		
		Project p = projectDAO.selectProjectOneForSetting(projectNo);
		if(p==null) {
			throw new ProjectException("중요 표시된 프로젝트 조회 오류!");
		}
		if(!isIncludeManager) {
			List<Member> list = p.getProjectMemberList();
			for(int i=0;i<list.size();i++) {
				Member m = list.get(i);
				if(("Y").equals(m.getManagerYn())) {
					list.remove(i);
				}
			}
		}
		List<Worklist> worklistList = projectDAO.selectWorklistListByProjectNo(projectNo);
		if(worklistList==null) {
			throw new ProjectException("업무리스트 조회 오류!");
		}
		
		p.setWorklistList(worklistList);
		return p;
	}

	@Override
	public List<Member> selectProjectManagerByDept(String projectManager) {
		List<Member> list = projectDAO.selectProjectManagerByDept(projectManager);
		if(list == null) {
			throw new ProjectException("부서별 팀장 조회 오류!");
		}
		return list;
	}

	@Override
	public Work selectOneWorkForSetting(int workNo) {
		Work work = projectDAO.selectOneWorkForSetting(workNo);
		if(work == null) {
			throw new ProjectException("업무 조회 오류!");
		}
		
		//체크리스트의 리스트
		List<Checklist> chklstList = projectDAO.selectChklstListByWorkNo(workNo);
		
		//체크리스트 작성자, 배정된 멤버 객체 구하기
		for(Checklist chklst: chklstList) {
			Member writerMember = projectDAO.selectMemberOneByMemberId(chklst.getChecklistWriter());
			Member chargedMember = projectDAO.selectMemberOneByMemberId(chklst.getChecklistChargedMemberId());
			chklst.setChecklistWriterMember(writerMember); //체크리스트 작성자
			chklst.setChecklistChargedMember(chargedMember); //체크리스트에 배정된 멤버
		}
		
		//업무 번호로 파일리스트 가져오기
		List<Attachment> attachList = projectDAO.selectAttachmentListByWorkNo(work.getWorkNo());
		
		//업무번호로 comment가져오기
		List<WorkComment> commentList = projectDAO.selectWorkCommentListByWorkNo(work.getWorkNo());
		
		work.setChecklistList(chklstList);
		work.setAttachmentList(attachList);
		work.setWorkCommentList(commentList);
		
		return work;
	}
	//언니꺼
	@Override
	public Member selectMemberOneByMemberId(String memberId) {
		Member m = projectDAO.selectMemberOneByMemberId(memberId);
		if(m==null) {
			throw new ProjectException("회원 아이디 조회 오류!");
		}
		return m;
	}

	@Override
	public int updateStatusCode(Map<String, Object> param) {
		int result = projectDAO.updateStatusCode(param);
		if(result==0) {
			throw new ProjectException("프로젝트 상태 코드 수정 오류!");
		}
		return result; 
	}

	@Override
	public int updateProjectDate(Map<String, String> param) {
		int result = projectDAO.updateProjectDate(param);
		if(result==0) {
			throw new ProjectException("프로젝트 날짜 관련 수정 오류!");
		}
		return result; 
	}

	@Override
	public int updateProjectMember(String updateMemberStr, int projectNo) {
		int result = 1;
		
		//수정할 프로젝트 회원 리스트
		String[] updateMemberArr = updateMemberStr.split(",");
		List<String> updateMemberList = new ArrayList<>(Arrays.asList(updateMemberArr));
//		logger.debug("updateMemberList={}",updateMemberList);
		
		//프로젝트 전체 회원 리스트(이전에 나갔었던 멤버까지 조회)
		List<Member> projectAllMemberList = projectDAO.selectProjectMemberIdList(projectNo);
		if(projectAllMemberList==null) throw new ProjectException("프로젝트 멤버 조회 오류!");
		
//		logger.debug("projectAllMemberList={}",projectAllMemberList);
		
		List<String> projectMemberList = new ArrayList<>(); 	//기존 프로젝트 회원 리스트
		List<String> projectQuitMemberList = new ArrayList<>();
		for(Member m : projectAllMemberList) {
			if(("N").equals(m.getProjectQuitYn())){
				projectMemberList.add(m.getMemberId());
			}else {
				projectQuitMemberList.add(m.getMemberId());
			}
		}
		
//		logger.debug("projectMemberList={}",projectMemberList);
//		logger.debug("projectQuitMemberList={}",projectQuitMemberList);
		
		//새롭게 추가되는 프로젝트 멤버
		for(String memberId : updateMemberList) {
			if(!projectMemberList.contains(memberId) && !projectQuitMemberList.contains(memberId)) {
				Map<String, String> param = new HashMap<>();
				param.put("projectNo", Integer.toString(projectNo));
				param.put("projectMember", memberId);
				result = projectDAO.insertProjectMember(param);
				if(result==0) throw new ProjectException("프로젝트 멤버 수정 (추가) 오류!");
			}
			//quit_yn이 y인 멤버 리스트.. projectQuitMemberList에 memberId가 포함되어있다..? 그렇다면.. 다시 컬럼을 y로..변경..^^,,
			if(projectQuitMemberList.contains(memberId)) {
				Map<String, String> param = new HashMap<>();
				param.put("projectNo", Integer.toString(projectNo));
				param.put("projectMember", memberId);
				param.put("quitYN", "N");
				result = projectDAO.updateProjectQuit(param);
				if(result==0) throw new ProjectException("프로젝트 멤버 수정 (재추가) 오류!");
			}
		}
		//기존 프로젝트 멤버였는데 삭제되는 프로젝트 멤버
		for(String memberId : projectMemberList) {
			if(!updateMemberList.contains(memberId)) {
				Map<String, String> param = new HashMap<>();
				param.put("projectNo", Integer.toString(projectNo));
				param.put("projectMember", memberId);
				param.put("quitYN", "Y");
				result = projectDAO.updateProjectQuit(param);
				if(result==0) throw new ProjectException("프로젝트 멤버 수정 (삭제) 오류!");
			}
		}
		
		return result;
	}

	@Override
	public int updateProjectManager(Map<String, String> param) {
		int result = projectDAO.updateProjectManager(param);
		if(result==0) throw new ProjectException("프로젝트 관리자 수정 오류!");
		return result;
	}

	@Override
	public int updateProjectQuit(Map<String, String> param) {
		int result = projectDAO.updateProjectQuit(param);
		if(result==0) throw new ProjectException("프로젝트 나가기 오류!");
		return result;
	}

	@Override
	public int updateWorkMember(String updateWorkMemberStr, int workNo) {
		
		int result = 1;
		Work work = projectDAO.selectOneWorkForSetting(workNo);

		//수정 할 업무 배정된 멤버 리스트
		String[] updateWorkMemberArr = updateWorkMemberStr.split(",");
		List<String> updateWorkMemberList = new ArrayList<>(Arrays.asList(updateWorkMemberArr));
		logger.debug("updateWorkMemberList={}",updateWorkMemberList);
		
		//해당 업무에 배정된 멤버 리스트
		List<String> workMemberList = new ArrayList<>();
		for(Member m : work.getWorkChargedMemberList()) {
			workMemberList.add(m.getMemberId());
		}
		//새로 추가되는 멤버
		for(String memberId:updateWorkMemberList) {
		    if(!workMemberList.contains(memberId)) {
		    	//새로 배정된 멤버
		    	Map<String,String> param = new HashMap<>();
		    	param.put("workNo",Integer.toString(workNo));
		    	param.put("memberId", memberId);
		    	result = projectDAO.insertWorkMember(param);
		    	if(result==0) throw new ProjectException("업무 배정 멤버 추가 오류!");
			}
		}
		for(String memberId:workMemberList) {
			if(!updateWorkMemberList.contains(memberId)) {
				//삭제되는 멤버
				Map<String,String> param = new HashMap<>();
		    	param.put("workNo",Integer.toString(workNo));
		    	param.put("memberId", memberId);
		    	result = projectDAO.deleteWorkMember(param);
		    	if(result==0) throw new ProjectException("업무 배정 멤버 삭제 오류!");
			}
		}
		return result;
	}

	@Override
	public int deleteWorkMember(Map<String, String> param) {
		int result = projectDAO.deleteWorkMember(param);
		if(result==0) throw new ProjectException("업무 배정 멤버 전체 삭제 오류!");
		return result;
	}

	@Override
	public int updateWorkTag(Map<String, Object> param) {
		int result = projectDAO.updateWorkTag(param);
		if(result==0) throw new ProjectException("업무 태그 수정 오류!");
		return result;
	}

	@Override
	public int updateWorkPoint(Map<String, Integer> param) {
		int result = projectDAO.updateWorkPoint(param);
		if(result==0) throw new ProjectException("업무 포인트 수정 오류!");
		return result;
	}

	@Override
	public int updateWorkDate(Map<String, String> param) {
		int result = projectDAO.updateWorkDate(param);
		if(result==0) throw new ProjectException("업무 날짜 수정 오류!");
		return result;
	}

	@Override
	public Checklist insertCheckList(Checklist chk) {
		int result = projectDAO.insertCheckList(chk);
		if(result==0) throw new ProjectException("체크리스트 추가 오류!");
		
		//방금 insert한 체크리스트 객체가져오기
		Checklist chklist = projectDAO.selectOneChecklist(chk.getChecklistNo());
		
		if(chklist==null) throw new ProjectException("체크리스트 추가 오류!");
		return chklist;
	}

	@Override
	public int updateWorkLocation(Map<String, Integer> param) {
		int result = projectDAO.updateWorkLocation(param);
		if(result==0) throw new ProjectException("업무 이동 오류!");
		return result;
	}

	@Override
	public int updateChkChargedMember(Map<String, String> param) {
		int result = projectDAO.updateChkChargedMember(param);
		if(result==0) throw new ProjectException("체크리스트 멤버 배정 오류!");
		return result;
	}

	@Override
	public int deleteChecklist(int checklistNo) {
		int result = projectDAO.deleteChecklist(checklistNo);
		if(result==0) throw new ProjectException("체크리스트 삭제 오류!");
		return result;
	}

	@Override
	public int updateDesc(Map<String, String> param) {
		int result = projectDAO.updateDesc(param);
		if(result==0) throw new ProjectException("설명 수정 오류!");
		return result;
	}

	@Override
	public int updateTitle(Map<String, String> param) {
		int result = projectDAO.updateTitle(param);
		if(result==0) throw new ProjectException("제목 수정 오류!");
		return result;
	}

	@Override
	public Map<String, Object> insertWorkComment(WorkComment wc) {
		Map<String, Object> result = new HashMap<>();
		//workNo으로 프로젝트 멤버 테이블의 번호 가져오기
		Map<String, String> param = new HashMap<>();
		param.put("memberId", wc.getWorkCommentWriterId());
		param.put("workNo", Integer.toString(wc.getWorkNo()));
		int member_no = projectDAO.selectProjectMemberNo(param);
		if(member_no<0) throw new ProjectException("프로젝트 멤버 번호 가져오기 오류!");
		
		wc.setWorkCommentWriterNo(member_no);
		
		int isUpdated = projectDAO.insertWorkComment(wc);
		
		if(isUpdated==0) throw new ProjectException("업무 코멘트 추가 오류!");
		result.put("isUpdated", isUpdated>0?true:false);
		
		//댓글 쓴 멤버 객체 가져오기
		Member member = projectDAO.selectMemberOneByMemberId(wc.getWorkCommentWriterId());
		if(member == null)throw new ProjectException("멤버 객체 가져오기 오류!");
		result.put("member", member);
		result.put("comment", wc);
		
		return result;
	}

	@Override
	public int deleteWorkComment(int commentNo) {
		int result = projectDAO.deleteWorkComment(commentNo);
		if(result==0) throw new ProjectException("업무 코멘트 삭제 오류!");
		return result;
	}

	@Override
	public Map<String, Object> insertWorkFile(Attachment attach) {
		Map<String, Object> result = new HashMap<>();
		//멤버 아이디, 업무번호로 프로젝트 멤버 테이블 고유번호 가져오기
		Map<String, String> param = new HashMap<>();
		param.put("memberId", attach.getAttachmentWriterId());
		param.put("workNo", Integer.toString(attach.getWorkNo()));
		int member_no = projectDAO.selectProjectMemberNo(param);
		if(member_no<0) throw new ProjectException("프로젝트 멤버 번호 가져오기 오류!");
		
		attach.setAttachmentWriterNo(member_no);
		
		//첨부파일 insert
		int isUpdated = projectDAO.insertWorkFile(attach);
		if(isUpdated==0) throw new ProjectException("업무 파일 업로드 오류!");
		result.put("isUpdated", isUpdated>0?true:false);
		
		//방금 insert한 첨부파일 객체 가져오기(멤버까지)
		Attachment attachment = projectDAO.selectAttachmentOne(attach.getAttachmentNo());
		result.put("attachment", attachment);
		
		return result;
	}

}
