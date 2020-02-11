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
public class ClubPhoto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int clubPhotoNo;
	private String clubPhotoTitle;
	private String clubPhotoOriginal;
	private String clubPhotoRenamed;
	private int clubNo;
	private int clubMemberNo;
	private Date clubPhotoDate;
	
	//가상컬럼
	private String memberName;
	private String memberId;
	
}
