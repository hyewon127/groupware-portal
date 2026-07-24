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
	public List<MessageVO> selectMessageSenderList(String userId, int offset, int size) {
		// 보낸 쪽지 목록 (페이징)
		return messageMapper.selectMessageSenderList(userId, offset, size);
	}

	@Override
	public List<MessageVO> selectMessageReceiverList(String userId, int offset, int size) {
		// 받은 쪽지 목록 (페이징)
		return messageMapper.selectMessageReceiverList(userId, offset, size);
	}

	@Override
	public int countMessageSenderList(String userId) {
		// 보낸 쪽지 총 개수
		return messageMapper.countMessageSenderList(userId);
	}

	@Override
	public int countMessageReceiverList(String userId) {
		// 받은 쪽지 총 개수
		return messageMapper.countMessageReceiverList(userId);
	}

	@Override
	public void insertMessage(MessageVO messageVO) {
		// 쪽지 작성
		messageMapper.insertMessage(messageVO);

	}

	@Override
	public void insertAttachFile(AttachFileVO attachFileVO) {
		// 쪽지 첨부파일 등록
		messageMapper.insertAttachFile(attachFileVO);
	}

	@Override
	public List<AttachFileVO> selectAttachFileList(int refId) {
		// 쪽지 첨부파일 목록 조회
		return messageMapper.selectAttachFileList(refId);
	}

	@Override
	public AttachFileVO selectAttachFile(int fileId) {
		// 쪽지 첨부파일 단건 조회 (다운로드용)
		return messageMapper.selectAttachFile(fileId);
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
