<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="일정관리"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- FullCalendar JS (v6 글로벌 번들 — CSS 가 JS 안에 포함되어 별도 CSS 불필요) -->
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>

<!-- 페이지 타이틀 + 일정추가 버튼 -->
<div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="fw-bold mb-0">일정관리</h4>
    <button type="button" class="btn btn-sm"
            style="background-color:#F96167; color:white;"
            onclick="openInsertModal('')">
        일정추가
    </button>
</div>

<!-- 캘린더 영역 -->
<div class="card border-0 shadow-sm">
    <div class="card-body">
        <div id="calendar"></div>
    </div>
</div>

<!-- 날짜 클릭 시 해당 날짜 일정 목록 표시 영역 -->
<div id="dateScheduleArea" class="card border-0 shadow-sm mt-3" style="display:none;">
    <div class="card-body">
        <h6 class="fw-bold" id="dateScheduleTitle"></h6>
        <!-- 일정 목록 테이블 (시간 · 제목 · 작성자 · 구분) -->
        <table class="table table-hover mb-0" id="dateScheduleTable">
            <thead class="table-light">
                <tr>
                    <th style="width:15%">시간</th>
                    <th>제목</th>
                    <th style="width:15%">작성자</th>
                    <th style="width:10%">구분</th>
                </tr>
            </thead>
            <tbody id="dateScheduleBody"></tbody>
        </table>
    </div>
</div>

<!-- ===================== 등록/수정 모달 ===================== -->
<div class="modal fade" id="scheduleModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="scheduleModalTitle">일정 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- 수정 시 scheduleId hidden으로 전달 -->
                <input type="hidden" id="modalScheduleId"/>

                <div class="mb-3">
                    <label class="form-label fw-bold">제목</label>
                    <input type="text" id="modalTitle" class="form-control" placeholder="일정 제목 입력"/>
                </div>

                <!-- datetime-local: 날짜 + 시간 함께 입력 -->
                <div class="mb-3">
                    <label class="form-label fw-bold">시작일시</label>
                    <input type="datetime-local" id="modalStart" class="form-control"/>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">종료일시</label>
                    <input type="datetime-local" id="modalEnd" class="form-control"/>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">구분</label>
                    <select id="modalType" class="form-select">
                        <!-- 개인 일정: 본인만 보임 -->
                        <option value="PERSONAL">개인</option>
                        <!-- 팀 일정: 같은 팀원 모두 보임 -->
                        <option value="TEAM">팀</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">색상</label>
                    <input type="color" id="modalColor" class="form-control form-control-color" value="#3788d8"/>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-sm"
                        style="background-color:#F96167; color:white;"
                        onclick="submitSchedule()">저장</button>
            </div>
        </div>
    </div>
</div>

<!-- ===================== 상세/삭제 모달 ===================== -->
<div class="modal fade" id="scheduleDetailModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">일정 상세</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p><strong>제목:</strong> <span id="detailTitle"></span></p>
                <p><strong>시작:</strong> <span id="detailStart"></span></p>
                <p><strong>종료:</strong> <span id="detailEnd"></span></p>
                <p><strong>작성자:</strong> <span id="detailWriter"></span></p>
                <p><strong>구분:</strong> <span id="detailType"></span></p>
            </div>
            <div class="modal-footer">
                <!-- 삭제 버튼 -->
                <button type="button" class="btn btn-danger btn-sm"
                        onclick="deleteSchedule()">삭제</button>
                <!-- 수정 버튼 → 등록/수정 모달로 전환 -->
                <button type="button" class="btn btn-sm"
                        style="background-color:#1E293B; color:white;"
                        onclick="openUpdateModal()">수정</button>
                <button type="button" class="btn btn-secondary btn-sm"
                        data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<script>
// 현재 클릭한 일정 정보 저장용 전역 변수
// → 상세 모달에서 수정/삭제 버튼 클릭 시 이 변수에서 scheduleId 꺼내 씀
var currentEvent = null;

// ─────────────────────────────────────────
// 날짜·시간 포맷 유틸 함수
// "2026-07-01T14:30:00" → "2026-07-01 14:30"
// ─────────────────────────────────────────
function formatDateTime(str) {
    if (!str) return '-';
    return str.substring(0, 16).replace('T', ' ');
}

