package com.groupware.schedule;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.groupware.user.UserVO;


@Controller
@RequestMapping("/schedule")
public class ScheduleController {
	@Autowired
	private ScheduleService scheduleService;

	// 캘린더 화면 반환
	@RequestMapping(value = "/calendar.do", method = RequestMethod.GET)
	public String calendar() {
		return "schedule/calendar";
	}

	// FullCalendar 가 자동으로 호출 → JSON 배열 반환
	// @ResponseBody: JSP 가 아니라 JSON 데이터를 직접 응답 본문에 담음
	@RequestMapping(value = "/list.do", method = RequestMethod.GET)
	@ResponseBody
	public List<ScheduleVO> list(HttpSession session) throws Exception {
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");

		ScheduleVO param = new ScheduleVO();
		// 개인 일정 조회용: 로그인 사용자 ID
		param.setUserId(loginUser.getUserId());
		// 팀 일정 조회용: 로그인 사용자의 팀 ID (본인 팀 일정만 조회됨)
		param.setTeamId(loginUser.getTeamId());

		return scheduleService.selectScheduleList(param);
	}

	// 일정 등록
	@RequestMapping(value = "/insert.do", method = RequestMethod.POST)
	@ResponseBody
	public String insert(ScheduleVO scheduleVO,
						 HttpSession session) throws Exception {
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");

		// 작성자 ID 를 세션의 로그인 사용자로 세팅 (NOT NULL 컬럼이므로 필수)
		scheduleVO.setUserId(loginUser.getUserId());

		// 팀 일정이면 로그인 사용자의 팀 ID 세팅, 개인 일정이면 null
		if ("TEAM".equals(scheduleVO.getType())) {
			scheduleVO.setTeamId(loginUser.getTeamId());
		} else {
			scheduleVO.setTeamId(null);
		}

		scheduleService.insertSchedule(scheduleVO);
		return "success";
	}

	// 일정 수정
	@RequestMapping(value = "/update.do", method = RequestMethod.POST)
	@ResponseBody
	public String update(ScheduleVO scheduleVO,
						 HttpSession session) throws Exception {
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");

		// 팀 일정이면 세션에서 팀 ID 세팅, 개인 일정이면 null (FK 제약조건 충족)
		if ("TEAM".equals(scheduleVO.getType())) {
			scheduleVO.setTeamId(loginUser.getTeamId());
		} else {
			scheduleVO.setTeamId(null);
		}

		scheduleService.updateSchedule(scheduleVO);
		return "success";
	}

	// 일정 삭제 (소프트 삭제)
	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public String delete(@RequestParam int scheduleId) throws Exception {
		scheduleService.deleteSchedule(scheduleId);
		return "success";
	}

}
