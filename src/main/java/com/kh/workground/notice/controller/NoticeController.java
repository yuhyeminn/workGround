package com.kh.workground.notice.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.notice.model.exception.NoticeException;
import com.kh.workground.notice.model.service.NoticeService;
import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.CommunityComment;
import com.kh.workground.notice.model.vo.Notice;
import com.kh.workground.notice.model.vo.NoticeComment;


@Controller
public class NoticeController {
	
	private static final Logger logger = LoggerFactory.getLogger(NoticeController.class);
	
	@Autowired
	NoticeService noticeService;
	
	@RequestMapping("/notice/noticeList.do")
	public ModelAndView noticeList(ModelAndView mav) {
		
		try {
				
				Map<String, String> noticeMap = new HashMap<>();
				Map<String, String> commuMap = new HashMap<>();
				
				noticeMap.put("sort", "notice_no desc");
				commuMap.put("sort", "commu_no desc");
				
				//전체 공지
				List<Notice> noticeList = noticeService.selectNoticeList(noticeMap);
				//logger.debug("noticeList={}", noticeList);
				
				//D1: 기획부 공지
				List<Notice> planningDeptNoticeList = noticeService.selectPlanningDeptNoticeList(noticeMap);
				//logger.debug("planningDeptNoticeList={}", planningDeptNoticeList);
				
				//D2: 디자인부 공지
				List<Notice> designDeptNoticeList = noticeService.selectDesignDeptNoticeList(noticeMap);
				//logger.debug("designDeptNoticeList={}", designDeptNoticeList);
				
				//D3: 개발부 공지
				List<Notice> developmentDeptNoticeList = noticeService.selectDevelopmentDeptNoticeList(noticeMap);
				//logger.debug("developmentDeptNoticeList={}", developmentDeptNoticeList);	
				
				//자유게시판
				List<Community> communityList = noticeService.selectCommunityList(commuMap);
				//logger.debug("communityList={}", communityList);	
				
				
				mav.addObject("noticeList", noticeList);
				mav.addObject("planningDeptNoticeList", planningDeptNoticeList);
				mav.addObject("designDeptNoticeList", designDeptNoticeList);
				mav.addObject("developmentDeptNoticeList", developmentDeptNoticeList);
				mav.addObject("communityList", communityList);
				
				mav.setViewName("/notice/noticeList");
				
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new NoticeException("공지 조회 오류!");
		}
		
		return mav;
	}
	
	
	@RequestMapping("/notice/noticeFormEnd.do")
	public ModelAndView boardFormEnd(ModelAndView mav,
									 Notice notice,
									 @RequestParam(value="upFile", required=false) MultipartFile upFile,
									 HttpServletRequest request) {
		logger.debug("Notice={}", notice);
		//logger.debug("사용자입력 name={}", upFile.getName());
		//logger.debug("fileName={}", upFile.getOriginalFilename());
		//logger.debug("size={}", upFile.getSize());
		
		try {
			String saveDirectory = request.getSession()
					.getServletContext()
					.getRealPath("/resources/upload/notice");
			File dir = new File(saveDirectory);
			if(dir.exists() == false)
				dir.mkdir();
			MultipartFile f = upFile;
			if(!f.isEmpty()) {
				String originalFileName = f.getOriginalFilename();
				String ext = originalFileName.substring(originalFileName.lastIndexOf("."));
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int)(Math.random()*1000);
				String renamedFileName = sdf.format(new Date())+"_"+rndNum+ext;
				try {
					f.transferTo(new File(saveDirectory+"/"+renamedFileName));
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				notice.setNoticeOriginalFileName(originalFileName);
				notice.setNoticeRenamedFileName(renamedFileName);
			}
			
			if(notice.getDeptCode().equals("all"))notice.setDeptCode(null);
			int result = noticeService.insertNotice(notice);
			mav.addObject("msg", result>0?"게시글이 등록되었습니다.":"게시글 등록 실패! 깔깔깔");
			mav.addObject("loc", "/notice/noticeList.do");
			mav.setViewName("common/msg");
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new NoticeException("공지 추가 오류!");
		}
		return mav;
	}
	
