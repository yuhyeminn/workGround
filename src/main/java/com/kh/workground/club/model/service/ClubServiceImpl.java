package com.kh.workground.club.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.club.model.dao.ClubDAO;
import com.kh.workground.club.model.vo.Club;

@Service
public class ClubServiceImpl implements ClubService {
	
	@Autowired
	ClubDAO clubDAO;

	@Override
	public List<Club> selectAllClubList() {
		return clubDAO.selectAllClubList();
	}

	@Override
	public int insertNewClub(Club club) {
		return clubDAO.insertNewClub(club);
	}
}
