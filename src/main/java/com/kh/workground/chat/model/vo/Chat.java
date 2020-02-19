package com.kh.workground.chat.model.vo;

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
public class Chat implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int chatNo;
	private String channelNo;
	private String sender;
	private Date sendDate;
	private String msg;
	
	//필요한 컬럼
	private long time;
	private MsgType type;
}
