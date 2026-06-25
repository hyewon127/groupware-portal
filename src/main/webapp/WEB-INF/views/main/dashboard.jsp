<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="대시보드"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- 페이지 제목 -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold mb-0">메인 대시보드</h4>
</div>

<!-- 통계 카드 4개 -->
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="text-muted small mb-1">미읽은 공지</div>
                <div class="fw-bold fs-4">0건</div>
                <div class="text-muted small">최근 7일 기준</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="text-muted small mb-1">새 쪽지</div>
                <div class="fw-bold fs-4">0건</div>
                <div class="text-muted small">읽지 않은 쪽지</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="text-muted small mb-1">오늘 일정</div>
                <div class="fw-bold fs-4">0건</div>
                <div class="text-muted small">오늘 등록된 일정</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="text-muted small mb-1">팀 게시글</div>
                <div class="fw-bold fs-4">0건</div>
                <div class="text-muted small">이번 주 등록</div>
            </div>
        </div>
    </div>
</div>

<!-- 최근 공지사항 -->
<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-white fw-bold">
        최근 공지사항
    </div>
    <div class="card-body">
        <table class="table table-hover mb-0">
            <thead class="table-light">
                <tr>
                    <th>제목</th>
                    <th width="120">작성자</th>
                    <th width="120">작성일</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="3" class="text-center text-muted py-4">
                        등록된 공지사항이 없습니다.
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>