package com.groupware.message;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import com.groupware.user.UserVO;

@Mapper
public interface MessageMapper {
	// 보낸 쪽지 목록
	List<MessageVO> selectMessageSenderList(String userId);
	
	// 받은 쪽지 목록
	List<MessageVO> selectMessageReceiverList(String userId);
	
	// 쪽지 작성
	void insertMessage(MessageVO messageVO);
	
	// 받은 쪽지 조회
	MessageVO selectMessageReceiverDetail(@Param("msgId") int msgId, @Param("userId") String userId);
		
	// 보낸 쪽지 조회
	MessageVO selectMessageSenderDetail(@Param("msgId") int msgId, @Param("userId") String userId);
	
	// 읽음 표시 
	void updateMessageReadStatus(MessageVO messageVO);
	
	// 쪽지 수신인 이름 검색용(자동완성)
	List<UserVO> selectReceiverName(String userName);
}
