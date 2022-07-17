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