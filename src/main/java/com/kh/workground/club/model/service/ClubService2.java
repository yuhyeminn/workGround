package com.kh.workground.club.model.service;

import java.util.List;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;
import com.kh.workground.club.model.vo.ClubNotice;
import com.kh.workground.club.model.vo.ClubPhoto;
import com.kh.workground.club.model.vo.ClubPlan;

public interface ClubService2 {

	int insertClubPhoto(ClubPhoto clubPhoto);

	Club selectClub(int clubNo);

	List<ClubPlan> selectClubPlanList(int clubNo);

	int updateClubPlan(ClubPlan clubPlan);

	int clubIntroduceUpdate(Club club);

	int clubPlanInsert(ClubPlan clubPlan);

	List<ClubNotice> selectClubNoticeList(int clubNo);

	int clubNoticeUpdate(ClubNotice clubNotice);

	int clubNoticeInsert(ClubNotice clubNotice);

	ClubMember selectOneClubMember(ClubNotice clubNotice);




}
