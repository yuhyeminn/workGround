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
import com.kh.workground.project.model.dao.ProjectDAO;
import com.kh.workground.project.model.exception.ProjectException;
import com.kh.workground.project.model.vo.Attachment;
import com.kh.workground.project.model.vo.Checklist;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;
import com.kh.workground.project.model.vo.WorkComment;
import com.kh.workground.project.model.vo.Worklist;

@Service
public class ProjectServiceImpl implements ProjectService {
	
	private static final Logger logger = LoggerFactory.getLogger(ProjectServiceImpl.class);
	
	@Autowired
	ProjectDAO projectDAO;

	@Override
	public Map<String, List<Project>> selectProjectListAll(Member memberLoggedIn) {
		Map<String, List<Project>> map = new HashMap<>(); //조회한 프로젝트 담는 맵
		String deptCode = memberLoggedIn.getDeptCode();
		String memberId = memberLoggedIn.getMemberId();
		
		//1. 부서 전체 프로젝트(최근 프로젝트) 조회
		List<Project> listByDept = projectDAO.selectListByDept(deptCode);
		
		if(listByDept==null)
			throw new ProjectException("최근 프로젝트 조회 오류!");
		
		//2. 중요 표시된 프로젝트 조회(프로젝트 번호만)
		List<Project> listByImportant = new ArrayList<>();
		List<Integer> pNoListByImportant = projectDAO.selectListByImportantProjectNo(memberId);
		if(pNoListByImportant==null)
			throw new ProjectException("중요 표시된 프로젝트 조회 오류!");
		
		//3. 내가 속한 프로젝트(내 워크패드 포함) 조회	
		List<Project> listByInclude = new ArrayList<>();
		
		//3-1. 내 워크패드 조회해서 listByInclude에 추가
		Project myP = projectDAO.selectMyProject(memberId);
		
		if(myP==null)
			throw new ProjectException("내 워크패드 조회 오류!");
		else 
			listByInclude.add(myP);
		
		//3-2. 부서 전체 프로젝트에서 내가 포함된 프로젝트 판별
		if(!listByDept.isEmpty()) {
			for(Project p: listByDept) {
				int projectNo = p.getProjectNo();
				List<Member> memList = p.getProjectMemberList();
				
				boolean bool = false; //내가 포함됐는지 여부
				for(Member m: memList) {
					String pMemId = m.getMemberId();
					if(memberId.equals(pMemId)) 
						bool = true;
				}
				
				//3-3. 내가 포함됐다면 중요 표시되어있는지 확인
				if(bool) {
					boolean important = pNoListByImportant.contains(projectNo);
					
					//중요 표시 되어있는 경우
					if(important) {
						p.setProjectStarYn("Y");
						listByImportant.add(p); //중요 표시된 프로젝트에 추가
						listByInclude.add(p); //내가 속한 프로젝트에 추가
					}
					//중요 표시 안되어있는 경우
					else {
						p.setProjectStarYn("N");
						listByInclude.add(p); //내가 속한 프로젝트에만 추가
					}
				} //end of if(bool)
				
			} //end of for(listByDept)
		} //end of if
		
		
		map.put("listByDept", listByDept);
		map.put("listByImportant", listByImportant);
		map.put("listByInclude", listByInclude);
		
		return map;
	}

	@Override
	public List<Member> selectMemberListByDept(String deptCode) {
		List<Member> list = projectDAO.selectMemberListByDept(deptCode);
		
		if(list==null) 
			throw new ProjectException("부서 멤버 조회 오류!");
		
		return list;
	}

