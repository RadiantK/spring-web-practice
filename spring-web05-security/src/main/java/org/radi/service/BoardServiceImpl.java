package org.radi.service;

import java.util.List;

import org.radi.domain.BoardAttachVO;
import org.radi.domain.BoardVO;
import org.radi.domain.Criteria;
import org.radi.mapper.BoardAttachMapper;
import org.radi.mapper.BoardMapper;
import org.radi.mapper.ReplyMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class BoardServiceImpl implements BoardService{

	// spring 4.3이상에서 자동처리
	@Autowired
	private BoardMapper mapper;
	@Autowired
	private BoardAttachMapper attachMapper;
	@Autowired
	private ReplyMapper replyMapper;

	@Transactional
	@Override
	public void register(BoardVO board) {
		
		log.info("register......" + board);
		mapper.insertSelectKey(board);
		
		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}
		
		// 첨부파일 주입
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {
		
		log.info("get..........." + bno);
		
		return mapper.read(bno);
	}

	// 게시글 수정
	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		
		log.info("modify......." + board);
		
		attachMapper.deleteAll(board.getBno());
		// 게시글 수정 성공
		boolean modifyResult = mapper.update(board) == 1;
		
		// 첨부파일 수정
		if(modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
			
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		
		return modifyResult;
	}

	// 게시글 제거
	@Transactional
	@Override
	public boolean remove(Long bno) {
		
		log.info("remove....." + bno);
		
		attachMapper.deleteAll(bno); // 첨부파일 제거
		replyMapper.deleteAll(bno); // 댓글 제거
		
		return mapper.delete(bno) == 1;
	}

//	@Override
//	public List<BoardVO> getList() {
//		
//		log.info("getList........");
//		
//		return mapper.getList();
//	}
	
	@Override
	public List<BoardVO> getList(Criteria cri) {
		
		log.info("getList........");
		
		return mapper.getListWithPaging(cri);
	}
	
	@Override
	public int getTotal(Criteria cri) {
		
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {

		log.info("get Attach list by bno " + bno);
		
		return attachMapper.findByBno(bno);
	}
	
}
