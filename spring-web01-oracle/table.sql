-- 오라클용

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