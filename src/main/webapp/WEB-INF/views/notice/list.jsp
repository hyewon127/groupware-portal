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
                    <th width="80" class="text-center">조회수</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr>
                            <td colspan="5" class="text-center py-4 text-muted">
                                등록된 공지사항이 없습니다.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="notice" items="${list}">
                            <tr style="cursor:pointer;"
                                onclick="location.href='${pageContext.request.contextPath}/notice/detail.do?noticeId=${notice.noticeId}'">
                                <td class="text-center">${notice.noticeId}</td>
                                <td>${notice.title}</td>
                                <td class="text-center">${notice.writerName}</td>
                                <td class="text-center">
                                    <fmt:formatDate value="${notice.createdAt}" pattern="yyyy.MM.dd"/>
                                </td>
                                <td class="text-center">${notice.viewCnt}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>