	@RequestMapping("/notice/deleteNotice.do")
	public ModelAndView deleteNotice(ModelAndView mav, @RequestParam String noticeNo) {
		//logger.debug("noticeNo={}", noticeNo);
		//에이젝스로 int 안넘어옴 -> String으로 수정
		try {
				int noticeNo_ = Integer.parseInt(noticeNo);
				
				int result = noticeService.deleteNotice(noticeNo_);
				mav.addObject("msg", result>0?"게시글이 삭제되었습니다.":"게시글 삭제 실패! 깔깔깔");
				mav.addObject("loc", "/notice/noticeList.do");
				mav.setViewName("common/msg");
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new NoticeException("공지 삭제 오류!");
		}
		return mav;
	}
	
	@RequestMapping("/notice/communityFormEnd.do")
	public ModelAndView communityFormEnd(ModelAndView mav,
									 	 Community commu,
									     @RequestParam(value="upFile", required=false) MultipartFile upFile,
									     HttpServletRequest request) {
		logger.debug("Community={}", commu);
		//logger.debug("사용자입력 name={}", upFile.getName());
		//logger.debug("fileName={}", upFile.getOriginalFilename());
		//logger.debug("size={}", upFile.getSize());
		try {
			String saveDirectory = request.getSession()
					.getServletContext()
					.getRealPath("/resources/upload/community");
			File dir = new File(saveDirectory);
			if(dir.exists() == false)
				dir.mkdir();
			MultipartFile f = upFile;
			if(!f.isEmpty()) {
				String originalFileName = f.getOriginalFilename();
				String ext = originalFileName.substring(originalFileName.lastIndexOf("."));
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int)(Math.random()*1000);
				String renamedFileName = sdf.format(new Date())+"_"+rndNum+ext;
				try {
					f.transferTo(new File(saveDirectory+"/"+renamedFileName));
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				commu.setCommuOriginalFileName(originalFileName);
				commu.setCommuRenamedFileName(renamedFileName);
			}
			
			int result = noticeService.insertCommunity(commu);
			mav.addObject("msg", result>0?"게시글이 등록되었습니다.":"게시글 등록 실패! 깔깔깔");
			mav.addObject("loc", "/notice/noticeList.do");
			mav.setViewName("common/msg");
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new NoticeException("커뮤니티 추가 오류!");
		}
		return mav;
	}
	
	@RequestMapping("/notice/deleteCommunity.do")
	public ModelAndView deleteCommunity(ModelAndView mav, String commuNo) {
		logger.debug("commuNo={}", commuNo);
		try {
			//에이젝스로 int 안넘어옴
			int commuNo_ = Integer.parseInt(commuNo);
			int result = noticeService.deleteCommunity(commuNo_);
			
			mav.addObject("msg", result>0?"게시글이 삭제되었습니다.":"게시글 삭제 실패! 깔깔깔");
			mav.addObject("loc", "/notice/noticeList.do");
			mav.setViewName("common/msg");
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new NoticeException("커뮤니티 삭제 오류!");
		}
		return mav;
	}
	
