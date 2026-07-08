package com.groupware.message;

import java.sql.Date;
import lombok.Data;
import lombok.ToString;

/**
 * 쪽지 첨부파일 VO
 *  - 공지/게시판과 동일하게 공용 ATTACH_FILE 테이블을 사용함
 *  - refType 을 "MESSAGE" 로 넣어 쪽지 첨부파일임을 구분
 */
@Data
@ToString
public class AttachFileVO {

    /** 파일 고유 번호 (PK) — seq_attach.NEXTVAL 로 자동 생성 */
    private int fileId;

    /** 참조 타입 — 쪽지 첨부는 "MESSAGE" 로 저장 */
    private String refType;

    /** 참조 ID — 어떤 쪽지(msg_id)의 첨부인지 */
    private int refId;

    /** 원본 파일명 — 다운로드 시 보여줄 이름 */
    private String origName;

    /** 서버 저장 경로 — UUID 로 변환된 실제 저장 경로 */
    private String savePath;

    /** 파일 크기 (byte) */
    private long fileSize;

    /** 업로드 일시 */
    private Date uploadedAT;

    /** 삭제 일시 (소프트 삭제 — NULL 이면 정상 파일) */
    private Date deletedAt;
}
