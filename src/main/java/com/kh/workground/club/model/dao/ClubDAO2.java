package com.kh.workground.club.model.dao;

import java.util.List;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubPhoto;
import com.kh.workground.club.model.vo.ClubPlan;

public interface ClubDAO2 {

	int insertClubPhoto(ClubPhoto clubPhoto);

	Club selectClub(int clubNo);

	List<ClubPlan> selectClubPlanList(int clubNo);

}
