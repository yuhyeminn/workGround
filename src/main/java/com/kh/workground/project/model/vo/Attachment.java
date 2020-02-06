package com.kh.workground.project.model.vo;

import java.io.Serializable;
import java.sql.Date;

import com.kh.workground.member.model.vo.Member;

public class Attachment extends Work implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int attachmentNo;
	//업무 번호는 상속받아서!? 
	private int attachmentWriterNo; //ProjectVo의 projectMemberList에서 참조
	private Member attachmentWriter; //위의 번호로 가져온 멤버 객체
	private String originalFilename;
	private String renamedFilename;
	private Date attachmentEnrollDate;
}
