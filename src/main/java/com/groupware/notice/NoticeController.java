package com.groupware.notice;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

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
	
	// 등록 처리
	@RequestMapping(value = "write.do", method=RequestMethod.POST)
	public String write(NoticeVO noticeVO,HttpSession session) throws Exception{
		// 세션에서 로그인 아이디를 꺼내고 작성자로 작성함. 
		UserVO loginUser = (UserVO) session.getAttribute("loginUser");
		noticeVO.setWriterId(loginUser.getUserId());
		noticeService.insertNotice(noticeVO);
		return "redirect:/notice/list.do";
	}
	
	// 상세 조회
	@RequestMapping(value = "/detail.do", method=RequestMethod.GET)
	public String datail(@RequestParam int noticeId,
						HttpSession session,
						Model model) throws Exception{
		// 조회수 증가
		noticeService.updateViewCnt(noticeId);
		
		// 상세 데이터 조회
		NoticeVO notice = noticeService.selectNoticeDetail(noticeId);
		model.addAttribute("notice", notice);
		
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
	    return "notice/write"; 
	}
	
	// 공지사항 수정 처리
	@RequestMapping(value = "/edit.do", method = RequestMethod.POST)
    public String edit(NoticeVO noticeVO) throws Exception {
        noticeService.updateNotice(noticeVO);
        return "redirect:/notice/detail.do?noticeId=" + noticeVO.getNoticeId();
    }
	
	// 공지사항 삭제
	@RequestMapping(value="/delete.do", method=RequestMethod.POST)
	public String delete(@RequestParam int noticeId) throws Exception {
		noticeService.deleteNotice(noticeId);
		return "redirect:/notice/list.do";
	}

}
