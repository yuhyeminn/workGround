package com.kh.workground.club.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.workground.club.model.vo.Club;

@Repository
public class ClubDAOImpl implements ClubDAO {
	
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public List<Club> selectAllClubList() {
		return sqlSession.selectList("club.selectAllClubList");
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


}
