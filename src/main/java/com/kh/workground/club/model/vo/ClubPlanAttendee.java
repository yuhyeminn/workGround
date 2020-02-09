package com.kh.workground.club.model.vo;

import java.io.Serializable;
import java.sql.Date;

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
public class ClubPlanAttendee implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int clubPlanAttendeeNo;
	private int clubPlanNo;
	private int clubMemberNo;
	private Date clubPlanAttendeeDate;
	
	//가상컬럼
	private String memberId;
	private String renamedFileName;
	private String memberName;
}
