package com.groupware.notice;

import java.util.List;

public interface NoticeService {
	// 구현할 기능들을 모두 매서드로 만듬
		// 공지사항 목록 조회 (검색 + 페이징)
		List<NoticeVO> selectNoticeList(String keyword, int offset, int size);

		// 검색 조건에 맞는 공지 총 개수
		int countNoticeList(String keyword);

		// 전체 직원 수
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
