package com.kh.workground.admin.model.vo;

import java.io.Serializable;
import java.sql.Date;

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
public class AdminProject implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int projectNo;
	private String projectWriter;
	private String memberName;
	private String projectTitle;

}
