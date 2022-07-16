<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Register</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<div class="panel-heading">Board Read Page</div>
			<!-- /.panel-heading -->
			<div class="panel-body">

				<div class="form-group">
					<label>Bno</label> <input class="form-control" name="bno"
						value="<c:out value='${board.bno}'/>" readonly />
				</div>

				<div class="form-group">
					<label>Title</label> <input class="form-control" name="title"
						value="<c:out value='${board.title}'/>" readonly />
				</div>

				<div class="form-group">
					<label>Text area</label>
					<textarea rows="3" class="form-control" name="content" readonly><c:out
							value="${board.content }" /></textarea>
				</div>

				<div class="form-group">
					<label>Writer</label> <input class="from-control" name="writer"
						value="<c:out value='${board.writer}'/>" readonly />
				</div>

				<button data-oper="modify" class="btn btn-default"
					onclick="location.href='/board/modify?bno=<c:out value="${board.bno}" />'">Modify</button>
				<button data-oper='list' class="btn btn-info"
					onclick="location.href='/board/list'">List</button>

				<form id="operForm" action="/board/modify" method="get">
					<input type="hidden" id="bno" name="bno"
						value="<c:out value='${board.bno }'/>" /> <input type="hidden"
						name="pageNum" value="<c:out value='${cri.pageNum}'/>" /> <input
						type="hidden" name="amount" value="<c:out value='${cri.amount}'/>" />
					<input type="hidden" name="type"
						value="<c:out value='${cri.type}' />" /> <input type="hidden"
						name="keyword" value="<c:out value='${cri.keyword}' />" />
				</form>

			</div>
			<!-- end panel body -->
		</div>
		<!-- end panel body -->
	</div>
	<!-- end panel -->
</div>
<!-- /. row -->

<div class="row">

	<div class="col-lg-12">

		<!-- /.panel -->
		<div class="panel panel-default">
			<!-- <div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> Reply
			</div> -->

			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> Reply
				<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">new
					Reply</button>
			</div>

			<!-- /.panel-heading -->
			<div class="panel-body">

				<ul class="chat">
					<!-- start reply -->
					<li class="left clearfix" data-rno="12">
						<div>
							<div class="header">
								<strong class="primary-font">user00</strong> <small
									class="pull-right text-muted">2022-02-02 12:12 </small>
							</div>
							<p>Good job!</p>
						</div>
					</li>
					<!-- end reply -->
				</ul>
				<!-- ./ end ul -->
			</div>
			<!-- /.panel .chat-panel -->
		</div>
	</div>
	<!-- ./ end row -->
</div>


<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label>
					<input class="form-control" name="reply" value="new Reply!!!" />
				</div>
				<div class="form-group">
					<label>Replyer</label>
					<input class="form-control" name="replyer" value="replyer" />
				</div>
				<div class="form-group">
					<label>Reply Date</label>
					<input class="form-control" name="replyDate" value="" />
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" id="modalModifyBtn" class="btn warning">Modify</button>
				<button type="button" id="modalRemoveBtn" class="btn btn-danger">Remove</button>
				<button type="button" id="modalRegisterBtn" class="btn btn-primary">Register</button>
				<button type="button" id="modalCloseBtn" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->


<%@ include file="../includes/footer.jsp"%>

<script src="/resources/js/reply.js"></script>

