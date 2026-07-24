<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="내 정보"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="fw-bold mb-0"><i class="bi bi-person-badge"></i> 내 정보 관리</h4>
</div>

<%-- 비밀번호 변경 결과 메시지 --%>
<c:if test="${not empty pwMsg}">
    <div class="alert alert-info">${pwMsg}</div>
</c:if>

<div class="row g-3">
    <!-- 기본 정보 수정 카드 -->
    <div class="col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-white fw-bold">기본 정보</div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/profile/update.do" method="post">
                    <div class="mb-3">
                        <label class="form-label">아이디</label>
                        <%-- 아이디는 변경 불가 (읽기 전용) --%>
                        <input type="text" class="form-control" value="${user.userId}" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">이름</label>
                        <input type="text" name="userName" class="form-control" value="${user.userName}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">이메일</label>
                        <input type="email" name="email" class="form-control" value="${user.email}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">권한</label>
                        <%-- 권한은 관리자만 변경 가능하므로 읽기 전용 표시 --%>
                        <input type="text" class="form-control" value="${user.role}" readonly>
                    </div>
                    <div class="text-end">
                        <button type="submit" class="btn" style="background-color:#F96167; color:#fff;">
                            <i class="bi bi-check-lg"></i> 정보 수정
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 비밀번호 변경 카드 -->
    <div class="col-md-6">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-white fw-bold">비밀번호 변경</div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/profile/password.do" method="post"
                      onsubmit="return checkPw()">
                    <div class="mb-3">
                        <label class="form-label">현재 비밀번호</label>
                        <input type="password" name="currentPw" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">새 비밀번호</label>
                        <input type="password" id="newPw" name="newPw" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">새 비밀번호 확인</label>
                        <input type="password" id="newPwConfirm" class="form-control" required>
                        <div id="pwMismatch" class="text-danger small mt-1" style="display:none;">
                            새 비밀번호가 일치하지 않습니다.
                        </div>
                    </div>
                    <div class="text-end">
                        <button type="submit" class="btn btn-dark">
                            <i class="bi bi-key"></i> 비밀번호 변경
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // 새 비밀번호 2개가 같은지 확인
    function checkPw() {
        var pw = document.getElementById('newPw').value;
        var pw2 = document.getElementById('newPwConfirm').value;
        if (pw !== pw2) {
            document.getElementById('pwMismatch').style.display = 'block';
            return false; // 다르면 폼 전송 막기
        }
        return true;
    }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
