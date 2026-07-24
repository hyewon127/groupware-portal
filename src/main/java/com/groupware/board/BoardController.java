package com.groupware.board;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.groupware.user.UserVO;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;



@Controller
@RequestMapping("/board")
public class BoardController {
	@Autowired
	private BoardService boardService;
	
	// 경로에 대한 key 값 resource 에 추가하기 
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
	// 게시판 목록 조회(로그인한 사용자가 속한 팀의 게시물만 조회할 수 있음) : 검색 + 페이징
	@RequestMapping(value="/list.do", method=RequestMethod.GET)
	public String boardList(Model model,
							HttpSession session,
							// 파라미터에서 teamId 를 받아오고, 없을 경우 디폴트로 -1를 입력해서 teamId로 받음.
							@RequestParam(value="teamId", defaultValue = "-1") int teamId,
							@RequestParam(value="keyword", required=false) String keyword,
							@RequestParam(value="page", defaultValue="1") int page) throws Exception{

		// session 에서 로그인 사용자 정보만 꺼냄
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		List<BoardVO> list;

		int size = 10;                     // 한 페이지에 보여줄 건수
		int offset = (page - 1) * size;    // 건너뛸 행 수
		int totalCount;                    // 검색 조건에 맞는 전체 건수

		// 관리자, 일반 직원 목록 구분 (관리자는 7)
		if(loginUser.getTeamId() == 7) {
			if(teamId == -1) {
				// 전체 팀 게시글
				list = boardService.selectAllBoardList(keyword, offset, size);
				totalCount = boardService.countAllBoardList(keyword);
			} else {
				// 선택한 팀 게시글
				list = boardService.BoardList(teamId, keyword, offset, size);
				totalCount = boardService.countBoardList(teamId, keyword);
			}
			// 팀 목록 확인(관리자만)
			List<BoardVO> teamList = boardService.selectTeamList();
			model.addAttribute("teamList", teamList);
			model.addAttribute("selectedTeamId", teamId);
		} else {
			// 일반 직원 - 본인 팀 게시글만
			int myTeamId = loginUser.getTeamId();
			list = boardService.BoardList(myTeamId, keyword, offset, size);
			totalCount = boardService.countBoardList(myTeamId, keyword);
			// 페이징/검색 링크에서 teamId 유지용 (일반 직원은 본인 팀 고정)
			model.addAttribute("selectedTeamId", myTeamId);
		}

		// 전체 페이지 수 계산 (올림)
		int totalPages = (int) Math.ceil((double) totalCount / size);

		model.addAttribute("list", list);
		model.addAttribute("keyword", keyword);        // 검색창 유지용
		model.addAttribute("page", page);              // 현재 페이지
		model.addAttribute("totalPages", totalPages);  // 전체 페이지 수
		model.addAttribute("totalCount", totalCount);  // 전체 건수
		return "board/list";
	}
	
	// 게시물 등록 화면
	@RequestMapping(value="/write.do", method=RequestMethod.GET)
	public String writeForm(HttpSession session){
		
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		
		// 관리자 게시물 list 에서 제외 
		if(loginUser.getTeamId()==7) {
			return "redirect:/board/list.do";
		}
		
		return "board/write";
	}
	
	// 게시물 등록 처리(파일 업로드 포함)
	@RequestMapping(value = "write.do", method=RequestMethod.POST)
	public String write(BoardVO boardVO, 
						// MultipartFile 여러 파일을 배열로 받음, name="uploadFiles"와 일치
						@RequestParam(value = "uploadFiles", required = false) MultipartFile[] uploadFiles,
						HttpSession session,
						HttpServletRequest request) throws Exception {
	
		// 1. 세션에서 로그인 아이디를 꺼내고 작성자로 작성함.
				UserVO loginUser = (UserVO) session.getAttribute("loginUser");
				
		// 1-1. 관리자 게시물 차단(작성 x) 
				if(loginUser.getTeamId() == 7) {
					return "redirect:/board/list.do";
				}
				
				boardVO.setWriterId(loginUser.getUserId());
				boardVO.setTeamId(loginUser.getTeamId());
				
		// 2. DB 저장 
				boardService.insertBoard(boardVO);
		
		// 3. 파일이 하나 이상 첨부된 경우에만 업로드 처리
        //    null 체크 + length 체크: 아예 선택 안 했을 때 빈 배열이 들어올 수 있음
		        if (uploadFiles != null && uploadFiles.length > 0) {
		
		            // 3-1. 서버에서 파일을 저장할 디렉토리 경로 가져오기
		        	String uploadDir = propertiesService.getString("uploadBaseDir") + File.separator + "board";
		
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
		                attachFileVO.setRefType("BOARD");
		                attachFileVO.setRefId(boardVO.getBoardId());
		                attachFileVO.setOrigName(origName);
		                attachFileVO.setSavePath(savePath);
		                attachFileVO.setFileSize(uploadFile.getSize());
		                System.out.println("DB 저장 직전 VO: " + attachFileVO);
		
		                boardService.insertAttachFile(attachFileVO);
		            }
		        }
				
