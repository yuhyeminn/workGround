package com.kh.workground.club.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.workground.club.model.vo.Club;

public interface ClubDAO {

	List<Club> selectAllClubList();

	int insertNewClub(Club club);

	int deleteClub(int clubNo);

	int updateClub(Club club);

	int selectCountClub();

	int insertClubMember(Map map);

}
