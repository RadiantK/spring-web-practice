-- mysql용
CREATE TABLE  tbl_board (
	bno INT(10),
    title VARCHAR(200) NOT NULL,
    content VARCHAR(2000) not null,
    writer varchar(50) not null,
    regdate DATETIME default now(),
    updatedate DATETIME default now()
);

ALTER TABLE tbl_board add constraint pk_board primary key (bno);

alter table tbl_board MODIFY bno INT(10) NOT NULL auto_increment;


-- 오라클용

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