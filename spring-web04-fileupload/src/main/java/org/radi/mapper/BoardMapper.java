package org.radi.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.radi.domain.BoardVO;
import org.radi.domain.Criteria;

public interface BoardMapper {

	// @Select("SELECT * FROM tbl_board WHERE bno > 0")
	public List<BoardVO> getList();
	
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	public int getTotalCount(Criteria cri);
	// insert만 처리되고 pk는 알 필요가 없는경우
	public void insert(BoardVO board);
	// insert가 처리되고 pk를 알 필요가 있는경우
	public void insertSelectKey(BoardVO board);
	
	public BoardVO read(Long bno);
	
	public int delete(Long bno);
	
	public int update(BoardVO board);
	
	// amount : 증가나 감소를 의미 (댓글증가 +1, 댓글감소 -1)
	// MyBatis는 SQL을 처리할 때 하나의 파라미터 타입을 사용하기 때문에 2개 이상의
	// 데이터를 전달하려면 @Param 어노테이션을 사용해서 처리 가능
	public void updateReplyCnt(
			@Param("bno") Long bno, @Param("amount") int amount);
	
}
