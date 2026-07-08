<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="쪽지" />
<%@ include file="/WEB-INF/views/common/header.jsp"%>

<div class="d-flex justify-content-between align-items-center mb-3">
	<h4 class="fw-bold mb-0">쪽지 상세</h4>
</div>

<div class="card border-0 shadow-sm">
	<div class="card-body">

		<!-- 제목 -->
		<h5 class="fw-bold mb-2">${message.title}</h5>
		
		<!-- 메타 정보 -->
		<div class="d-flex gap-3 text-muted small border-bottom pb-2 mb-3">
			<span>발송인: ${message.senderName}</span> 
			<span>수신인: ${message.receiverName}</span>
			<span>작성일: <fmt:formatDate value="${message.sentAt}" pattern="yyyy.MM.dd HH:mm" /></span> 
		</div>
		
		<!-- 본문 (pre-line: 입력한 줄바꿈 그대로 표시) -->
		<div class="mb-3" style="min-height: 200px; white-space: pre-line;">
			${message.content}</div>

		<!-- 첨부파일 목록 (있을 때만 표시) -->
		<c:if test="${not empty fileList}">
			<div class="border-top pt-3 mb-3">
				<div class="fw-bold small mb-2"><i class="bi bi-paperclip"></i> 첨부파일</div>
				<ul class="list-group">
					<c:forEach var="file" items="${fileList}">
						<li class="list-group-item d-flex justify-content-between align-items-center">
							<span>📎 ${file.origName}</span>
							<a href="${pageContext.request.contextPath}/message/download.do?fileId=${file.fileId}"
							   class="btn btn-sm btn-outline-secondary">다운로드</a>
						</li>
					</c:forEach>
				</ul>
			</div>
		</c:if>

		<!-- 답장/목록 버튼 -->
		<div class="d-flex justify-content-end gap-2 mt-3">

		    <c:if test="${type eq 'received'}">
			    <!-- 답장 버튼 replyMsgId(원본 쪽지 번호)-> write.do / Controller -> 원본 쪽지 -->
			    <a href="${pageContext.request.contextPath}/message/write.do?replyMsgId=${message.msgId}"
			       class="btn btn-sm"
			       style="background:#F96167;color:white;">
			        답장
			    </a>
			</c:if>
		
		    <a href="${pageContext.request.contextPath}/message/list.do"
		       class="btn btn-secondary btn-sm" style="width:50px;">
		        목록
		    </a>
		</div>    
		</div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp"%>