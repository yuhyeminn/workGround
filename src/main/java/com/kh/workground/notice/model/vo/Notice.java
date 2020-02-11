package com.kh.workground.notice.model.vo;

import java.io.Serializable;
import java.sql.Date;

public class Notice implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int noticeNo;
	private String noticeWriter;
	private String noticeTitle;
	private Date noticeDate;
	private String noticeContent;
	private String noticeOriginalFilename;
	private String noticeRenamedFilename;
	private String deptCode;
	
	public Notice() {
		super();
	}

	public Notice(int noticeNo, String noticeWriter, String noticeTitle, Date noticeDate, String noticeContent,
			String noticeOriginalFilename, String noticeRenamedFilename, String deptCode) {
		super();
		this.noticeNo = noticeNo;
		this.noticeWriter = noticeWriter;
		this.noticeTitle = noticeTitle;
		this.noticeDate = noticeDate;
		this.noticeContent = noticeContent;
		this.noticeOriginalFilename = noticeOriginalFilename;
		this.noticeRenamedFilename = noticeRenamedFilename;
		this.deptCode = deptCode;
	}

	public int getNoticeNo() {
		return noticeNo;
	}

	public void setNoticeNo(int noticeNo) {
		this.noticeNo = noticeNo;
	}

	public String getNoticeWriter() {
		return noticeWriter;
	}

	public void setNoticeWriter(String noticeWriter) {
		this.noticeWriter = noticeWriter;
	}

	public String getNoticeTitle() {
		return noticeTitle;
	}

	public void setNoticeTitle(String noticeTitle) {
		this.noticeTitle = noticeTitle;
	}

	public Date getNoticeDate() {
		return noticeDate;
	}

	public void setNoticeDate(Date noticeDate) {
		this.noticeDate = noticeDate;
	}

	public String getNoticeContent() {
		return noticeContent;
	}

	public void setNoticeContent(String noticeContent) {
		this.noticeContent = noticeContent;
	}

	public String getNoticeOriginalFilename() {
		return noticeOriginalFilename;
	}

	public void setNoticeOriginalFilename(String noticeOriginalFilename) {
		this.noticeOriginalFilename = noticeOriginalFilename;
	}

	public String getNoticeRenamedFilename() {
		return noticeRenamedFilename;
	}

	public void setNoticeRenamedFilename(String noticeRenamedFilename) {
		this.noticeRenamedFilename = noticeRenamedFilename;
	}

	public String getDeptCode() {
		return deptCode;
	}

	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public String toString() {
		return "Notice [noticeNo=" + noticeNo + ", noticeWriter=" + noticeWriter + ", noticeTitle=" + noticeTitle
				+ ", noticeDate=" + noticeDate + ", noticeContent=" + noticeContent + ", noticeOriginalFilename="
				+ noticeOriginalFilename + ", noticeRenamedFilename=" + noticeRenamedFilename + ", deptCode=" + deptCode
				+ "]";
	}
	
	

}
