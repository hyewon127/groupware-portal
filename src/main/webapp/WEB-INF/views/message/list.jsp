<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="pageTitle" value="쪽지" />
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
		<table class="table table-hover mb-0 align-middle">
			<thead class="table-light">
				<tr>
					<th width="90" class="text-center">읽음</th>
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
							<%-- 본문 행: 클릭하면 아래 미리보기 행이 열림/닫힘 --%>
							<tr style="cursor: pointer;" onclick="togglePreview(${msg.msgId})">
								<td class="text-center">
									<%-- 안읽음이면 붉은 배지, 읽음이면 회색 배지 --%>
									<c:choose>
										<c:when test="${msg.isRead == 'N'}">
											<span class="badge bg-danger">안읽음</span>
										</c:when>
										<c:otherwise>
											<span class="badge bg-secondary">읽음</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${type == 'sent'}">${msg.receiverName}</c:when>
										<c:otherwise>${msg.senderName}</c:otherwise>
									</c:choose>
								</td>
								<td class="${msg.isRead == 'N' ? 'fw-bold' : ''}">
									${msg.title}
									<%-- 첨부파일이 있으면 클립 이모지 표시 --%>
									<c:if test="${msg.attachCnt > 0}">📎</c:if>
								</td>
								<td class="text-center"><fmt:formatDate
										value="${msg.sentAt}" pattern="yyyy.MM.dd HH:mm" /></td>
							</tr>
							<%-- 미리보기 행: 평소엔 숨김. 본문 내용 일부 + 자세히 보기 버튼 --%>
							<tr id="preview-${msg.msgId}" style="display:none;" class="table-light">
								<td colspan="4">
									<div class="p-2 text-muted" style="white-space:pre-line;">
										<c:choose>
											<c:when test="${fn:length(msg.content) > 120}">
												<c:out value="${fn:substring(msg.content, 0, 120)}"/>...
											</c:when>
											<c:otherwise>
												<c:out value="${msg.content}"/>
											</c:otherwise>
										</c:choose>
									</div>
									<div class="text-end">
										<a href="${pageContext.request.contextPath}/message/detail.do?msgId=${msg.msgId}&type=${type}"
										   class="btn btn-sm" style="background:#F96167;color:white;">
											자세히 보기
										</a>
									</div>
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
			<li class="page-item ${page <= 1 ? 'disabled' : ''}">
				<a class="page-link" href="?type=${type}&page=${page - 1}">이전</a>
			</li>
			<c:forEach var="p" begin="1" end="${totalPages}">
				<li class="page-item ${p == page ? 'active' : ''}">
					<a class="page-link" href="?type=${type}&page=${p}">${p}</a>
				</li>
			</c:forEach>
			<li class="page-item ${page >= totalPages ? 'disabled' : ''}">
				<a class="page-link" href="?type=${type}&page=${page + 1}">다음</a>
			</li>
		</ul>
	</nav>
</c:if>

<script>
	// 쪽지 행 클릭 시 미리보기 행을 토글(열기/닫기)
	function togglePreview(msgId) {
		var row = document.getElementById('preview-' + msgId);
		if (row.style.display === 'none') {
			row.style.display = 'table-row';
		} else {
			row.style.display = 'none';
		}
	}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp"%>
