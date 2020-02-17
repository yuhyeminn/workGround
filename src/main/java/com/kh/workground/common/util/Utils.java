package com.kh.workground.common.util;

public class Utils {
	
	/**
	 * 페이징바 html코드를 문자열로 리턴하는 메소드
	 * 
	 * @param totalContents
	 * @param cPage
	 * @param numPerPage
	 * @param url
	 * @return
	 */
	public static String getPageBar(int totalContents, int cPage, int numPerPage, String url) {
		String pageBar = "";
		final int pageBarSize = 5;
		//총 페이지
		final int totalPage = (int)Math.ceil((double)totalContents/numPerPage);
		
		final int pageStart = ((cPage-1)/pageBarSize)*pageBarSize + 1; 
		final int pageEnd = pageStart + pageBarSize - 1;
		//페이지바 순회용 증감변수
		int pageNo = pageStart;
		
		pageBar += "<ul class='pagination justify-content-center'>";
		
		//[이전] previous
		if(pageNo==1) { 
			//비활성화: disabled
			pageBar += "<li class=\"page-item disabled\">"
					+  "<a class=\"page-link\" href=\"#\" tabindex=\"-1\">이전</a>"
					+  "</li>";
		}
		else {
			pageBar += "<li class=\"page-item\">"
					+  "<a class=\"page-link\" href=\""+url+"&cPage="+(pageNo-1)+"\">이전</a>"
					+  "</li>";
		}
		
		//[pageNo]
		while(!(pageNo>pageEnd || pageNo>totalPage)) {
			if(pageNo == cPage) {
				pageBar += "<li class=\"page-item active\">"
						+  "<a class=\"page-link\">"+pageNo+"</a>"
						+  "</li>";
			}
			else {
				pageBar += "<li class=\"page-item\">"
						+  "<a class=\"page-link\" href=\""+url+"&cPage="+pageNo+"\">"+pageNo+"</a>"
						+  "</li>";
			}
			
			pageNo++;
		}
		
		//[다음] next 
		if(pageNo > totalPage) {
			//비활성화: disabled
			pageBar += "<li class=\"page-item disabled\">"
					+  "<a class=\"page-link\" href=\"#\" tabindex=\"-1\">다음</a>"
					+  "</li>";
		}
		else {
			pageBar += "<li class=\"page-item\">"
					+  "<a class=\"page-link\" href=\""+url+"&cPage="+pageNo+"\">다음</a>"
					+  "</li>";
		}
		
		pageBar += "</ul>";
		
		return pageBar;
	}
}
