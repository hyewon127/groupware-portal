package com.groupware.notice;

import lombok.Data;
import lombok.ToString;
import java.util.Date;

@Data
@ToString
public class NoticeVO {
    private int noticeId;        // notice_id
    private String writerId;     // writer_id
    private String writerName;   // 작성자 이름 (JOIN용 - DB 컬럼 없음)
    private String title;        // title
    private String content;      // content (CLOB → String으로 받으면 됨!)
    private int viewCnt;         // view_cnt
    private Date createdAt;      // created_at
    private Date deletedAt;      // deleted_at
    
    // 읽음 확인용 추가 필드
    private int readCnt;      // 읽은 사람 수
    private int totalCnt;     // 전체 사람 수
    private boolean isRead;   // 내가 읽었는지 여부

    // 목록에서 첨부파일 유무 표시(이모지)용 — 첨부파일 개수
    private int attachCnt;
	
}