	@Override
	public Project selectProjectWorklistAll(int projectNo, String loggedInMemberId) {
		
		//1-1. 프로젝트 객체 가져오기
		Project p = projectDAO.selectProjectOne(projectNo);
		
		if(p==null)
			throw new ProjectException("프로젝트 조회 오류!");
		
		//1-2. 프로젝트 멤버 리스트
		List<Member> projectMemberList = p.getProjectMemberList();
		List<String> pMemberIdList = new ArrayList<>();
		for(Member m: projectMemberList) {
			String memberId = m.getMemberId();
			pMemberIdList.add(memberId);
		}

		//2. 프로젝트 안의 업무리스트들 가져오기
		//2-1. 프로젝트 번호로 업무리스트의 리스트 가져오기
		List<Worklist> worklistList = projectDAO.selectWorklistListByProjectNo(projectNo);
		
		//2-2. 업무리스트 번호로 업무의 리스트(+업무 배정된 멤버 리스트) 가져오기
		for(int i=0; i<worklistList.size(); i++) {
			Worklist wl = worklistList.get(i);
			List<Work> workList = projectDAO.selectWorkListByWorklistNo(wl.getWorklistNo());
			
			//3. 업무 안의 체크리스트/첨부파일/코멘트 가져오기
			for(int j=0; j<workList.size(); j++) {
				Work work = workList.get(j);
				
				List<Member> workChargedMemberList = work.getWorkChargedMemberList(); //업무 배정된 멤버 리스트
				List<String> chargedMemberIdList = new ArrayList<>(); //업무 배정된 멤버의 아이디만 담은 리스트
				for(Member m: workChargedMemberList) {
					String memberId = m.getMemberId();
					chargedMemberIdList.add(memberId);
				}
				
				//3-1. 업무 번호로 체크리스트 가져오기
				List<Checklist> chklstList = projectDAO.selectChklstListByWorkNo(work.getWorkNo());
				//체크리스트 작성자, 배정된 멤버 객체 구하기
				for(Checklist chklst: chklstList) {
					Member writerMember = projectDAO.selectMemberOneByMemberId(chklst.getChecklistWriter());
					Member chargedMember = null;
					
					int idx = chargedMemberIdList.indexOf(chklst.getChecklistChargedMemberId());
					if(idx != -1)
						chargedMember = workChargedMemberList.get(idx);
					
					chklst.setChecklistWriterMember(writerMember); //체크리스트 작성자
					chklst.setChecklistChargedMember(chargedMember); //체크리스트에 배정된 멤버
				}
				
				//3-2. 업무 번호로 파일첨부 가져오기
				List<Attachment> attachList = projectDAO.selectAttachListByWorkNo(work.getWorkNo());
				//파일첨부 작성자 객체 구하기
				for(Attachment attach: attachList) {
					String writerId = attach.getAttachmentWriterId();
					Member writerMember = null;
					
					int idx = pMemberIdList.indexOf(writerId);
					if(idx != -1) 
						writerMember = projectMemberList.get(idx);
					
					attach.setAttachmentWriterMember(writerMember);
				}
				
				//3-3. 업무 번호로 코멘트 가져오기
				List<WorkComment> commentList = projectDAO.selectCommentListByWorkNo(work.getWorkNo());
				//코멘트 작성자 객체 구하기
				for(WorkComment comment: commentList) {
					String writerId = comment.getWorkCommentWriterId();
					Member writerMember = null;
					
					int idx = pMemberIdList.indexOf(writerId);
					if(idx != -1) 
						writerMember = projectMemberList.get(idx);
					
					comment.setWorkCommentWriterMember(writerMember);
				}
				
				//3-4. 업무에 담기
				work.setChecklistList(chklstList);
				work.setAttachmentList(attachList);
				work.setWorkCommentList(commentList);
				//logger.debug("work={}", work);
			}
			
			//2-3. 업무리스트에 업무의 리스트 담기 
			wl.setWorkList(workList);
			
		}//end of for
		
		//2-3. 진행 중인/완료된 업무 수 구하기
		for(int i=0; i<worklistList.size(); i++) {
			Worklist wl = worklistList.get(i);
			int worklistNo = wl.getWorklistNo();
			int totalCnt = 0; //업무 수
			
			//진행 중인 업무 수
			if(i!=2) {
				totalCnt = projectDAO.selectTotalWorkCompleteYn(worklistNo);
				wl.setTotalWorkCompletYn(totalCnt);
			}
			//완료된 업무 수 
			else {
				if(wl.getWorkList()==null)
					totalCnt = 0;
				else
					totalCnt = wl.getWorkList().size();
				
				wl.setTotalWorkCompletYn(totalCnt);
			}
		}
		
		//1-2. 프로젝트에 업무리스트의 리스트 담기
		p.setWorklistList(worklistList);
		
		//1-3. 프로젝트 중요표시 여부 담기
		Map<String, Object> param = new HashMap<>();
		param.put("memberId", loggedInMemberId);
		param.put("projectNo", projectNo);
		
		Map<String, Object> starMap = projectDAO.selectProjectImportantOne(param);
		
		if(starMap==null) {
			p.setProjectStarYn("N");
		}
		else {
			if(projectNo == Integer.parseInt(String.valueOf(starMap.get("projectNo")))) 
				p.setProjectStarYn("Y");
		}
		
		return p;
		
	} //end of selectProjectWorklistAll()

	@Override
	public Map<String, Object> selectProjectImportantOne(Map<String, Object> param) {
		return projectDAO.selectProjectImportantOne(param);
	}

	@Override
	public int insertProjectImportant(Map<String, Object> param) {
		int result = projectDAO.insertProjectImportant(param);
		
		if(result==0)
			throw new ProjectException("중요 프로젝트 추가 오류!");
		
		return result;
	}

	@Override
	public int deleteProjectImportant(int projectImportantNo) {
		int result = projectDAO.deleteProjectImportant(projectImportantNo);
		
		if(result==0)
			throw new ProjectException("중요 프로젝트 삭제 오류!");
		
		return result;
	}

	@Override
	public int insertWorklist(Map<String, Object> param) {
		int result = projectDAO.insertWorklist(param);
		
		if(result==0)
			throw new ProjectException("업무리스트 추가 오류!");
		
		return result;
	}

	@Override
	public int deleteWorklist(int worklistNo) {
		int result = projectDAO.deleteWorklist(worklistNo);
		
		if(result==0)
			throw new ProjectException("업무리스트 삭제 오류!");
		
		return result;
	}

	@Override
	public int insertWork(Map<String, Object> param) {
		int result = 0;
		
		//1.업무 객체 생성
		Work work = new Work();
		work.setWorklistNo((int)param.get("worklistNo"));
		work.setWorkTitle(String.valueOf(param.get("workTitle")));
		work.setWorkTagCode(String.valueOf(param.get("workTag")));
		//to_date('02/12/2020', 'mm/dd/yyyy')
		//날짜 넣기
		List<String> dateList = (List<String>)param.get("workDate");
		if(dateList!=null && !dateList.isEmpty()) {
			//시작일을 지정한 경우
			if(dateList.get(0)!=null) {
				//work.setWorkStartDate(dateList.get(0));
			}
		}
		
		//2.업무 insert
		/*result = projectDAO.insertWork(work);
		
		if(result==0)
			throw new ProjectException("새 업무 만들기 오류!");
		
		
		//3.위에서 가져온 workNo로 업무 배정된 멤버 insert
		result = 0;
		List<String> memberList = (List<String>)param.get("workChargedMember");
		Map<String, Object> chargedParam = new HashMap<>(); 
		chargedParam.put("workNo", work.getWorkNo());
		
		for(String memberId: memberList) {
			chargedParam.put("memberId", memberId);
			result += projectDAO.insertWorkChargedMember(chargedParam);
		}
		
		if(result != memberList.size())
			throw new ProjectException("업무 배정된 멤버 추가 오류!");*/
		
		
		return result;
	}

}
