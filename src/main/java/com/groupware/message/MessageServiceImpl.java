package com.groupware.message;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groupware.user.UserVO;

@Service
public class MessageServiceImpl implements MessageService{
	@Autowired 
	private MessageMapper messageMapper;

	@Override
	public List<MessageVO> selectMessageSenderList(String userId) {
		// 보낸 쪽지 목록
		return messageMapper.selectMessageSenderList(userId);
	}

	@Override
	public List<MessageVO> selectMessageReceiverList(String userId) {
		// 받은 쪽지 목록
		return messageMapper.selectMessageReceiverList(userId);
	}

	@Override
	public void insertMessage(MessageVO messageVO) {
		// 쪽지 작성
		messageMapper.insertMessage(messageVO);
		
	}

	@Override
	public MessageVO selectMessageReceiverDetail(int msgId, String userId) {
		// 받은 쪽지 조회
		return messageMapper.selectMessageReceiverDetail(msgId, userId);
	}

	@Override
	public MessageVO selectMessageSenderDetail(int msgId, String userId) {
		// 보낸 쪽지 조회
		return messageMapper.selectMessageSenderDetail(msgId, userId);
	}

	@Override
	public void updateMessageReadStatus(MessageVO messageVO) {
		// 읽음 표시 
		messageMapper.updateMessageReadStatus(messageVO);
		
	}

	@Override
	public List<UserVO> selectReceiverName(String userName) {
		// 쪽지 수신인 이름 검색용(자동완성)
		return messageMapper.selectReceiverName(userName);
	}
	

}
