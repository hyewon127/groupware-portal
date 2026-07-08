<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="공지사항"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>


<!-- 페이지 타이틀 -->
<div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="fw-bold mb-0">공지사항</h4>
    <a href="${pageContext.request.contextPath}/notice/write.do"
       class="btn btn-sm" style="background-color:#F96167; color:white;">
        등록
    </a>
</div>

<!-- 검색 폼: 제목/작성자 검색. GET 방식이라 URL 에 keyword 가 남아 새로고침/페이징에도 유지됨 -->
<form class="row g-2 mb-3 justify-content-end" method="get"
      action="${pageContext.request.contextPath}/notice/list.do">
    <div class="col-auto">
        <input type="text" name="keyword" class="form-control form-control-sm"
               style="width:220px;" placeholder="제목 또는 작성자 검색"
               value="${keyword}">
    </div>
    <div class="col-auto">
        <button type="submit" class="btn btn-sm btn-dark">
            <i class="bi bi-search"></i> 검색
        </button>
    </div>
</form>

<!-- 공지사항 테이블 -->
<div class="card border-0 shadow-sm">
    <div class="card-body p-0">
        <table class="table table-hover mb-0">
            <thead class="table-light">
                <tr>
                    <th width="80" class="text-center">번호</th>
                    <th>제목</th>
                    <th width="120" class="text-center">작성자</th>
                    <th width="120" class="text-center">작성일</th>
                    <th width="90" class="text-center">읽음</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr>
                            <td colspan="5" class="text-center py-4 text-muted">
                                <c:choose>
                                    <c:when test="${not empty keyword}">'${keyword}' 검색 결과가 없습니다.</c:when>
                                    <c:otherwise>등록된 공지사항이 없습니다.</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="notice" items="${list}">
                            <tr style="cursor:pointer;"
                                onclick="location.href='${pageContext.request.contextPath}/notice/detail.do?noticeId=${notice.noticeId}'">
                                <td class="text-center">${notice.noticeId}</td>
                                <td>
                                    ${notice.title}
                                   <%-- 첨부파일이 있으면 클립 이모지 표시 --%>
                                   <c:if test="${notice.attachCnt > 0}"> 🗂️ </c:if>
                                </td>
                                <td class="text-center">${notice.writerName}</td>
                                <td class="text-center">
                                    <fmt:formatDate value="${notice.createdAt}" pattern="yyyy.MM.dd"/>
                                </td>
                                <%-- 읽은 사람 수 / 전체 직원 수 --%>
                                <td class="text-center">
                                    <span class="text">${notice.readCnt} / ${totalUserCnt}</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<!-- ===================== 페이지네이션 ===================== -->
<c:if test="${totalPages > 1}">
    <nav class="mt-3">
        <ul class="pagination justify-content-center mb-0">
            <%-- 이전 페이지 (1페이지면 비활성화) --%>
            <li class="page-item ${page <= 1 ? 'disabled' : ''}">
                <a class="page-link"
                   href="?page=${page - 1}&keyword=${keyword}">이전</a>
            </li>
            <%-- 페이지 번호 1 ~ totalPages 반복 --%>
            <c:forEach var="p" begin="1" end="${totalPages}">
                <li class="page-item ${p == page ? 'active' : ''}">
                    <a class="page-link" href="?page=${p}&keyword=${keyword}">${p}</a>
                </li>
            </c:forEach>
            <%-- 다음 페이지 (마지막 페이지면 비활성화) --%>
            <li class="page-item ${page >= totalPages ? 'disabled' : ''}">
                <a class="page-link"
                   href="?page=${page + 1}&keyword=${keyword}">다음</a>
            </li>
        </ul>
    </nav>
</c:if>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
