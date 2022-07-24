-- 오라클용

-- tbl_board
drop table tbl_board;
drop sequence seq_board;

CREATE TABLE  tbl_board (
	bno NUMBER(10),
    title VARCHAR2(200) NOT NULL,
    content VARCHAR2(2000) not null,
    writer varchar2(50) not null,
    regdate DATE default sysdate,
    updatedate DATE default sysdate
);

CREATE SEQUENCE seq_board;

ALTER table tbl_board add constraint pk_board primary key (bno);
ALTER table tbl_board modify bno number(10) NOT NULL;

-- tbl_reply
CREATE TABLE tbl_reply (
    rno NUMBER(10, 0),
    bno NUMBER(10, 0) not null,
    reply VARCHAR2(1000) not null,
    replyer VARCHAR2(50) not null,
    replyDate date default sysdate,
    updateDate date default sysdate
);

CREATE SEQUENCE seq_reply;

alter table tbl_reply add constraint pk_reply primary key (rno);
alter table tbl_reply add constraint fk_reply_board 
foreign key (bno) references tbl_board (bno);

-- 댓글 페이징 처리용 인덱스 생성()
CREATE INDEX idx_reply ON tbl_reply (bno DESC, rno ASC);


-- 첨부파일
CREATE TABLE tbl_attach (
	uuid varchar2(100) not null,
	uploadPath varchar2(200) not null,
	fileName varchar2(100) not null,
	filetype char(1) default 'I',
	bno number(10, 0)
);

alter table tbl_attach add constraint pk_attach primary key(uuid);

alter table tbl_attach add constraint fk_board_attach 
foreign key (bno) references tbl_board (bno);




-- 스프링 시큐리티 지정된 테이블 사용
create table users (
    username varchar2(50) not null primary key,
    password varchar2(100) not null,
    enabled char(10) default '1'
);

create table authorities (
    username varchar2(50) not null,
    authority varchar2(50) not null,
    constraint fk_authorities_users foreign key(username) references users(username)
);

create unique index ix_auth_username on authorities (username, authority);

insert into users (username, password) values('user', '1234');
insert into users (username, password) values('member', '1234');
insert into users (username, password) values('admin', '1234');

insert into authorities (username, authority) values('user', 'ROLE_USER');
insert into authorities (username, authority) values('member', 'ROLE_MANAGER');
insert into authorities (username, authority) values('admin', 'ROLE_MANAGER');
insert into authorities (username, authority) values('admin', 'ROLE_ADMIN');

delete from users;
delete from authorities;

commit;

select * from users;
select * from authorities;



-- 일반적인 회원 테이블 및 권한 테이블
create table tbl_member (
    userid varchar2(50) not null primary key,
    userpw varchar2(100) not null,
    username varchar2(100) not null,
    regdate date default sysdate, 
    updatedate date default sysdate,
    enabled char(1) default '1'
);

create table tbl_member_auth (
    userid varchar2(50) not null,
    auth varchar2(50) not null,
    constraint fk_member_auth foreign key (userid) references tbl_member (userid)
);