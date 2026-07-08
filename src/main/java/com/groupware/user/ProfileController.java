package com.groupware.user;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 내 프로필 관리 컨트롤러
 *  - 로그인한 직원 본인이 이름/이메일/비밀번호를 수정할 수 있는 페이지
 */
@Controller
public class ProfileController {

	@Autowired
	private UserService userService;

	// 내 프로필 화면 (현재 로그인 사용자의 최신 정보를 다시 조회해서 보여줌)
	@RequestMapping(value = "/profile.do", method = RequestMethod.GET)
	public String profile(HttpSession session, Model model) throws Exception {
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");

		// 세션 값이 오래됐을 수 있으니 DB에서 최신 정보를 다시 조회
		UserVO user = userService.selectUserById(loginUser.getUserId());
		model.addAttribute("user", user);
		return "user/profile";
	}

	// 내 프로필(이름/이메일) 수정 처리
	@RequestMapping(value = "/profile/update.do", method = RequestMethod.POST)
	public String updateProfile(@RequestParam String userName,
								@RequestParam String email,
								HttpSession session) throws Exception {
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");

		// 1) DB 업데이트
		userService.updateProfile(loginUser.getUserId(), userName, email);

		// 2) 세션의 로그인 사용자 정보도 최신값으로 갱신 (헤더의 이름 등 즉시 반영)
		loginUser.setUserName(userName);
		loginUser.setEmail(email);
		session.setAttribute("loginUser", loginUser);

		return "redirect:/profile.do";
	}

	// 내 비밀번호 변경 처리 (현재 비밀번호 확인 후 변경)
	@RequestMapping(value = "/profile/password.do", method = RequestMethod.POST)
	public String changePassword(@RequestParam String currentPw,
								 @RequestParam String newPw,
								 HttpSession session,
								 Model model) throws Exception {
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");

		// 현재 비밀번호가 맞는지 다시 조회해서 확인
		UserVO user = userService.selectUserById(loginUser.getUserId());
		if (user != null && user.getUserPw().equals(currentPw)) {
			// 비밀번호 재설정 로직 재사용 (이메일까지 일치하므로 안전)
			userService.resetPassword(loginUser.getUserId(), user.getEmail(), newPw);
			model.addAttribute("pwMsg", "비밀번호가 변경되었습니다.");
		} else {
			model.addAttribute("pwMsg", "현재 비밀번호가 일치하지 않습니다.");
		}

		// 변경 후 최신 프로필 다시 표시
		model.addAttribute("user", userService.selectUserById(loginUser.getUserId()));
		return "user/profile";
	}
}