// "2026-07-01T14:30:00" → "14:30"
function formatTime(str) {
    if (!str) return '';
    return str.substring(11, 16);
}

// "2026-07-01T14:30:00" → "2026-07-01T14:30" (datetime-local input 용)
function toInputValue(str) {
    if (!str) return '';
    return str.substring(0, 16);
}

document.addEventListener('DOMContentLoaded', function() {

    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ko',
        height: 650,
        // 월간 뷰에서도 시간 표시
        displayEventTime: true,
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek'
        },

        // 날짜 클릭 → 하단에 해당 날짜 일정 목록 표시
        dateClick: function(info) {
            showDateSchedule(info.dateStr, calendar);
        },

        // 일정 클릭 → 상세 모달 띄우기
        eventClick: function(info) {
            currentEvent = info.event;
            openDetailModal(info.event);
        },

        // 서버에서 JSON 배열로 일정 데이터를 가져옴
        events: '${pageContext.request.contextPath}/schedule/list.do'
    });

    calendar.render();

    // calendar 변수를 전역으로 노출 → 모달에서 캘린더 갱신 시 사용
    window._calendar = calendar;
});

// ─────────────────────────────────────────
// 등록 모달 열기
// dateStr: 날짜 클릭 시 넘어온 날짜 (없으면 빈 값)
// ─────────────────────────────────────────
function openInsertModal(dateStr) {
    document.getElementById('scheduleModalTitle').innerText = '일정 등록';
    document.getElementById('modalScheduleId').value = '';
    document.getElementById('modalTitle').value = '';
    // datetime-local 은 "YYYY-MM-DDTHH:mm" 형식 필요
    // 날짜만 넘어오면 기본 시간 09:00 세팅
    var defaultStart = dateStr ? dateStr + 'T09:00' : '';
    var defaultEnd   = dateStr ? dateStr + 'T18:00' : '';
    document.getElementById('modalStart').value = defaultStart;
    document.getElementById('modalEnd').value = defaultEnd;
    document.getElementById('modalType').value = 'PERSONAL';
    document.getElementById('modalColor').value = '#3788d8';

    var modal = new bootstrap.Modal(document.getElementById('scheduleModal'));
    modal.show();
}

// ─────────────────────────────────────────
// 상세 모달 열기
// ─────────────────────────────────────────
function openDetailModal(event) {
    document.getElementById('detailTitle').innerText = event.title;
    // 날짜+시간을 보기 좋게 포맷 ("2026-07-01 14:30")
    document.getElementById('detailStart').innerText = formatDateTime(event.startStr);
    document.getElementById('detailEnd').innerText   = formatDateTime(event.endStr || event.startStr);
    // 작성자 이름 (서버에서 writerName 으로 내려옴 → extendedProps 에 들어감)
    document.getElementById('detailWriter').innerText = event.extendedProps.writerName || '';
    document.getElementById('detailType').innerText  = event.extendedProps.type === 'TEAM' ? '팀' : '개인';

    var modal = new bootstrap.Modal(document.getElementById('scheduleDetailModal'));
    modal.show();
}

// ─────────────────────────────────────────
// 수정 모달 열기 (상세 모달 → 수정 모달 전환)
// ─────────────────────────────────────────
function openUpdateModal() {
    // 상세 모달 닫기
    bootstrap.Modal.getInstance(document.getElementById('scheduleDetailModal')).hide();

    document.getElementById('scheduleModalTitle').innerText = '일정 수정';
    document.getElementById('modalScheduleId').value = currentEvent.id;
    document.getElementById('modalTitle').value = currentEvent.title;
    // datetime-local input 에 "YYYY-MM-DDTHH:mm" 형식으로 세팅
    document.getElementById('modalStart').value = toInputValue(currentEvent.startStr);
    document.getElementById('modalEnd').value   = toInputValue(currentEvent.endStr || currentEvent.startStr);
    document.getElementById('modalType').value  = currentEvent.extendedProps.type || 'PERSONAL';
    document.getElementById('modalColor').value = currentEvent.backgroundColor || '#3788d8';

    var modal = new bootstrap.Modal(document.getElementById('scheduleModal'));
    modal.show();
}

