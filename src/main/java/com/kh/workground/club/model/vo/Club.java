package com.kh.workground.club.model.vo;

import java.io.Serializable;
import java.sql.Date;

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
	
	public Club() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Club(int clubNo, String clubName, Date clubEnrollDate, String clubIntroduce, String clubMeetingDate,
			String clubCategory) {
		super();
		this.clubNo = clubNo;
		this.clubName = clubName;
		this.clubEnrollDate = clubEnrollDate;
		this.clubIntroduce = clubIntroduce;
		this.clubMeetingDate = clubMeetingDate;
		this.clubCategory = clubCategory;
	}
	
	public int getClubNo() {
		return clubNo;
	}
	public void setClubNo(int clubNo) {
		this.clubNo = clubNo;
	}
	public String getClubName() {
		return clubName;
	}
	public void setClubName(String clubName) {
		this.clubName = clubName;
	}
	public Date getClubEnrollDate() {
		return clubEnrollDate;
	}
	public void setClubEnrollDate(Date clubEnrollDate) {
		this.clubEnrollDate = clubEnrollDate;
	}
	public String getClubIntroduce() {
		return clubIntroduce;
	}
	public void setClubIntroduce(String clubIntroduce) {
		this.clubIntroduce = clubIntroduce;
	}
	public String getClubMeetingDate() {
		return clubMeetingDate;
	}
	public void setClubMeetingDate(String clubMeetingDate) {
		this.clubMeetingDate = clubMeetingDate;
	}
	public String getClubCategory() {
		return clubCategory;
	}
	public void setClubCategory(String clubCategory) {
		this.clubCategory = clubCategory;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	@Override
	public String toString() {
		return "Club [clubNo=" + clubNo + ", clubName=" + clubName + ", clubEnrollDate=" + clubEnrollDate
				+ ", clubIntroduce=" + clubIntroduce + ", clubMeetingDate=" + clubMeetingDate + ", clubCategory="
				+ clubCategory + "]";
	}
}
