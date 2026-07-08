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
        /* 로그인 폼 아래 보조 링크(회원가입/비밀번호 찾기) */
        .login-links {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
            font-size: 13px;
        }
        .login-links a, .login-links button {
            color: #6c757d;
            text-decoration: none;
            background: none;
            border: none;
            padding: 0;
        }
        .login-links a:hover, .login-links button:hover { color: #F96167; }
    </style>
</head>
<body>

<div class="login-wrap">
    <div class="login-title">사내 그룹웨어 포털</div>

    <!-- action = LoginController POST /login.do 로 전송 -->
    <!-- ${pageContext.request.contextPath} 자동으로 프로젝트 찾아주는 기능  -->
    <!--  method = "post" 는 url 에 pw=1234 이런식으로 뜨는거 막아줌 -->
    <form action="${pageContext.request.contextPath}/login.do" method="post">
        <div class="mb-3">
            <label class="form-label">아이디</label>
            <!--  name 은 컨트롤러에 적힌 변수명과 동일해야 함!  -->
            <input type="text" name="userId" class="form-control" placeholder="아이디를 입력하세요" required>
        </div>
        <!--  비밀번호 입력 부분 -->
        <div class="mb-3">
            <label class="form-label">비밀번호</label>
            <input type="password" name="userPw" class="form-control" placeholder="비밀번호를 입력하세요" required>
        </div>
        <button type="submit" class="btn btn-login">로그인</button>

        <!-- 회원가입 / 비밀번호 찾기 링크 -->
        <div class="login-links">
            <a href="${pageContext.request.contextPath}/signup.do">회원가입</a>
            <%-- data-bs-toggle 로 비밀번호 찾기 모달 열기 --%>
            <button type="button" data-bs-toggle="modal" data-bs-target="#findPwModal">
                비밀번호 찾기
            </button>
        </div>
    </form>
</div>

<!-- ===================== 비밀번호 찾기 모달 ===================== -->
<div class="modal fade" id="findPwModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">비밀번호 찾기</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <!-- 아이디 + 이메일이 일치하면 새 비밀번호로 재설정 -->
            <form action="${pageContext.request.contextPath}/findPw.do" method="post">
                <div class="modal-body">
                    <p class="text-muted small">가입 시 등록한 아이디와 이메일을 입력하면 새 비밀번호로 재설정할 수 있습니다.</p>
                    <div class="mb-3">
                        <label class="form-label">아이디</label>
                        <input type="text" name="userId" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">이메일</label>
                        <input type="email" name="email" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">새 비밀번호</label>
                        <input type="password" name="newPw" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-login" style="width:auto;">비밀번호 재설정</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ===================== 결과/오류 팝업 모달 ===================== -->
<!-- 로그인 실패 또는 비밀번호 재설정 결과 메시지를 팝업으로 표시 -->
<div class="modal fade" id="msgModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">알림</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                ${msg}
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-login" style="width:auto;" data-bs-dismiss="modal">확인</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS (모달 동작에 필요) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 서버에서 msg 가 내려오면(로그인 실패 등) 팝업을 자동으로 띄움
    <c:if test="${not empty msg}">
        var msgModal = new bootstrap.Modal(document.getElementById('msgModal'));
        msgModal.show();
    </c:if>
</script>

</body>
</html>
