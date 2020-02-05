package com.kh.workground.club.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.club.model.dao.ClubDAO2;
import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubPhoto;

@Service
public class ClubServiceImpl2 implements ClubService2 {
	
	@Autowired
	ClubDAO2 clubDAO2;

	@Override
	public int insertClubPhoto(ClubPhoto clubPhoto) {
		return clubDAO2.insertClubPhoto(clubPhoto);
	}

	@Override
	public Club selectClub(int clubNo) {
		return clubDAO2.selectClub(clubNo);
	}



}
