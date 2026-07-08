package com.groupware.notice;

import java.io.File;
import java.net.URLEncoder;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;


import java.io.BufferedOutputStream;
import java.io.FileInputStream;


import com.groupware.user.UserVO;


@Controller
@RequestMapping("/notice")
public class NoticeController {
	
	@Autowired
	private NoticeService noticeService;
	
	// 공지사항 목록 조회
	@RequestMapping(value="/list.do", method=RequestMethod.GET)
	public String list(Model model) throws Exception{
		List<NoticeVO> list = noticeService.selectNoticeList();
		model.addAttribute("list", list);
		return "notice/list";
	}
	
	// 공지사항 등록 화면
	@RequestMapping(value="/write.do", method=RequestMethod.GET)
	public String writeForm() {
		return "notice/write";
	}
	
	// 등록 처리 (파일 업로드 포함)
	@RequestMapping(value = "write.do", method=RequestMethod.POST)
	public String write(NoticeVO noticeVO, 
						// MultipartFile 여러 파일을 배열로 받음, name="uploadFiles"와 일치
						@RequestParam(value = "uploadFiles", required = false) MultipartFile[] uploadFiles,
						HttpSession session,
						HttpServletRequest request) throws Exception {
		
		// 1. 세션에서 로그인 아이디를 꺼내고 작성자로 작성함.
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		noticeVO.setWriterId(loginUser.getUserId());
		
		// 2. 공지사항 DB 저장 → 저장 후 noticeVO에 noticeId가 채워짐
		noticeService.insertNotice(noticeVO);
		
		// 3. 파일이 하나 이상 첨부된 경우에만 업로드 처리
        //    null 체크 + length 체크: 아예 선택 안 했을 때 빈 배열이 들어올 수 있음
        if (uploadFiles != null && uploadFiles.length > 0) {

            // 3-1. 서버에서 파일을 저장할 디렉토리 경로 가져오기
            String uploadDir = request.getServletContext().getRealPath("/upload/notice");

            // 3-2. 디렉토리가 없으면 자동 생성
            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            // 3-3. 배열을 순회하면서 파일마다 동일한 저장 로직 반복
            for (MultipartFile uploadFile : uploadFiles) {

                // 파일을 선택 안 한 슬롯은 비어있을 수 있어서 개별 체크 후 건너뜀
                if (uploadFile.isEmpty()) {
                    continue;
                }

                // 3-4. 원본 파일명 추출
                String origName = uploadFile.getOriginalFilename();

                // 3-5. UUID로 저장 파일명 생성 — 중복 방지 + 한글/특수문자 문제 예방
                String saveName = UUID.randomUUID().toString() + "_" + origName;

                // 3-6. 최종 저장 경로 (디렉토리 + 파일명)
                String savePath = uploadDir + File.separator + saveName;

                // 3-7. 실제 파일을 서버 디스크에 저장
                uploadFile.transferTo(new File(savePath));

                // 3-8. DB에 파일 정보 저장
                AttachFileVO attachFileVO = new AttachFileVO();
                attachFileVO.setRefType("NOTICE");
                attachFileVO.setRefId(noticeVO.getNoticeId());
                attachFileVO.setOrigName(origName);
                attachFileVO.setSavePath(savePath);
                attachFileVO.setFileSize(uploadFile.getSize());
                System.out.println("DB 저장 직전 VO: " + attachFileVO);

                noticeService.insertAttachFile(attachFileVO);
            }
        }
		
		return "redirect:/notice/list.do";
	}
	
	// 상세 조회
	@RequestMapping(value = "/detail.do", method=RequestMethod.GET)
	public String detail(@RequestParam int noticeId,
						HttpSession session,
						Model model) throws Exception{
		// 조회수 증가
		noticeService.updateViewCnt(noticeId);
		
		// 상세 데이터 조회
		NoticeVO notice = noticeService.selectNoticeDetail(noticeId);
		model.addAttribute("notice", notice);
		
		// 첨부파일 목록 조회 (jsp 에서 다운로드 링크 표시에 사용)
		List<AttachFileVO> fileList = noticeService.selectAttachFileList(noticeId);
		model.addAttribute("fileList", fileList);
		
		// 읽음 처리
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		NoticeReadVO readVO = new NoticeReadVO();
		readVO.setNoticeId(noticeId);
		readVO.setUserId(loginUser.getUserId()); 
		
		// 이미 읽었으면 중복 insert 안 함
		if(noticeService.selectReadCheck(readVO) == 0) {
			noticeService.insertNoticeRead(readVO);
		}
		
		return "notice/detail";
	}
	
