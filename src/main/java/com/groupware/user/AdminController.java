package com.groupware.user;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.groupware.board.BoardService;
import com.groupware.board.BoardVO;

/**
 * 관리자 전용 컨트롤러
 *  - 관리자(권한 ADMIN 또는 관리팀 teamId=7)만 접근 가능
 *  - 직원(사용자) 목록 조회 / 팀·권한 변경 / 계정 비활성화
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private UserService userService;

	@Autowired // 팀 목록(편집용 select 박스)은 기존 게시판 서비스의 팀 조회를 재사용
	private BoardService boardService;

	/**
	 * 관리자 권한 여부 확인 유틸
	 *  - role 이 "ADMIN" 이거나, 관리팀(teamId=7) 이면 관리자로 판단
	 */
	private boolean isAdmin(UserVO loginUser) {
		if (loginUser == null) return false;
		return "ADMIN".equals(loginUser.getRole()) || loginUser.getTeamId() == 7;
	}

	// 관리자 - 직원 관리 화면 (사용자 목록 + 팀 목록)
	@RequestMapping(value = "/users.do", method = RequestMethod.GET)
	public String userList(HttpSession session, Model model) throws Exception {
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		// 관리자가 아니면 대시보드로 돌려보냄 (접근 차단)
		if (!isAdmin(loginUser)) {
			return "redirect:/dashboard.do";
		}

		List<UserVO> userList = userService.selectUserList();
		model.addAttribute("userList", userList);

		// 팀 변경 select 박스에 쓸 팀 목록 (teamId, teamName)
		List<BoardVO> teamList = boardService.selectTeamList();
		model.addAttribute("teamList", teamList);

		return "admin/users";
	}

	// 관리자 - 사용자 팀/권한 변경 처리
	@RequestMapping(value = "/user/update.do", method = RequestMethod.POST)
	public String updateUser(@RequestParam String userId,
							 @RequestParam int teamId,
							 @RequestParam String role,
							 HttpSession session) throws Exception {
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		if (!isAdmin(loginUser)) {
			return "redirect:/dashboard.do";
		}
		userService.updateUserByAdmin(userId, teamId, role);
		return "redirect:/admin/users.do";
	}

	// 관리자 - 사용자 비활성화(소프트 삭제) 처리
	@RequestMapping(value = "/user/delete.do", method = RequestMethod.POST)
	public String deleteUser(@RequestParam String userId,
							 HttpSession session) throws Exception {
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		if (!isAdmin(loginUser)) {
			return "redirect:/dashboard.do";
		}
		userService.deleteUser(userId);
		return "redirect:/admin/users.do";
	}
}
