package com.groupware.main;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class DashboardController {

    // 대시보드 메인 페이지
    @RequestMapping("/dashboard.do")
    public String dashboard() {
        return "main/dashboard";  // /WEB-INF/views/main/dashboard.jsp
    }
}