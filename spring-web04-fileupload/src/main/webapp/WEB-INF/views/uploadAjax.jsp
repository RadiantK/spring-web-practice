<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ajax업로드</title>
</head>
<body>
	<h1>Upload With Ajax</h1>
	
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple />
	</div>
	<div class="uploadResult">
		<ul></ul>
	</div>
	
	<button id="uploadBtn">Upload</button>
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	
	<script>
		$(document).ready(function(){
			
			let regexp = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			let maxSize = 5242880; // 5MB
			
			function checkExtension(fileName, fileSize) {
				
				if(fileSize >= maxSize) {
					alert("파일 사이즈 초과");
					return false;
				}
				
				if(regexp.test(fileName)){
					alert('해당 종류의 파일은 업로드할 수 없습니다.');
					return false;
				}
				
				return true;
			}
			
			let cloneObj = $(".uploadDiv").clone();
			console.log(cloneObj.html());
			
			$('#uploadBtn').on('click', function(){
				
				let formData = new FormData();
				
				let inputFile = $('input[name="uploadFile"]');
				
				let files = inputFile[0].files;
				
				console.log(files);
				
				// add File Data to formData
				for(let i = 0; i < files.length; i++) {
					
					if(!checkExtension(files[i].name, files[i].size) ) {
						return false;
					}
					
					formData.append('uploadFile', files[i]);
				}
				
				//processData: false, 문자열을 쿼리스트링으로 변환할지 선택(기본값 true)
				// 파일전송은 변환하지 않기 때문에 false
				//contentType: false, 서버로 요청을 보낼타입 (application/x-www-form-urlencoded가 기본값)
				// multipart/form-data로 전송할 것이기 때문에 false로 지정 
				$.ajax({
					url: '/uploadAjaxAction',
					processData: false, // 문자열을 쿼리스트링으로 변환할지 선택(기본값 true)
					contentType: false, // 서버로 요청을 보낼타입 (application/x-www-form-urlencoded가 기본값)
					data: formData,
					type: 'post',
					dataType: 'json',
					success: function(result){
						
						console.log(result);
						
						showUploadedFile(result);
						$(".uploadDiv").html(cloneObj.html());
					}
				});
			});
			
			let uploadResult = $('.uploadResult ul');
			
			// 파일 이름 출력
			function showUploadedFile(uploadResultArr) {
				
				let str = "";
				
				$(uploadResultArr).each(function(idx, obj) {
					
					str += "<li>" + obj.fileName + "</li>";
				});
				
				uploadResult.append(str);
			}
			
		});
	</script>
</body>
</html>