package org.radi.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
// Test for Controller : WebApplicationContext를 사용하기 위함(가상의 web.xml사용)
@WebAppConfiguration // 자동으로 Web과 컨트롤러에서 사용되는 Bean들을 생성하여 등록
@ContextConfiguration({
	"file:src/main/webapp/WEB-INF/spring/root-context.xml",
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
@Log4j
public class BoardControllerTest {

	@Setter(onMethod_ = {@Autowired})
	private WebApplicationContext ctx;
	
	// 가짜 mvc : 가상의 url과 파라미터등을 브라우저에서 사용하는것처럼 만듬
	private MockMvc mockMvc;
	
	@Before
	public void setup() {
		// mockMvc 생성
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
	@Test
	public void consoleTest() {
		log.info(Math.ceil(2 / 10.0));
	}
	
	@Test
	public void testList() throws Exception {

		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/list"))
				.andReturn()
				.getModelAndView()
				.getModelMap());
	}
	
	@Test
	public void testListPaging() throws Exception {
		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/list")
				.param("pageNum", "2")
				.param("amount", "50"))
				.andReturn().getModelAndView().getModelMap());
	}
	
	@Test
	public void testRegister() throws Exception {
		String resultPage = mockMvc.perform(
				MockMvcRequestBuilders.post("/board/register")
				.param("title", "테스트 새글 등록")
				.param("content", "테스트 새글 내용")
				.param("writer", "user12"))
				.andReturn().getModelAndView().getViewName();
		
		log.info(resultPage);
	}
	
	@Test
	public void testGet() throws Exception {
		
		log.info(mockMvc.perform(MockMvcRequestBuilders
				.get("/board/get")
				.param("bno", "10"))
				.andReturn()
				.getModelAndView().getModelMap());
	}
	
	@Test
	public void testModify() throws Exception {
		String resultPage = mockMvc.perform(
				MockMvcRequestBuilders.post("/board/modify")
				.param("bno", "8")
				.param("title", "수정할 제목")
				.param("content", "수정할 내용")
				.param("writer", "newuser"))
				.andReturn().getModelAndView().getViewName();
		log.info(resultPage);
	}
	
	@Test
	public void testRemove() throws Exception {
		// 삭제 전 데이터베이스에 게시물 번호 확인할 것
		String resultPage = mockMvc.perform(
				MockMvcRequestBuilders.post("/board/remove")
				.param("bno", "6"))
				.andReturn().getModelAndView().getViewName();
		
		log.info(resultPage);
	}
}
