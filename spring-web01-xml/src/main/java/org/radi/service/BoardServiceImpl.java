package org.radi.service;

import java.util.List;

import org.radi.domain.BoardVO;
import org.radi.mapper.BoardMapper;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService{

	// spring 4.3이상에서 자동처리
	private BoardMapper mapper;

	@Override
	public void register(BoardVO board) {
		
	}

	@Override
	public BoardVO get(Long bno) {
		return null;
	}

	@Override
	public boolean modify(BoardVO board) {
		return false;
	}

	@Override
	public boolean remove(Long bno) {
		return false;
	}

	@Override
	public List<BoardVO> getList() {
		return null;
	}
}
