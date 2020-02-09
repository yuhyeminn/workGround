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
public class WorkComment implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int workCommentNo;
	//업무 번호는 상속받아서!? 
	private int workCommentWriterNo; //Projec의 projectMemberList에서 참조
	private String workCommentWriterId;
	private int workCommentLevel; //댓글(1), 대댓글(2) 
	private String workCommentContent;
	private Date workCommentEnrollDate;
	private int workCommentRef; //업무 코멘트 참조번호
	
	private Member workCommentWriterMember; //workCommentWriterId로 가져온 멤버 객체
}
