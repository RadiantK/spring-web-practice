package org.radi.mapper;

import java.util.List;

import org.radi.domain.BoardAttachVO;

public interface BoardAttachMapper {

	public void insert(BoardAttachVO vo);
	
	public void delete(String uuid);
	
	public List<BoardAttachVO> findByBno(Long bno);
	
	public int deleteAll(Long bno);
}