	@RequestMapping("/notice/updateNotice.do")
	public ModelAndView updateNotice(ModelAndView mav, 
									 Notice notice,
									 @RequestParam(value="delFileChk", required=false)  Boolean delFileChk,
									 @RequestParam(value="updateFile", required=false) MultipartFile updateFile,
								     HttpServletRequest request) {
		
//		logger.debug("delFileChk={}", delFileChk);
//		logger.debug("Notice={}", notice);
//		logger.debug("사용자입력 name={}", updateFile.getName());
//		logger.debug("fileName={}", updateFile.getOriginalFilename());
//		logger.debug("size={}", updateFile.getSize());
		try {
			String saveDirectory = request.getSession()
					.getServletContext()
					.getRealPath("/resources/upload/notice");
			String originalFileName = null;
			String renamedFileName = null;
			File dir = new File(saveDirectory);
			if(dir.exists() == false)
				dir.mkdir();
			MultipartFile f = updateFile;
			if(!f.isEmpty()) {
				originalFileName = f.getOriginalFilename();
				String ext = originalFileName.substring(originalFileName.lastIndexOf("."));
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int)(Math.random()*1000);
				renamedFileName = sdf.format(new Date())+"_"+rndNum+ext;
				try {
					f.transferTo(new File(saveDirectory+"/"+renamedFileName));
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				/*notice.setNoticeOriginalFileName(originalFileName);
			notice.setNoticeRenamedFileName(renamedFileName);*/
			}
			
			//신규첨부파일이 있는 경우, 기존첨부파일 삭제
			if(updateFile.getSize() != 0){
				File delFile = new File(saveDirectory, notice.getNoticeRenamedFileName());
				boolean result = delFile.delete();
				logger.debug("기존첨부파일삭제={}",result?"성공!":"실패!");
			}
			//신규첨부파일이 없는 경우: 기존 파일 삭제
			else if(delFileChk!=null) {
				File delFile = new File(saveDirectory, notice.getNoticeRenamedFileName());
				boolean result = delFile.delete();
				logger.debug("기존첨부파일삭제={}",result?"성공!":"실패!");
			}
			//신규첨부파일이 없는 경우: 기존파일 유지
			else {
				originalFileName = notice.getNoticeOriginalFileName();
				renamedFileName = notice.getNoticeRenamedFileName();
			}
			
			notice.setNoticeOriginalFileName(originalFileName);
			notice.setNoticeRenamedFileName(renamedFileName);
			
			if(notice.getDeptCode().equals("all"))notice.setDeptCode(null);
			int result = noticeService.updateNotice(notice);
			mav.addObject("msg", result>0?"게시글이 수정되었습니다.":"게시글 수정 실패! 깔깔깔");
			mav.addObject("loc", "/notice/noticeList.do");
			mav.setViewName("common/msg");
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new NoticeException("공지 수정 오류!");
		}
		
		return mav;
	}
	
	@RequestMapping("/notice/updateCommunity.do")
	public ModelAndView updateCommunity(ModelAndView mav, 
									    Community commu,
									    @RequestParam(value="delFileChk", required=false)  Boolean delFileChk,
									    @RequestParam(value="updateFile", required=false) MultipartFile updateFile,
								        HttpServletRequest request) {
		
		logger.debug("delFileChk={}", delFileChk);
		logger.debug("Community={}", commu);
		logger.debug("사용자입력 name={}", updateFile.getName());
		logger.debug("fileName={}", updateFile.getOriginalFilename());
		logger.debug("size={}", updateFile.getSize());
		
		try {
			String saveDirectory = request.getSession()
					.getServletContext()
					.getRealPath("/resources/upload/community");
			String originalFileName = null;
			String renamedFileName = null;
			File dir = new File(saveDirectory);
			if(dir.exists() == false)
				dir.mkdir();
			MultipartFile f = updateFile;
			if(!f.isEmpty()) {
				originalFileName = f.getOriginalFilename();
				String ext = originalFileName.substring(originalFileName.lastIndexOf("."));
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int)(Math.random()*1000);
				renamedFileName = sdf.format(new Date())+"_"+rndNum+ext;
				try {
					f.transferTo(new File(saveDirectory+"/"+renamedFileName));
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				
			}
			
			//신규첨부파일이 있는 경우, 기존첨부파일 삭제
			if(updateFile.getSize() != 0){
				File delFile = new File(saveDirectory, commu.getCommuRenamedFileName());
				boolean result = delFile.delete();
				logger.debug("기존첨부파일삭제={}",result?"성공!":"실패!");
			}
			//신규첨부파일이 없는 경우: 기존 파일 삭제
			else if(delFileChk!=null) {
				File delFile = new File(saveDirectory, commu.getCommuRenamedFileName());
				boolean result = delFile.delete();
				logger.debug("기존첨부파일삭제={}",result?"성공!":"실패!");
			}
			//신규첨부파일이 없는 경우: 기존파일 유지
			else {
				originalFileName = commu.getCommuOriginalFileName();
				renamedFileName = commu.getCommuRenamedFileName();
			}
			
			commu.setCommuOriginalFileName(originalFileName);
			commu.setCommuRenamedFileName(renamedFileName);
			
			int result = noticeService.updateCommunity(commu);
			mav.addObject("msg", result>0?"게시글이 수정되었습니다.":"게시글 수정 실패! 깔깔깔");
			mav.addObject("loc", "/notice/noticeList.do");
			mav.setViewName("common/msg");
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new NoticeException("커뮤니티 수정 오류!");
		}
		
		return mav;
	}
	
