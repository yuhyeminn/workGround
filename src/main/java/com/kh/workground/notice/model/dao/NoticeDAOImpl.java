package com.kh.workground.notice.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.notice.model.vo.Community;
import com.kh.workground.notice.model.vo.Notice;

@Repository
public class NoticeDAOImpl implements NoticeDAO {
	
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public List<Notice> selectNoticeList() {
		return sqlSession.selectList("notice.selectNoticeList");
	}

	@Override
	public List<Notice> selectPlanningDeptNoticeList() {
		return sqlSession.selectList("notice.selectPlanningDeptNoticeList");
	}

	@Override
	public List<Notice> selectDesignDeptNoticeList() {
		return sqlSession.selectList("notice.selectDesignDeptNoticeList");
	}

	@Override
	public List<Notice> selectDevelopmentDeptNoticeList() {
		return sqlSession.selectList("notice.selectDevelopmentDeptNoticeList");
	}

	@Override
	public List<Community> selectCommunityList() {
		return sqlSession.selectList("notice.selectCommunityList");
	}


}
