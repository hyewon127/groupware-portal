<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="공지사항" />
<%@ include file="/WEB-INF/views/common/header.jsp"%>

<div class="d-flex justify-content-between align-items-center mb-3">
	<h4 class="fw-bold mb-0">쪽지 작성</h4>
</div>

<div class="card border-0 shadow-sm">
	<div class="card-body">

		<!-- 등록 폼 -->
		<form action="${pageContext.request.contextPath}/message/write.do"
			method="post" enctype="multipart/form-data">

			<!-- 수정/답장 시 msgId -->
		    <c:if test="${not empty message}">
		        <input type="hidden"
		               name="msgId"
		               value="${message.msgId}">
		    </c:if>
			<!--  쪽지 제목 -->
			<div class="mb-3">
				
				<label class="form-label fw-bold">제목</label>
				
				<input type="text"
			       name="title"
			       class="form-control"
			       value="${message.title}">
			</div>
			<!--  쪽지 받는사람 -->
			<div class="mb-3 position-relative">

			    <label class="form-label fw-bold">받는사람</label>
				<!-- 일반 작성은 (직접 입력->자동완성) 답장은(발신자 자동입력) -->
			   <input type="text"
			       id="receiverName"
			       class="form-control"
			       value="${empty message ? '' : message.receiverName}"
			       autocomplete="off"
			       <c:if test="${reply}">readonly</c:if>>
				<!-- 실제 DB 저장(일반/답장) -->
				<input type="hidden"
			       id="receiverId"
			       name="receiverId"
			       value="${message.receiverId}">
			     <!-- 자동완성 목록 -->
		        <ul id="userSearchResult"
		            class="list-group position-absolute w-100"
		            style="top:100%;
		                   left:0;
		                   z-index:9999;
		                   background:white;">
		        </ul>
			
			</div>
			<!--  쪽지 내용 -->
			<div class="mb-3">
				<label class="form-label fw-bold">내용</label>
				<textarea name="content" class="form-control" rows="15"
					placeholder="내용을 입력하세요" required>${message.content}</textarea>
			</div>
			<!-- 쪽지 버튼 -->
			<div class="d-flex gap-2 justify-content-end">
				<a href="${pageContext.request.contextPath}/message/list.do"
					class="btn btn-secondary">취소</a>
				<button type="submit" class="btn"
					style="background-color: #F96167; color: white;">발송</button>
			</div>
		</form>

	</div>
</div>
<script>
$(function(){

    // 답장 화면일 경우 자동 완성 기능 x
    if($("#receiverName").prop("readonly")){
        return;
    }
	// 이름 자동완성 기능
    $("#receiverName").on("keyup", function(){

        var keyword=$(this).val();

        if(keyword.length<1){

            $("#userSearchResult").empty();

            return;
        }

        $.ajax({

            url:"${pageContext.request.contextPath}/message/searchReceiver.do",

            type:"GET",

            data:{
                userName:keyword
            },

            success:function(list){

                $("#userSearchResult").empty();

                $.each(list,function(i,user){

                    $("#userSearchResult").append(

                        '<li class="list-group-item" data-id="'+user.userId+'">'
                        +user.userName+
                        '</li>'

                    );

                });

            }

        });

    });

    // 자동완성 목록 클릭 선택
    $(document).on("click","#userSearchResult li",function(){

        $("#receiverName").val($(this).text());

        $("#receiverId").val($(this).data("id"));

        $("#userSearchResult").empty();

    });

});
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp"%>