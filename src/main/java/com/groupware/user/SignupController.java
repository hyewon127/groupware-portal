package com.groupware.user;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.groupware.board.BoardService;
import com.groupware.board.BoardVO;

/**
 * 회원가입 컨트롤러
 *  - 신규 직원이 아이디/비밀번호/이름/이메일/소속팀을 입력해 계정을 만든다.
 *  - 권한(role)은 무조건 'USER' 로 생성되고, 관리자가 나중에 직원관리에서 변경한다.
 */
@Controller
public class SignupController {

	@Autowired
	private UserService userService;

	@Autowired // 소속팀 선택 목록은 기존 게시판 서비스의 팀 조회를 재사용
	private BoardService boardService;

	// 회원가입 화면 (팀 선택 목록을 함께 내려줌)
	@RequestMapping(value = "/signup.do", method = RequestMethod.GET)
	public String signupForm(Model model) throws Exception {
		List<BoardVO> teamList = boardService.selectTeamList();
		model.addAttribute("teamList", teamList);
		return "user/signup";
	}

	// 회원가입 처리
	@RequestMapping(value = "/signup.do", method = RequestMethod.POST)
	public String signup(UserVO userVO,
						 Model model,
						 RedirectAttributes redirectAttributes) throws Exception {

		// 1) 아이디 중복 재확인 (서버 측 최종 검증 - 화면 검증만 믿지 않음)
		if (!userService.isUserIdAvailable(userVO.getUserId())) {
			// 이미 존재하는 아이디 → 폼을 다시 보여주면서 에러 메시지 + 입력값 유지
			model.addAttribute("msg", "이미 사용 중인 아이디입니다.");
			model.addAttribute("user", userVO); // 입력했던 값 다시 채우기
			model.addAttribute("teamList", boardService.selectTeamList());
			return "user/signup";
		}

		// 2) 권한은 항상 일반 사용자(USER)로 고정해서 저장
		userVO.setRole("USER");
		userService.insertUser(userVO);

		// 3) 성공 → 로그인 화면으로 이동하며 초록색 성공 팝업 메시지 전달
		//    (flash: 리다이렉트 후에도 한 번은 model 에 남아 login.jsp 의 successMsg 팝업으로 표시)
		redirectAttributes.addFlashAttribute("successMsg", "회원가입이 완료되었습니다. 로그인해주세요.");
		return "redirect:/login.do";
	}

	// [AJAX] 아이디 중복 확인 - 화면에서 '중복확인' 버튼 클릭 시 호출
	//   반환: "available"(사용 가능) / "taken"(이미 사용 중)
	@GetMapping("/signup/checkId.do")
	@ResponseBody
	public String checkId(@RequestParam String userId) throws Exception {
		return userService.isUserIdAvailable(userId) ? "available" : "taken";
	}
}
