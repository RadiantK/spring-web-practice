package org.radi.mapper;

import java.util.List;

import org.radi.domain.BoardVO;

public interface BoardMapper {

	// @Select("SELECT * FROM tbl_board WHERE bno > 0")
	public List<BoardVO> getList();
	// insert만 처리되고 pk는 알 필요가 없는경우
	public void insert(BoardVO board);
	// insert가 처리되고 pk를 알 필요가 있는경우
	public void insertSelectKey(BoardVO board);
	
	public BoardVO read(Long bno);
	
	public int delete(Long bno);
	
	public int update(BoardVO board);
}
