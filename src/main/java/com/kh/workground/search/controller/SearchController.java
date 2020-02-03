package com.kh.workground.search.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class SearchController {
	
	private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
	
//	@Autowired
//	SearchService searchService;
	
	@RequestMapping("/search/searchList.do")
	public ModelAndView chatList(ModelAndView mav) {
		
		mav.setViewName("/search/searchList");
		
		return mav;
	}
	
}
