--================================================
--system계정
--================================================
--workground계정 생성
create user workground identified by workground
default tablespace users;

grant connect, resource to workground;
grant create view to workground;

--테스트 계정 생성
create user workgroundTest identified by workgroundTest
default tablespace users;

grant connect, resource to workgroundTest;
grant create view to workgroundTest;

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
insert into member values('kh2020'||seq_member.nextval, '1234', '유찬호', 'chanC@gmail.com', '01012357334', '19920815', 'D1', 'J2', default, null, null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '전희진', 'heeJ@gmail.com', '01082004511', '19970230', 'D1', 'J3', default, 'kh2020101', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '정주영', 'jooyoung@gmail.com', '01060405050', '19950408', 'D1', 'J3', default, 'kh2020101', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '임하라', 'hara@gmail.com', '01046541777', '19970618', 'D1', 'J3', default, 'kh2020101', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '홍성준', 'hsJoon@gmail.com', '01042585555', '19931102', 'D1', 'J3', default, 'kh2020101', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '신윤지', 'yoonG@gmail.com', '01078994656', '19950613', 'D1', 'J3', default, 'kh2020101', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '이하은', 'haeun@gmail.com', '01010303000', '19920525', 'D1', 'J3', default, 'kh2020101', null, null);
--디자인부
insert into member values('kh2020'||seq_member.nextval, '1234', '장예찬', 'janggg@gmail.com', '01050554422', '19950131', 'D2', 'J2', default, null, null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '오근호', 'hohoho@gmail.com', '01096334810', '19950412', 'D2', 'J3', default, 'kh2020108', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '김민호', 'minho@gmail.com', '01090909090', '19920526', 'D2', 'J3', default, 'kh2020108', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '신하진', 'hajin@gmail.com', '01046541777', '19960102', 'D2', 'J3', default, 'kh2020108', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '최주영', 'jooyoung@gmail.com', '01075128922', '19970123', 'D2', 'J3', default, 'kh2020108', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '최현규', 'gyu@gmail.com', '01035440822', '19950429', 'D2', 'J3', default, 'kh2020108', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '임지은', 'jieun@gmail.com', '01042441792', '19970225', 'D2', 'J3', default, 'kh2020108', null, null);
--개발부 1팀
insert into member values('kh2020'||seq_member.nextval, '1234', '정영균', 'youngjeong@gmail.com', '01050147465', '19880621', 'D3', 'J2', default, null, null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '이창택', 'changT@gmail.com', '01035621744', '19941025', 'D3', 'J3', default, 'kh2020115', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '이정훈', 'hoonn@gmail.com', '01014115522', '19950202', 'D3', 'J3', default, 'kh2020115', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '이도현', 'doDO@gmail.com', '01034819222', '19950202', 'D3', 'J3', default, 'kh2020115', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '민병준', 'bjM@gmail.com', '01041001841', '19930810', 'D3', 'J3', default, 'kh2020115', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '허준', 'hjoon@gmail.com', '01012028944', '19920111', 'D3', 'J3', default, 'kh2020115', null, null);
insert into member values('kh2020'||seq_member.nextval, '1234', '정진섭', 'seojicoji@gmail.com', '01044150132', '19930712', 'D3', 'J3', default, 'kh2020115', null, null);
--개발부 2팀
insert into member values('kh2020'||seq_member.nextval, null, '이단비', 'danbi.db@gmail.com', '01040134147', '19920819', 'D3', 'J2', default, null, null, null);
insert into member values('kh2020'||seq_member.nextval, null, '유혜민', 'yuhyeminn@gmail.com', '01062228421', '19961211', 'D3', 'J3', default, 'kh2020122', null, null);
insert into member values('kh2020'||seq_member.nextval, null, '주보라', 'bora@gmail.com', '01011116666', '19940425', 'D3', 'J3', default, 'kh2020122', null, null);
insert into member values('kh2020'||seq_member.nextval, null, '이소현', 'soohyeon@gmail.com', '01092150000', '19970522', 'D3', 'J3', default, 'kh2020122', null, null);
insert into member values('kh2020'||seq_member.nextval, null, '김효정', 'hyojeong@gmail.com', '01054226921', '19971102', 'D3', 'J3', default, 'kh2020122', null, null);
insert into member values('kh2020'||seq_member.nextval, null, '이주현', 'joohyeon@gmail.com', '01098445110', '19970906', 'D3', 'J3', default, 'kh2020122', null, null);


--트랜잭션 처리
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










