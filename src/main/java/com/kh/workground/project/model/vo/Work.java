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
public class Work extends Worklist implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int workNo;
	//업무리스트 번호는 상속받아서!? 
	private String workTitle;
	private String workDesc;
	private int workPoint;
	private Date workStartDate;
	private Date workEndDate;
	private String workCompleteYn;
	private String workTagCode; 
	private String workTagTitle; //work_tag테이블값 
	private String workTagColor; //work_tag테이블값 
	private int workNoRef; //참조할 업무번호  
	
	private List<Member> workChargedMemberList; //업무에 배정된 팀원 리스트
}
