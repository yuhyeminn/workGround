package com.kh.workground.admin.model.service;

import java.util.List;

import com.kh.workground.admin.model.vo.AdminClub;
import com.kh.workground.admin.model.vo.AdminProject;
import com.kh.workground.member.model.vo.Member;

public interface AdminService {

	List<AdminClub> selectAdminClubList();

	List<AdminProject> selectAdminProjectList();

}
