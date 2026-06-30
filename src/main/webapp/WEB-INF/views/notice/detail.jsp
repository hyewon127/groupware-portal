<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="공지사항" />
<%@ include file="/WEB-INF/views/common/header.jsp"%>

<div class="d-flex justify-content-between align-items-center mb-3">
	<h4 class="fw-bold mb-0">공지사항 상세</h4>
</div>

<div class="card border-0 shadow-sm">
	<div class="card-body">

		<!-- 제목 -->
		<h5 class="fw-bold mb-2">${notice.title}</h5>

		<!-- 메타 정보 -->
		<div class="d-flex gap-3 text-muted small border-bottom pb-2 mb-3">
			<span>작성자: ${notice.writerName}</span> <span>작성일: <fmt:formatDate
					value="${notice.createdAt}" pattern="yyyy.MM.dd" /></span> <span>조회수:
				${notice.viewCnt}</span>
		</div>

		<!-- 본문 -->
		<div class="mb-4" style="min-height: 200px; white-space: pre-wrap;">
			${notice.content}</div>

		<!-- 버튼 -->
		<div class="d-flex gap-2 justify-content-end">
			<a href="${pageContext.request.contextPath}/notice/list.do"
				class="btn btn-secondary btn-sm">목록</a>

			<!-- 작성자 본인만 수정/삭제 가능 -->
			<c:if test="${notice.writerId == sessionScope.loginUser.userId}">
				<a
					href="${pageContext.request.contextPath}/notice/edit.do?noticeId=${notice.noticeId}"
					class="btn btn-sm" style="background-color: #1E293B; color: white;">수정</a>

				<form action="${pageContext.request.contextPath}/notice/delete.do"
					method="post" style="display: inline;"
					onsubmit="return confirm('삭제하시겠습니까?')">
					<input type="hidden" name="noticeId" value="${notice.noticeId}" />
					<button type="submit" class="btn btn-danger btn-sm">삭제</button>
				</form>
			</c:if>
		</div>
		<!-- 첨부파일 추가 기능 -->
		<div class="card-footer">
			<c:if test="${not empty fileList}">
				<strong>첨부파일</strong>
				<ul class="list-unstyled mt-2">
					<c:forEach var="file" items="${fileList}">
						<li>
							<%-- 
                        다운로드 링크: href에 컨트롤러의 download.do + fileId 파라미터를 넘김
                        클릭하면 NoticeController.filedownload() 메서드가 실행됨
                    	--%> 
                    	<a href="${pageContext.request.contextPath}/notice/download.do?fileId=${file.fileId}">
								${file.origName} <span class="text-muted small">
									(${file.fileSize / 1024}KB) </span>
						</a>
						</li>
					</c:forEach>
				</ul>
			</c:if>
			<c:if test="${empty fileList}">
				<span class="text-muted">첨부파일 없음</span>
			</c:if>
		</div>
	</div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp"%>