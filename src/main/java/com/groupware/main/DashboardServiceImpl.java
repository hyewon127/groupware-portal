package com.groupware.main;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groupware.notice.NoticeVO;
import com.groupware.schedule.ScheduleVO;

/**
 * 대시보드 서비스 구현체
 *  - 실제 DB 조회는 DashboardMapper 에 위임함 (단순 위임 계층)
 */
@Service
public class DashboardServiceImpl implements DashboardService {

	@Autowired // 대시보드 전용 Mapper 주입
	private DashboardMapper dashboardMapper;

	@Override
	public int countUnreadNotice(String userId) {
		return dashboardMapper.countUnreadNotice(userId);
	}

	@Override
	public int countUnreadMessage(String userId) {
		return dashboardMapper.countUnreadMessage(userId);
	}

	@Override
	public int countTodaySchedule(String userId, int teamId) {
		return dashboardMapper.countTodaySchedule(userId, teamId);
	}

	@Override
	public int countWeekBoard(int teamId) {
		return dashboardMapper.countWeekBoard(teamId);
	}

	@Override
	public List<NoticeVO> selectRecentNoticeList() {
		return dashboardMapper.selectRecentNoticeList();
	}

	@Override
	public List<ScheduleVO> selectUpcomingScheduleList(String userId, int teamId) {
		return dashboardMapper.selectUpcomingScheduleList(userId, teamId);
	}
}
