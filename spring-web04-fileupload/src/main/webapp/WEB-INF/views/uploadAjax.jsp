<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ajax업로드</title>
<style>
	.uploadResult {
		width: 100%;
		background-color: gray;
	}
	
	.uploadResult ul {
		display: flex;
		flew-flow: row;
		justify-content: center;
		align-items: center;
	}
	
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
		align-center: center;
		text-align: center;
	}
	.uploadResult ul li img {
		width: 100px;
	}
	.uploadResult ul li span {
		color: #fff;
	}
	
	.bigPictureWrapper {
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top: 0;
		width: 100%;
		height: 100%;
		background-color: gray;
		z-index: 100;
		background: rgba(255,255,255,0.5); 
	}
	.bigPicture {
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	
	.bigPicture img {
		width: 600px;
	}
</style>
</head>
<body>
	<h1>Upload With Ajax</h1>
	
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple />
	</div>
	<div class="uploadResult">
		<ul></ul>
	</div>
	
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		</div>
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
			console.log(formData);
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
		
		// 파일 출력 및 다운로드
		function showUploadedFile(uploadResultArr) {
			
			let str = "";
			
			$(uploadResultArr).each(function(idx, obj) {
				
				if(!obj.image) {
					let fileCallPath = encodeURIComponent(
							obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
					console.log(fileCallPath);
					
					str += "<li><div><a href='/download?fileName="+fileCallPath+"'>" + 
					"<img src='/resources/img/attach.png'>"+obj.fileName+"</a>" +
					"<span data-file=\'"+fileCallPath+"\' data-type='file'> X </span>" + 
					"</div></li>";
							
				} else {
					// str += "<li>" + obj.fileName + "</li>";
					
					let fileCallPath = encodeURIComponent(
							obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
					console.log(fileCallPath);
					
					let originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
					
					originPath = originPath.replace(new RegExp(/\\/g), "/");
					
					str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\">" +
					"<img src='/display?fileName="+fileCallPath+"'></a>" + 
					"<span data-file=\'"+fileCallPath+"\' data-type='image'> X </span></li>";
				}
				
			});
			
			uploadResult.append(str);
		}
		
		// 파일 삭제
		$('.uploadResult').on('click', 'span', function(e) {
			
			let targetFile = $(this).data('file');
			let type = $(this).data('type');
			console.log(targetFile);
			
			$.ajax({
				url: '/deleteFile',
				data: {
					fileName: targetFile,
					type: type
				},
				dataType: 'text',
				type: 'post',
				success: function(result){
					alert(result);
				}
			});
		});
		
	});
	// 이미지파일 섬네일 보여주기
	function showImage(fileCallPath) {
		// alert(fileCallPath);
		
		$('.bigPictureWrapper').css('display', 'flex').show();
		
		$('.bigPicture')
		.html("<img src='/display?fileName="+encodeURI(fileCallPath)+"'>")
		.animate({width: '100%', height: '100%'}, 1000);
	}
	
	// 섬네일 숨기기
	$(".bigPictureWrapper").on('click', function(e){
		$(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
		setTimeout(function() {
			$('bigPictureWrapper').hide();
		}, 1000);
	});
	
	
</script>
</body>
</html>