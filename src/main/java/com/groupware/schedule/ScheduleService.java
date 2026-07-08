package com.groupware.schedule;

import java.util.List;

public interface ScheduleService {
	// 전체 스케줄 목록 조회
		List<ScheduleVO> selectScheduleList(ScheduleVO scheduleVO);
		
		// 일정 등록
		void insertSchedule(ScheduleVO scheduleVO);
		
		// 일정 수정
		void updateSchedule(ScheduleVO scheduleVO);

		// 일정 삭제
		void deleteSchedule(int scheduleId);
		
}
