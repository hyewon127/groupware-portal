<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인 | 사내 그룹웨어</title>
    <!-- Bootstrap 5 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .login-wrap {
            max-width: 400px;
            margin: 100px auto;
            background: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .login-title {
            text-align: center;
            margin-bottom: 30px;
            font-weight: bold;
            font-size: 22px;
        }
        .btn-login {
            width: 100%;
            background-color: #F96167;
            border: none;
            color: white;
            padding: 10px;
        }
    </style>
</head>
<body>

<div class="login-wrap">
    <div class="login-title">사내 그룹웨어 포털</div>

    <!-- 에러 메시지 출력 -->
    <!-- msg 가 있을 때만 표시 -->
    <c:if test="${not empty msg}">
        <div class="alert alert-danger">${msg}</div>
    </c:if>

    <!-- action = LoginController POST /login.do 로 전송 -->
    <!-- ${pageContext.request.contextPath} 자동으로 프로젝트 찾아주는 기능  -->
    <!--  method = "post" 는 url 에 pw=1234 이런식으로 뜨는거 막아줌 -->
    <form action="${pageContext.request.contextPath}/login.do" method="post">
    	<!--  아이디 입력 부분 -->
    	<!--  mb-3 — Bootstrap의 margin-bottom 클래스 -->
    	<!--  m  = margin (바깥 여백)
			  b  = bottom (아래쪽)
			  3  = 크기 (0~5 숫자로 조절)
			  
			  mt = margin-top
			  ms = margin-start (왼쪽)
			  me = margin-end (오른쪽)
			  p  = padding (안쪽 여백) 
    	 -->
        <div class="mb-3">
            <label class="form-label">아이디</label>
            <!--  type="text" — 입력 박스 종류 지정 -->
            <!--  name 은 컨트롤러에 적힌 변수명과 동일해야 함!  -->
            <!-- class="form-control" — Bootstrap CSS 클래스. 입력박스를 예쁘게 스타일링 -->
            <!-- placeholder="" — 입력 전에 흐리게 보이는 안내 텍스트  -->
            <!--  required — 필수 입력 속성. 비워두고 submit 하면 브라우저가 자동으로 막아줌 -->
            <input type="text" name="userId" class="form-control" placeholder="아이디를 입력하세요" required>
        </div>
        <!--  비밀번호 입력 부분 -->
        <div class="mb-3">
            <label class="form-label">비밀번호</label>
            <input type="password" name="userPw" class="form-control" placeholder="비밀번호를 입력하세요" required>
        </div>
        <button type="submit" class="btn btn-login">로그인</button>
    </form>
</div>

</body>
</html>