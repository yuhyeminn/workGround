package com.kh.workground.notice.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

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
	public int insertNotice(Notice notice) {
		return sqlSession.insert("notice.insertNotice", notice);
	}


}
