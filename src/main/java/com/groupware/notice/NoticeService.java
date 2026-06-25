package com.groupware.notice;

import java.util.List;

public interface NoticeService {
	// 구현할 기능들을 모두 매서드로 만듬
		// 공지사항 목록 조회
		List<NoticeVO> selectNoticeList();
		
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
}
