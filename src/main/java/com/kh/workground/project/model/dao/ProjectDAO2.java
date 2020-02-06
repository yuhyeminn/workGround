package com.kh.workground.project.model.dao;

import java.util.Map;

import com.kh.workground.project.model.vo.Project;

public interface ProjectDAO2 {

	int insertProject(Project p);

	int insertProjectManager(Project p);

	int insertProjectMember(Map<String, String> param);

}
