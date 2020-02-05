package com.kh.workground.club.model.vo;

import java.io.Serializable;
import java.sql.Date;

public class ClubPhoto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int clubPhotoNo;
	private String clubPhotoTitle;
	private String clubPhotoOriginal;
	private String clubPhotoRenamed;
	private int clubNo;
	private Date clubPhotoDate;
	
	public ClubPhoto() {
		super();
		// TODO Auto-generated constructor stub
	}
	public ClubPhoto(int clubPhotoNo, String clubPhotoTitle, String clubPhotoOriginal, String clubPhotoRenamed,
			int clubNo, Date clubPhotoDate) {
		super();
		this.clubPhotoNo = clubPhotoNo;
		this.clubPhotoTitle = clubPhotoTitle;
		this.clubPhotoOriginal = clubPhotoOriginal;
		this.clubPhotoRenamed = clubPhotoRenamed;
		this.clubNo = clubNo;
		this.clubPhotoDate = clubPhotoDate;
	}
	
	public int getClubPhotoNo() {
		return clubPhotoNo;
	}
	public void setClubPhotoNo(int clubPhotoNo) {
		this.clubPhotoNo = clubPhotoNo;
	}
	public String getClubPhotoTitle() {
		return clubPhotoTitle;
	}
	public void setClubPhotoTitle(String clubPhotoTitle) {
		this.clubPhotoTitle = clubPhotoTitle;
	}
	public String getClubPhotoOriginal() {
		return clubPhotoOriginal;
	}
	public void setClubPhotoOriginal(String clubPhotoOriginal) {
		this.clubPhotoOriginal = clubPhotoOriginal;
	}
	public String getClubPhotoRenamed() {
		return clubPhotoRenamed;
	}
	public void setClubPhotoRenamed(String clubPhotoRenamed) {
		this.clubPhotoRenamed = clubPhotoRenamed;
	}
	public int getClubNo() {
		return clubNo;
	}
	public void setClubNo(int clubNo) {
		this.clubNo = clubNo;
	}
	public Date getClubPhotoDate() {
		return clubPhotoDate;
	}
	public void setClubPhotoDate(Date clubPhotoDate) {
		this.clubPhotoDate = clubPhotoDate;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	@Override
	public String toString() {
		return "ClubPhoto [clubPhotoNo=" + clubPhotoNo + ", clubPhotoTitle=" + clubPhotoTitle + ", clubPhotoOriginal="
				+ clubPhotoOriginal + ", clubPhotoRenamed=" + clubPhotoRenamed + ", clubNo=" + clubNo
				+ ", clubPhotoDate=" + clubPhotoDate + "]";
	}
}
