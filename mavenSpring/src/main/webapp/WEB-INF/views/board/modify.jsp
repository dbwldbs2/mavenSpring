<%@ page contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>

<script type="text/javascript">
	$(document).ready(function() {
		var formObj = $("form");
		
		$("button").on("clock", function(e) {
			e.preventDefault();
			
			var operation = $(this).data("oper");
			
			console.log("jquery :: " + operation);
			
			if(operation === 'remove') {
				formObj.attr("action", "/board/remove");
			} else if(operation === 'list') {
				formObj.attr("action", "/board/list").attr("method", "get");
				formObj.empty();
			}
			
			formObj.submit();
		});
	});
</script>

<div class="row">
	<div class="col-lg-12">
		<h1 class ="page-header">Board Modify</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class = "col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Modify Page</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<form role="form" action="/board/modify" method="post">
					<div class="form-group">
						<label>Bno</label> <input class="form-control" name="bno" value='<c:out value="${board.bno}" />' readonly="readonly">
					</div>
					
					<div class="form-group">
						<label>Title</label> <input class="form-control" name="title" value='<c:out value="${board.title}" />'>
					</div>
					
					<div class="form-group">
						<label>Text area</label> <textarea class="form-control" rows="3" name="content"><c:out value="${board.content}" /></textarea>
					</div>
					
					<div class="form-group">
						<label>Writer</label> <input class="form-control" name="writer" value='<c:out value="${board.writer}" />'>
					</div>
					
					<div class="form-group">
						<label>RegDate</label> <input class="form-control" name="regDate" value='<fmt:formatDate pattern ="yyyy/MM/dd" value ="${board.regdate}" />' readonly="readonly">
					</div>
					
					<div class="form-group">
						<label>Update Date</label> <input class="form-control" name="regDate" value='<fmt:formatDate pattern ="yyyy/MM/dd" value ="${board.updateDate}" />' readonly="readonly">
					</div>
					
					<button type ="submit" date-oper="modify" class="btn btn-default">Modify</button>
					<button type ="submit" date-oper="remove" class="btn btn-danger">Remove</button>
					<button type ="submit" date-oper="list" class="btn btn-info">List</button>
				</form>
			</div>
			<!--  end panel-body -->
		</div>
		<!-- end panel -->
	</div>
	<!-- end col-log-12 -->
</div>
<!-- end row -->