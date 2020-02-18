package com.kh.workground.chat.model.dao;

import java.util.List;

import com.kh.workground.chat.model.vo.Channel;

public interface ChatDAO {

	List<Channel> findChannelNoListByMemberId(String memberId);

}
