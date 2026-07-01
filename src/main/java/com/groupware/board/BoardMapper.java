package com.groupware.board;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;


@Mapper
public interface BoardMapper {
	// 게시판 목족 조회(전체 조회)
	List<BoardVO> selectAllBoardList();
	
	// 게시판 목록 조회(팀별로 조회)
	List<BoardVO> BoardList(int teamId);
	
	// 팀 목록 조회
	List<BoardVO> selectTeamList();
	
	// 게시물 상세 조회
	BoardVO selectBoardDetail(@Param("teamId") int teamId, @Param("boardId") int boardId);
	
	// 관리자용 상세 조회
	BoardVO selectBoardDetailById(int boardId);
	
	// 게시물 등록
	void insertBoard(BoardVO boardVO);
	
	// 게시물 수정
	void updateBoard(BoardVO boardVO);
	
	// 게시물 삭제(소프트 삭제)
	void deleteBoard(int boardId);
	
	// 파일 업로드
	void insertAttachFile(AttachFileVO attachFileVO);
	
	// 파일 목록
	List<AttachFileVO> selectAttachFileList(int refId);
	
	// 파일 조회
	AttachFileVO selectAttachFile(int fileId);
	
	// 파일 삭제
	void deleteAttachFile(int fileId); 
	
	// 댓글 등록
	void insertComment(CommentVO commentVO);
	
	// 댓글 목록 조회
	List<CommentVO> selectCommentList(int boardId);
	
	// 댓글 삭제
	void deleteComment(int commentId);
}
