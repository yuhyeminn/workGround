package com.kh.workground.chat.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ChatController {
	
	private static final Logger logger = LoggerFactory.getLogger(ChatController.class);
	
//	@Autowired
//	ChatService chatService;
	
	@RequestMapping("/chat/chatList.do")
	public ModelAndView chatList(ModelAndView mav) {
		
		mav.setViewName("/chat/chatList");
		
		return mav;
	}
	
}
