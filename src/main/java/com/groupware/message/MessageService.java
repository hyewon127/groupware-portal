package com.groupware.message;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.groupware.user.UserVO;

public interface MessageService {
	// 보낸 쪽지 목록 (페이징)
	List<MessageVO> selectMessageSenderList(String userId, int offset, int size);

	// 받은 쪽지 목록 (페이징)
	List<MessageVO> selectMessageReceiverList(String userId, int offset, int size);

	// 보낸/받은 쪽지 총 개수 (페이징 계산용)
	int countMessageSenderList(String userId);
	int countMessageReceiverList(String userId);

	// 쪽지 작성
	void insertMessage(MessageVO messageVO);

	// 쪽지 첨부파일 등록
	void insertAttachFile(AttachFileVO attachFileVO);

	// 쪽지 첨부파일 목록 조회
	List<AttachFileVO> selectAttachFileList(int refId);

	// 쪽지 첨부파일 단건 조회 (다운로드용)
	AttachFileVO selectAttachFile(int fileId);
	
	// 받은 쪽지 조회
	MessageVO selectMessageReceiverDetail(@Param("msgId") int msgId, @Param("userId") String userId);
		
	// 보낸 쪽지 조회
	MessageVO selectMessageSenderDetail(@Param("msgId") int msgId, @Param("userId") String userId);
	
	// 읽음 표시 
	void updateMessageReadStatus(MessageVO messageVO);
	
	// 쪽지 수신인 이름 검색용(자동완성)
	List<UserVO> selectReceiverName(String userName);
}
