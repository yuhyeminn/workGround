package com.kh.workground.club.model.service;

import java.util.List;

import com.kh.workground.club.model.vo.Club;

public interface ClubService {

	List<Club> selectAllClubList();

	int insertNewClub(Club club);

	int deleteClub(int clubNo);




}
