package com.groupware.message;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.groupware.user.UserVO;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
@RequestMapping("/message")
public class MessageController {
	@Autowired
	private MessageService messageService;
	
	// 받은 쪽지, 보낸 쪽지 화면
	@RequestMapping(value = "/list.do", method=RequestMethod.GET)
	public String list(@RequestParam(defaultValue = "received") String type,
					   HttpSession session, 
					   Model model) throws Exception {
	    UserVO loginUser = (UserVO) session.getAttribute("loginUser");

	    List<MessageVO> list;
	    if ("sent".equals(type)) {
	        list = messageService.selectMessageSenderList(loginUser.getUserId());
	    } else {
	        list = messageService.selectMessageReceiverList(loginUser.getUserId());
	    }

	    model.addAttribute("list", list);
	    model.addAttribute("type", type);
	    return "message/list";
	}
	
	// 받은 쪽지, 보낸 쪽지 상세 조회
	@RequestMapping(value = "/detail.do", method=RequestMethod.GET)
	public String detail(@RequestParam int msgId,  
						@RequestParam String type,
						HttpSession session,
						Model model) throws Exception{
		
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		MessageVO message;
		
		if ("received".equals(type)) {

		    MessageVO messageVO = new MessageVO();
		    messageVO.setMsgId(msgId);
		    messageVO.setReceiverId(loginUser.getUserId());

		    messageService.updateMessageReadStatus(messageVO);

		    message = messageService.selectMessageReceiverDetail(msgId, loginUser.getUserId());
		} else {
		    message = messageService.selectMessageSenderDetail(msgId, loginUser.getUserId());
		}
		
		model.addAttribute("message", message);
		model.addAttribute("type", type);
	
		return "message/detail";
	}
	
	// 쪽지 수신인 이름 검색용(자동완성)
	@GetMapping("/searchReceiver.do")
	@ResponseBody
	public List<UserVO> searchReceiver(@RequestParam("userName") String userName) throws Exception{
		return messageService.selectReceiverName(userName);
	}
	
	// 쪽지 작성 화면(답장포함)
		@RequestMapping(value = "/write.do", method=RequestMethod.GET)
		public String write(
		        @RequestParam(required = false) Integer replyMsgId,
		        HttpSession session,
		        Model model) throws Exception {

			// replayMsgId 유무로 답장 화면인지 확인
		    if(replyMsgId != null) {
		        UserVO loginUser = (UserVO)session.getAttribute("loginUser");

		        // 원본 조회
		        MessageVO message =
		                messageService.selectMessageReceiverDetail(replyMsgId, loginUser.getUserId());
		        
		        // 답장의 받는 사람 = 원래 발신자
		        message.setReceiverName(message.getSenderName());
		        
		        // 답장의 receiverId = 원래 senderId
		        message.setReceiverId(message.getSenderId());

		        // 제목 앞에 RE: 붙이기
		        message.setTitle("RE: " + message.getTitle());
		        
		        // 내용에 답장 구분 선 
		        message.setContent(
		        		// 원본 내용
		        		message.getContent() +
		        		"\n\n\n" +

		        		"======================================================\n" +
		        		"[원본 메시지]\n\n" +
		        		"발신자 : " + message.getSenderName() + "\n" +
		        		"작성일 : " + message.getSentAt() + "\n\n" 
		        		);
		        
		        // 답장 유무
		        model.addAttribute("reply", true);
		        model.addAttribute("message", message);
		      
		    }
		    return "message/write";
		}

	// 쪽지 등록 처리
	@RequestMapping(value = "/write.do", method=RequestMethod.POST)
	public String write(MessageVO messageVO, HttpSession session) throws Exception {
	    UserVO loginUser = (UserVO) session.getAttribute("loginUser");
	    if (loginUser == null) {
	        return "redirect:/login.do";
	    }
	    messageVO.setSenderId(loginUser.getUserId());
	    messageService.insertMessage(messageVO);
	    return "redirect:/message/list.do";
	}
	
}
