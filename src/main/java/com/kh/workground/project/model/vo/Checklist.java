package com.kh.workground.project.model.vo;

import java.io.Serializable;
import java.sql.Date;

import com.kh.workground.member.model.vo.Member;

public class Checklist extends Work implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int checklistNo;
	//업무 번호는 상속받아서!? 
	private String checklistWriter;
	private int checklistChargedMemberNo; //Work의 workChargedMemberList에서 참조 
	private Member checklistChargedMember; //위의 번호로 가져온 멤버 객체
	private String checklistContent;
	private Date checklistStartDate;
	private Date checklistEndDate;
	private String completeYn; 
}
