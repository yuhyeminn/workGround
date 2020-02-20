package com.kh.workground.chat.model.vo;

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
public class ChannelMember implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int channelMemberNo;
	private String channelNo;
	private String memberId;
	
	//프로필사진 가상컬럼
	private String renamedFileName;
}
