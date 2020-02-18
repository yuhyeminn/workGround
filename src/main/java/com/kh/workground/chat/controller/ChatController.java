package com.kh.workground.chat.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.chat.model.service.ChatService;
import com.kh.workground.chat.model.service.ChatServiceImpl;
import com.kh.workground.chat.model.vo.Channel;
import com.kh.workground.member.model.vo.Member;

@Controller
public class ChatController {
	
	private static final Logger logger = LoggerFactory.getLogger(ChatController.class);
	
	@Autowired
	ChatService chatService;
	
	@GetMapping("/chat/chatList.do")
	public void chatList(Model model, 
						 HttpSession session, 
						 @SessionAttribute(value="memberLoggedIn", required=false) Member memberLoggedIn) {
		logger.debug("memberLoggId={}", memberLoggedIn);
		List<Channel> channelList = null;
		
		//chatId 조회
		//1. memberId로 등록한 chatroom존재여부 검사. 있는 경우 chatId 리턴.
		channelList = chatService.findChannelNoListByMemberId(memberLoggedIn.getMemberId());
		if(channelList == null) {
			channelList = new ArrayList<>();
		}
		
		logger.debug("channelList={}", channelList);
		
		model.addAttribute(channelList);
	}
	
	/**
	 * 인자로 전달될 길이의 임의의 문자열을 생성하는 메소드
	 * 영대소문자/숫자의 혼합.
	 * 
	 * @param len
	 * @return
	 */
	private String getRandomChannelNo(int len){
		Random rnd = new Random();
		StringBuffer buf =new StringBuffer();
		buf.append("chat_");
		for(int i=0;i<len;i++){
			//임의의 참거짓에 따라 참=>영대소문자, 거짓=> 숫자
		    if(rnd.nextBoolean()){
		    	boolean isCap = rnd.nextBoolean();
		        buf.append((char)((int)(rnd.nextInt(26))+(isCap?65:97)));
		    }
		    else{
		        buf.append((rnd.nextInt(10))); 
		    }
		}
		return buf.toString();

	}
	
}
