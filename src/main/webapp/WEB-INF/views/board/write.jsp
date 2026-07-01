<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="게시판" />
<%@ include file="/WEB-INF/views/common/header.jsp"%>

<div class="d-flex justify-content-between align-items-center mb-3">
	<h4 class="fw-bold mb-0">
		<c:choose>
			<c:when test="${not empty board}">게시판 수정</c:when>
			<c:otherwise>게시판 등록</c:otherwise>
		</c:choose>
	</h4>
</div>

<div class="card border-0 shadow-sm">
	<div class="card-body">
		<!-- ✅ 메인 등록/수정 폼 -->
		<form
			action="${pageContext.request.contextPath}/board/${not empty board ? 'edit' : 'write'}.do"
			method="post" enctype="multipart/form-data">

			<c:if test="${not empty board}">
				<input type="hidden" name="boardId" value="${board.boardId}" />
			</c:if>

			<div class="mb-3">
				<label class="form-label fw-bold">제목</label> <input type="text"
					name="title" class="form-control" value="${board.title}"
					placeholder="제목을 입력하세요" required>
			</div>

			<div class="mb-3">
				<label class="form-label fw-bold">내용</label>
				<textarea name="content" class="form-control" rows="15"
					placeholder="내용을 입력하세요" required>${board.content}</textarea>
			</div>

			<!-- ✅ 기존 첨부파일 "표시용" 영역 — form 없이 목록만 보여줌 -->
			<c:if test="${not empty board and not empty fileList}">
				<div class="mb-3">
					<label class="form-label fw-bold">첨부파일 목록</label>
					<ul class="list-group">
						<c:forEach var="file" items="${fileList}">
							<li
								class="list-group-item d-flex justify-content-between align-items-center"
								id="file-${file.fileId}"><a
								href="${pageContext.request.contextPath}/board/download.do?fileId=${file.fileId}">
									${file.origName} <span class="text-muted small">(${file.fileSize / 1024}KB)</span>
							</a> <!-- 
									삭제는 form이 아닌 버튼 + JS로 처리
									실제 form 제출은 메인 폼 바깥의 별도 form에서 함
								-->
								<button type="button" class="btn btn-sm btn-outline-danger"
									onclick="deleteFile(${file.fileId}, ${board.boardId})">
									삭제</button></li>
						</c:forEach>
					</ul>
				</div>
			</c:if>

			<div class="mb-3">
				<label class="form-label"> <c:choose>
						<c:when test="${not empty board}">첨부파일 추가</c:when>
						<c:otherwise>첨부파일</c:otherwise>
					</c:choose>
				</label> <input type="file" name="uploadFiles" class="form-control" multiple />
			</div>

			<div class="d-flex gap-2 justify-content-end">
				<a href="${pageContext.request.contextPath}/board/list.do"
					class="btn btn-secondary">목록</a>
				<button type="submit" class="btn"
					style="background-color: #F96167; color: white;">
					<c:choose>
						<c:when test="${not empty board}">수정</c:when>
						<c:otherwise>등록</c:otherwise>
					</c:choose>
				</button>
			</div>
		</form>

	</div>
</div>

<!-- 첨부 파일 삭제-->
<form id="deleteFileForm"
	action="${pageContext.request.contextPath}/board/deleteFile.do"
	method="post" style="display: none;">
	<input type="hidden" name="fileId" id="deleteFileId" /> <input
		type="hidden" name="boardId" id="deleteboardId" />
</form>

<script>
	// 삭제 버튼 클릭 시 숨겨진 form에 값 채우고 제출
	function deleteFile(fileId, boardId) {
		if (!confirm('이 파일을 삭제하시겠습니까?')) {
			return;
		}
		document.getElementById('deleteFileId').value = fileId;
		document.getElementById('deleteboardId').value = boardId;
		document.getElementById('deleteFileForm').submit();
	}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp"%>