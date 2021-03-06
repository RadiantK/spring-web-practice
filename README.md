# spring-web-practice

## 사용환경
- eclipse IDE
- JAVA (JDK11)
- MySQL (8.0.27)

## MySQL설정
```sql
// 사용자 생성
CREATE USER 'codebook'@'localhost' identified by 'codebook';
GRANT ALL PRIVILEGES ON *.* TO 'codebook'@'localhost';
flush privileges;

CREATE DATABASE codebook;
```

## Oracle 설정
```sql
ALTER SESSION SET “_oracle_script”=true;
CREATE USER temp identified by temp;
GRANT CONNECT, RESOURCE, DBA TO temp;
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
@RestController에서는 @ResponseBody 어노테이션이 생략 가능하다.  
ResponseEntity : 데이터와 함께 HTTP헤더의 상태 메시지 등을 같이 전달하는 용도로 사용한다.
<br/>

**주요 어노테이션**
- @RestController : REST 방식으로 동작하는 컨트롤러
- @RequestBody : JSON 데이터를 원하는 타입의 객체로 변환해야 하는 경우에 주로 사용
- @ResponseBody : @Controller어노테이션을 사용할 때결과값을 응답할 때 Body에 데이터를 실어서 출력한다.
- @PathVariable : URL 경로의 일부를 파라미터로 사용할 때 이용(일반 @Controller에서도 사용 가능)


## AOP
AOP는 관점 지향 프로그래밍이라는 뜻으로 프로그래밍에 있어 핵심 로직이 아닌 공통의 관심사(부가기능)을 수행하는 방법이다.
<br/>

**AOP 용어**
- Target : 개발자가 작성한 핵심 비즈니스 로직을 갖는 객체로 어떠한 관심사(주변 로직)들과도 관계를 맺지않는 순수한 코어이다.
- Proxy : Target을 감싸고 있는 존재이다 Proxy는 내부적으로 Target객체를 호출해서 핵심 기능은 Target객체가 처리하고 부가기능을 처리한다.
- JoinPoint : Target객체가 가진 메소드로, 외부에서의 호출은 Proxy객체를 통해서 Target객체의 Joinpont를 호출하는 방식이다.
- Pointcut : 어떤 메소드에 관심사를 결합할 것인지를 결정 
<br/>

## 스프링 트랜잭션 관리
트랜잭션 : 하나의 작업으로 처리되어야 하는 여러 쿼리의 묶음(쪼개질 수 없는 하나의 작업)
<br/>

**트랜잭션(ACID 원칙)**
- **원자성(Atomicity)** : 하나의 트랜잭션은 모두 하나의 단위로 처리되어야 한다. 예로 트랜잭션이 A와 B로 구성된다면 항상 A, B의 처리 결과는 동일한 결과이어야 한다. 작업이 잘못됐을 경우 모든 것은 다시 원점으로 되돌아가야 한다.
- **일관성(Consistency)** : 트랜잭션이 성공했다면 데이터베이스의 모든 데이터는 일관성을 유지해야 한다. 트랜잭션으로 처리된 데이터와 일반 데이터 사이에는 전혀 차이가 없어야만 한다.
- **격리성(Isolation)** : 트랜잭션으로 처리되는 중간에 외부에서의 간섭은 없어야만 한다.
- **영속성(Durability)** : 트랜잭션이 성공적으로 처리되면, 그 결과는 영속적으로 보관되어야 한다.


## 스프링 시큐리티(Security)
**인증(Authentication)** : 자신을 증명하는 것. 즉, 사용자의 신원을 확인하는 절차(자신의 증명하는 자료를 제시하는 것)
**인가(Authorization)** : 식별된 사용자가 특정 리소스에 접근할 수 있는 권한을 부여하는 것
- AuthenticationManager(인증 매니저) : 인증을 담당함
- ProviderManager : 인증에 대한 처리를 AuthenticationProvider라는 타입의 객체를 이용해서 처리를 위임
- AuthenticationProvider(인증 제공자) : 실제 인증 작업을 진행. 이 때 인증된 정보에는 권한에 대한 정보를 같이 전달되는데 이 처리는 UserDetailsService와 관련됨
- UserDetailsService인터페이스 : 실제 사용자의 정보와 사용자가 가진 권한의 정보를 처리해서 다시 반환

## 스프링 표현식(SPEL: spring expression language)

hasRole([role])
현재 로그인된 사용자가 지정된 role을 가지고 있으면 true를 반환합니다. 제공된 role이 'ROLE_'로 시작하지 않으면 기본적으로 'ROLE_'를 추가합니다. 이것은 DefaultWebSecurityExpressionHandler에서 defaultRolePrefix를 수정하여 커스터마이즈할 수 있습니다.

hasAnyRole([role1,role2])
현재 로그인된 사용자가 콤마(,)로 분리하여 주어진 role들 중 하나라도 가지고 있으면 true를 반환합니다. 제공된 role이 'ROLE_'로 시작하지 않으면 기본적으로 'ROLE_'를 추가합니다. 이것은 DefaultWebSecurityExpressionHandler에서 defaultRolePrefix를 수정하여 커스터마이즈할 수 있습니다.

hasAuthority([authority])
현재 로그인된 사용자가 지정된 권한이 있으면 true를 반환합니다.

hasAnyAuthority([authority1,authority2])
현재 로그인된 사용자가 콤마(,)로 분리하여 주어진 권한들중 하나라도 가지고 있으면 true를 반환합니다.

principal
현재 사용자를 나타내는 principal 객체에 직접 접근할 수 있습니다.

authentication
SecurityContext로 부터 얻은 Authentication 객체에 직접 접근할 수 있습니다.

permitAll
항상 true로 평가 됩니다.

denyAll
항상 false로 평가 됩니다.

isAnonymous()
현재 사용자가 익명사용자(로그인 안됨) 사용자이면 true를 반환합니다.

isRememberMe()
현재 로그인된 사용자가 remember-me 사용자이면 true를 반환합니다.(로그인 정보 기억 기능에 의한 사용자)

isAuthenticated()
현재 사용자가 로그인된 사용자라면 true를 반환합니다.

isFullyAuthenticated()
로그인 정보 기억(remember-me)이 아니라 아이디/비밀번호를 입력하여 로그인 했다면 true를 반환합니다.

hasPermission(Object target, Object permission)
사용자가 주어진 권한으로 제공된 대상에 액세스 할 수 있으면 true 를 반환합니다. 예, hasPermission(domainObject, 'read')

hasPermission(Object targetId, String targetType, Object permission)
사용자가 주어진 권한으로 제공된 대상에 액세스 할 수 있으면 true 를 반환합니다. 예, hasPermission(1, 'com.example.domain.Message', 'read')

<br/>
<br/>
<br/>

[참조] 코드로 배우는 스프링 웹 프로젝트
