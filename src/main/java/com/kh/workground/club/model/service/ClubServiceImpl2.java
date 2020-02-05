package com.kh.workground.club.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.workground.club.model.dao.ClubDAO2;
import com.kh.workground.club.model.vo.Club;

@Service
public class ClubServiceImpl2 implements ClubService2 {
	
	@Autowired
	ClubDAO2 clubDAO2;



}
