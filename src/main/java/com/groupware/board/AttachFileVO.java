package com.groupware.board;

import java.sql.Date;
import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class AttachFileVO {
    
    /** 파일 고유 번호 (PK) — DB에서 seq_attach.NEXTVAL로 자동 생성 */
    private int fileId;
    
    /** 참조 대상 타입 — 어떤 게시판의 파일인지 구분
     *  예) "NOTICE" (공지사항), "BOARD" (게시판) 등
     *  → 하나의 ATTACH_FILE 테이블을 여러 기능에서 공용으로 쓸 수 있게 해줌 */
    private String refType;
    
    /** 참조 대상 ID — refType에 해당하는 게시글 번호
     *  예) refType="NOTICE"이면 notice_id 값이 들어옴
     *  → refType + refId 조합으로 "어떤 게시글의 파일"인지 특정 */
    private int refId;
    
    /** 원본 파일명 — 사용자가 업로드한 실제 파일 이름
     *  예) "공지사항_첨부파일.pdf"
     *  → 다운로드 시 브라우저에 보여줄 파일명으로 사용 */
    private String origName;
    
    /** 서버 저장 경로 — 서버에 실제로 저장된 파일의 전체 경로
     *  예) "/upload/notice/20240630_uuid_공지사항.pdf"
     *  → 원본 파일명 그대로 저장하면 중복/한글 문제가 생겨서
     *     UUID 등으로 변환한 이름을 경로에 포함시킴 */
    private String savePath;
    
    /** 파일 크기 (바이트 단위)
     *  예) 1024 = 1KB, 1048576 = 1MB
     *  → long 타입인 이유: int 최대값(약 2GB)을 초과하는 대용량 파일 대비 */
    private long fileSize;
    
    /** 업로드 일시 — 파일이 등록된 날짜/시간
     *  DB의 uploaded_at 컬럼과 매핑 */
    private Date uploadedAT;
    
    /** 삭제 일시 — 파일이 삭제된 날짜/시간 (소프트 삭제용)
     *  NULL이면 정상 파일, 값이 있으면 삭제된 파일
     *  → 실제로 DB에서 row를 지우지 않고 이 날짜를 채워서 삭제 처리함
     *     Mapper XML에서 "AND deleted_at IS NULL" 조건으로 삭제된 파일 제외 */
    private Date deletedAt; 
    
}