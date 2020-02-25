package com.kh.workground.admin.model.dao;

import java.util.List;

import com.kh.workground.admin.model.vo.AdminClub;
import com.kh.workground.admin.model.vo.AdminProject;

public interface AdminDAO {

	List<AdminClub> selectAdminClubList();

	List<AdminProject> selectAdminProjectList();

}
