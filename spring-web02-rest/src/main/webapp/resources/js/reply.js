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
					// callback(data); // 댓글 목록만 가져오는 경우
					callback(data.replyCnt, data.list); // 댓글 숫자와 목록을 가져오는 경우
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
	
	// 댓글 수정
	function update(reply, callback, error) {
		
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
	
	function displayTime(timeValue) {
		let today = new Date();
		//console.log(today.getTime()); // 1970/1/1 12:00 기준 경과한 밀리 초
		//console.log(timeValue);
		let gap = today.getTime() - timeValue;
		//console.log(gap);
		let dateObj = new Date(timeValue);
		let str = "";
		
		if(gap < (1000 * 60 * 60 * 24)) { // 하루 밀리초 계산
			
			let hh = dateObj.getHours();
			let min = dateObj.getMinutes();
			let ss = dateObj.getSeconds();
			
			return [ (hh > 9 ? '' : '0') + hh, ':', (min > 9 ? '' : '0') + min, ':', 
				(ss > 9 ? '' : '0') + ss].join('');
		} else {
			let yy = dateObj.getFullYear();
			let mm = dateObj.getMonth() + 1; // getMonth()는 0이 1월
			let dd = dateObj.getDate();
			
			return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/', 
				(dd > 9 ? '' : '0') + dd].join('');
		}
	}
	
	return {
		add: add,
		getList : getList,
		remove : remove,
		update : update,
		get : get,
		displayTime : displayTime
	};
})();