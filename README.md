# spring-web-practice

## 사용환경
- eclipse IDE
- JAVA (JDK11)
- MySQL (8.0.27)

## mysql설정
```sql
// 사용자 생성
CREATE USER 'codebook'@'localhost' identified by 'codebook';
GRANT ALL PRIVILEGES ON *.* TO 'codebook'@'localhost';
flush privileges;

CREATE DATABASE codebook;
```
## 프로젝트 패키지 구성
프로젝트의 패키지 관련 Naming Convention(패키지명에 대한 규칙) 입니다.
- config : 프로젝트와 관련딘 설정 클래스들의 보관 패키지
- controller : 스프링 MVC의 Controller들의 보관 패키지
- service : 스프링 Service 인터페이스와 구현 클래스 패키지
- domain : VO, DTO 클래스들의 패키지
- persistence : MyBatis Mapper 인터페이스 패키지
- exception : 웹 관련 예외처리 패키지
- aop : 스프링 AOP 관련 패키지
- security : 스프링 Security 관련 패키지
- util : 각종 유틸리티 클래스 관련 패지키

## @RestController
@Controller는 View로 전달할 데이터를 Model 객체로 담아보낼 때 사용하게 되는데 @RestController 어노테이션을 사용하면 데이터 자체를 전달하게 된다.  
출력하는 데이터의 방식은 XML 및 JSON을 주로 사용하며 요즘은 JSON을 주로 사용한다.  
@GetMapping어노테이션이나 @PostMapping어노테이션을 사용할 때 produces 속성의 MediaType의 static메소드를 사용해서 출력할 방식을 정할 수 있다.  
@Controller 어노테이션으로 출력값을 model객체가 아닌 데이터 자체를 전달하려면 @ResponseBody어노테이션을 사용해야한다.  
- @RestController : REST 방식으로 동작하는 컨트롤러
- @ResponseBody : 결과값을 응답할 때 Body에 실어서 데이터 자체를 

<br/>
<br/>
<br/>

[참조] 코드로 배우는 스프링 웹 프로젝트
