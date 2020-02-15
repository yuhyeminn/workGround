package com.kh.workground.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

import com.kh.workground.project.model.exception.ProjectException;

public class DownloadView extends AbstractView {
	
	private static final Logger logger = LoggerFactory.getLogger(DownloadView.class);
	
	public DownloadView() {
		setContentType("application/download; charset=utf-8");
	}

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//1.파라미터 핸들링
		ModelMap map = (ModelMap)model.get("model");
		File file = (File)map.get("downloadFile");
		String oName = String.valueOf(map.get("oName"));
		
		//2.response헤더 작성
		String userAgent = request.getHeader("User-Agent");
		boolean isMSIE = userAgent.indexOf("MSIE")!=-1 || userAgent.indexOf("Trident")!=-1;
		String fileName = "";
		
		//ie인 경우
		if(isMSIE) {
			fileName = URLEncoder.encode(oName, "utf-8");
			fileName = fileName.replaceAll("\\+", "%20"); //+로 치환되는 공백문자 변경 
		}
		//ie가 아닌 경우
		else {
			//utf-8바이트배열 -> iso-8~방식
			fileName = new String(oName.getBytes("utf-8"), "iso-8859-1");
		}
		
		response.setContentType("application/octet-stream");
		response.setContentLength((int)file.length());
		response.setHeader("Content-Disposition", "attachment;filename="+fileName);
		
		//3.파일입출력 스트림
		OutputStream out = response.getOutputStream();
		FileInputStream fis = null;

		try {
			
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
			throw new ProjectException("파일 다운로드 오류!");
		} finally {
			
			if(fis!=null) {
				try {
					fis.close();
				} catch(IOException e) {
					logger.error(e.getMessage(), e);
				}
			}
			
		}
		
		out.flush();
		
	}

}
