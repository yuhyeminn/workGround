package com.kh.workground.club.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.club.model.dao.ClubDAO;
import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;

@Service
public class ClubServiceImpl implements ClubService {
	
	@Autowired
	ClubDAO clubDAO;

	@Override
	public List<Club> selectAllClubList(Map param) {
		return clubDAO.selectAllClubList(param);
	}

	@Override
	public int insertNewClub(Club club) {
		return clubDAO.insertNewClub(club);
	}

	@Override
	public int deleteClub(int clubNo) {
		return clubDAO.deleteClub(clubNo);
	}

	@Override
	public int updateClub(Club club) {
		return clubDAO.updateClub(club);
	}

	@Override
	public int selectCountClub() {
		return clubDAO.selectCountClub();
	}

	@Override
	public int insertClubMember(Map map) {

		return clubDAO.insertClubMember(map);
	}

	@Override
	public List<Club> selectAllMyClubList(String memberId) {
		return clubDAO.selectAllMyClubList(memberId);
	}

	@Override
	public List<Club> selectAllStandByClubList(String memberId) {
		return clubDAO.selectAllStandByClubList(memberId);
	}

	@Override
	public List<Club> selectAllMyAndStandClubList(String memberId) {
		return clubDAO.selectAllMyAndStandClubList(memberId);
	}

	@Override
	public int selectCountMyClub(String memberId) {
		return clubDAO.selectCountMyClub(memberId);
	}





}
