package com.groupware.board;

import java.sql.Date;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class BoardVO {
	// 게시판 변수
	private int boardId; // 고유 번호
	private int teamId; // 팀 구분을 위한 팀 id
	private String writerId; // 작성 id
	private String writerName; // 작성자 이름(join 용)
	private String teamName; // 팀이름 (join 용)
	private String title; // 제목
	private String content; // 내용
	private Date createdAt; // 작성일
	private Date deletedAt; // 삭제일(소프트 삭제시 사용)

	// 목록 표시용 추가 필드
	private int commentCnt; // 댓글 수 ([댓글 n] 표시용)
	private int attachCnt;  // 첨부파일 수 (0보다 크면 📎 이모지 표시)

}
