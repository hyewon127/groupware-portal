package com.groupware.notice;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface NoticeMapper {
	// 구현할 기능들을 모두 매서드로 만듬
	// 공지사항 목록 조회 (검색어 + 페이징)
	//  - keyword: 제목/작성자 검색어(없으면 전체)
	//  - offset : 건너뛸 행 수, size: 한 페이지 건수
	List<NoticeVO> selectNoticeList(@Param("keyword") String keyword,
									@Param("offset") int offset,
									@Param("size") int size);

	// 검색 조건에 맞는 공지 총 개수 (페이지 수 계산용)
	int countNoticeList(@Param("keyword") String keyword);

	// 전체 직원 수 (읽음 카운팅 "읽은 사람 / 전체 직원" 표시용)
	int selectTotalUserCnt();
	
	// 게시물 상세 조회
	NoticeVO selectNoticeDetail(int noticeId);
	
	// 게시물 등록
	void insertNotice(NoticeVO noticeVO);
	
	// 게시물 수정
	void updateNotice(NoticeVO noticeVO);
	
	// 게시물 삭제(소프트 삭제)
	void deleteNotice(int noticeId);
	
	// 조회수 증가
	void updateViewCnt(int noticeId);
	
	// 읽음 처리
	void insertNoticeRead(NoticeReadVO noticeReadVO);
	
	// 읽음 여부 확인
	int selectReadCheck(NoticeReadVO noticeReadVO);
	
	// 읽은 사람 수
	int selectReadCnt(int noticeId);
	
	// 파일 업로드
	void insertAttachFile(AttachFileVO attachFileVO);
	
	// 파일 목록
	List<AttachFileVO> selectAttachFileList(int refId);
	
	// 파일 조회
	AttachFileVO selectAttachFile(int fileId);
	
	// 파일 삭제
	void deleteAttachFile(int fileId);
}