	//공지 댓글 추가
	@PostMapping("/notice/noticeCommentInsert.do")
	public ModelAndView noticeCommentInsert(ModelAndView mav,
									  NoticeComment noticeComment,
									  HttpServletRequest request) {
   		logger.debug("noticeComment={}",noticeComment);
   
   		try {
   			//XSS공격대비 &문자변환
   			String noticeCommentContent = noticeComment.getNoticeCommentContent();
   			noticeCommentContent = noticeCommentContent.replaceAll("<", "&lt;")
   									   				   .replaceAll(">", "&gt;")
   									   				   .replaceAll("\\n", "<br/>");//개행문자처리
   			
   			Map<String, Object> noticeCommentMap = new HashMap<>();
   			noticeCommentMap.put("noticeRef", noticeComment.getNoticeRef());
   			noticeCommentMap.put("noticeCommentLevel", noticeComment.getNoticeCommentLevel());
   			noticeCommentMap.put("noticeCommentWriter", noticeComment.getNoticeCommentWriter());
   			noticeCommentMap.put("noticeCommentContent", noticeCommentContent);
   			noticeCommentMap.put("noticeCommentRef", noticeComment.getNoticeCommentRef()==0?null:noticeComment.getNoticeCommentRef());
   			
   			int result = noticeService.insertNoticeComment(noticeCommentMap);
   			//리다이렉트 주소 (공지페이지/검색페이지)
   		    String referer = request.getHeader("Referer");
   			
   			mav.addObject("msg", result>0?"댓글이 작성되었습니다.":"댓글 작성에 실패하셨습니다.");
   			mav.addObject("loc", referer.substring(32)); //http://localhost:9090/workground의 다음 주소부터
   			mav.setViewName("common/msg");
   		} catch(Exception e) {
   			logger.error(e.getMessage(), e);
			throw new NoticeException("공지 댓글 작성 오류!");
   		}
   		
   		return mav;
	}
	
	//공지 댓글 삭제
	@RequestMapping("/notice/noticeCommentDelete.do")
	public ModelAndView noticeCommentDelete(ModelAndView mav,
											@RequestParam("noticeCommentNo") int noticeCommentNo,
											HttpServletRequest request) {
		try {
			int result = noticeService.deleteNoticeComment(noticeCommentNo);
   			//리다이렉트 주소 (공지페이지/검색페이지)
   		    String referer = request.getHeader("Referer");
			
			mav.addObject("msg", result>0?"댓글이 삭제되었습니다.":"댓글 삭제가 실패되었습니다.");
   			mav.addObject("loc", referer.substring(32)); //http://localhost:9090/workground의 다음 주소부터
			mav.setViewName("common/msg");
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new NoticeException("공지 댓글 삭제 오류!");
		}
   		
   		return mav;
	}
	
