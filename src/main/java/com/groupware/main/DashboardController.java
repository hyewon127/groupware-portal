package com.groupware.main;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.groupware.user.UserVO;

@Controller
public class DashboardController {

    // 대시보드 전용 서비스 주입 (통계/최근공지/일정 미니뷰 조회)
    @Autowired
    private DashboardService dashboardService;

    // 대시보드 메인 페이지
    @RequestMapping("/dashboard.do")
    public String dashboard(HttpSession session, Model model) {

        // 세션에서 로그인 사용자 꺼내기
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");

        // 비로그인 상태면 로그인 페이지로 되돌림 (직접 URL 접근 방어)
        if (loginUser == null) {
            return "redirect:/login.do";
        }

        // 조회에 필요한 사용자 정보
        String userId = loginUser.getUserId();
        int teamId = loginUser.getTeamId();

        // ── 통계 카드 4개 ───────────────────────────────
        // 각 패키지(공지/쪽지/일정/게시판)와 연동된 실시간 카운트
        model.addAttribute("unreadNoticeCnt", dashboardService.countUnreadNotice(userId));
        model.addAttribute("unreadMessageCnt", dashboardService.countUnreadMessage(userId));
        model.addAttribute("todayScheduleCnt", dashboardService.countTodaySchedule(userId, teamId));
        model.addAttribute("weekBoardCnt", dashboardService.countWeekBoard(teamId));

        // ── 최근 공지 3건 ───────────────────────────────
        model.addAttribute("recentNoticeList", dashboardService.selectRecentNoticeList());

        // ── 다가오는 일정 5건 (일정 미니뷰) ──────────────
        model.addAttribute("upcomingScheduleList",
                dashboardService.selectUpcomingScheduleList(userId, teamId));

        return "main/dashboard";  // /WEB-INF/views/main/dashboard.jsp
    }
}
