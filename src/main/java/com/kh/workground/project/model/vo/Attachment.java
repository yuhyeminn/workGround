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
public class Attachment extends Work implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int attachmentNo;
	private int attachmentWriterNo; //Project의 projectMemberList에서 참조
	private String attachmentWriterId; 
	private String originalFilename;
	private String renamedFilename;
	private Date attachmentEnrollDate;
	
	private Member attachmentWriterMember; //attachmentWriterId로 가져온 멤버 객체
}