// ─────────────────────────────────────────
// 등록/수정 저장 처리
// scheduleId 가 있으면 수정, 없으면 등록
// ─────────────────────────────────────────
function submitSchedule() {
    var scheduleId = document.getElementById('modalScheduleId').value;
    var title      = document.getElementById('modalTitle').value;
    var start      = document.getElementById('modalStart').value;
    var end        = document.getElementById('modalEnd').value;
    var type       = document.getElementById('modalType').value;
    var color      = document.getElementById('modalColor').value;

    if (!title) {
        alert('제목을 입력해주세요.');
        return;
    }
    if (!start) {
        alert('시작일시를 입력해주세요.');
        return;
    }

    // scheduleId 있으면 수정, 없으면 등록
    var url = scheduleId
        ? '${pageContext.request.contextPath}/schedule/update.do'
        : '${pageContext.request.contextPath}/schedule/insert.do';

    // 전송할 파라미터 구성
    var params = {
        title   : title,
        startDt : start,   // "2026-07-01T14:30" 형식 그대로 전송
        endDt   : end,
        type    : type,
        color   : color
    };
    // 수정일 때만 scheduleId 포함 (등록 시 빈 문자열 전송 방지)
    if (scheduleId) {
        params.scheduleId = scheduleId;
    }

    fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams(params)
    })
    .then(response => response.text())
    .then(result => {
        if (result === 'success') {
            bootstrap.Modal.getInstance(document.getElementById('scheduleModal')).hide();
            // 캘린더 일정 새로고침 (페이지 새로고침 없이)
            window._calendar.refetchEvents();
        } else {
            alert('저장 실패. 다시 시도해주세요.');
        }
    })
    .catch(error => {
        console.error('오류:', error);
        alert('오류가 발생했습니다.');
    });
}

// ─────────────────────────────────────────
// 일정 삭제
// ─────────────────────────────────────────
function deleteSchedule() {
    if (!confirm('일정을 삭제하시겠습니까?')) return;

    fetch('${pageContext.request.contextPath}/schedule/delete.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ scheduleId: currentEvent.id })
    })
    .then(response => response.text())
    .then(result => {
        if (result === 'success') {
            bootstrap.Modal.getInstance(document.getElementById('scheduleDetailModal')).hide();
            window._calendar.refetchEvents();
        } else {
            alert('삭제 실패.');
        }
    });
}

// ─────────────────────────────────────────
// 날짜 클릭 시 하단에 해당 날짜 일정 목록 표시
// 시간 · 제목 · 작성자 · 구분 컬럼으로 표시
// ─────────────────────────────────────────
function showDateSchedule(dateStr, calendar) {
    // FullCalendar 에서 해당 날짜의 이벤트 필터링
    // startStr 이 "2026-07-01T14:30:00" 형식이므로 앞 10자리(날짜)만 비교
    var events = calendar.getEvents().filter(function(e) {
        var eventStartDate = e.startStr.substring(0, 10);
        var eventEndDate   = e.endStr ? e.endStr.substring(0, 10) : eventStartDate;
        return eventStartDate <= dateStr && eventEndDate >= dateStr;
    });

    var area  = document.getElementById('dateScheduleArea');
    var title = document.getElementById('dateScheduleTitle');
    var tbody = document.getElementById('dateScheduleBody');

    title.innerText = dateStr + ' 일정 목록';
    tbody.innerHTML = '';

    if (events.length === 0) {
        tbody.innerHTML =
            '<tr><td colspan="4" class="text-center text-muted">등록된 일정이 없습니다.</td></tr>';
    } else {
        events.forEach(function(e) {
            var tr = document.createElement('tr');
            // 시간 (HH:mm)
            var startTime = formatTime(e.startStr);
            var endTime   = formatTime(e.endStr);
            var timeStr   = startTime + (endTime ? ' ~ ' + endTime : '');
            // 구분 배지
            var typeBadge = e.extendedProps.type === 'TEAM'
                ? '<span class="badge bg-primary">팀</span>'
                : '<span class="badge bg-success">개인</span>';

            tr.innerHTML =
                '<td>' + timeStr + '</td>' +
                '<td><span style="color:' + e.backgroundColor + '">● </span>' + e.title + '</td>' +
                '<td>' + (e.extendedProps.writerName || '') + '</td>' +
                '<td>' + typeBadge + '</td>';
            tbody.appendChild(tr);
        });
    }

    area.style.display = 'block';
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
