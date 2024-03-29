<%@ page contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>

<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<script src="//code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>

<!-- Modal -->
<div class="modal fade" id ="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label>
					<input class="form-control" name='reply' value='New Reply!!!!'>
				</div>
				<div class="form-group">
					<label>Replyer</label>
					<input class="form-control" name='replyer' value='replyer' readonly = 'readonly'>
				</div>
<!-- 				<div class="form-group"> -->
<!-- 					<label>Date</label> -->
<!-- 					<input class="form-control" name='reply' value=''> -->
<!-- 				</div> -->
			</div>
			<div class="modal-footer">
				<button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
				<button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
				<button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
				<button id='modalCloseBtn' type="button" class="btn btn-default">Close</button>
			</div>
		</div> <!-- /.modal-content -->
	</div> <!-- /.modal-dialog -->
</div> <!-- /.modal -->

<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		var operForm = $("#operForm");
		
		$("button[data-oper='modify']").on("click", function(e) {
			operForm.attr("action", "/board/modify").submit();
		});
		
		$("button[data-oper='list']").on("click", function(e) {
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list")
			operForm.submit();
		});
		
		var bnoValue = '<c:out value="${board.bno}"/>';
		var replyUL = $(".chat");
		var pageNum = 1;
		var replyPageFooter = $(".panel-footer");
		
		showList(1);
		
		function showList(page) {
			replyService.getList({bno:bnoValue, page:page || 1}, function(replyCnt, list) {
				
				if(page == -1) {
					pageNum = Math.ceil(replyCnt/10.0);
					showList(pageNum);
					return;
				}
				
				var str="";
				
				if(list == null || list.length == 0) {
					replyUL.html("");	
					return;
				}
				
				for(var i= 0, len= list.length || 0; i< len; i++) {
					str +="<li class='left clearfix' data-rno='" + list[i].rno + "'>";
					str +="    <div><div class='header'><strong class='primary-font'>" + list[i].replyer+"</strong>";
					str +="        <small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small></div>";
					str +="        <p>" + list[i].reply + "</p></div></li>";
				}
				
				replyUL.html(str);
				showReplyPage(replyCnt);
			}); //end getList
		} //end showList
		
		function showReplyPage(replyCnt) {
			var endNum = Math.ceil(pageNum / 10.0) * 10;
			var startNum = endNum - 9;
			
			var prev= startNum != 1;
			var next= false;
			
			if(endNum * 10 >= replyCnt) {
				endNum = Math.ceil(replyCnt/10.0);
			}
			
			if(endNum * 10 < replyCnt) {
				next = true;
			}
			
			var str = "<ul class='pagination pull-right'>";
			
			if(prev) {
				str+= "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>"
			}
			
			for(var i= startNum; i<= endNum; i++) {
				var active = pageNum == i ? "active":"";
				str+= "<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
			}
			
			if(next) {
				str+= "li class='page-item'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>";
			}
			
			str+= "</ul></div>";
			
			replyPageFooter.html(str);
		}
		
		
		var modal = $(".modal");
		var modalInputReply = modal.find("input[name='reply']");
		var modalInputReplyer = modal.find("input[name='replyer']");
		var modalInputReplyDate = modal.find("input[name='replyDate']");
		
		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn = $("#modalRemoveBtn");
		var modalRegisterBtn = $("#modalRegisterBtn");
		var modalCloseBtn = $("#modalCloseBtn");
		
		var replyer = null;
		<sec:authorize access="isAuthenticated()">
			replyer = "<sec:authentication property='principal.username' />";
		</sec:authorize>
		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		$("#addReplyBtn").on("click", function(e) {
			modal.find("input").val("");
			modal.find("input[name='replyer']").val(replyer);
			modalInputReplyDate.closest("div").hide();
			modal.find("button[id !='modalCloseBtn']").hide();
			
			modalRegisterBtn.show();
			
			modal.modal("show");
		});
		
		$(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		});
		
		modalRegisterBtn.on("click", function(e) {
			var reply = {
					reply : modalInputReply.val(),
					replyer : modalInputReplyer.val(),
					bno : bnoValue
			};
			
			replyService.add(reply, function(result) {
				alert("댓글이 등록되었습니다.");
				
				modal.find("input").val("");
				modal.modal("hide");
				
				showList(-1);
			});
		});
		modalCloseBtn.on("click", function(e) {
			modal.modal("hide");
		});
		
		$(".chat").on("click", "li", function(e) {
			var rno = $(this).data("rno");
			replyService.get(rno, function(reply) {
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
				modal.data("rno", reply.rno);
				
				modal.find("button[id !='modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				
				$(".modal").modal("show");
			});
		});
		
		modalModBtn.on("click", function(e) {
			var originalReplyer = modalInputReplyer.val();
			
			var reply = {rno:modal.data("rno"), 
						 reply: modalInputReply.val(), 
						 replyer: originalReplyer
						};
			
			if(!replyer) {
				alert("로그인 후 수정이 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			if(replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 수정이 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			replyService.update(reply, function(result){
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		modalRemoveBtn.on("click", function(e) {
			if(!confirm("댓글을 삭제하시겠습니까?")) {return;} 
			
			var rno = modal.data("rno");
			
			console.log("rno :: " + rno);
			console.log("replyer :: " + replyer);
			
			if(!replyer) {
				alter("로그인 후 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			var originalReplyer = modalInputReplyer.val();
			console.log("originalReplyer :: " + originalReplyer);
			
			if(replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			replyService.removeReply(rno, originalReplyer, function(result) {
				alert("삭제되었습니다.");
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		replyPageFooter.on("click", "li a", function(e) {
			e.preventDefault();
			
			var targetPageNum = $(this).attr("href");
			pageNum = targetPageNum;
			
			showList(pageNum);
		});
	});
</script>


<div class="row">
	<div class="col-lg-12">
		<h1 class ="page-header">Board Read</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class = "col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading" style="margin-bottom: 15px">Board Read Page</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<div class="form-group">
					<label style="margin-left:7px">Bno</label> 
					<input class="form-control" name="bno" value='<c:out value="${board.bno}" />' readonly="readonly" style="width: 40%; margin-left:7px">
				</div>
				<div class="form-group">
					<label style="margin-left:7px">Title</label> 
					<input class="form-control" name="title" value='<c:out value="${board.title}" />' readonly="readonly" style="width: 40%; margin-left:7px">
				</div>
				<div class="form-group">
					<label style="margin-left:7px">Text area</label> 
					<textarea class="form-control" rows="3" name="content" readonly="readonly" style="width: 40%; margin-left:7px"><c:out value="${board.content}" /></textarea>
				</div>
				<div class="form-group">
					<label style="margin-left:7px">Writer</label> 
					<input class="form-control" name="writer" value='<c:out value="${board.writer}" />' readonly="readonly" style="width: 40%; margin-left:7px">
				</div>
				
				<sec:authentication property="principal" var="pinfo"/>
				<sec:authorize access="isAuthenticated()">
					<c:if test="${pinfo.username eq board.writer }">
						<button data-oper="modify" class="btn btn-info"
							onclick="location.href='/board/modify?bno=<c:out value="${board.bno}" />'" style="margin-left: 20px">Modify</button>
					</c:if>
				</sec:authorize>
				
				<button data-oper="list" class="btn btn-info"
					onclick="location.href='/board/list'" style="margin-left: 5px">List</button>
				
				<form id="operForm" action="/board/modify" method="get">
					<input type="hidden" id="bno" name="bno" value="<c:out value='${board.bno}' />" >
					<input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum}' />" >
					<input type="hidden" name="amount" value="<c:out value='${cri.amount}' />" >
					<input type="hidden" name="type" value="<c:out value='${cri.type}' />" >
					<input type="hidden" name="keyword" value="<c:out value='${cri.keyword}' />" >
					
				</form>
				
			</div>
			<!--  end panel-body -->
		</div>
		<!-- end panel -->
	</div>
	<!-- end col-log-12 -->
</div>
<!-- end row -->

<div class='row'>
	<div class='col-lg-12'>
		
		<!-- /.paenl -->
		<div class="panel panel-default">
			<!-- 
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> Reply
			</div>
			 -->
			 
			 <div class="panel-heading" style="margin-top: 45px; margin-left: 7px; margin-bottom: 20px">
			 	<i class="fa fa-comments fa-fw"></i>Reply
			 	<sec:authorize access="isAuthenticated()"> 
			 		<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
			 	</sec:authorize>
			 </div>
			  
			<!-- /.panel=heading -->
			<div class="panel-body">
				<ul class="chat" style="margin-left: 1.5rem">
				<!-- ./end ul -->
			</div>
			<!-- /.panel .chat-panel -->
			
			<div class="panel-footer" style="margin-left: 1.5rem">
			
			</div>
		</div>
	</div>
	<!--  ./ end row --> 
</div>


