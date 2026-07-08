package com.groupware.message;

import java.sql.Date;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class MessageVO {
	// 메세지 아이디
	private int msgId;
	// 발신자 아이디
	private String senderId;
	// 발신자 이름(join용)
	private String senderName;
	// 송신자 아이디
	private String receiverId;
	// 발신자 이름(join용)
	private String receiverName;
	// 쪽지 제목
	private String title;
	// 쪽지 내용
	private String content;
	// 읽음 표시
	private String isRead;
	// 발송일
	private Date sentAt;
	// 삭제일(소프트 삭제)
	private Date deletedAt;

	// 목록에서 첨부파일 유무 표시(이모지)용 — 첨부파일 개수
	private int attachCnt;

}
