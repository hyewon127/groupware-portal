<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="pageTitle" value="관리자설정"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="fw-bold mb-0"><i class="bi bi-gear"></i> 관리자 설정 · 직원 관리</h4>
    <span class="text-muted small">총 ${fn:length(userList)} 명</span>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-body p-0">
        <table class="table table-hover mb-0 align-middle">
            <thead class="table-light">
                <tr>
                    <th width="120">아이디</th>
                    <th width="120">이름</th>
                    <th>이메일</th>
                    <th width="150">팀</th>
                    <th width="150">권한</th>
                    <th width="160" class="text-center">관리</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty userList}">
                        <tr><td colspan="6" class="text-center py-4 text-muted">등록된 직원이 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="u" items="${userList}">
                            <tr>
                                <td class="fw-semibold">${u.userId}</td>
                                <td>${u.userName}</td>
                                <td>${u.email}</td>
                                <td>
                                    <%-- HTML5 form 속성으로 아래 action 칸의 editForm 에 연결 --%>
                                    <select name="teamId" form="editForm_${u.userId}" class="form-select form-select-sm">
                                        <c:forEach var="team" items="${teamList}">
                                            <option value="${team.teamId}" ${u.teamId == team.teamId ? 'selected' : ''}>
                                                ${team.teamName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <select name="role" form="editForm_${u.userId}" class="form-select form-select-sm">
                                        <option value="USER" ${u.role == 'USER' ? 'selected' : ''}>USER</option>
                                        <option value="TEAM_LEADER" ${u.role == 'TEAM_LEADER' ? 'selected' : ''}>TEAM_LEADER</option>
                                        <option value="ADMIN" ${u.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                                    </select>
                                </td>
                                <td class="text-center">
                                    <%-- 팀/권한 변경 폼 (form 속성으로 위 select 들과 연결됨) --%>
                                    <form id="editForm_${u.userId}"
                                          action="${pageContext.request.contextPath}/admin/user/update.do" method="post"
                                          style="display:inline;">
                                        <input type="hidden" name="userId" value="${u.userId}">
                                        <button type="submit" class="btn btn-sm btn-dark">저장</button>
                                    </form>
                                    <%-- 계정 비활성화 폼 (별도) --%>
                                    <form action="${pageContext.request.contextPath}/admin/user/delete.do"
                                          method="post" style="display:inline;"
                                          onsubmit="return confirm('${u.userName}(${u.userId}) 계정을 비활성화하시겠습니까?');">
                                        <input type="hidden" name="userId" value="${u.userId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">비활성화</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<div class="text-muted small mt-2">
    <i class="bi bi-info-circle"></i> 팀/권한을 바꾼 뒤 <b>저장</b>을 누르면 즉시 반영됩니다. 비활성화된 계정은 로그인·목록에서 제외됩니다.
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
