package com.kh.workground.chat.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.ModelAndView;

import com.kh.workground.chat.model.service.ChatService;
import com.kh.workground.chat.model.vo.Channel;
import com.kh.workground.chat.model.vo.Chat;
import com.kh.workground.club.model.exception.ClubException;
import com.kh.workground.club.model.service.ClubService;
import com.kh.workground.club.model.service.ClubService2;
import com.kh.workground.club.model.vo.ClubMember;
import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.exception.ProjectException;
import com.kh.workground.project.model.service.ProjectService2;
import com.kh.workground.project.model.vo.Project;
import com.kh.workground.project.model.vo.Work;

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
	public void chatList(Model model, 
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
	
	/*@PostMapping("/chat/insertChannel.do")
	public ModelAndView insertChannel(ModelAndView mav, 
									  @RequestParam("memberId") String memberId, 
									  @RequestParam("channelTitle") String channelTitle, 
									  @SessionAttribute("memberLoggedIn") Member memberLoggedIn) {
		logger.debug("memberId={}", memberId);
		logger.debug("channelTitle={}", channelTitle);
		
		Map<String, String> param = new HashMap<>();
		param.put("chatMember", memberId); //채팅상대
		param.put("memberId", memberLoggedIn.getMemberId());
		
		logger.debug("param={}", param);
		
		String channelNo = null;
		
		channelNo = chatService.findChannelByMemberId(param);
		logger.debug("channelNo={}", channelNo);
		
		if(channelNo == null) {
			channelNo = getRandomChannelNo(10);
			
			Channel channel = new Channel(channelNo, "CH3", channelTitle, "Y", 0, null);
			chatService.insertChannel(channel);
			
			ChannelMember channelMember = new ChannelMember(0, channelNo, memberId);
			chatService.insertChannelMember(channelMember);
			channelMember = new ChannelMember(0, channelNo, memberLoggedIn.getMemberId());
			chatService.insertChannelMember(channelMember);
		}
		else {
			List<Chat> chatList = chatService.findChatListByChannelNo(channelNo);
			mav.addObject("chatList", chatList);
		}
		
		mav.setViewName("redirect:/chat/chatList.do");
		
		return mav;
	}*/
	
	@MessageMapping("/chat/{channelNo}")
	@SendTo(value={"/chat/{channelNo}"})
	public Chat sendEcho(Chat fromMessage, 
						@DestinationVariable String channelNo, 
						@Header("simpSessionId") String sessionId){
		logger.info("fromMessage={}",fromMessage);
		logger.info("channelNo={}",channelNo);
		logger.info("sessionId={}",sessionId);
		
		chatService.insertChatLog(fromMessage);

		return fromMessage; 
	}
	
	
	
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
