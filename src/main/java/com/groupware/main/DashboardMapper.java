package com.groupware.main;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import com.groupware.notice.NoticeVO;
import com.groupware.schedule.ScheduleVO;

/**
 * 대시보드(메인 화면) 전용 Mapper
 *  - 여러 모듈(공지/쪽지/일정/게시판)의 요약 정보를 한 화면에서 보여주기 위해
 *    대시보드에서만 쓰는 집계용 쿼리를 따로 모아둔 Mapper 임.
 */
@Mapper
public interface DashboardMapper {

	// [카드1] 내가 아직 안 읽은 공지 개수 (NOTICE_READ 에 기록이 없는 공지)
	int countUnreadNotice(String userId);

	// [카드2] 내가 받은 쪽지 중 안 읽은(is_read='N') 쪽지 개수
	int countUnreadMessage(String userId);

	// [카드3] 오늘 날짜에 걸쳐 있는 내 일정(개인+팀) 개수
	int countTodaySchedule(@Param("userId") String userId, @Param("teamId") int teamId);

	// [카드4] 이번 주에 우리 팀 게시판에 올라온 글 개수
	int countWeekBoard(int teamId);

	// [최근 공지] 최신 공지 3건 (제목/작성자/작성일)
	List<NoticeVO> selectRecentNoticeList();

	// [일정 미니뷰] 오늘 이후 다가오는 내 일정 5건
	List<ScheduleVO> selectUpcomingScheduleList(@Param("userId") String userId, @Param("teamId") int teamId);
}
