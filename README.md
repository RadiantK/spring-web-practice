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
config : 프로젝트와 관련딘 설정 클래스들의 보관 패키지
controller : 스프링 MVC의 Controller들의 보관 패키지
service : 스프링 Service 인터페이스와 구현 클래스 패키지
domain : VO, DTO 클래스들의 패키지
persistence : MyBatis Mapper 인터페이스 패키지
exception : 웹 관련 예외처리 패키지
aop : 스프링 AOP 관련 패키지
security : 스프링 Security 관련 패키지
util : 각종 유틸리티 클래스 관련 패지키


[참조] 코드로 배우는 스프링 웹 프로젝트
