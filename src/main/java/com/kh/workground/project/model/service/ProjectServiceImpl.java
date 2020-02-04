package com.kh.workground.project.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.member.model.vo.Member;
import com.kh.workground.project.model.dao.ProjectDAO;

@Service
public class ProjectServiceImpl implements ProjectService {
	
	@Autowired
	ProjectDAO projectDAO;

	@Override
	public Member selectMemberOne(String string) {
		return projectDAO.selectMemberOne(string);
	}

}
