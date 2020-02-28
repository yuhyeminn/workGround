package com.kh.workground.admin.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.admin.controller.AdminController;
import com.kh.workground.admin.model.vo.AdminClub;
import com.kh.workground.admin.model.vo.AdminProject;

@Repository
public class AdminDAOImpl  implements AdminDAO{

	@Autowired
	SqlSessionTemplate sqlSession;
	private static final Logger logger = LoggerFactory.getLogger(AdminDAOImpl.class);

	@Override
	public List<AdminClub> selectAdminClubList() {
		logger.debug("zz");
		return sqlSession.selectList("admin.selectAdminClubList");
	}

	@Override
	public List<AdminProject> selectAdminProjectList() {
		return sqlSession.selectList("admin.selectAdminProjectList");
	}
}
