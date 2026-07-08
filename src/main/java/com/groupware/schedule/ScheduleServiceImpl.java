package com.groupware.schedule;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ScheduleServiceImpl implements ScheduleService{
	@Autowired
	private ScheduleMapper scheduleMapper;

	@Override
	public List<ScheduleVO> selectScheduleList(ScheduleVO scheduleVO) {
		// 전체 스케줄 목록 조회
		return scheduleMapper.selectScheduleList(scheduleVO);
	}

	@Override
	public void insertSchedule(ScheduleVO scheduleVO) {
		// 일정 등록
		scheduleMapper.insertSchedule(scheduleVO);
		
	}

	@Override
	public void updateSchedule(ScheduleVO scheduleVO) {
		// 일정 수정
		scheduleMapper.updateSchedule(scheduleVO);
		
	}

	@Override
	public void deleteSchedule(int scheduleId) {
		// 일정 삭제(소프트 삭제)
		scheduleMapper.deleteSchedule(scheduleId);
		
	}
	
	
}
