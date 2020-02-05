package com.kh.workground.club.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubPhoto;
import com.kh.workground.club.model.vo.ClubPlan;

@Repository
public class ClubDAOImpl2 implements ClubDAO2 {
	
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public int insertClubPhoto(ClubPhoto clubPhoto) {
		return sqlSession.insert("club.insertClubPhoto", clubPhoto);
	}

	@Override
	public Club selectClub(int clubNo) {
		return sqlSession.selectOne("club.selectClub", clubNo);
	}

	@Override
	public List<ClubPlan> selectClubPlanList(int clubNo) {
		return sqlSession.selectList("club.selectClubPlanList", clubNo);
	}




}
