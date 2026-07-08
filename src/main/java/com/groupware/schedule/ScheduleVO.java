package com.groupware.schedule;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class ScheduleVO {
	// 스케줄 번호 (FullCalendar 에서 id 로 인식하도록 @JsonProperty 매핑)
	@JsonProperty("id")
	private Integer scheduleId;
	// 사용자 번호(작성자)
	private String userId;
	// 작성자 이름 (USERS 테이블 JOIN 으로 조회)
	private String writerName;
	// 팀 이름 (TEAM 테이블 JOIN 으로 조회)
	private String teamName;
	// 일정 제목
	private String title;
	// 시작일 — String 으로 관리 ("yyyy-MM-dd")
	// FullCalendar 가 "start" 필드로 인식하도록 @JsonProperty 매핑
	@JsonProperty("start")
	private String startDt;
	// 종료일 — String 으로 관리 ("yyyy-MM-dd")
	// FullCalendar 가 "end" 필드로 인식하도록 @JsonProperty 매핑
	@JsonProperty("end")
	private String endDt;
	// 색상 (FullCalendar 이벤트 배경색으로 사용)
	private String color;
	// 개인/팀 구분 ("PERSONAL" 또는 "TEAM")
	private String type;
	// 팀 번호 (팀 일정일 때 사용, FK → TEAM 테이블)
	// Integer 사용 → 개인 일정이면 null 로 처리 (FK 제약조건 충족)
	private Integer teamId;
	// 작성일
	private Date createdAt;
	// 삭제일 (소프트 삭제 — NULL 이면 유효한 일정)
	private Date deletedAt;
}
