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
		
		<!-- 본문 -->
		<div class="mb-3" style="min-height: 200px; white-space: left;">
			${message.content}</div>
			
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