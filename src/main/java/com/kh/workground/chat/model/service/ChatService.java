package com.kh.workground.chat.model.service;

import java.util.List;

import com.kh.workground.chat.model.vo.Channel;

public interface ChatService {

	List<Channel> findChannelNoListByMemberId(String memberId);

}
