package com.groupware.main;

import java.util.List;

import com.groupware.notice.NoticeVO;
import com.groupware.schedule.ScheduleVO;

/**
 * 대시보드 서비스 인터페이스
 *  - 컨트롤러는 이 인터페이스만 바라보고, 실제 구현은 DashboardServiceImpl 이 담당
 */
public interface DashboardService {

	// 안 읽은 공지 개수
	int countUnreadNotice(String userId);

	// 안 읽은 쪽지 개수
	int countUnreadMessage(String userId);

	// 오늘 일정 개수
	int countTodaySchedule(String userId, int teamId);

	// 이번 주 팀 게시글 개수
	int countWeekBoard(int teamId);

	// 최근 공지 3건
	List<NoticeVO> selectRecentNoticeList();

	// 다가오는 일정 5건
	List<ScheduleVO> selectUpcomingScheduleList(String userId, int teamId);
}
