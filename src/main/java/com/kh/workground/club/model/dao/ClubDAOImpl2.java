package com.kh.workground.club.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.club.model.vo.Club;

@Repository
public class ClubDAOImpl2 implements ClubDAO2 {
	
	@Autowired
	SqlSessionTemplate sqlSession;




}
