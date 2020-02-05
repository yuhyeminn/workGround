
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
public class Club implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int clubNo;
	private String clubName;
	private Date clubEnrollDate;
	private String clubIntroduce;
	private String clubMeetingDate;
	private String clubCategory;
	
	
}
