package org.radi.controlle;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.radi.domain.BoardAttachVO;
import org.radi.domain.BoardVO;
import org.radi.domain.Criteria;
import org.radi.domain.PageDTO;
import org.radi.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {

	@Autowired
	private BoardService service;
	
	// 전체 게시글 출력
	@GetMapping("/list")
	public void list(Criteria cri,Model model) {
		
		log.info("list: " + cri);
		
		model.addAttribute("list", service.getList(cri));
		//model.addAttribute("pageMaker", new PageDTO(cri, 123));
		
		int total = service.getTotal(cri);
		
		log.info("total: " + total);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	// 게시글 등록페이지 이동
	@GetMapping("/register")
	public void register() {
		
	}
	
	// 게시글 등록
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		
		log.info("===================================");
		log.info("register: " + board);
		
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.info(attach));
		}
		log.info("===================================");
		
		service.register(board);
		// 화면에 한 번만 사용하고 다음에는 사용되지 않는 데이터를 전달하기 위해서 사용
		rttr.addFlashAttribute("result", board.getBno());
		
		return "redirect:/board/list";
	}
	
	// 상세 페이지
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("bno") Long bno, 
			@ModelAttribute("cri") Criteria cri,Model model) {
		
		log.info("/get or modify");
		model.addAttribute("board", service.get(bno));
	}
	
	// 첨부파일 처리(ajax)
	@ResponseBody
	@GetMapping(value = "/getAttachList",
			produces = {MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {
	
		log.info("getAttachList " + bno);
		
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	// 게시글 수정
	@PostMapping("/modify")
	public String modify(BoardVO board,
			@ModelAttribute("cri") Criteria cri ,RedirectAttributes rttr) {
		log.info("modify: " + board);
		
		if(service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		
//		rttr.addAttribute("pageNum", cri.getPageNum());
//		rttr.addAttribute("amount", cri.getAmount());
//		rttr.addAttribute("type", cri.getType());
//		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list" + cri.getListLink();
	}
	
	// 게시글 제거
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno,
			@ModelAttribute("cri") Criteria cri,RedirectAttributes rttr) {
		log.info("remove....." + bno);
		
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if(service.remove(bno)) {
			// 첨부파일 제거
			deleteFiles(attachList);
			
			rttr.addFlashAttribute("result", "success");
		}
		
//		rttr.addAttribute("pageNum", cri.getPageNum());
//		rttr.addAttribute("amount", cri.getAmount());
//		rttr.addAttribute("type", cri.getType());
//		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list" + cri.getListLink();
	}
	
	// 파일 삭제 처리
	private void deleteFiles(List<BoardAttachVO> attachList) {
		
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		log.info("delete attach files.................");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			try {
				// 절대 경로 정의
				Path file = Paths.get(
						"D:\\upload\\"+attach.getUploadPath() + 
						"\\" + attach.getUuid() + "_" + attach.getFileName());
				
				Files.deleteIfExists(file); // 파일이 있으면 제거
				
				// 이미지 파일이면 섬네일 제거
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get(
							"D:\\upload\\" + attach.getUploadPath() + "\\s_" + 
							attach.getUuid() + "_" + attach.getFileName());
					
					Files.delete(thumbNail);
				}
			}catch(Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		});
	}
}
