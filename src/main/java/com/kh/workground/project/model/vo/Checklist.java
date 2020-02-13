package com.kh.workground.project.model.vo;

import java.io.Serializable;
import java.sql.Date;
import java.util.List;

import com.kh.workground.member.model.vo.Member;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Checklist extends Work implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int checklistNo;
	private String checklistWriter; //관리자, 팀장, 업무에 배정된 멤버 중
	private int checklistChargedMembersNo; 
	private String checklistChargedMemberId; //Work의 workChargedMemberList랑 조인 
	private String checklistContent;
	private Date checklistStartDate;
	private Date checklistEndDate;
	private String completeYn;
	
	private Member checklistWriterMember; //checklistWriter사번으로 가져온 멤버 객체
	private Member checklistChargedMember; //checklistChargedMemberNo로 가져온 멤버 객체
	
	//실제완료자!?
}
