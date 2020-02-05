package com.kh.workground.club.model.service;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubPhoto;

public interface ClubService2 {

	int insertClubPhoto(ClubPhoto clubPhoto);

	Club selectClub(int clubNo);




}