	//자유게시판 댓글 등록
	@PostMapping("/community/communityCommentInsert.do")
	public ModelAndView communityCommentInsert(ModelAndView mav,
									  CommunityComment communityComment,
									  HttpServletRequest request) {
   		logger.debug("communityComment={}",communityComment);
   
   		try {
   			//XSS공격대비 &문자변환
   			String commuCommentContent = communityComment.getCommuCommentContent();
   			commuCommentContent = commuCommentContent.replaceAll("<", "&lt;")
   									   				   .replaceAll(">", "&gt;")
   									   				   .replaceAll("\\n", "<br/>");//개행문자처리
   			
   			Map<String, Object> communityCommentMap = new HashMap<>();
   			communityCommentMap.put("commuRef", communityComment.getCommuRef());
   			communityCommentMap.put("commuCommentLevel", communityComment.getCommuCommentLevel());
   			communityCommentMap.put("commuCommentWriter", communityComment.getCommuCommentWriter());
   			communityCommentMap.put("commuCommentContent", commuCommentContent);
   			communityCommentMap.put("commuCommentRef", communityComment.getCommuCommentRef()==0?null:communityComment.getCommuCommentRef());
   			
   			int result = noticeService.insertCommunityComment(communityCommentMap);
   			//리다이렉트 주소 (공지페이지/검색페이지)
   		    String referer = request.getHeader("Referer");
   			
   			mav.addObject("msg", result>0?"댓글이 작성되었습니다.":"댓글 작성에 실패하셨습니다.");
   			mav.addObject("loc", referer.substring(32)); //http://localhost:9090/workground의 다음 주소부터
   			mav.setViewName("common/msg");
   		} catch(Exception e) {
   			logger.error(e.getMessage(), e);
			throw new NoticeException("커뮤니티 댓글 작성 오류!");
   		}
   		
   		return mav;
	}
	
	//게시판 댓글 삭제
	@RequestMapping("/community/communityCommentDelete.do")
	public ModelAndView communityCommentDelete(ModelAndView mav,
												@RequestParam("communityCommentNo") int communityCommentNo,
												HttpServletRequest request) {
		try {
			int result = noticeService.deleteCommunityComment(communityCommentNo);
   			//리다이렉트 주소 (공지페이지/검색페이지)
   		    String referer = request.getHeader("Referer");
			
			mav.addObject("msg", result>0?"댓글이 삭제되었습니다.":"댓글 삭제가 실패되었습니다.");
   			mav.addObject("loc", referer.substring(32)); //http://localhost:9090/workground의 다음 주소부터
			mav.setViewName("common/msg");
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new NoticeException("커뮤니티 댓글 삭제 오류!");
		}
   		
   		return mav;
	}
	
	//게시글 정렬
	@RequestMapping("/notice/noticeListBySort.do")
	@ResponseBody
	public Map<String, List> noticeListBySort(@RequestParam("sortMenu") String sortMenu, HttpSession session){
		Map<String, List> map = new HashMap<>();
		
		try {
			Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
			String memberDeptCode = memberLoggedIn.getDeptCode();
			
			Map<String, String> noticeMap = new HashMap<>();
			Map<String, String> commuMap = new HashMap<>();
			
			//정렬
			if (sortMenu.equals("업데이트순")) {
				noticeMap.put("sort", "notice_no desc");			
				commuMap.put("sort", "commu_no desc");
			} else {
				noticeMap.put("sort", "notice_title asc");
				commuMap.put("sort", "commu_title asc");
			}
			
			List<Notice> noticeList = noticeService.selectNoticeList(noticeMap); //전체공지
			List<Community> communityList = noticeService.selectCommunityList(commuMap); //커뮤니티
			List<Notice> planningDeptNoticeList = noticeService.selectPlanningDeptNoticeList(noticeMap); //기획부
			List<Notice> designDeptNoticeList = noticeService.selectDesignDeptNoticeList(noticeMap); //디자인부
			List<Notice> developmentDeptNoticeList = noticeService.selectDevelopmentDeptNoticeList(noticeMap); //개발부
			
			map.put("noticeList", noticeList);
			map.put("deptNoticeList", memberDeptCode.equals("D1")?planningDeptNoticeList:memberDeptCode.equals("D2")?designDeptNoticeList:developmentDeptNoticeList);
			map.put("communityList", communityList);
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new NoticeException("게시글 정렬 오류!");
		}
		
		return map;
	}
	
