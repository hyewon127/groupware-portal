package com.groupware.message;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;

import com.groupware.user.UserVO;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
@RequestMapping("/message")
public class MessageController {
	@Autowired
	private MessageService messageService;
	
	// 경로에 대한 key 값 resource 에 추가하기 
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
	// 받은 쪽지, 보낸 쪽지 화면 (페이징)
	@RequestMapping(value = "/list.do", method=RequestMethod.GET)
	public String list(@RequestParam(defaultValue = "received") String type,
					   @RequestParam(defaultValue = "1") int page,
					   HttpSession session,
					   Model model) throws Exception {
	    UserVO loginUser = (UserVO) session.getAttribute("loginUser");
	    String userId = loginUser.getUserId();

	    int size = 10;                    // 한 페이지 건수
	    int offset = (page - 1) * size;   // 건너뛸 행 수

	    List<MessageVO> list;
	    int totalCount;
	    if ("sent".equals(type)) {
	        list = messageService.selectMessageSenderList(userId, offset, size);
	        totalCount = messageService.countMessageSenderList(userId);
	    } else {
	        list = messageService.selectMessageReceiverList(userId, offset, size);
	        totalCount = messageService.countMessageReceiverList(userId);
	    }

	    // 전체 페이지 수 계산 (올림)
	    int totalPages = (int) Math.ceil((double) totalCount / size);

	    model.addAttribute("list", list);
	    model.addAttribute("type", type);
	    model.addAttribute("page", page);
	    model.addAttribute("totalPages", totalPages);
	    model.addAttribute("totalCount", totalCount);
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

		// 첨부파일 목록 조회 (상세 화면에서 다운로드 링크 표시용)
		List<AttachFileVO> fileList = messageService.selectAttachFileList(msgId);
		model.addAttribute("fileList", fileList);

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

	// 쪽지 등록 처리 (파일 업로드 포함)
	@RequestMapping(value = "/write.do", method=RequestMethod.POST)
	public String write(MessageVO messageVO,
						@RequestParam(value = "uploadFiles", required = false) MultipartFile[] uploadFiles,
						HttpSession session,
						HttpServletRequest request) throws Exception {
	    UserVO loginUser = (UserVO) session.getAttribute("loginUser");
	    if (loginUser == null) {
	        return "redirect:/login.do";
	    }
	    messageVO.setSenderId(loginUser.getUserId());

	    // 1. 쪽지 저장 → selectKey 로 messageVO 에 msgId 가 채워짐
	    messageService.insertMessage(messageVO);

	    // 2. 파일이 하나 이상 첨부된 경우에만 업로드 처리
	    if (uploadFiles != null && uploadFiles.length > 0) {

	        // 저장 디렉토리 (/upload/message). 공지/게시판과 동일한 패턴
	    	String uploadDir = propertiesService.getString("uploadBaseDir") + File.separator + "message";
	        File dir = new File(uploadDir);
	        if (!dir.exists()) {
	            dir.mkdirs();
	        }

	        for (MultipartFile uploadFile : uploadFiles) {
	            // 파일 선택 안 한 빈 슬롯은 건너뜀
	            if (uploadFile.isEmpty()) {
	                continue;
	            }

	            String origName = uploadFile.getOriginalFilename();
	            // UUID 로 저장 파일명 생성 (중복/한글 문제 예방)
	            String saveName = UUID.randomUUID().toString() + "_" + origName;
	            String savePath = uploadDir + File.separator + saveName;

	            // 실제 파일을 서버 디스크에 저장
	            uploadFile.transferTo(new File(savePath));

	            // DB(ATTACH_FILE)에 파일 정보 저장 (ref_type='MESSAGE')
	            AttachFileVO attachFileVO = new AttachFileVO();
	            attachFileVO.setRefType("MESSAGE");
	            attachFileVO.setRefId(messageVO.getMsgId());
	            attachFileVO.setOrigName(origName);
	            attachFileVO.setSavePath(savePath);
	            attachFileVO.setFileSize(uploadFile.getSize());
	            messageService.insertAttachFile(attachFileVO);
	        }
	    }

	    return "redirect:/message/list.do";
	}

	// 쪽지 첨부파일 다운로드
	@RequestMapping(value = "/download.do", method=RequestMethod.GET)
	public void filedownload(@RequestParam int fileId,
							HttpServletResponse response) throws Exception {

		// 1. DB 에서 파일 정보 조회
		AttachFileVO file = messageService.selectAttachFile(fileId);

		// 2. 응답 헤더 설정 (한글 파일명 깨짐 방지)
		String fileName = URLEncoder.encode(file.getOrigName(), "UTF-8");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
		response.setContentType("application/octet-stream");

		// 3. 서버 파일을 읽어서 브라우저로 전송
		File serverFile = new File(file.getSavePath());
		FileInputStream fis = new FileInputStream(serverFile);
		BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());

		byte[] buffer = new byte[1024];
		int len;
		while ((len = fis.read(buffer)) != -1) {
			bos.write(buffer, 0, len);
		}
		bos.flush();
		bos.close();
		fis.close();
	}

}
