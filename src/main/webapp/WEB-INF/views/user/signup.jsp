<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 | 사내 그룹웨어</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .signup-wrap {
            max-width: 460px;
            margin: 60px auto;
            background: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .signup-title { text-align: center; margin-bottom: 30px; font-weight: bold; font-size: 22px; }
        .btn-signup { width: 100%; background-color: #F96167; border: none; color: white; padding: 10px; }
    </style>
</head>
<body>

<div class="signup-wrap">
    <div class="signup-title"><i class="bi bi-person-plus"></i> 회원가입</div>

    <%-- 서버에서 넘어온 에러(아이디 중복 등) 표시 --%>
    <c:if test="${not empty msg}">
        <div class="alert alert-danger py-2">${msg}</div>
    </c:if>

    <%-- 회원가입 폼: name 값(userId, userPw, userName, email, teamId)은 UserVO 필드명과 일치 --%>
    <form id="signupForm" action="${pageContext.request.contextPath}/signup.do" method="post"
          onsubmit="return validateSignup()">

        <!-- 아이디 + 중복확인 버튼 -->
        <div class="mb-3">
            <label class="form-label">아이디</label>
            <div class="input-group">
                <input type="text" id="userId" name="userId" class="form-control"
                       value="${user.userId}" placeholder="아이디" required>
                <button type="button" class="btn btn-outline-secondary" onclick="checkId()">중복확인</button>
            </div>
            <%-- 중복확인 결과 문구 (JS로 채움) --%>
            <div id="idCheckResult" class="small mt-1"></div>
        </div>

        <!-- 비밀번호 -->
        <div class="mb-3">
            <label class="form-label">비밀번호</label>
            <input type="password" id="userPw" name="userPw" class="form-control" placeholder="비밀번호" required>
        </div>
        <!-- 비밀번호 확인 -->
        <div class="mb-3">
            <label class="form-label">비밀번호 확인</label>
            <input type="password" id="userPwConfirm" class="form-control" placeholder="비밀번호 다시 입력" required>
            <div id="pwMismatch" class="text-danger small mt-1" style="display:none;">비밀번호가 일치하지 않습니다.</div>
        </div>

        <!-- 이름 -->
        <div class="mb-3">
            <label class="form-label">이름</label>
            <input type="text" name="userName" class="form-control" value="${user.userName}" placeholder="이름" required>
        </div>
        <!-- 이메일 -->
        <div class="mb-3">
            <label class="form-label">이메일</label>
            <input type="email" name="email" class="form-control" value="${user.email}" placeholder="example@company.com" required>
        </div>
        <!-- 소속팀 선택 -->
        <div class="mb-4">
            <label class="form-label">소속팀</label>
            <select name="teamId" class="form-select" required>
                <option value="">팀을 선택하세요</option>
                <c:forEach var="team" items="${teamList}">
                    <option value="${team.teamId}" ${user.teamId == team.teamId ? 'selected' : ''}>
                        ${team.teamName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <button type="submit" class="btn btn-signup">가입하기</button>
    </form>

    <div class="text-center mt-3">
        <a href="${pageContext.request.contextPath}/login.do" class="small text-muted text-decoration-none">
            <i class="bi bi-arrow-left"></i> 로그인으로 돌아가기
        </a>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 아이디 중복확인 통과 여부 (true 여야 가입 가능)
    var idChecked = false;

    // 아이디 값이 바뀌면 다시 중복확인 하도록 초기화
    $("#userId").on("input", function () {
        idChecked = false;
        $("#idCheckResult").text("");
    });

    // [중복확인] 버튼 → 서버에 AJAX 로 아이디 존재 여부 조회
    function checkId() {
        var userId = $("#userId").val().trim();
        if (userId === "") {
            $("#idCheckResult").text("아이디를 입력하세요.").css("color", "#dc3545");
            return;
        }
        $.ajax({
            url: "${pageContext.request.contextPath}/signup/checkId.do",
            type: "GET",
            data: { userId: userId },
            success: function (result) {
                if (result === "available") {
                    idChecked = true;
                    $("#idCheckResult").text("사용 가능한 아이디입니다.").css("color", "#28a745");
                } else {
                    idChecked = false;
                    $("#idCheckResult").text("이미 사용 중인 아이디입니다.").css("color", "#dc3545");
                }
            }
        });
    }

    // 폼 제출 전 검증: 중복확인 통과 + 비밀번호 일치
    function validateSignup() {
        if (!idChecked) {
            alert("아이디 중복확인을 해주세요.");
            return false;
        }
        var pw = $("#userPw").val();
        var pw2 = $("#userPwConfirm").val();
        if (pw !== pw2) {
            $("#pwMismatch").show();
            return false;
        }
        $("#pwMismatch").hide();
        return true;
    }
</script>

</body>
</html>