	//게시글 검색 및 정렬
	@RequestMapping("/notice/searchNoticeList.do")
	@ResponseBody
	public Map<String, List> searchNoticeList(@RequestParam("searchKeyword") String searchKeyword, 
											  @RequestParam("sortMenu") String sortMenu, 
											  HttpSession session){
	
		Map<String, List> map = new HashMap<>(); //ajax 보낼 맵
		try {
			Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
			String memberDeptCode = memberLoggedIn.getDeptCode();
			
			Map<String, String> noticeMap = new HashMap<>();
			Map<String, String> commuMap = new HashMap<>();
			
			//검색어
			noticeMap.put("searchKeyword", searchKeyword);
			commuMap.put("searchKeyword", searchKeyword);
			//정렬
			if (sortMenu.equals("업데이트순")) {
				noticeMap.put("sort", "notice_no desc");			
				commuMap.put("sort", "commu_no desc");
			} else {
				noticeMap.put("sort", "notice_title asc");
				commuMap.put("sort", "commu_title asc");
			}
			
			List<Notice> noticeList = noticeService.searchNoticeList(noticeMap); //전체공지
			List<Community> communityList = noticeService.searchCommunityList(commuMap); //커뮤니티
			List<Notice> planningDeptNoticeList = noticeService.searchPlanningDeptNoticeList(noticeMap); //기획부
			List<Notice> designDeptNoticeList = noticeService.searchDesignDeptNoticeList(noticeMap); //디자인부
			List<Notice> developmentDeptNoticeList = noticeService.searchDevelopmentDeptNoticeList(noticeMap); //개발부
			
			map.put("noticeList", noticeList);
			map.put("deptNoticeList", memberDeptCode.equals("D1")?planningDeptNoticeList:memberDeptCode.equals("D2")?designDeptNoticeList:developmentDeptNoticeList);
			map.put("communityList", communityList);
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new NoticeException("게시글 검색 오류!");
		}
		
		return map;
		
	}
	
	@RequestMapping("/notice/noticeShowAll.do")
	public ModelAndView noticeShowAll(ModelAndView mav, HttpSession session,
									  @RequestParam String keyword, @RequestParam String type) {
		
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		String memberDeptCode = memberLoggedIn.getDeptCode();
		Map<String, String> noticeMap = new HashMap<>();
		Map<String, String> commuMap = new HashMap<>();
		
		try {
			//검색어
			noticeMap.put("searchKeyword", keyword);
			noticeMap.put("sort", "notice_no desc");
			commuMap.put("searchKeyword", keyword);
			commuMap.put("sort", "commu_no desc");
		
			//공지
			if("total".equals(type)) {
				List<Notice> noticeList = noticeService.searchNoticeList(noticeMap);
				mav.addObject("noticeList", noticeList);
			}
			//부서별 게시글
			if("dept".equals(type)) {
				List<Notice> planningDeptNoticeList = noticeService.searchPlanningDeptNoticeList(noticeMap); //기획부
				List<Notice> designDeptNoticeList = noticeService.searchDesignDeptNoticeList(noticeMap); //디자인부
				List<Notice> developmentDeptNoticeList = noticeService.searchDevelopmentDeptNoticeList(noticeMap); //개발부
				mav.addObject("deptNoticeList", memberDeptCode.equals("D1")?planningDeptNoticeList:memberDeptCode.equals("D2")?designDeptNoticeList:developmentDeptNoticeList);
			}
			//커뮤니티
			if("commu".equals(type)) {
				List<Community> communityList = noticeService.searchCommunityList(commuMap); //커뮤니티
				mav.addObject("communityList", communityList);
			}
			mav.setViewName("/notice/noticeShowAll");
			mav.addObject("type", type);
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new NoticeException("게시판 모두보기 오류!", e);
		}
		return mav;
	}
	
	
}
