package com.kh.workground.project.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ProjectDAOImpl2 implements ProjectDAO2 {

	@Autowired
	SqlSessionTemplate sqlSession;
	

}
