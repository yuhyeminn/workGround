package com.kh.workground.admin.model.service;

import java.util.List;

import com.kh.workground.admin.model.vo.AdminClub;
import com.kh.workground.admin.model.vo.AdminProject;

public interface AdminService {

	List<AdminClub> selectAdminClubList();

	List<AdminProject> selectAdminProjectList();

}
