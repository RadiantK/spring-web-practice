package org.radi.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.radi.domain.Criteria;
import org.radi.domain.ReplyVO;

public interface ReplyMapper {

	List<ReplyVO> getListWithPaging(
			@Param("cri") Criteria cri,
			@Param("bno") Long bno);
	
	int getCountByBno(Long bno);
	
	ReplyVO read(long rno); // 특정 댓글 읽기
	
	int insert(ReplyVO vo);
	
	int delete(Long rno);
	
	int update(ReplyVO reply);
}
