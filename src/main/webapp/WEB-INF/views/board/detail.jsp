<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="게시판" />
<%@ include file="/WEB-INF/views/common/header.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div class="d-flex justify-content-between align-items-center mb-3">
	<h4 class="fw-bold mb-0">게시판 상세</h4>
</div>

<div class="card border-0 shadow-sm">
	<div class="card-body">

		<!-- 제목 -->
		<h5 class="fw-bold mb-2">${board.title}</h5>

		<!-- 메타 정보 -->
		<div class="d-flex gap-3 text-muted small border-bottom pb-2 mb-3">
			<span>작성자: ${board.writerName}</span> <span>작성일: <fmt:formatDate
					value="${board.createdAt}" pattern="yyyy.MM.dd" /></span>
		</div>

		<!-- 본문 -->
		<div class="mb-3" style="min-height: 200px; text-align: left;">
			${board.content}</div>
		<!-- 버튼 -->
		<div class="d-flex gap-2 justify-content-end mb-3">
			<a href="${pageContext.request.contextPath}/board/list.do"
				class="btn btn-secondary btn-sm">목록</a>

			<%-- ✅ 관리자이거나(or) 본인 작성자일 때 수정/삭제 버튼 표시 --%>
			<c:if
				test="${loginUser.teamId == 7 or board.writerId == loginUser.userId}">
				<a
					href="${pageContext.request.contextPath}/board/edit.do?boardId=${board.boardId}"
					class="btn btn-sm" style="background-color: #1E293B; color: white;">수정</a>

				<form action="${pageContext.request.contextPath}/board/delete.do"
					method="post" style="display: inline;"
					onsubmit="return confirm('삭제하시겠습니까?')">
					<input type="hidden" name="boardId" value="${board.boardId}" />
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
                        클릭하면 boardController.filedownload() 메서드가 실행됨
                    	--%> <a
							href="${pageContext.request.contextPath}/board/download.do?fileId=${file.fileId}">
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
		<!-- 댓글 영역 -->
		<div class="mt-4">
			<h6 class="fw-bold mb-3">댓글 ${fn:length(commentList)}개</h6>

			<!-- 댓글 목록 -->
			<c:choose>
				<c:when test="${empty commentList}">
					<p class="text-muted small">등록된 댓글이 없습니다.</p>
				</c:when>
				<c:otherwise>
					<c:forEach var="comment" items="${commentList}">
						<div class="border rounded p-3 mb-2 bg-light">
							<div
								class="d-flex justify-content-between align-items-center mb-1">
								<span class="fw-bold small">${comment.writerName}</span>
								<div class="d-flex gap-2 align-items-center">
									<span class="text-muted small"> <fmt:formatDate
											value="${comment.createdAt}" pattern="yyyy.MM.dd HH:mm" />
									</span>
									<%-- 본인 댓글이거나 관리자면 삭제 버튼 표시 --%>
									<c:if
										test="${comment.writerId == loginUser.userId or loginUser.teamId == 7}">
										<form
											action="${pageContext.request.contextPath}/board/comment/delete.do"
											method="post" style="display: inline;"
											onsubmit="return confirm('댓글을 삭제하시겠습니까?')">
											<input type="hidden" name="commentId"
												value="${comment.commentId}" /> <input type="hidden"
												name="boardId" value="${board.boardId}" />
											<button type="submit" class="btn btn-sm btn-outline-danger">삭제</button>
										</form>
									</c:if>
								</div>
							</div>
							<p class="mb-0 small">${comment.content}</p>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>

			<!-- 댓글 등록 폼 -->
			<form
				action="${pageContext.request.contextPath}/board/comment/insert.do"
				method="post">
				<input type="hidden" name="boardId" value="${board.boardId}" />
				<div class="input-group mt-3">
					<input type="text" name="content" class="form-control"
						placeholder="댓글을 입력하세요" required />
					<button type="submit" class="btn btn-sm"
						style="background-color: #F96167; color: white;">등록</button>
				</div>
			</form>
		</div>
	</div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp"%>