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
public class ClubPhotoComment implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int clubPhotoCommentNo;
	private int clubPhotoNo;
	private int clubPhotoCommentLevel;
	private int clubMemberNo;
	private String clubPhotoCommentContent;
	private Date clubPhotoCommentDate;
	private String clubPhotoCommentRef;
	private int clubNo;
	
	//가상컬럼
	private String memberName;
	private String renamedFileName;
	private String memberId;
}
