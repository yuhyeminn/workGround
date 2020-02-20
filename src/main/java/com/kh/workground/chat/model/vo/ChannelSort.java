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
public class ChannelSort implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String channelType;
	private String channelSortName;
}
