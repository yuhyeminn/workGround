package com.kh.workground.project.model.vo;

import java.io.Serializable;
import java.sql.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
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
public class Project implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private int projectNo;
	private String projectWriter;
	private String projectTitle;
	private String privateYn;
	private String projectDesc;
	private Date projectStartDate;
	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd")
	private Date projectEndDate;
	private Date projectRealEndDate;
	private String projectStatusCode;
	private String projectStatusTitle; //project_status_code테이블값 
	private String projectStatusColor; //project_status_code테이블값
	
	private List<Member> projectMemberList; //프로젝트에 포함된 팀원 리스트
	private List<Worklist> worklistList; //프로젝트 안의 업무리스트들
	private String projectStarYn; //프로젝트 중요표시 여부
	
}
