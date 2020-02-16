
package com.kh.workground.club.model.vo;

import java.io.Serializable;
import java.sql.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

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
public class Club implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int clubNo;
	private String clubName;
	
	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd")
	private Date clubEnrollDate;
	private String clubIntroduce;
	private String clubMeetingCycle;
	private String clubMeetingDate;
	private String clubCategory;
	private String clubManagerId; //동호회 회장 아이디.
	
	//동호회 가입승인 여부 가상컬럼
	private String clubApproveYN;
	
	//동호회 관리자 여부 가상컬럼
	private String clubManagerYN;
	
	//동호회 사진 가상컬럼
	private List<ClubPhoto> clubPhotoList;
	

	
	
}
