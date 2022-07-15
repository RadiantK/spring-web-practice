package org.radi.service;

import java.util.List;

import org.radi.domain.Criteria;
import org.radi.domain.ReplyVO;

public interface ReplyService {

	int register(ReplyVO vo);
	
	ReplyVO get(Long rno);
	
	int modify(ReplyVO vo);
	
	int remove(Long rno);
	
	List<ReplyVO> getList(Criteria cri, Long bno);
}
