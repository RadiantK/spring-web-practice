console.log("Reply Module......");

let replyService = (function(){
	
	// 댓글 추가
	function add(reply, callback, error){
		console.log("add reply.............");
		
		$.ajax({
			type : 'post',
			url : '/replies/new',
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr){
				if(callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er){
				if(error) {
					error(er);
				}
			}
		});
	}
	
	// 댓글 조회
	function getList(param, callback, error){
		let bno = param.bno;
		let page = param.page || 1;
		
		$.ajax({
			url: '/replies/pages/' + bno + "/" + page + ".json",
			type: 'get',
			dataType: 'json',
			success: function(data) {
				if(callback){
					callback(data);
				}
			},
			error: function(xhr, status, err) {
				if(error) {
					error();
				}
			}
		});
	}
	
	// 댓글 삭제
	function remove(rno, callback, error) {
		$.ajax({
			type : 'delete',
			url : '/replies/' + rno,
			success : function(deleteResult, status, xhr) {
				if(callback){
					callback(deleteResult);
				}
			},
			error : function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
	}
	
	// 전체 댓글 수정
	function update(reply, callback, error) {
		전
		console.log("RNO: " + reply.rno);
		
		$.ajax({
			type : 'put',
			url : '/replies/' + reply.rno,
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr){
				if(callback){
					callback(result);
					console.log(status);
					console.log(xhr);
				}
			},
			error : function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
	}
	
	// 특정 번호 댓글 조회
	function get(rno, callback, error) {
		
		$.get('/replies/' + rno + '.json', function(result) {
			if(callback) {
				callback(result);
			}
		}).fail(function(xhr, status, err) {
			if(error) {
				error();
			}
		});
	}
	
	return {
		add: add,
		getList : getList,
		remove : remove,
		update : update,
		get : get
	};
})();