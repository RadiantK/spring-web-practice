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
