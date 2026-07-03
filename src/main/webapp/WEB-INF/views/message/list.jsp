<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="쪽지함" />
<%@ include file="/WEB-INF/views/common/header.jsp"%>

<!-- 페이지 타이틀 -->
<div class="d-flex justify-content-between align-items-center mb-3">
	<h4 class="fw-bold mb-0">쪽지함</h4>
	<a href="${pageContext.request.contextPath}/message/write.do"
		class="btn btn-sm" style="background-color: #F96167; color: white;">
		쪽지 보내기 </a>
</div>

<div class="d-flex justify-content-between align-items-center mb-3">
	<div>
		<a
			href="${pageContext.request.contextPath}/message/list.do?type=received"
			class="btn ${type == 'received' ? 'btn-secondary' : 'btn-outline-secondary'} me-2">
			받은 쪽지 </a> <a
			href="${pageContext.request.contextPath}/message/list.do?type=sent"
			class="btn ${type == 'sent' ? 'btn-secondary' : 'btn-outline-secondary'}">
			보낸 쪽지 </a>
	</div>
</div>


<!-- 쪽지함 테이블 -->
<div class="card border-0 shadow-sm">
	<div class="card-body p-0">
		<table class="table table-hover mb-0">
			<thead class="table-light">
				<tr>
					<th width="80" class="text-center">읽음</th>
					<th>${type == 'sent' ? '수신자' : '발신자'}</th>
					<th>제목</th>
					<th width="160" class="text-center">${type == 'sent' ? '발신일' : '수신일'}</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${empty list}">
						<tr>
							<td colspan="4" class="text-center py-4 text-muted">${type == 'sent' ? '보낸' : '받은'}
								쪽지가 없습니다.</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="msg" items="${list}">
							<tr style="cursor: pointer;"
								class="${msg.isRead == 'N' ? 'fw-bold' : ''}"
								onclick="location.href='${pageContext.request.contextPath}/message/detail.do?msgId=${msg.msgId}&type=${type}'">
								<td class="text-center">${msg.isRead}</td>
								<td><c:choose>
										<c:when test="${type == 'sent'}">${msg.receiverName}</c:when>
										<c:otherwise>${msg.senderName}</c:otherwise>
									</c:choose></td>
								<td>${msg.title}</td>
								<td class="text-center"><fmt:formatDate
										value="${msg.sentAt}" pattern="yyyy.MM.dd HH:mm" /></td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>
</div>