	// 공지사항 수정 화면
	@RequestMapping(value = "/edit.do", method = RequestMethod.GET)
	public String editForm(@RequestParam int noticeId, Model model) throws Exception {
	    NoticeVO notice = noticeService.selectNoticeDetail(noticeId);
	    model.addAttribute("notice", notice);
	    
	    // 기존 첨부파일 목록 조회
	    List<AttachFileVO> fileList = noticeService.selectAttachFileList(noticeId);
	    model.addAttribute("fileList", fileList);
	    
	    return "notice/write"; 
	}
	
	// 공지사항 수정 처리
	@RequestMapping(value = "/edit.do", method = RequestMethod.POST)
	public String edit(NoticeVO noticeVO,
	                   @RequestParam(value = "uploadFiles", required = false) MultipartFile[] uploadFiles,
	                   HttpServletRequest request) throws Exception {
		
		 System.out.println("===== edit() 진입함");
	     System.out.println("===== uploadFiles = " + (uploadFiles == null ? "null" : uploadFiles.length));
	    
	    noticeService.updateNotice(noticeVO);
	    
	    if (uploadFiles != null && uploadFiles.length > 0) {
	    	 System.out.println("===== 파일 처리 진입");
	        
	        String uploadDir = request.getServletContext().getRealPath("/upload/notice");
	        File dir = new File(uploadDir);
	        if (!dir.exists()) {
	            dir.mkdirs();
	        }
	        
	        for (MultipartFile uploadFile : uploadFiles) {
	            if (uploadFile.isEmpty()) {
	                continue;
	            }
	            
	            String origName = uploadFile.getOriginalFilename();
	            String saveName = UUID.randomUUID().toString() + "_" + origName;
	            String savePath = uploadDir + File.separator + saveName;
	            
	            uploadFile.transferTo(new File(savePath));
	            
	            AttachFileVO attachFileVO = new AttachFileVO();
	            attachFileVO.setRefType("NOTICE");
	            attachFileVO.setRefId(noticeVO.getNoticeId());
	            attachFileVO.setOrigName(origName);
	            attachFileVO.setSavePath(savePath);
	            attachFileVO.setFileSize(uploadFile.getSize());
	            
	            noticeService.insertAttachFile(attachFileVO);
	        }
	    }
	    
	    return "redirect:/notice/detail.do?noticeId=" + noticeVO.getNoticeId();
	}
	
	// 공지사항 첨부파일 추가, 삭제
	@RequestMapping(value="/deleteFile.do", method=RequestMethod.POST)
	public String deleteFile(@RequestParam int fileId,
							@RequestParam int noticeId) throws Exception {
		
		// 소프트 삭제 처리
		noticeService.deleteAttachFile(fileId); 
		return "redirect:/notice/edit.do?noticeId="+ noticeId;
	}
	
	
	// 공지사항 삭제
	@RequestMapping(value="/delete.do", method=RequestMethod.POST)
	public String delete(@RequestParam int noticeId) throws Exception {
		noticeService.deleteNotice(noticeId);
		return "redirect:/notice/list.do";
	}
	
	// 파일 다운로드
	@RequestMapping(value="/download.do", method=RequestMethod.GET)
	public void filedownload(@RequestParam int fileId,
							HttpServletResponse response) throws Exception{
		
		// 1. DB 에서 파일 정보 조회
		AttachFileVO file = noticeService.selectAttachFile(fileId); 
	
		// 2. 응답 헤더 설정 
		// Content-Disposition: attachment → 브라우저에 "파일로 저장해라" 지시
	    // URLEncoder.encode: 한글 파일명 깨짐 방지
		String fileName = URLEncoder.encode(file.getOrigName(), "UTF-8");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
		
		// setContentType: 응답 데이터 타입 설정
	    // application/octet-stream → "그냥 바이너리 파일이다" (어떤 파일이든 다운로드 됨)
		response.setContentType("application/octet-stream");
		
		// 3. 서버 파일 읽어서 브라우저로 전송
	    // File: 서버에 저장된 실제 파일 객체
	    // FileInputStream: 파일을 읽는 통로 (파일 → Java)
	    // BufferedOutputStream: 브라우저로 보내는 통로 (Java → 브라우저)
		File serverFile = new File(file.getSavePath());
		FileInputStream fis = new FileInputStream(serverFile);
		BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());
		
		// 1024바이트씩 나눠서 읽고 전송
	    // 한 번에 다 읽으면 메모리 부족할 수 있어서 조금씩 나눠서 보냄
	    byte[] buffer = new byte[1024];
	    int len;
	    while ((len = fis.read(buffer)) != -1) {
	        bos.write(buffer, 0, len);
	    }

	    // 남은 데이터 마저 전송 후 통로 닫기
	    bos.flush();
	    bos.close();
	    fis.close();
		
	}
	   
	
}
