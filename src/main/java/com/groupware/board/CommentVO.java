package com.groupware.board;

import java.sql.Date;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class CommentVO {
	// 댓글 번호
	private int commentId;
	// 게시판 번호(어느 게시물에 달린 댓글인지 확인)
	private int boardId;
	// 작성자 이름(join 용)
	private String writerName; 
	// 작성자 ID
	private String writerId;
	// 댓글 내용
	private String content;
	// 작성일
	private Date createdAt;
	// 삭제일(소프트 삭제)
	private Date deletedAt;
}
