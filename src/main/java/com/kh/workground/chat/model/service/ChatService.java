package com.kh.workground.chat.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.chat.model.dao.ChatDAO;

@Service
public class ChatService implements ChatServiceImpl {
	
	@Autowired
	ChatDAO chatDAO;
}
