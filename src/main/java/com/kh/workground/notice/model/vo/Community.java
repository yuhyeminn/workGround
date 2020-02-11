package com.kh.workground.notice.model.vo;

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
public class Community implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int commuNo;
	private String commuWriter;
	private String commuTitle;
	private String commuContent;
	private Date commuDate;
	private String commuOriginalFileName;
	private String commuRenamedFileName;
	private String memberName; //view_communityMember 이용해서 조회
	private String renamedFileName; //프로필사진: view_communityMember 이용해서 조회

}

