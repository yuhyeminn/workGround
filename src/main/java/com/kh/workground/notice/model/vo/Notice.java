package com.kh.workground.notice.model.vo;

import java.io.Serializable;
import java.sql.Date;

public class Notice implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int notice_no;
	private String notice_writer;
	private String notice_title;
	private Date notice_date;
	private String notice_content;
	private String notice_original_filename;
	private String notice_renamed_filename;
	private String dept_code;
	
	public Notice() {
		super();
	}

	public Notice(int notice_no, String notice_writer, String notice_title, Date notice_date, String notice_content,
			String notice_original_filename, String notice_renamed_filename, String dept_code) {
		super();
		this.notice_no = notice_no;
		this.notice_writer = notice_writer;
		this.notice_title = notice_title;
		this.notice_date = notice_date;
		this.notice_content = notice_content;
		this.notice_original_filename = notice_original_filename;
		this.notice_renamed_filename = notice_renamed_filename;
		this.dept_code = dept_code;
	}

	public int getNotice_no() {
		return notice_no;
	}

	public void setNotice_no(int notice_no) {
		this.notice_no = notice_no;
	}

	public String getNotice_writer() {
		return notice_writer;
	}

	public void setNotice_writer(String notice_writer) {
		this.notice_writer = notice_writer;
	}

	public String getNotice_title() {
		return notice_title;
	}

	public void setNotice_title(String notice_title) {
		this.notice_title = notice_title;
	}

	public Date getNotice_date() {
		return notice_date;
	}

	public void setNotice_date(Date notice_date) {
		this.notice_date = notice_date;
	}

	public String getNotice_content() {
		return notice_content;
	}

	public void setNotice_content(String notice_content) {
		this.notice_content = notice_content;
	}

	public String getNotice_original_filename() {
		return notice_original_filename;
	}

	public void setNotice_original_filename(String notice_original_filename) {
		this.notice_original_filename = notice_original_filename;
	}

	public String getNotice_renamed_filename() {
		return notice_renamed_filename;
	}

	public void setNotice_renamed_filename(String notice_renamed_filename) {
		this.notice_renamed_filename = notice_renamed_filename;
	}

	public String getDept_code() {
		return dept_code;
	}

	public void setDept_code(String dept_code) {
		this.dept_code = dept_code;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public String toString() {
		return "Notice [notice_no=" + notice_no + ", notice_writer=" + notice_writer + ", notice_title=" + notice_title
				+ ", notice_date=" + notice_date + ", notice_content=" + notice_content + ", notice_original_filename="
				+ notice_original_filename + ", notice_renamed_filename=" + notice_renamed_filename + ", dept_code="
				+ dept_code + "]";
	}
	
	

}
