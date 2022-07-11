package org.radi.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {

	private int pageNum; // 페이지 번호
	private int amount; // 한페이지당 출력할 게시글 수
	
	private String type; // 검색어 종류
	private String keyword; // 키워드
	
	public Criteria() {
		this(1, 10);
	}
	
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	public String[] getTypeArr() {
		
		return type == null ? new String[] {} : type.split("");
	}
	
	public String getListLink() {
		
		// 여러 개의 파라미터들을 연결해서 URL 형태로 만들어줌
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", this.pageNum)
				.queryParam("amount", this.getAmount())
				.queryParam("amount", this.getType())
				.queryParam("amount", this.getKeyword());
		
		return builder.toUriString();
	}
}
