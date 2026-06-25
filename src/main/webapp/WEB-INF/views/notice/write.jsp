<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="공지사항"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="fw-bold mb-0">
        <!-- noticeId 있으면 수정, 없으면 등록 -->
        <c:choose>
            <c:when test="${not empty notice}">공지사항 수정</c:when>
            <c:otherwise>공지사항 등록</c:otherwise>
        </c:choose>
    </h4>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/notice/${not empty notice ? 'edit' : 'write'}.do"
              method="post">

            <!-- 수정일 때 noticeId hidden으로 전달 -->
            <c:if test="${not empty notice}">
                <input type="hidden" name="noticeId" value="${notice.noticeId}"/>
            </c:if>

            <div class="mb-3">
                <label class="form-label fw-bold">제목</label>
                <input type="text" name="title" class="form-control"
                       value="${notice.title}" placeholder="제목을 입력하세요" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">내용</label>
                <textarea name="content" class="form-control" rows="15"
                          placeholder="내용을 입력하세요" required>${notice.content}</textarea>
            </div>

            <div class="d-flex gap-2 justify-content-end">
                <a href="${pageContext.request.contextPath}/notice/list.do"
                   class="btn btn-secondary">목록</a>
                <button type="submit" class="btn"
                        style="background-color:#F96167; color:white;">
                    <c:choose>
                        <c:when test="${not empty notice}">수정</c:when>
                        <c:otherwise>등록</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>