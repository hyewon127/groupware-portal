<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사내 그룹웨어 포털</title>
    <!-- Bootstrap 5 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { margin: 0; padding: 0; background-color: #f4f5f7; }

        /* GNB 상단바 */
        .gnb {
            height: 56px;
            background-color: #1E293B;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 20px;
            position: fixed;
            top: 0; left: 0; right: 0;
            z-index: 1000;
        }
        .gnb .logo {
            color: #F96167;
            font-size: 18px;
            font-weight: bold;
            text-decoration: none;
        }
        .gnb .user-info {
            color: #fff;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .gnb .user-info a {
            color: #CBD5E1;
            text-decoration: none;
            font-size: 13px;
        }
        .gnb .user-info a:hover { color: #fff; }

        /* LNB 사이드바 */
        .lnb {
            width: 200px;
            background-color: #1E293B;
            position: fixed;
            top: 56px; left: 0; bottom: 0;
            overflow-y: auto;
            padding-top: 10px;
        }
        .lnb a {
            display: block;
            color: #CBD5E1;
            text-decoration: none;
            padding: 12px 20px;
            font-size: 14px;
            transition: all 0.2s;
        }
        .lnb a:hover, .lnb a.active {
            background-color: #F96167;
            color: #fff;
        }
        .lnb .menu-title {
            color: #64748B;
            font-size: 11px;
            padding: 15px 20px 5px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* 본문 영역 */
        .content-wrap {
            margin-left: 200px;
            margin-top: 56px;
            padding: 24px;
            min-height: calc(100vh - 56px);
        }
    </style>
</head>
<body>

<!-- GNB 상단바 -->
<div class="gnb">
    <a href="${pageContext.request.contextPath}/dashboard.do" class="logo">
        GW Portal
    </a>
    <div class="user-info">
        <span><i class="bi bi-person-circle"></i> ${sessionScope.loginUser.userName} 님</span>
        <a href="${pageContext.request.contextPath}/logout.do">
            <i class="bi bi-box-arrow-right"></i> 로그아웃
        </a>
    </div>
</div>

<!-- LNB 사이드바 -->
<div class="lnb">
    <div class="menu-title">메인</div>
    <a href="${pageContext.request.contextPath}/dashboard.do"
       class="${pageTitle == '대시보드' ? 'active' : ''}">
        <i class="bi bi-speedometer2"></i> 대시보드
    </a>

    <div class="menu-title">업무</div>
    <a href="${pageContext.request.contextPath}/notice/list.do"
       class="${pageTitle == '공지사항' ? 'active' : ''}">
        <i class="bi bi-megaphone"></i> 공지사항
    </a>
    <a href="${pageContext.request.contextPath}/board/list.do"
       class="${pageTitle == '게시판' ? 'active' : ''}">
        <i class="bi bi-layout-text-window"></i> 게시판
    </a>
    <a href="${pageContext.request.contextPath}/schedule/calendar.do"
       class="${pageTitle == '일정관리' ? 'active' : ''}">
        <i class="bi bi-calendar3"></i> 일정관리
    </a>
    <a href="${pageContext.request.contextPath}/message/list.do"
       class="${pageTitle == '쪽지' ? 'active' : ''}">
        <i class="bi bi-envelope"></i> 쪽지함
    </a>
</div>

<!-- 본문 시작 -->
<div class="content-wrap">