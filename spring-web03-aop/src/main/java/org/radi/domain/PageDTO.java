package org.radi.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {

	private int startPage;
	private int endPage;
	private boolean prev, next;
	
	private int total;
	private Criteria cri;
	
	public PageDTO(Criteria cri, int total) {
		
		this.cri = cri;
		this.total = total;
		
		// 끝페이지 번호
		this.endPage = (int)(Math.ceil(cri.getPageNum() / 10.0)) * 10;
		// 시작페이지 번호
		this.startPage = this.endPage - 9;
		// 페이지의 마지막 번호
		// int realEnd = (int)(Math.ceil((total * 1.0) / cri.getAmount()));
		int realEnd = (int)(Math.ceil(total / (double)cri.getAmount()));
		
		if(endPage > realEnd) endPage = realEnd;
		
		this.prev = this.startPage > 1;
		this.next = this.endPage < realEnd;
	}
}
