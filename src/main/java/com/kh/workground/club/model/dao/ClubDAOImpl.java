package com.kh.workground.club.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;

@Repository
public class ClubDAOImpl implements ClubDAO {
	
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public List<Club> selectAllClubList(Map param) {
		return sqlSession.selectList("club.selectAllClubList",param);
	}

	@Override
	public int insertNewClub(Club club) {
		return sqlSession.insert("club.insertNewClub",club);
	}

	@Override
	public int deleteClub(int clubNo) {
		return sqlSession.insert("club.deleteClub",clubNo);
	}

	@Override
	public int updateClub(Club club) {
		return sqlSession.update("club.updateClub",club);
	}

	@Override
	public int selectCountClub() {
		return sqlSession.selectOne("club.selectCountClub");
	}

	@Override
	public int insertClubMember(Map map) {

		return sqlSession.insert("club.insertClubMember",map);
	}

	@Override
	public List<Club> selectAllMyClubList(Map param) {
		return sqlSession.selectList("club.selectAllMyClubList",param);
	}

	@Override
	public List<Club> selectAllStandByClubList(Map param) {

		return sqlSession.selectList("club.selectAllStandByClubList",param);
	}

	@Override
	public List<ClubMember> selectClubMemberList(int clubNo) {

		return sqlSession.selectList("club.selectClubMemberList",clubNo);
	}


}
