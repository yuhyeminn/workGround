package com.kh.workground.club.model.dao;

import java.util.List;

import com.kh.workground.club.model.vo.Club;
import com.kh.workground.club.model.vo.ClubMember;
import com.kh.workground.club.model.vo.ClubNotice;
import com.kh.workground.club.model.vo.ClubPhoto;
import com.kh.workground.club.model.vo.ClubPlan;

public interface ClubDAO2 {

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

	int deleteClubNotice(int clubNoticeNo);

	List<ClubPhoto> selectClubPhotoList(int clubNo);

	int deleteClubPhoto(ClubPhoto clubPhoto);

}
