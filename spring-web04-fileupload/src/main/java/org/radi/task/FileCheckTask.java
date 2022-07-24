package org.radi.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.radi.domain.BoardAttachVO;
import org.radi.mapper.BoardAttachMapper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {
	
	@Setter
	private BoardAttachMapper attachMapper;

	/*
	 * 주기적인 작업 제어(특정시간 혹은 몇시간 마다 동작해야 하는 스케줄러 구현)
	 * cron : unix 운영체제에서 어떤 작업을 특정시간에 실행시키기 위한 데몬(백그라운드 프로세스)
	 * 매분 0초가 될때마다 실행
	 * (seconds(0~59), minutes(0~59), hours(0~23), day(0~31), months(1~12), dayofweek(1~7), year(optional))
	 */
//	@Scheduled(cron = "0 * * * * *")
//	public void checkFiles() throws Exception {
//		
//		log.warn("File Check Task run..............");
//		log.warn("===================================");
//	}
	
	private String getFolderYesterDay() {
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1); // 이번달의 요일 - 1
		
		String str = sdf.format(cal.getTime());
		
		return str.replace("-", File.separator);
	}
	
	// 새벽 2시에 동작
	@Scheduled(cron = "0 0 2 * * *")
	public void checkFiles() {
		
		log.warn("File Check Task run..............");
		
		log.warn(new Date());
		// file list in datebase
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		// read for check file in directory with database file list 원본 파일
		List<Path> fileListPaths = fileList.stream()
			.map(vo -> Paths.get(
				"D:\\upload", vo.getUploadPath(), vo.getUuid(), vo.getFileName()))
			.collect(Collectors.toList());
		
		// imageFile has thumnail file 섬네일 파일 
		fileList.stream().filter(vo -> vo.isFileType() == true)
		.map(vo -> Paths.get(
			"D:\\upload", vo.getUploadPath(), "s_"+vo.getUuid(), vo.getFileName()))
		.forEach(p -> fileListPaths.add(p));
		
		log.warn("===================================");
		
		fileListPaths.forEach(p-> log.warn(p));
		
		// files in yesterday directiry
		File targetDir = Paths.get("D:\\upload", getFolderYesterDay()).toFile();
		
		// db에 저장되있는 파일 목록들과 일치하지 않는 목록 읽어오기
		File[] removeFiles = targetDir.listFiles(
				file -> fileListPaths.contains(file.toPath()) == false);
		// 데이터베이스에 없는 목록들 제거
		log.warn("---------------------------------------------");
		for(File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			file.delete();
		}
		
	}
}
