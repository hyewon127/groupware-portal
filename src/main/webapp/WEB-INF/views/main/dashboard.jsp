<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="대시보드"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- 페이지 제목 -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold mb-0">메인 대시보드</h4>
    <span class="text-muted small">${sessionScope.loginUser.userName} 님, 환영합니다.</span>
</div>

<!-- ===================== 통계 카드 4개 ===================== -->
<%-- 각 카드는 해당 패키지 목록 화면으로 이동(연동). 숫자는 컨트롤러에서 내려준 실시간 값 --%>
<div class="row g-3 mb-4">
    <!-- 카드1: 안 읽은 공지 -->
    <div class="col-md-3">
        <a href="${pageContext.request.contextPath}/notice/list.do" class="text-decoration-none text-dark">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body">
                    <div class="text-muted small mb-1"><i class="bi bi-megaphone"></i> 안 읽은 공지</div>
                    <div class="fw-bold fs-4">${unreadNoticeCnt}건</div>
                    <div class="text-muted small">아직 확인하지 않은 공지</div>
                </div>
            </div>
        </a>
    </div>
    <!-- 카드2: 새 쪽지 -->
    <div class="col-md-3">
        <a href="${pageContext.request.contextPath}/message/list.do?type=received" class="text-decoration-none text-dark">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body">
                    <div class="text-muted small mb-1"><i class="bi bi-envelope"></i> 새 쪽지</div>
                    <div class="fw-bold fs-4">${unreadMessageCnt}건</div>
                    <div class="text-muted small">읽지 않은 쪽지</div>
                </div>
            </div>
        </a>
    </div>
    <!-- 카드3: 오늘 일정 -->
    <div class="col-md-3">
        <a href="${pageContext.request.contextPath}/schedule/calendar.do" class="text-decoration-none text-dark">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body">
                    <div class="text-muted small mb-1"><i class="bi bi-calendar3"></i> 오늘 일정</div>
                    <div class="fw-bold fs-4">${todayScheduleCnt}건</div>
                    <div class="text-muted small">오늘 진행되는 일정</div>
                </div>
            </div>
        </a>
    </div>
    <!-- 카드4: 이번 주 팀 게시글 -->
    <div class="col-md-3">
        <a href="${pageContext.request.contextPath}/board/list.do" class="text-decoration-none text-dark">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body">
                    <div class="text-muted small mb-1"><i class="bi bi-layout-text-window"></i> 팀 게시글</div>
                    <div class="fw-bold fs-4">${weekBoardCnt}건</div>
                    <div class="text-muted small">이번 주 등록</div>
                </div>
            </div>
        </a>
    </div>
</div>

<div class="row g-3">
    <!-- ===================== 최근 공지사항 ===================== -->
    <div class="col-md-7">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-white fw-bold d-flex justify-content-between align-items-center">
                <span><i class="bi bi-megaphone"></i> 최근 공지사항</span>
                <a href="${pageContext.request.contextPath}/notice/list.do"
                   class="btn btn-sm btn-outline-secondary">더보기</a>
            </div>
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>제목</th>
                            <th width="110">작성자</th>
                            <th width="110">작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- 최근 공지 목록을 반복 출력. 없으면 안내 문구 --%>
                        <c:choose>
                            <c:when test="${empty recentNoticeList}">
                                <tr>
                                    <td colspan="3" class="text-center text-muted py-4">
                                        등록된 공지사항이 없습니다.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="notice" items="${recentNoticeList}">
                                    <tr style="cursor:pointer;"
                                        onclick="location.href='${pageContext.request.contextPath}/notice/detail.do?noticeId=${notice.noticeId}'">
                                        <td>${notice.title}</td>
                                        <td>${notice.writerName}</td>
                                        <td><fmt:formatDate value="${notice.createdAt}" pattern="yyyy.MM.dd"/></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- ===================== 일정 미니뷰 ===================== -->
    <div class="col-md-5">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-header bg-white fw-bold d-flex justify-content-between align-items-center">
                <span><i class="bi bi-calendar3"></i> 다가오는 일정</span>
                <a href="${pageContext.request.contextPath}/schedule/calendar.do"
                   class="btn btn-sm btn-outline-secondary">달력</a>
            </div>
            <div class="card-body">
                <%-- 오늘 이후 다가오는 내 일정 5건. 색상 점 + 제목 + 시작일 --%>
                <c:choose>
                    <c:when test="${empty upcomingScheduleList}">
                        <div class="text-center text-muted py-4">다가오는 일정이 없습니다.</div>
                    </c:when>
                    <c:otherwise>
                        <ul class="list-group list-group-flush">
                            <c:forEach var="sch" items="${upcomingScheduleList}">
                                <li class="list-group-item d-flex align-items-center px-0">
                                    <%-- 일정 색상 표시용 점 --%>
                                    <span style="display:inline-block;width:10px;height:10px;border-radius:50%;
                                                 background:${sch.color};margin-right:10px;"></span>
                                    <span class="flex-grow-1">${sch.title}</span>
                                    <span class="text-muted small">${sch.startDt}</span>
                                    <%-- 개인/팀 구분 배지 --%>
                                    <span class="badge ${sch.type == 'TEAM' ? 'bg-primary' : 'bg-success'} ms-2">
                                        ${sch.type == 'TEAM' ? '팀' : '개인'}
                                    </span>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
