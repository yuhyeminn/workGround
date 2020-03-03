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
		if(projectMemberList!=null && !projectMemberList.isEmpty()) {
			for(String memberId:projectMemberList) {
				Map<String, String> param = new HashMap<>();
				param.put("projectNo", Integer.toString(p.getProjectNo()));
				param.put("projectMember", memberId);
				result = projectDAO.insertProjectMember(param);
				
				if(result == 0)
					throw new ProjectException("팀원 추가 오류!");
			}
		}
		
		//4.업무리스트 기본 3 개 생성(해야할 일, 진행중, 완료됨)
		List<String> worklistTitle = new ArrayList<>();
		Map<String, Object> param = new HashMap<>();
		param.put("projectNo", p.getProjectNo());
		worklistTitle.add("해야할 일");
		worklistTitle.add("진행중");
		worklistTitle.add("완료");
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
	public List<Member> selectMemberListByDeptCode(Map<String, String> param) {
		List<Member> list = projectDAO.selectMemberListByDeptCode(param);
		if(list == null)
			throw new ProjectException("부서별 멤버 조회 오류 !");
		return list;
	}
	
	@Override
	public Project selectProjectOneForSetting(int projectNo) {
		
		Project p = projectDAO.selectProjectOneForSetting(projectNo);
		if(p==null) {
			throw new ProjectException("프로젝트 조회 오류!");
		}
		List<Worklist> worklistList = projectDAO.selectWorklistListByProjectNo(projectNo);
		if(worklistList==null) {
			throw new ProjectException("업무리스트 조회 오류!");
		}
		//work의 List 추가
		for(int i=0; i<worklistList.size(); i++) {
			Worklist wl = worklistList.get(i);
			List<Work> workList = projectDAO.selectWorkListByWorklistNo(wl.getWorklistNo());
			wl.setWorkList(workList);
		}
		p.setWorklistList(worklistList);
		return p;
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
		
		//프로젝트 전체 회원 리스트(이전에 나갔었던 멤버까지 조회)
		List<Member> projectAllMemberList = projectDAO.selectProjectMemberIdList(projectNo);
		if(projectAllMemberList==null) throw new ProjectException("프로젝트 멤버 조회 오류!");
		
		List<String> projectMemberList = new ArrayList<>(); 	//기존 프로젝트 회원 리스트
		List<String> projectQuitMemberList = new ArrayList<>();
		for(Member m : projectAllMemberList) {
			if(("N").equals(m.getProjectQuitYn())){
				projectMemberList.add(m.getMemberId());
			}else {
				projectQuitMemberList.add(m.getMemberId());
			}
		}
		Map<String, String> param = new HashMap<>();
		//새롭게 추가되는 프로젝트 멤버
		for(String memberId : updateMemberList) {
			if(!projectMemberList.contains(memberId) && !projectQuitMemberList.contains(memberId)) {
				param.put("projectNo", Integer.toString(projectNo));
				param.put("projectMember", memberId);
				result = projectDAO.insertProjectMember(param);
				if(result==0) throw new ProjectException("프로젝트 멤버 수정 (추가) 오류!");
			}
			//projectQuitMemberList에 추가될 memberId가 포함되어있을 경우 quit_yn을 다시 n으로 변경
			if(projectQuitMemberList.contains(memberId)) {
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
	public int updateProjectManager(String updateManager, int projectNo) {
		int result = 0;
		
		//프로젝트 팀원 전체(매니저 포함)
		List<Member> memberList = projectDAO.selectProjectMemberList(projectNo);
		if(memberList==null) throw new ProjectException("프로젝트 팀원 조회 오류!");
		
		//수정할 프로젝트 관리자 리스트
		String[] updateManagerArr = updateManager.split(",");
		List<String> updateManagerList = new ArrayList<>(Arrays.asList(updateManagerArr));
		
		//updatemanagerArr 해당 멤버들 managerYn Y로 수정
		Map<String, Object> param = new HashMap<>();
		param.put("projectNo", projectNo);
		param.put("YN", "Y");
		param.put("list", updateManagerList);
		result = projectDAO.updateProjectManagerYn(param);
		if(result==0) throw new ProjectException("프로젝트 관리자 수정 오류!");
		
		//전체 팀원 리스트 중 매니저 리스트 제외한 팀원 모두 managerYn N으로 수정
		List<String> updateMemberList = new ArrayList<>();
		for(Member m : memberList) {
			if(!updateManagerList.contains(m.getMemberId())) {
				updateMemberList.add(m.getMemberId());
			}
		}
		param.put("list", updateMemberList);
		param.put("YN", "N");
		result = projectDAO.updateProjectManagerYn(param);
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

	@Override
	public List<Work> selectMyWorkList(int projectNo, String memberId) {
		Map<String, String> param = new HashMap<>();
		param.put("projectNo", Integer.toString(projectNo));
		param.put("memberId", memberId);
		
		List<Work> list= projectDAO.selectMyWorkList(param);
		if(list==null) throw new ProjectException("내가 배정된 업무 리스트 오류!");
		return list;
	}

	@Override
	public Map<String, Integer> selectMyActivity(int projectNo, String memberId) {
		Map<String,Integer> cntMap = new HashMap<>();
		
		Map<String, String> param = new HashMap<>();
		param.put("projectNo", Integer.toString(projectNo));
		param.put("memberId", memberId);
		
		int myChkCnt = projectDAO.selectMyChecklistCnt(param);
		
		String type="";
		type="attachment";
		param.put("type", type);
		int myAttachCnt = projectDAO.selectMyAttachCommentCnt(param);
		
		type="work_comment";
		param.put("type", type);
		int myCommentCnt = projectDAO.selectMyAttachCommentCnt(param);
		
		cntMap.put("myChkCnt", myChkCnt);
		cntMap.put("myAttachCnt", myAttachCnt);
		cntMap.put("myCommentCnt", myCommentCnt);
		
		return cntMap;
	}

	@Override
	public int updateChklist(Map<String, String> param) {
		int result = projectDAO.updateChklist(param);
		if(result==0) {
			throw new ProjectException("내가 배정된 업무 리스트 오류!");
		}
		return result;
	}
	
	@Override
	public List<Map<String, Object>> selectProjectLogList(int projectNo) {
		List<Map<String, Object>> result = projectDAO.selectProjectLogList(projectNo);
		if(result==null) throw new ProjectException("프로젝트 활동로그 조회 오류!");
		return result;
	}

	@Override
	public Map<String, List<Member>> selectProjectSettingMemberList(int projectNo) {
		Map<String, List<Member>> map = new HashMap<>();
		//프로젝트 팀원 전체(매니저 포함)
		List<Member> memberList = projectDAO.selectProjectMemberList(projectNo);
		if(memberList==null) throw new ProjectException("프로젝트 팀원 조회 오류!");
		
		//프로젝트 매니저 리스트
		List<Member> managerList = new ArrayList<>();
		for(int i=0;i<memberList.size();i++) {
			Member m = memberList.get(i);
			if(("Y").equals(m.getManagerYn())) {
				//매니저리스트에 추가
				managerList.add(m);
			}
		}
		
		//프로젝트팀원 multiselect에 뿌려질 리스트
		//프로젝트 매니저를 제외한 부서 멤버 리스트
		String memberId = "";
		for(int i=0; i<managerList.size(); i++) {
			Member m = managerList.get(i);
			memberId += "'"+m.getMemberId()+"'";
			if(i != (managerList.size()-1)) {
				memberId += ",";
			}
		}
		
		String deptCode = "";
		//프로젝트는 부서단위로만 생성되므로 아무 member객체에서 deptCode얻음.
		if(!memberList.isEmpty()) {
			deptCode = memberList.get(0).getDeptCode();
		}
		
		Map<String, String> param = new HashMap<>();
		param.put("deptCode",deptCode);
		param.put("memberId", memberId);
		List<Member> deptMemberList = projectDAO.selectMemberListByDeptCode(param);
		
		map.put("memberList", memberList);
		map.put("managerList", managerList);
		map.put("deptMemberList", deptMemberList);
		
		return map;
	}

	@Override
	public List<Project> selectMyManagingProjectList(String memberId) {
		List<Project> list = projectDAO.selectMyManagingProjectList(memberId);
		if(list==null) throw new ProjectException("나의 프로젝트 조회 오류!");
		return list;
	}

	@Override
	public List<Worklist> selectWorklistByProjectNo(int projectNo) {
		List<Worklist> list = projectDAO.selectWorklistByProjectNo(projectNo);
		if(list==null) throw new ProjectException("업무리스트 조회 오류!");
		return list;
	}

	@Override
	public int insertCopyWork(int workNo, int worklistNo, Member memberLoggedIn) {
		int result = 1;
		//복사 할 work객체 가져오기
		Work work = projectDAO.selectOneWorkForSetting(workNo);
		if(work==null) throw new ProjectException("업무 조회 오류!");
		
		//해당 workNo의 체크리스트 가져오기
		List<Checklist> chklstList = projectDAO.selectChklstListByWorkNo(workNo);
		
		//work복사
		work.setWorklistNo(worklistNo);
		result = projectDAO.insertCopyWork(work);
		if(result==0)throw new ProjectException("업무 복사 오류!");
		
		//체크리스트 복사
		if(chklstList != null && !chklstList.isEmpty()) {
			Map<String,Object> param = new HashMap<>();
			int copyWorkNo = work.getWorkNo();
			param.put("workNo", copyWorkNo);
			param.put("list", chklstList);
			param.put("memberId", memberLoggedIn.getMemberId());
			result = projectDAO.insertCopyChkList(param);
			if(result==0)throw new ProjectException("체크리스트 복사 오류!");
		}
		
		
		return result;
	}

}
