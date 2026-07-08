package com.groupware.user;


import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class LoginController {
	
	@Autowired // service 주입하기
	private UserService userService;
	
	// 로그인 폼 (GET) - 처음 접속하면 여기로
	@RequestMapping(value = "/login.do", method=RequestMethod.GET)
	public String loginform() {
		return "user/login";
	}
	
	// 로그인 처리(POST)
	@RequestMapping(value = "/login.do", method=RequestMethod.POST)
	public String login(@RequestParam String userId, // RequestParam 브라우저 넘어온값 받음
						@RequestParam String userPw,
						HttpSession session, // session 로그인 정보 세션에 저장
						Model model) throws Exception { // model jsp 경로 전달 
		
		UserVO user = userService.selectUserById(userId);
		
		if(user != null && user.getUserPw().equals(userPw)) {
			session.setAttribute("loginUser", user); // 세션에 저장 됨
			return "redirect:/dashboard.do"; // main 으로 이동 + redirect: 다른 url 로 이동! 
		} else {
			model.addAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
			return "user/login"; // 다시 로그인 페이지
		}
	}
	
	// 로그아웃
	@RequestMapping(value = "/logout.do")
	public String logout(HttpSession session) {
		session.invalidate(); // 세션 전체 삭제
		return "redirect:/login.do"; // 로그인 페이지로 돌아감
	}
	
}