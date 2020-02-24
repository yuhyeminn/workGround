
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
public class Channel implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String channelNo;
	private String channelType;
	private String channelTitle;
	private String status;
	private int lastCheck;
	private String projectOrClubNo;
	
	//멤버네임 가상컬럼
	private String memberName;
	//프로필사진 가상컬럼
	private String renamedFileName;
	//멤버아이디 가상컬럼
	private String memberId;
}