				return "redirect:/board/list.do";
	
	}
	
	// 게시물 상세 조회
	@RequestMapping(value="/detail.do", method=RequestMethod.GET)
	public String detail(@RequestParam int boardId, // teamId 를 파라미터로 받으면 노출될 가능성 있어서 boardId 만 받음
						HttpSession session,
						Model model) throws Exception {
		// teamId 를 로그인 정보에서 꺼내옴(teamId 조작 가능성 x)
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		BoardVO board;
		
		// 상제 데이터 조회
		
		if(loginUser.getTeamId() == 7) {
			// 관리자일 경우 모두 접근 가능
			board = boardService.selectBoardDetailById(boardId);
		} else{
			// 일반 직원일 경우 본인 팀 글만 조회
			board = boardService.selectBoardDetail(loginUser.getTeamId(), boardId);
		}
		// url 직접 검색, 다른 팀원 링크 공유하는 경우 방지
		// board가 null 이면 다른 팀 글이거나 없는 글이라 목록으로 넘어가게 안전장치 설정
	    if (board == null) {
	        return "redirect:/board/list.do";
	    }
		
	    model.addAttribute("board", board);
	    
		// 첨부파일 목록 조회
		List<AttachFileVO> fileList = boardService.selectAttachFileList(boardId);
		model.addAttribute("fileList", fileList); 
		
		// 댓글 목록 조회
		List<CommentVO> commentList = boardService.selectCommentList(boardId);
		model.addAttribute("commentList", commentList);
		
		return "board/detail";
	}
	
	// 게시물 수정 화면
	@RequestMapping(value = "/edit.do", method = RequestMethod.GET)
	public String editForm(@RequestParam int boardId, 
						   HttpSession session,
						   Model model) throws Exception {
		
		// teamId 를 로그인 정보에서 꺼내옴(teamId 조작 가능성 x)
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		BoardVO board;
		
		if(loginUser.getTeamId() == 7) {
			// 관리자용 세부 정보 확인
			board = boardService.selectBoardDetailById(boardId);
		} else {
			// 일반 직원용 세부 정보 확인
			board = boardService.selectBoardDetail(loginUser.getTeamId(), boardId);
		}
		
		model.addAttribute("board", board);
		
		// 기존 첨부파일 목록 조회
		List<AttachFileVO> fileList = boardService.selectAttachFileList(boardId);
		model.addAttribute("fileList", fileList);
		
		return "board/write";
	}
		
	// 게시물 수정 처리
	@RequestMapping(value="/edit.do", method=RequestMethod.POST)
	public String edit(BoardVO boardVO,
					   @RequestParam(value="uploadFiles", required = false) MultipartFile[] uploadFiles,
					   HttpServletRequest request) throws Exception {
		
		boardService.updateBoard(boardVO);
		
	    if (uploadFiles != null && uploadFiles.length > 0) {
	    	 System.out.println("===== 파일 처리 진입");
	        
	    	String uploadDir = propertiesService.getString("uploadBaseDir") + File.separator + "board";
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
	            attachFileVO.setRefType("BOARD");
	            attachFileVO.setRefId(boardVO.getBoardId());
	            attachFileVO.setOrigName(origName);
	            attachFileVO.setSavePath(savePath);
	            attachFileVO.setFileSize(uploadFile.getSize());
	            
	            boardService.insertAttachFile(attachFileVO);
	        }
	    }
	    
	    return "redirect:/board/detail.do?boardId=" + boardVO.getBoardId();
	}
	
	// 게시물 첨부파일 추가, 삭제
	@RequestMapping(value = "/deleteFile.do", method=RequestMethod.POST)
	public String deleteFile(@RequestParam int fileId,
							@RequestParam int boardId) throws Exception{
		
		boardService.deleteAttachFile(fileId);
		return "redirect:/board/edit.do?boardId=" + boardId;
	}
	
	// 게시물 삭제
	@RequestMapping(value="/delete.do", method=RequestMethod.POST)
	public String delete(@RequestParam int boardId) throws Exception {
		boardService.deleteBoard(boardId);
		return "redirect:/board/list.do";
	}
	
	// 파일 다운로드
	@RequestMapping(value="/download.do", method=RequestMethod.GET)
	public void filedownload(@RequestParam int fileId,
							HttpServletResponse response) throws Exception{
		
		// 1. DB 에서 파일 정보 조회
		AttachFileVO file = boardService.selectAttachFile(fileId); 
	
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
	
	// 댓글 등록
	@RequestMapping(value="/comment/insert.do", method=RequestMethod.POST)
	public String insertcomment(@RequestParam int boardId,
									@RequestParam String content,
									HttpSession session) throws Exception{
		
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		
		CommentVO commentVO = new CommentVO();
		commentVO.setBoardId(boardId);
		commentVO.setWriterId(loginUser.getUserId());
		commentVO.setContent(content);
		
		boardService.insertComment(commentVO);
		
		// 댓글 등록 후 해당 게시글 상세로 들어감
		return "redirect:/board/detail.do?boardId="+ boardId;
	}
	
	// 댓글 삭제
	@RequestMapping(value="/comment/delete.do", method=RequestMethod.POST)
	public String deletecomment(@RequestParam int commentId,
								@RequestParam int boardId,
								Model model) throws Exception{
		
		boardService.deleteComment(commentId); 
		
		List<CommentVO> commentList = boardService.selectCommentList(boardId);
		model.addAttribute("commentList", commentList);
		
		// 원래 게시물 
		return "redirect:/board/detail.do?boardId="+ boardId;
	}
	
	
}
