package com.kh.workground.club.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.club.model.dao.ClubDAO2;
import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubPhoto;
import com.kh.workground.club.model.vo.ClubPlan;

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

	@Override
	public List<ClubPlan> selectClubPlanList(int clubNo) {
		return clubDAO2.selectClubPlanList(clubNo);
	}

	@Override
	public int updateClubPlan(ClubPlan clubPlan) {
		return clubDAO2.updateClubPlan(clubPlan);
	}

	@Override
	public int clubIntroduceUpdate(Club club) {
		return clubDAO2.clubIntroduceUpdate(club);
	}

	@Override
	public int clubPlanInsert(ClubPlan clubPlan) {
		return clubDAO2.clubPlanInsert(clubPlan);
	}



}
