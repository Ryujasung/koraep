package egovframework.koraep.auth.web;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;

import egovframework.koraep.auth.service.UserAuthCheckService;

@Controller
public class UserAuthCheckController {

	@Resource(name="userAuthCheckService")
	private UserAuthCheckService service;

}
