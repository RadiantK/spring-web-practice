package org.radi.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.radi.domain.AttachFileDTO;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {

	@GetMapping("/uploadForm")
	public void uploadForm() {
		
		log.info("upload form");
	}
	
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		
		String uploadFolder = "D:\\upload";
		
		for(MultipartFile multipartFile : uploadFile) {
			
			log.info("-----------------------------");
			log.info("Upload File Name: " + multipartFile.getOriginalFilename());
			log.info("Upload File Size: " + multipartFile.getSize());
			
			File saveFile = new File(
					uploadFolder, multipartFile.getOriginalFilename());
			
			try {
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		
		log.info("upload ajax");
	}
	
	@ResponseBody
	@PostMapping(value = "/uploadAjaxAction", produces = {MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		
		log.info("upload ajax post..........");
		
		List<AttachFileDTO> list = new ArrayList<>();
		String uploadFolder = "D:\\upload";
		
		String uploadFolderPath = getFolder();
		// mak Folder yyyy/MM/dd
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		log.info("upload path: " + uploadPath);
		
		if(!uploadPath.exists()) {
			uploadPath.mkdirs(); // ?????? ??????????????? ?????? ?????? ???????????? ?????? ??????
		}
		
		// ?????? ??????
		for(MultipartFile file : uploadFile) {
			
//			log.info("-----------------------------");
//			log.info("Upload File Name: " + file.getOriginalFilename());
//			log.info("Upload File Size: " + file.getSize());
			
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			String uploadFileName = file.getOriginalFilename();
			
			// IE has file path
			uploadFileName = uploadFileName.substring(
					uploadFileName.lastIndexOf("\\") + 1);
			log.info("only file name: " + uploadFileName);
			attachDTO.setFileName(uploadFileName);
			
			UUID uuid = UUID.randomUUID();
			
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			try {
				// ?????? ??????, ?????? ???
				// File saveFile = new File(uploadFolder, uploadFileName);
				File saveFile = new File(uploadPath, uploadFileName);
				file.transferTo(saveFile); // ????????????
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				// ????????? ???????????? ??????
				if(checkImageType(saveFile)) {
					
					attachDTO.setImage(true);
					
					FileOutputStream thumbnail = new FileOutputStream(
							new File(uploadPath, "s_" + uploadFileName));
					
					Thumbnailator.createThumbnail(
							file.getInputStream(), thumbnail, 100, 100);
					
					thumbnail.close();
				}
				
				//add to list
				list.add(attachDTO);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	// ?????? ????????????(????????? ??????)
	@ResponseBody
	@GetMapping("/display")
	public ResponseEntity<byte[]> getFile(String fileName) {
		
		log.info("fileName: " + fileName);
		
		File file = new File("d:\\upload\\" + fileName);
		
		log.info("file: " + file);
		
		ResponseEntity<byte[]> result = null;
		
		try {
			HttpHeaders header = new HttpHeaders();
			
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			// byte[], mime????????? ????????? ????????? ??????
			result = new ResponseEntity<>(
					FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch(IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	//???????????? ???????????? MediaType.APPLICATION_OCTET_STREAM_VALUE 8?????? ???????????? ???????????? ?????? ?????????
	@ResponseBody
	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	public ResponseEntity<Resource> downloadFile(
			@RequestHeader("User-Agent") String userAgent, // ?????? ?????? ????????????
			String fileName) {
		
		log.info("download file: " + fileName);
		// Resource : ????????? ?????? ????????? ??????????????? ?????? ???????????????
		Resource resource = new FileSystemResource("d:\\upload\\" + fileName);
		
		if(resource.exists() == false) { // ????????? ?????????
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		log.info("resource: " + resource);
		
		String resourceName = resource.getFilename(); // ?????? ????????? ????????????
		
		// remove UUID
		String resourceOriginalName = 
				resourceName.substring(resourceName.indexOf("_")+1);
		log.info("resourceOriginalName: " + resourceOriginalName);
		
		HttpHeaders headers = new HttpHeaders();
		
		try {
			String downloadName = null;
			
			if(userAgent.contains("Trident")) { // IE????????????
				log.info("IE browser");
				
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8")
						.replaceAll("\\+", " "); // +?????? ???????????? ??????
				
				log.info("Edge name: " + downloadName);
			}else if(userAgent.contains("Edge")){
				log.info("Edge browser");
				
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
			}else {
				
				log.info("Chrome browser");
				// ?????????
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
			}
			
			// content-Disposition??? HTTP ResponseBody??? ?????? ???????????? ????????? ???????????? ??????
			// ???????????? inline?????? web??? ???????????? data
			// attachment; fileName= ????????? ?????? body??? ?????? ?????? ???????????? ???????????? ?????? ???
			headers.add("Content-Disposition", "attachment; fileName=" + 
					downloadName);
		} catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	//?????? ??????
	@ResponseBody
	@PostMapping("/deleteFile")
	public ResponseEntity<String> deleteFile(String fileName, String type) {
		
		log.info("deleteFile: " + fileName);
		
		File file;
		
		try {
			file = new File("d:\\upload\\" + URLDecoder.decode(fileName, "UTF-8"));
			log.info("fileName: " + file.getName());
			file.delete();
			
			if(type.equals("image")) {
				
				// ????????? ??????
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				
				log.info("largeFileName: " + largeFileName);
				
				file = new File(largeFileName);
				
				file.delete();
			}
		}catch(UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<>("deleted", HttpStatus.OK);
	}
	
	// ?????? ????????? ?????? ??????
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date date = new Date();
		
		String str = sdf.format(date);
		
		return str.replace("-", File.separator);
	}
	
	// ????????? ?????? ??????
	private boolean checkImageType(File file) {
		
		try {
			log.info("toPath: " + file.toPath());
			// MIME ?????? ??????
			String contentType = Files.probeContentType(file.toPath());
			log.info("contentType: " + contentType);
			
			return contentType.startsWith("image");
		}catch(IOException e) {
			e.printStackTrace();
		}
		
		return false;
	}
}
