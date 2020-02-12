package com.kh.workground.member.model.vo;

import java.io.Serializable;

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
public class Member implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String memberId;
	private String password;
	private String memberName;
	private String email;
	private String phone;
	private String dateOfBirth;
	private String deptCode;
	private String deptTitle; //view_member이용해서 조회
	private String jobCode;
	private String jobTitle; //view_member이용해서 조회
	private String quitYn;
	private String managerId;
	private String originalFileName;
	private String renamedFileName;
	
	
	private String projectQuitYn; //프로젝트 테이블 - 혜민
	
}
