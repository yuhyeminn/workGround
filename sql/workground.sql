--================================================
--system계정
--================================================
--workground계정 생성
create user workground identified by workground
default tablespace users;

grant connect, resource to workground;

--테스트 계정 생성
create user workgroundtest identified by workgroundtest
default tablespace users;

grant connect, resource to test;

--계정 삭제
--drop user workground cascade;
--drop user workgroundtest cascade;


--================================================
--workground계정
--================================================
--member관련 테이블/시퀀스
--================================================
--job테이블
--------------------------------------------------
create table job(
    job_code char(2) not null,
    job_title varchar2(35) not null,
    constraint pk_job primary key(job_code)
);

--------------------------------------------------
--department테이블
--------------------------------------------------
create table department(
    dept_code char(2) not null,
    dept_title varchar2(35) not null,
    constraint pk_department primary key(dept_code)
);

--------------------------------------------------
--member테이블 생성
--------------------------------------------------
create table member(
    member_id varchar2(30) not null,
    password varchar2(300),
    member_name varchar2(20) not null,
    email varchar2(25) not null,
    phone varchar2(12) not null,
    date_of_birth char(8) not null, 
    dept_code char(2) not null,
    job_code char(2) not null,
    quit_yn char(1) default 'N' not null,
    manager_id varchar2(30),
    original_filename varchar2(100),
    renamed_filename varchar2(100),
    constraint pk_member primary key(member_id),
    constraint fk_member_jobcode foreign key(job_code) references job(job_code),
    constraint fk_member_deptcode foreign key(dept_code) references department(dept_code),
    constraint fk_member_managerid foreign key(manager_id) references member(member_id),
    constraint ck_member_quityn check(quit_yn in ('Y', 'N'))
);

--------------------------------------------------
--member테이블 시퀀스 생성
--------------------------------------------------
CREATE SEQUENCE seq_member START WITH 100 INCREMENT BY 1 NOMINVALUE NOMAXVALUE NOCYCLE NOCACHE;



--================================================
--project관련 테이블/시퀀스
--================================================







--================================================
--drop문
--================================================
/*
--member테이블 관련 drop문
drop table job;
drop table department;
drop table member;
drop sequence seq_member;

--project테이블 관련 drop문

*/


--================================================
--insert문
--================================================
--member테이블 관련 insert문
--------------------------------------------------
insert into job values('J1', '대표');
insert into job values('J2', '팀장');
insert into job values('J3', '사원');
insert into job values('J4', '관리자');

insert into department values('D1', '기획부');
insert into department values('D2', '디자인부');
insert into department values('D3', '개발부');

insert into member values('admin', '1234', '관리자', 'admin@gmail.com', '01012341234', '19800101', 'D1', 'J4', default, null, null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '김동현', 'boss@gmail.com', '01011111111', '19601103', 'D1', 'J1', default, null, null, null);
--기획부
insert into member values('kh2020'||seq_member.nextval, null, '유찬호', 'chanC@gmail.com', '01012357334', '19920815', 'D1', 'J2', default, null, null, null);
insert into member values('kh2020'||seq_member.nextval, null, '전희진', 'heeJ@gmail.com', '01082004511', '19970230', 'D1', 'J3', default, 'kh2020101', null, null);
insert into member values('kh2020'||seq_member.nextval, null, '정주영', 'jooyoung@gmail.com', '01060405050', '19950408', 'D1', 'J3', default, 'kh2020101', null, null);
insert into member values('kh2020'||seq_member.nextval, null, '임하라', 'hara@gmail.com', '01046541777', '19970618', 'D1', 'J3', default, 'kh2020101', null, null);
insert into member values('kh2020'||seq_member.nextval, null, '홍성준', 'hsJoon@gmail.com', '01042585555', '19931102', 'D1', 'J3', default, 'kh2020101', null, null);
insert into member values('kh2020'||seq_member.nextval, null, '신윤지', 'yoonG@gmail.com', '01078994656', '19950613', 'D1', 'J3', default, 'kh2020101', null, null);
insert into member values('kh2020'||seq_member.nextval, null, '이하은', 'haeun@gmail.com', '01010303000', '19920525', 'D1', 'J3', default, 'kh2020101', null, null);
--디자인부
insert into member values('kh2020'||seq_member.nextval, null, '장예찬', 'chanC@gmail.com', '01012357334', '19920815', 'D2', 'J2', default, null, null, null);
insert into member values('kh2020'||seq_member.nextval, null, '오근호', 'heeJ@gmail.com', '01082004511', '19970230', 'D2', 'J3', default, 'kh2020108', null, null);
insert into member values('kh2020'||seq_member.nextval, null, '김민호', 'jooyoung@gmail.com', '01060405050', '19950408', 'D2', 'J3', default, 'kh2020108', null, null);
insert into member values('kh2020'||seq_member.nextval, null, '신하진', 'hara@gmail.com', '01046541777', '19970618', 'D2', 'J3', default, 'kh2020108', null, null);
insert into member values('kh2020'||seq_member.nextval, null, '최주영', 'hsJoon@gmail.com', '01060507085', '19931102', 'D2', 'J3', default, 'kh2020108', null, null);
insert into member values('kh2020'||seq_member.nextval, null, '최현규', 'yoonG@gmail.com', '01078994656', '19950613', 'D2', 'J3', default, 'kh2020108', null, null);
insert into member values('kh2020'||seq_member.nextval, null, '임지은', 'jieun@gmail.com', '01010303000', '19950525', 'D2', 'J3', default, 'kh2020108', null, null);


commit;
rollback;



--================================================
--select문
--================================================
--member테이블 관련 select문
--------------------------------------------------
select * from job;
select * from department;
select * from member;                                                                                                                                                                         

--------------------------------------------------
--project테이블 관련 select문
--------------------------------------------------










