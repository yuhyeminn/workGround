package com.kh.workground.club.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.club.model.dao.ClubDAO;

@Service
public class ClubServiceImpl implements ClubService {
	
	@Autowired
	ClubDAO clubDAO;
}
