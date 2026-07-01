package com.groupware.board;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	private BoardMapper boardMapper;

	@Override
	public List<BoardVO> BoardList(int teamId) {
		// 게시판 목록 조회(팀별)
		return boardMapper.BoardList(teamId);
	}

	@Override
	public BoardVO selectBoardDetail(@Param("teamId") int teamId, @Param("boardId") int boardId) {
		// 게시물 상세 조회
		return boardMapper.selectBoardDetail(teamId, boardId);
	}

	@Override
	public void insertBoard(BoardVO boardVO) {
		// 게시물 등록
		boardMapper.insertBoard(boardVO);
		
	}

	@Override
	public void updateBoard(BoardVO boardVO) {
		// 게시물 수정
		boardMapper.updateBoard(boardVO);
		
	}

	@Override
	public void deleteBoard(int boradId) {
		// 게시물 삭제(소프트 삭제)
		boardMapper.deleteBoard(boradId);
		
	}

	@Override
	public void insertAttachFile(AttachFileVO attachFileVO) {
		// 파일 업로드
		boardMapper.insertAttachFile(attachFileVO);
		
	}

	@Override
	public List<AttachFileVO> selectAttachFileList(int refId) {
		// 파일 목록
		return boardMapper.selectAttachFileList(refId);
	}

	@Override
	public AttachFileVO selectAttachFile(int fileId) {
		// 파일 조회
		return boardMapper.selectAttachFile(fileId);
	}

	@Override
	public void deleteAttachFile(int fileId) {
		// 파일 삭제
		boardMapper.deleteAttachFile(fileId);
		
	}

	@Override
	public List<BoardVO> selectAllBoardList() {
		// 게시물 목록 조회(전체)
		return boardMapper.selectAllBoardList();
	}

	@Override
	public List<BoardVO> selectTeamList() {
		// 팀 목록 조회
		return boardMapper.selectTeamList();
	}

	@Override
	public BoardVO selectBoardDetailById(int boardId) {
		// 관리자용 게시물 조회
		return boardMapper.selectBoardDetailById(boardId);
	}

	@Override
	public void insertComment(CommentVO commentVO) {
		// 댓글 등록
		boardMapper.insertComment(commentVO);
		
	}

	@Override
	public List<CommentVO> selectCommentList(int boardId) {
		// 댓글 목록 조회
		return boardMapper.selectCommentList(boardId);
	}

	@Override
	public void deleteComment(int commentId) {
		// 댓글 삭제
		boardMapper.deleteComment(commentId);
		
	}
	
}
