package com.kh.workground.chat.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.chat.model.dao.ChatDAO;
import com.kh.workground.chat.model.dao.ChatDAOImpl;
import com.kh.workground.chat.model.vo.Channel;

@Service
public class ChatServiceImpl implements ChatService {
	
	@Autowired
	ChatDAO chatDAO;

	@Override
	public List<Channel> findChannelNoListByMemberId(String memberId) {
		return chatDAO.findChannelNoListByMemberId(memberId);
	}
}
