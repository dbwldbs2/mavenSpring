package com.part7.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/securitySample/*") 
@Controller
public class SecuritySampleController {
	
	@GetMapping("/all")
	public void doAll() {
		log.info("do all can access everybody");
	}
	  
	@GetMapping("/member")
	public void doMember() {
		log.info("logined member");
	}
	  
	@GetMapping("/admin")
	public void doAdmin() {
		log.info("admin only");
	}  
}
