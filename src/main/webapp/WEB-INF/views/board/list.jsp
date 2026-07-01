<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="게시판"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%-- 관리자일 때만 탭 버튼 표시 --%>
<c:if test="${loginUser.teamId == 7}">
    <div class="mb-3 d-flex gap-2 flex-wrap">
        <a href="${pageContext.request.contextPath}/board/list.do?teamId=-1"
           class="btn btn-sm ${selectedTeamId == -1 ? 'btn-danger' : 'btn-outline-secondary'}">
            전체
        </a>
        <c:forEach var="team" items="${teamList}">
            <a href="${pageContext.request.contextPath}/board/list.do?teamId=${team.teamId}"
               class="btn btn-sm ${selectedTeamId == team.teamId ? 'btn-danger' : 'btn-outline-secondary'}">
                ${team.teamName}
            </a>
        </c:forEach>
    </div>
</c:if>

<!-- 페이지 타이틀 -->
<div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="fw-bold mb-0">팀 게시판</h4>
    <c:if test="${loginUser.teamId != 7}">
        <a href="${pageContext.request.contextPath}/board/write.do"
           class="btn btn-sm" style="background-color:#F96167; color:white;">
            등록
        </a>
    </c:if>
</div>

<!-- 게시판 테이블 -->
<div class="card border-0 shadow-sm">
    <div class="card-body p-0">
        <table class="table table-hover mb-0">
            <thead class="table-light">
                <tr>
                    <th width="80" class="text-center">번호</th>
                    <th>팀</th>
                    <th>제목</th>
                    <th width="120" class="text-center">작성자</th>
                    <th width="120" class="text-center">작성일</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr>
                            <td colspan="5" class="text-center py-4 text-muted">
                                등록된 게시글이 없습니다.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="board" items="${list}">
                            <tr style="cursor:pointer;"
                                onclick="location.href='${pageContext.request.contextPath}/board/detail.do?boardId=${board.boardId}'">
                                <td class="text-center">${board.boardId}</td>
                                <td>${board.teamName}</td>
                                <td>${board.title}</td>
                                <td class="text-center">${board.writerName}</td>
                                <td class="text-center">
                                    <fmt:formatDate value="${board.createdAt}" pattern="yyyy.MM.dd"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>