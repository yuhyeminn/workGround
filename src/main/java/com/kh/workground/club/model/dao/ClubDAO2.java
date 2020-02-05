package com.kh.workground.club.model.dao;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubPhoto;

public interface ClubDAO2 {

	int insertClubPhoto(ClubPhoto clubPhoto);

	Club selectClub(int clubNo);

}
