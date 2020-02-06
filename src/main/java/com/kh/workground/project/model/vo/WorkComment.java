package com.kh.workground.project.model.vo;

import java.io.Serializable;
import java.sql.Date;

import com.kh.workground.member.model.vo.Member;

public class WorkComment extends Work implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int workCommentNo;
	//업무 번호는 상속받아서!? 
	private int workCommentWriterNo; //ProjectVo의 projectMemberList에서 참조
	private Member workCommentWriter; //위의 번호로 가져온 멤버 객체
	private int workCommentLevel; //댓글(1), 대댓글(2) 
	private String workCommentContent;
	private Date workCommentEnrollDate;
	private int workCommentRef; //업무 코멘트 참조번호 
}
