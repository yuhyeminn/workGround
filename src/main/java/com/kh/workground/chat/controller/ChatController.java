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
import com.kh.workground.club.model.exception.ClubException;
import com.kh.workground.club.model.service.ClubService;
import com.kh.workground.club.model.service.ClubService2;
import com.kh.workground.club.model.vo.ClubMember;
import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.exception.ProjectException;
import com.kh.workground.project.model.service.ProjectService2;
import com.kh.workground.project.model.vo.Project;

@Controller
public class ChatController {
	
	private static final Logger logger = LoggerFactory.getLogger(ChatController.class);
	
	@Autowired
	ChatService chatService;
	@Autowired
	ClubService2 clubService2;
	@Autowired
	ClubService clubService;
	@Autowired
	ProjectService2 projectService;
	
	@GetMapping("/chat/chatList.do")
	public ModelAndView chatList(ModelAndView mav, 
						 @SessionAttribute(value="memberLoggedIn", required=false) Member memberLoggedIn) {
		logger.debug("memberLoggId={}", memberLoggedIn);
		List<Channel> channelList = null;
		logger.debug("channelList={}", channelList);
		
		//1. memberId로 등록한 chatroom존재여부 검사. 있는 경우 chatId 리턴.
		channelList = chatService.findChannelNoListByMemberId(memberLoggedIn.getMemberId());
		logger.debug("channelList={}", channelList);
		if(channelList == null) {
			channelList = new ArrayList<>();
		}
		
		//2. chatList가져오기
		List<Chat> chatList = chatService.selectChatList();
		logger.debug("chatList={}", chatList);
		
		if(!channelList.isEmpty())
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
//		logger.debug("memberId={}", memberId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("memberId", memberId);
		
		Member member = chatService.selectOneMember(memberId);
		map.put("member", member);
		
//		logger.debug("map={}", map);
		
		return map;
	}
	
	@PostMapping("/chat/insertChannel.do")
	public ModelAndView insertChannel(ModelAndView mav, 
									  @RequestParam("memberId") String memberId, 
									  @RequestParam("channelTitle") String channelTitle, 
									  @SessionAttribute("memberLoggedIn") Member memberLoggedIn) {
		logger.debug("memberId={}", memberId);
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
		
		int index = 0;
		
		if(channelNoList.isEmpty()) {
			channelNo = getRandomChannelNo(10);
//			logger.debug("channelNo={}", channelNo);
			
			Channel channel = new Channel(channelNo, "CH3", channelTitle, "Y", 0, null, member.getMemberName(), member.getRenamedFileName(), member.getMemberId());
			int insertChannelResult = chatService.insertChannel(channel);
//			logger.debug("insertChatResult={}", insertChannelResult);
			
			List<ChannelMember> channelMemberList = new ArrayList<>();
			channelMemberList.add(new ChannelMember(0, channelNo, memberId, member.getRenamedFileName()));
			channelMemberList.add(new ChannelMember(0, channelNo, memberLoggedIn.getMemberId(), memberLoggedIn.getRenamedFileName()));
//			logger.debug("channelMemberList={}", channelMemberList);
			
			int insertChannelMemberResult = chatService.insertChannelMember(channelMemberList);
//			logger.debug("insertChannelMemberResult={}", insertChannelMemberResult);
			
		}
		
		//1. memberId로 등록한 chatroom존재여부 검사. 있는 경우 chatId 리턴.
		List<Channel> channelList = chatService.findChannelNoListByMemberId(memberLoggedIn.getMemberId());
		logger.debug("channelList={}", channelList);
		
		//2. chatList가져오기
		List<Chat> chatList = chatService.selectChatList();
		logger.debug("chatList={}", chatList);
		
		for(int i=0; i<channelList.size(); i++) {
			if(channelList.get(i).getMemberId().equals(memberId)) {
				channelNo = channelList.get(i).getChannelNo();
				index = i;
			}
		}
		logger.debug("channelNo={}", channelNo);
		
		
		mav.addObject("index", index);
		mav.addObject("channelNo", channelNo);
		mav.addObject("chatList", chatList);
		mav.addObject("channelList", channelList);
		mav.setViewName("chat/chatList");
		
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
	
	@MessageMapping("/chat/typing")
	@SendTo("/chat/typing")
	public Channel sendEcho2(Channel channel, 
						    @Header(value="simpSessionId") String sessionId) {
		return channel;
	}
	
	@RequestMapping("/chat/findChannel.do")
	@ResponseBody
	public Map<String, Object> findChannel(@RequestParam("keyword") String keyword, 
			@SessionAttribute(value="memberLoggedIn", required=false) Member memberLoggedIn) {
		logger.debug("keyword={}", keyword);
		
		Map<String, String> param = new HashMap<>();
		param.put("keyword", keyword);
		param.put("memberId", memberLoggedIn.getMemberId());
		
		Map<String, Object> map = new HashMap<>();
		map.put("keyword", keyword);
		
		List<Channel> channelList = chatService.findChannelListByKeyword(param);
		map.put("channelList", channelList);
		
		logger.debug("map={}", map);
		
		return map;
	}
	
//	sh start
	@RequestMapping("/chat/clubChatting.do")
	public ModelAndView clubChatting(ModelAndView mav, @RequestParam int clubNo, HttpServletRequest request) {
		
		try {
			//채팅쪽
			Member memberLoggedIn = (Member) request.getSession().getAttribute("memberLoggedIn");
			mav.addObject("memberId", memberLoggedIn.getMemberId());
			String channelNoTemp = "C"+clubNo;
			Channel channel = chatService.selectChannel(channelNoTemp);
		
			logger.info("channel에 대한정보: {}"+channel);
			
			//채팅리스트
			List<Chat> chatList = chatService.getClubChatList(channel.getChannelNo());
			logger.info("chatList에 대한정보: {}"+chatList);
			
			
			//동호회 멤버
			List<ClubMember> memberList = clubService.selectClubMemberList(clubNo);
			
			mav.addObject("channelNo", channel.getChannelNo());
			mav.addObject("chatList", chatList);
			mav.addObject("memberList", memberList);
			
			mav.setViewName("club/clubChattingSideBar");
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ClubException("프로젝트 채팅창 조회 오류!");
		}
		
		return mav;
	}
	
	@RequestMapping("/chat/projectChatting.do")
	public ModelAndView projectChatting(ModelAndView mav, @RequestParam int projectNo, HttpServletRequest request) {
		
		try {
			Member memberLoggedIn = (Member) request.getSession().getAttribute("memberLoggedIn");
			mav.addObject("memberId", memberLoggedIn.getMemberId());
			String channelNoTemp = "P"+projectNo;
			Channel channel = chatService.selectChannel(channelNoTemp);
		
			//프로젝트 팀원 리스트에 팀장 포함이면 true, 제외하면 false
			boolean isIncludeManager = true;
			Project p = projectService.selectProjectOneForSetting(projectNo,isIncludeManager);
			
			//프로젝트 팀원 리스트
			List<Member> projectMemberList = p.getProjectMemberList();
			
			logger.info("channel에 대한정보: {}"+channel);
			
			//채팅리스트
			List<Chat> chatList = chatService.getClubChatList(channel.getChannelNo());
			logger.info("chatList에 대한정보: {}"+chatList);
			mav.addObject("channelNo", channel.getChannelNo());
			mav.addObject("chatList", chatList);
			mav.addObject("projectMemberList", projectMemberList);
			
			mav.setViewName("project/projectChattingSideBar");
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("프로젝트 채팅창 조회 오류!");
		}
		
		return mav;
	}

}