<script>
	$(document).ready(function() {

		let operForm = $('#operForm');

		$('button[data-oper="modify"]').on('click', function(e) {

			operForm.attr('action', '/board/modify').submit();
		});

		$('button[data-oper="list"]').on('click', function() {
			operForm.find('#bno').remove();
			operForm.attr('action', '/board/list');
			operForm.submit();
		});
	});

	$(document).ready(function() {
		//console.log("=============");
		//console.log("JS TEST");

		//let bnoValue = '<c:out value="${board.bno}"/>';

		// replyService add test 댓글 추가
		/* replyService.add(
			{
				reply: "JS Test",
				replyer: "tester",
				bno: bnoValue
			},
			function(result){
				alert("RESULT : " + result);
			}
		); */

		// replyService getList test 댓글 목록
		/* replyService.getList({bno: bnoValue, page: 1}, function(list){
			for(let i = 0, len = list.length || 0; i < len; i++){
				console.log(list[i]);
			}
		}); */

		// replyService delete test 댓글 삭제
		/* replyService.remove(2, function(count){
			
			console.log(count);
			
			if(count === 'success') {
				alert('REMOVED');
			}
		}, function(err) {
			alert('ERROR...');
		}); */

		//replyService update test 댓글 수정
		/* replyService.update({
			rno : 12,
			bno : bnoValue,
			reply : "Modified Reply..."
		}, function(result) {
			alert('수정 완료...');
		}); */

		// replyService get test 댓글 수정
		/* replyService.get(10, function(data){
			console.log(data);
		}); */

	});

	$(document).ready(function() {
		let bnoValue = '<c:out value="${board.bno}"/>';
		let replyUL = $('.chat');

		showList(1);

		function showList(page) {

			replyService.getList({bno : bnoValue,	page : page || 1}, function(list) {
								let str = "";
								if (list == null || list.length == 0) {
									replyUL.html("");

									return;
								}

								for (let i = 0, len = list.length || 0; i < len; i++) {
									str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
									str += "<div><div class='header'>";
									str += "<strong class='primary-font'>"+list[i].replyer+"</strong>";
									str += "<small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>"
									str += "<p>"+list[i].reply+"</p></div></li>";
								}

								replyUL.html(str);
							}); // end function
		}// end showList

		// 댓글 모달 처리
		let modal = $('.modal');
		let modalInputReply = modal.find("input[name='reply']");
		let modalInputReplyer = modal.find("input[name='replyer']");
		let modalInputReplyDate = modal.find("input[name='replyDate']");
		
		let modalModifyBtn = $('#modalModifyBtn');
		let modalRemoveBtn = $('#modalRemoveBtn');
		let modalRegisterBtn = $('#modalRegisterBtn');
		
		// 댓글 등록
		$('#addReplyBtn').on('click', function(e){
			modal.find("input").val("");
			modalInputReplyDate.closest("div").hide();
			modal.find("button[id != 'modalCloseBtn']").hide();
			
			modalRegisterBtn.show();
			
			$('.modal').modal("show");
		});
		
		// 댓글 등록버튼 처리
		modalRegisterBtn.on('click', function(e){
			
			let reply = {
					reply: modalInputReply.val(),
					replyer: modalInputReplyer.val(),
					bno: bnoValue
			};
			replyService.add(reply, function(result) {
				
				alert(result);
				
				modal.find('input').val("");
				modal.modal("hide");
				
				showList(1);
			});
		});
		
		// 특정댓글 클릭 이벤트 처리
		$('.chat').on('click', 'li', function(e){
			let rno = $(this).data('rno');
			
			replyService.get(rno, function(reply) {
				
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate))
				.prop("readonly", true);
				modal.data("rno", reply.rno);
				
				modal.find("button[id != 'modalCloseBtn']").hide();
				modalModifyBtn.show();
				modalRemoveBtn.show();
				
				$('.modal').modal('show');
			});
		});
		
		// 댓글수정 처리
		modalModifyBtn.on('click', function(){
			let reply = {
					rno: modal.data('rno'),
					reply: modalInputReply.val()
			};
			
			replyService.update(reply, function(result) {
				alert(result);
				
				modal.modal('hide');
				showList(1);
			});
		});
		
		// 댓글삭제 처리
		modalRemoveBtn.on('click', function(e) {
			let rno = modal.data('rno');
			
			replyService.remove(rno, function(result){
				alert(result);
				
				modal.modal('hide');
				showList(1);
			});
		});
	});
</script>
