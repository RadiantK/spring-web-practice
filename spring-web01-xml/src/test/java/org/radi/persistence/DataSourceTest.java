package org.radi.persistence;

import static org.junit.Assert.fail;

import java.sql.Connection;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

// 이 클래스를 스프링 테스트 클래스로 사용하겠다는 설정
@RunWith(SpringJUnit4ClassRunner.class)
// 어플리케이션 설정과 디스패처 서블릿의 xml설정을 디렉토리에서 가져오겠다는 어노테이션
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class DataSourceTest {

	// setter메소드 생성 시 메소드에 추가할 어노테이션을 지정
	@Setter(onMethod_ = {@Autowired})
	private DataSource dataSource;
	
	@Setter(onMethod_ = {@Autowired})
	private SqlSessionFactory sqlSessionFactory;
	
	@Test
	public void testConnection() {
		try(SqlSession session = sqlSessionFactory.openSession();
				Connection con = dataSource.getConnection()) {
			log.info(con);
			log.info(session);
		}catch(Exception e) {
			fail(e.getMessage());
		}
	}
}
