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

			<div class="panel-heading">Board Register</div>
			<!-- /.panel-heading -->
			<div class="panel-body">

				<form role="form" action="/board/register" method="post">
					<div class="form-group">
						<label>Title</label> <input class="form-control" name="title">
					</div>

					<div class="form-group">
						<label>Text area</label>
						<textarea rows="3" class="form-control" name="content"></textarea>
					</div>

					<div class="form-group">
						<label>Writer</label> <input class="from-control" name="writer" />
					</div>

					<button type="submit" class="btn btn-default">Submit
						Button</button>
					<button type="reset" class="btn btn-default">Reset Button</button>
				</form>

			</div>
			<!-- end panel body -->
		</div>
		<!-- end panel body -->
	</div>
	<!-- end panel -->
</div>
<!-- /. row -->

<!-- 파일첨부 부분 -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			
			<div class="panel-heading">File Attach</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name="uploadFile" multiple>
				</div>
				
				<div class="uploadResult">
					<ul>
					
					</ul>
				</div>
				
			</div>
			<!-- end panel-body -->
		</div>
		<!-- end panel-default -->
	</div>
	<!-- end col-lg-12 -->
</div>
<!-- end row -->
<%@ include file="../includes/footer.jsp"%>

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
</style>

<script>
	$(document).ready(function(){
		let formObj = $("form[role=form]");
		
		$("button[type='submit']").on('click', function(e){
			e.preventDefault();
			
			console.log("submit clicked");
			
			let str = "";
			$('.uploadResult ul li').each(function(idx, obj) {
				let jobj = $(obj);
				
				console.dir(jobj);
				
				str += "<input type='hidden' name='attachList["+idx+"].fileName'" + 
					"value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+idx+"].uuid'" + 
				"value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+idx+"].uploadPath'" + 
				"value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+idx+"].fileType'" + 
				"value='"+jobj.data("type")+"'>";
			});
			
			formObj.append(str).submit();
			
		});
		
		let regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		let maxSize = 5242880; // 5MB
		
		function checkExtension(fileName, fileSize) {
			if(fileSize >= maxSize) {
				alert('파일 사이즈 초과');
				return false;
			}
			
			if(regex.test(fileName)){
				alert('해당 종류의 파일은 업로드할 수 없습니다.');
				return false;
			}
			
			return true;
		}
		
		$("input[type='file']").change(function(e) {
			
			let formData = new FormData();
			
			// let inputFile = $("input[name='uploadFile']");
			let inputFile = document.getElementsByName('uploadFile');
			
			let files = inputFile[0].files;
			console.log("inputFile", inputFile);
			console.log("files", files);
			
			for(let i = 0; i< files.length; i++) {
				
				if(!checkExtension(files[i].name, files[i].size)) {
					return false;
				}
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url: '/uploadAjaxAction',
				processData: false, 
				contentType: false,
				data: formData,
				type: 'post',
				dataType: 'json',
				success: function(result) {
					console.log("result", result);
					showUploadResult(result); // 업로드 결과 처리함수
				}
			}); // end ajax
			
		});
		
		
		// 섬네일 처리
		function showUploadResult(uploadResultArr) {
			if(!uploadResultArr || uploadResultArr.length == 0) {
				return;
			}
			
			let uploadUL = $(".uploadResult ul");
			let str= "";
			
			$(uploadResultArr).each(function(idx, obj) {
				// image type
				if(obj.image) {
					let fileCallPath = encodeURIComponent(
							obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
					str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
					str += " data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>";
					str += "<span> " + obj.fileName + "</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' " +
						"data-type='image' class='btn btn-warning btn-circle'>" + 
						"<i class='fa fa-times'></i></button></br>";
					str += "<img src='/display?fileName="+fileCallPath+"'>";
					str += "</div></li>";
				}else {
					let fileCallPath = encodeURIComponent(
							obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
					let fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
					str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
					str += " data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>";
					str += "<span> " + obj.fileName + "</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' " +
						"data-type='file' class='btn btn-warning btn-circle'>" + 
						"<i class='fa fa-times'></i></button></br>";
					str += "<a><img src='/resources/img/attach.png'></a>";
					str += "</div></li>";
				}
			});
			
			uploadUL.append(str);
		} // end showUploadResult
		
		// 첨부파일 변경 처리
		$('.uploadResult').on('click', 'button', function(){
			
			console.log("delete file");
			
			let targetFile = $(this).data("file");
			let type = $(this).data('type');
			
			let targetLi = $(this).closest('li');
			
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
					targetLi.remove();
				}
				
			});
		});
		
		// 바닐라자바스크립트로 해보기
		//let uploadResultEl = document.querySelector('.uploadResult');
		/* document.querySelector('.uploadResult').addEventListener('click', function(e){
			if(e.target.type == 'button'){
				console.log("delete File");
				let target = e.target;
	 			let targetFile = target.dataset.file;
				let type = target.dataset.type;
				
				console.log(targetFile);
				console.log(type);
				
				let targetLi = target.closest('li');
			}
			
			return;
		});
 */
	});
</script>