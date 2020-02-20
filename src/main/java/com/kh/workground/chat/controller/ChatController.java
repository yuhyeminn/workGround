package com.kh.workground.chat.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.JsonIOException;
import com.kh.workground.chat.model.service.ChatService;
import com.kh.workground.chat.model.vo.Channel;
import com.kh.workground.chat.model.vo.ChannelMember;
import com.kh.workground.chat.model.vo.Chat;
import com.kh.workground.member.model.vo.Member;

@Controller
public class ChatController {
	
	private static final Logger logger = LoggerFactory.getLogger(ChatController.class);
	
	@Autowired
	ChatService chatService;
	
	@GetMapping("/chat/chatList.do")
	public ModelAndView chatList(ModelAndView mav, 
						 @SessionAttribute(value="memberLoggedIn", required=false) Member memberLoggedIn) {
		logger.debug("memberLoggId={}", memberLoggedIn);
		List<Channel> channelList = null;
		logger.debug("channelList={}", channelList);
		
		//chatId 조회
		//1. memberId로 등록한 chatroom존재여부 검사. 있는 경우 chatId 리턴.
		channelList = chatService.findChannelNoListByMemberId(memberLoggedIn.getMemberId());
		logger.debug("channelList={}", channelList);
		if(channelList == null) {
			channelList = new ArrayList<>();
		}
		
		//2. chatList가져오기
		List<Chat> chatList = chatService.selectChatList();
		logger.debug("chatList={}", chatList);
		
		mav.addObject("channelNo", channelList.get(0).getChannelNo());
		mav.addObject("index", 0);
		mav.addObject("chatList", chatList);
		mav.addObject("channelList", channelList);
		mav.setViewName("chat/chatList");
		
		return mav;
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
	
	@RequestMapping("/chat/findMember.do")
	@ResponseBody
	public Map<String, Object> findMember(@RequestParam("keyword") String keyword) {
//		logger.debug("keyword={}", keyword);
		
		Map<String, Object> map = new HashMap<>();
		map.put("keyword", keyword);
		
		List<Member> memberList = chatService.selectMemberList(keyword);
		map.put("memberList", memberList);
		
//		logger.debug("map={}", map);
		
		return map;
	}
	
	@RequestMapping("/chat/plusMember.do")
	@ResponseBody
	public Map<String, Object> plusMember(@RequestParam("memberId") String memberId) {
		logger.debug("memberId={}", memberId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("memberId", memberId);
		
		Member member = chatService.selectOneMember(memberId);
		map.put("member", member);
		
		logger.debug("map={}", map);
		
		return map;
	}
	
	@PostMapping("/chat/insertChannel.do")
	public ModelAndView insertChannel(ModelAndView mav, 
									  @RequestParam("memberId") String memberId, 
									  @RequestParam("channelTitle") String channelTitle, 
									  @SessionAttribute("memberLoggedIn") Member memberLoggedIn) {
//		logger.debug("memberId={}", memberId);
//		logger.debug("channelTitle={}", channelTitle);
		
		Member member = chatService.selectOneMember(memberId);
		
		Map<String, String> param = new HashMap<>();
		param.put("chatMember", memberId); //채팅상대
		param.put("memberId", memberLoggedIn.getMemberId());
		
//		logger.debug("param={}", param);
		
		List<Channel> channelNoList = null;
		String channelNo = null;
		
		channelNoList = chatService.findChannelByMemberId(param);
		logger.debug("channelNoList={}", channelNoList);
		
		if(channelNoList.isEmpty()) {
			channelNo = getRandomChannelNo(10);
//			logger.debug("channelNo={}", channelNo);
			
			Channel channel = new Channel(channelNo, "CH3", channelTitle, "Y", 0, null, member.getMemberName(), member.getRenamedFileName());
			int insertChannelResult = chatService.insertChannel(channel);
//			logger.debug("insertChatResult={}", insertChannelResult);
			
			List<ChannelMember> channelMemberList = new ArrayList<>();
			channelMemberList.add(new ChannelMember(0, channelNo, memberId, member.getRenamedFileName()));
			channelMemberList.add(new ChannelMember(0, channelNo, memberLoggedIn.getMemberId(), memberLoggedIn.getRenamedFileName()));
//			logger.debug("channelMemberList={}", channelMemberList);
			
			int insertChannelMemberResult = chatService.insertChannelMember(channelMemberList);
//			logger.debug("insertChannelMemberResult={}", insertChannelMemberResult);
		}
		else {
			channelNo = channelNoList.get(0).getChannelNo();
//			logger.debug("channelNo={}", channelNo);
			
			mav.addObject("channelNo", channelNo);
		}
		
//		mav.addObject("channelNo", channelNo);
		
		mav.setViewName("redirect:/chat/chatList.do");
		
		return mav;
	}
	
	@PostMapping("/chat/loadChatList.do")
	public ModelAndView loadChatList(ModelAndView mav, 
			 @SessionAttribute(value="memberLoggedIn", required=false) Member memberLoggedIn, 
			 @RequestParam("channelNo") String channelNo, 
			 @RequestParam("index") int index) {
		logger.debug("channelNo={}", channelNo);
		logger.debug("index={}", index);
		logger.debug("memberLoggId={}", memberLoggedIn);
		List<Channel> channelList = null;
		logger.debug("channelList={}", channelList);
		
		//chatId 조회
		//1. memberId로 등록한 chatroom존재여부 검사. 있는 경우 chatId 리턴.
		channelList = chatService.findChannelNoListByMemberId(memberLoggedIn.getMemberId());
		logger.debug("channelList={}", channelList);
		if(channelList == null) {
			channelList = new ArrayList<>();
		}
		
		//2. chatList가져오기
		List<Chat> chatList = chatService.selectChatList();
		logger.debug("chatList={}", chatList);
		
		mav.addObject("channelNo", channelList.get(index).getChannelNo());
		mav.addObject("index", index);
		mav.addObject("chatList", chatList);
		mav.addObject("channelList", channelList);
		mav.setViewName("chat/chatList");
		
		return mav;
	}
	
	@RequestMapping("/chat/loadChatList2.do")
	@ResponseBody
	public Map<String, Object> loadChatList2 (@RequestParam("channelNo") String channelNo, 
											 @SessionAttribute("memberLoggedIn") Member memberLoggedIn, 
											 HttpSession session, 
											 HttpServletRequest request, 
											 Model model) {
		logger.debug("channelNo={}", channelNo);
		logger.debug("memberLoggedIn={}", memberLoggedIn);
		
		Map<String, Object> map = new HashMap<>();
		map.put("channelNo", channelNo);
		
		List<ChannelMember> channelMemberList = chatService.selectChannelMemberList(channelNo);
		map.put("channelMemberList", channelMemberList);
//		logger.debug("channelMemberList={}", channelMemberList);
		
		String chatMemberId = channelMemberList.get(0).getMemberId();
		if(memberLoggedIn.getMemberId().equals(chatMemberId))
			chatMemberId = channelMemberList.get(1).getMemberId();
		map.put("chatMemberId", chatMemberId);
//		logger.debug("chatMemberId={}", chatMemberId);
		map.put("memberId", memberLoggedIn.getMemberId());
		
		List<Chat> chatList = chatService.findChatRoomByChannelNo(channelNo);
		logger.debug("chatList={}", chatList);
		map.put("chatList", chatList);
		
//		logger.debug("map={}", map);
//		session.removeAttribute("channelNo");
//		session.setAttribute("channelNo", channelNo);
//		request.removeAttribute("channelNo");
//		request.setAttribute("channelNo", channelNo);
//		logger.debug("channelNo={}", channelNo);
		
		model.addAttribute("channelNo", channelNo);
		logger.debug("model={}", model);
		
		return map;
	}
	
	@MessageMapping("/chat/{channelNo}")
	@SendTo("/chat/{channelNo}")
	public Chat sendEcho(Chat fromMessage, 
						 @DestinationVariable String channelNo, 
						 @Header(value="simpSessionId") String sessionId) {
		logger.debug("fromMessage={}", fromMessage);
		logger.debug("channelNo={}", channelNo);
		logger.debug("sessionId={}", sessionId);
		
		chatService.insertChatLog(fromMessage);
		
		logger.debug("fromMessage={}", fromMessage);

		return fromMessage;
	}
	
}
