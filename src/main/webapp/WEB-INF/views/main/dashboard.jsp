<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>대시보드</title>
</head>
<body>
    <h2>안녕하세요, ${sessionScope.loginUser.userName}님!</h2>
    <a href="/groupware-portal/logout.do">로그아웃</a>
</body>
</html>