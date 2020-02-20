package com.kh.workground.admin.model.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.admin.model.dao.AdminDAO;
import com.kh.workground.admin.model.dao.AdminDAOImpl;
import com.kh.workground.admin.model.vo.AdminClub;
import com.kh.workground.admin.model.vo.AdminProject;

@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	AdminDAO adminDAO;
	
	private static final Logger logger = LoggerFactory.getLogger(AdminServiceImpl.class);

	@Override
	public List<AdminClub> selectAdminClubList() {
		logger.debug("zzzz");
		return adminDAO.selectAdminClubList();
	}

	@Override
	public List<AdminProject> selectAdminProjectList() {
		return adminDAO.selectAdminProjectList();
	}
}
