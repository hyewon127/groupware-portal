package com.groupware.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class NoticeServiceImpl implements NoticeService {
	@Autowired
	private NoticeMapper noticeMapper;

	@Override
	public List<NoticeVO> selectNoticeList() {
		// 공지사항 목록 조회
		return noticeMapper.selectNoticeList();
	}

	@Override
	public NoticeVO selectNoticeDetail(int noticeId) {
		// 공지사항 상세 조회
		return noticeMapper.selectNoticeDetail(noticeId);
	}

	@Override
	public void insertNotice(NoticeVO noticeVO) {
		// 공지사항 등록
		noticeMapper.insertNotice(noticeVO);
	}

	@Override
	public void updateNotice(NoticeVO noticeVO) {
		// 공지사항 수정
		noticeMapper.updateNotice(noticeVO);
	}

	@Override
	public void deleteNotice(int noticeId) {
		// 공지사항 삭제(소프트 삭제)
		noticeMapper.deleteNotice(noticeId);
	}

	@Override
	public void updateViewCnt(int noticeId) {
		// 조회수 증가
		noticeMapper.updateViewCnt(noticeId);
	}

	@Override
	public void insertNoticeRead(NoticeReadVO noticeReadVO) {
		// 읽음 처리
		noticeMapper.insertNoticeRead(noticeReadVO);
	}

	@Override
	public int selectReadCheck(NoticeReadVO noticeReadVO) {
		// 읽음 여부 확인
		return noticeMapper.selectReadCheck(noticeReadVO);
	}

	@Override
	public int selectReadCnt(int noticeId) {
		// 읽은 사람 수
		return noticeMapper.selectReadCnt(noticeId);
	}

	@Override
	public void insertAttachFile(AttachFileVO attachFileVO) {
		// 파일 업로드 
		noticeMapper.insertAttachFile(attachFileVO);
		
	}

	@Override
	public List<AttachFileVO> selectAttachFileList(int refId) {
		// 파일 목록
		return noticeMapper.selectAttachFileList(refId);
	}

	@Override
	public AttachFileVO selectAttachFile(int fileId) {
		return noticeMapper.selectAttachFile(fileId);
	}

	@Override
	public void deleteAttachFile(int fileId) {
		noticeMapper.deleteAttachFile(fileId);
		
	}
	
	
	
}
