--================================================
--workground계정 생성
--================================================
create user workground identified by workground
default tablespace users;

grant connect, resource to workground;
grant create view to workground;
--drop user workgroundtest cascade;

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
--project_status 테이블
--------------------------------------------------
create table project_status(
    project_status_code char(3) not null,
    project_status_title varchar2(20) not null,
    project_status_color varchar2(20) not null,
    constraint pk_project_status primary key(project_status_code)
);

--------------------------------------------------
--project 테이블
--------------------------------------------------
create table project(
    project_no number not null,
    project_writer varchar2(30) not null,
    project_title varchar2(100) not null,
    private_yn char(1) default 'N' not null,
    project_desc varchar2(2000),
    project_startDate date default sysdate,
    project_endDate date, --마감일
    project_realEndDate date, --실제 완료일
    project_status_code char(3),
    constraint pk_project primary key(project_no),
    constraint fk_project_writer foreign key(project_writer) references member(member_id) on delete set null,
    constraint fk_project_status_code foreign key(project_status_code) references project_status(project_status_code) on delete set null,
    constraint ck_project_private_yn check(private_yn in ('Y','N'))
);

--------------------------------------------------
--project 테이블 시퀀스 생성
--------------------------------------------------
create sequence seq_project;

--------------------------------------------------
--project_members 테이블
--------------------------------------------------
create table project_members(
    project_members_no number not null,
    project_no number not null,
    member_id varchar2(30) not null,
    manager_yn char(1) default 'N' not null,
    project_quit_yn char(1) default 'N' not null, 
    constraint pk_project_members primary key(project_members_no),
    constraint fk_project_members_member_id foreign key(member_id) references member(member_id) on delete cascade,
    constraint fk_project_members_project_no foreign key(project_no) references project(project_no) on delete cascade,
    constraint ck_project_members_manager_yn check(manager_yn in ('Y','N'))
);

--------------------------------------------------
--project_members 테이블 시퀀스 생성
--------------------------------------------------
create sequence seq_project_members;

--------------------------------------------------
--project_important 테이블
--------------------------------------------------
create table project_important(
    project_important_no number not null,
    member_id varchar2(30) not null,
    project_no number not null,
    constraint pk_project_important primary key(project_important_no),
    constraint fk_p_important_member_id foreign key(member_id) references member(member_id) on delete cascade,
    constraint fk_p_important_project_no foreign key(project_no) references project(project_no) on delete cascade
);

--------------------------------------------------
--project_important 테이블 시퀀스 생성
--------------------------------------------------
create sequence seq_project_important;

--------------------------------------------------
--worklist 테이블
--------------------------------------------------
create table worklist(
    worklist_no number not null,
    project_no number not null,
    worklist_title varchar2(100) not null,
    constraint pk_worklist_no primary key(worklist_no),
    constraint fk_worklist_project_no foreign key(project_no) references project(project_no) on delete cascade
);

--------------------------------------------------
--worklist테이블 시퀀스 생성
--------------------------------------------------
CREATE SEQUENCE seq_worklist;

-----------------------------------------------------------------------
--work_tag 테이블
-----------------------------------------------------------------------
create table work_tag(
    work_tag_code char(3) not null,
    work_tag_title varchar2(20) not null,
    work_tag_color varchar2(20) not null,
    constraint pk_work_tag primary key(work_tag_code)
);

-----------------------------------------------------------------------
--work 테이블
-----------------------------------------------------------------------
create table work(
    work_no number not null,
    worklist_no number not null,
    work_title varchar2(100) not null,
    work_desc varchar2(2000) null,
    work_point number default 0 not null,
    work_startDate date default sysdate,
    work_endDate date, --마감일
    work_realEndDate date, --실제 완료일
    work_complete_yn char(1) default 'N' not null,
    work_tag_code char(3),
    work_no_ref number,
    constraint pk_work primary key(work_no),
    constraint fk_work_worklist_no foreign key(worklist_no) references worklist(worklist_no) on delete cascade,
    constraint ck_wokr_work_complete_yn check (work_complete_yn in ('Y','N')),
    constraint fk_work_work_no_ref foreign key(work_no_ref) references work(work_no) on delete cascade
);
--alter table work drop column 

-----------------------------------------------------------------------
--work테이블 시퀀스 생성
-----------------------------------------------------------------------
CREATE SEQUENCE seq_work;

-----------------------------------------------------------------------
--work_charged_members 테이블
-----------------------------------------------------------------------
create table work_charged_members(
    work_charged_members_no number not null,
    work_no number not null,
    charged_member_id varchar2(30) not null,
    constraint pk_work_charged_members primary key(work_charged_members_no),
    constraint fk_work_charged_work_no foreign key(work_no) references work(work_no) on delete cascade
);

-----------------------------------------------------------------------
--work_charged_members테이블 시퀀스 생성
-----------------------------------------------------------------------
CREATE SEQUENCE seq_work_charged_members;

-----------------------------------------------------------------------
--checklist 테이블
-----------------------------------------------------------------------
create table checklist(
    checklist_no number not null,
    work_no number not null,
    checklist_writer varchar2(30) not null, -- 관리자, 팀장, 업무 배정된 멤버 아이디
    checklist_charged_members_no number,  -- 업무 배정된 멤버 고유 번호
    checklist_content varchar2(2000) not null,
    checklist_startDate date default sysdate not null,
    checklist_endDate date, --완료일
    complete_yn char(1) default 'N' not null,
    constraint pk_checklist primary key(checklist_no),
    constraint fk_checklist_work_no foreign key(work_no) references work(work_no) on delete cascade,
    constraint fk_checklist_charged_mem_no foreign key(checklist_charged_members_no) references work_charged_members(work_charged_members_no) on delete set null,
    constraint ck_checklist_complete_yn check (complete_yn in ('Y','N')) 
);

-----------------------------------------------------------------------
--checklist테이블 시퀀스 생성
-----------------------------------------------------------------------
CREATE SEQUENCE seq_checklist;

-----------------------------------------------------------------------
--work_comment 테이블
-----------------------------------------------------------------------
create table work_comment(
    work_comment_no number not null,
    work_no number not null,
    work_comment_writer_no number not null, -- 프로젝트 멤버 고유 번호
    work_comment_level number default 1 not null,
    work_comment_content varchar2(2000) not null,
    work_comment_enrollDate date default sysdate not null,
    work_comment_ref number,
    constraint pk_work_comment primary key(work_comment_no),
    constraint fk_work_comment_work_no foreign key (work_no) references work(work_no) on delete cascade,
    constraint fk_work_comment_ref foreign key (work_comment_ref) references work_comment(work_comment_no) on delete cascade
);

-----------------------------------------------------------------------
--work_comment테이블 시퀀스 생성
-----------------------------------------------------------------------
CREATE SEQUENCE seq_work_comment;

-----------------------------------------------------------------------
--attachment 테이블
-----------------------------------------------------------------------
create table attachment(
    attachment_no number not null,
    work_no number not null,
    attachment_writer_no number not null,
    original_filename varchar2(100) not null,
    renamed_filename varchar2(100) not null,
    attachment_enrollDate date default sysdate,
    constraint pk_attachment primary key(attachment_no),
    constraint fk_attachment_work_no foreign key (work_no) references work(work_no) on delete cascade
);

-----------------------------------------------------------------------
--work_comment테이블 시퀀스 생성
-----------------------------------------------------------------------
CREATE SEQUENCE seq_attachment;

--------------------------------------------------
--project_log 테이블
--------------------------------------------------
create table project_log(
    log_no number not null,
    project_no number not null,
    log_type varchar(50) not null,
    log_content varchar2(1000) not null,
    log_date date not null,
    constraint pk_project_log primary key(log_no),
    constraint fk_project_log_project_no foreign key(project_no) references project(project_no) on delete cascade
);

--------------------------------------------------
--project_log 테이블 시퀀스 생성
--------------------------------------------------
create sequence seq_project_log;

commit;
select * from project_log order by log_no;

--================================================
--notice/community 관련 테이블/시퀀스
--================================================
--notice테이블
--------------------------------------------------
create table notice(
	notice_no	number not null,
	notice_writer varchar2(30) not null,
	notice_title varchar2(100) not null,
	notice_date date default sysdate not null,
	notice_content varchar2(4000) not null,
	notice_original_filename varchar2(100) null,
	notice_renamed_filename varchar2(100) null,
	dept_code char(2) null,
    constraint pk_notice primary key(notice_no),
    constraint fk_notice_writer foreign key(notice_writer) references member(member_id) on delete set null
);
--------------------------------------------------
--notice 테이블 시퀀스 생성
--------------------------------------------------
create sequence seq_notice;

--------------------------------------------------
--community 테이블 생성
--------------------------------------------------
create table community(
	commu_no number not null,
	commu_writer varchar2(30) not null,
	commu_title	varchar2(100) not null,
	commu_content varchar2(4000)	not null,
    commu_date date default sysdate not null,
	commu_original_filename varchar2(100) null,
	commu_renamed_filename varchar2(100) null,
    constraint pk_community primary key(commu_no),
    constraint fk_commu_writer foreign key(commu_writer) references member(member_id) on delete set null  
);
--------------------------------------------------
--community 테이블 시퀀스 생성
--------------------------------------------------
create sequence seq_community;


--================================================
--drop문
--================================================
/*
--------------------------------------------------
--member테이블 관련 drop문
--------------------------------------------------
drop table job;
drop table department;
drop table member;
drop sequence seq_member;

--------------------------------------------------
--project테이블 관련 drop문
--------------------------------------------------
drop table project_status;
drop table project;
drop table project_members;
drop sequence seq_project_members;
drop sequence seq_project;
drop table project_important;
drop sequence seq_project_important;

--------------------------------------------------
--worklist/work 테이블 관련 drop문
--------------------------------------------------
drop table worklist;
drop sequence seq_worklist;
drop table work_tag;
drop table work;
drop sequence seq_work;
drop table work_charged_members;
drop sequence seq_work_charged_members;
drop table checklist;
drop sequence seq_checklist;
drop table work_comment;
drop sequence seq_work_comment;
drop table attachment;
drop sequence seq_attachment;


--------------------------------------------------
--notice/community테이블 관련 drop문
--------------------------------------------------
--drop table notice;
--drop sequence seq_notice;
--drop table community;
--drop sequence seq_community;

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

insert into member values('admin', '1234', '관리자', 'admin@gmail.com', '01012341234', '19800101', 'D1', 'J4', default, null, 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '김동현', 'boss@gmail.com', '01011111111', '19601103', 'D1', 'J1', default, null, 'default.jpg', 'default.jpg');
--기획부
insert into member values('kh2020'||seq_member.nextval, '1234', '유찬호', 'chanC@gmail.com', '01012357334', '19920815', 'D1', 'J2', default, null, 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '전희진', 'heeJ@gmail.com', '01082004511', '19970230', 'D1', 'J3', default, 'kh2020101', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '정주영', 'jooyoung@gmail.com', '01060405050', '19950408', 'D1', 'J3', default, 'kh2020101', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '임하라', 'hara@gmail.com', '01046541777', '19970618', 'D1', 'J3', default, 'kh2020101', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '홍성준', 'hsJoon@gmail.com', '01042585555', '19931102', 'D1', 'J3', default, 'kh2020101', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '신윤지', 'yoonG@gmail.com', '01078994656', '19950613', 'D1', 'J3', default, 'kh2020101', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '이하은', 'haeun@gmail.com', '01010303000', '19920525', 'D1', 'J3', default, 'kh2020101', 'default.jpg', 'default.jpg');
--디자인부
insert into member values('kh2020'||seq_member.nextval, '1234', '장예찬', 'janggg@gmail.com', '01050554422', '19950131', 'D2', 'J2', default, null, 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '오근호', 'hohoho@gmail.com', '01096334810', '19950412', 'D2', 'J3', default, 'kh2020108', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '김민호', 'minho@gmail.com', '01090909090', '19920526', 'D2', 'J3', default, 'kh2020108', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '신하진', 'hajin@gmail.com', '01046541777', '19960102', 'D2', 'J3', default, 'kh2020108', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '최주영', 'jooyoung@gmail.com', '01075128922', '19970123', 'D2', 'J3', default, 'kh2020108', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '최현규', 'gyu@gmail.com', '01035440822', '19950429', 'D2', 'J3', default, 'kh2020108', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '임지은', 'jieun@gmail.com', '01042441792', '19970225', 'D2', 'J3', default, 'kh2020108', 'default.jpg', 'default.jpg');
--개발부 1팀
insert into member values('kh2020'||seq_member.nextval, '1234', '정영균', 'youngjeong@gmail.com', '01050147465', '19880621', 'D3', 'J2', default, null, 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '이창택', 'changT@gmail.com', '01035621744', '19941025', 'D3', 'J3', default, 'kh2020115', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '이정훈', 'hoonn@gmail.com', '01014115522', '19950202', 'D3', 'J3', default, 'kh2020115', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '이도현', 'doDO@gmail.com', '01034819222', '19950202', 'D3', 'J3', default, 'kh2020115', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '민병준', 'bjM@gmail.com', '01041001841', '19930810', 'D3', 'J3', default, 'kh2020115', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '허준', 'hjoon@gmail.com', '01012028944', '19920111', 'D3', 'J3', default, 'kh2020115', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, '1234', '정진섭', 'seojicoji@gmail.com', '01044150132', '19930712', 'D3', 'J3', default, 'kh2020115', 'default.jpg', 'default.jpg');
--개발부 2팀
insert into member values('kh2020'||seq_member.nextval, null, '이단비', 'danbi.db@gmail.com', '01040134147', '19920819', 'D3', 'J2', default, null, 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, null, '유혜민', 'yuhyeminn@gmail.com', '01062228421', '19961211', 'D3', 'J3', default, 'kh2020122', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, null, '주보라', 'bora@gmail.com', '01011116666', '19940425', 'D3', 'J3', default, 'kh2020122', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, null, '이소현', 'soohyeon@gmail.com', '01092150000', '19970522', 'D3', 'J3', default, 'kh2020122', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, null, '김효정', 'hyojeong@gmail.com', '01054226921', '19971102', 'D3', 'J3', default, 'kh2020122', 'default.jpg', 'default.jpg');
insert into member values('kh2020'||seq_member.nextval, null, '이주현', 'joohyeon@gmail.com', '01098445110', '19970906', 'D3', 'J3', default, 'kh2020122', 'default.jpg', 'default.jpg');

--------------------------------------------------
--project테이블 관련 insert문
--------------------------------------------------
insert into project_status values('PS1', '계획됨', 'warning');
insert into project_status values('PS2', '진행중', 'success');
insert into project_status values('PS3', '완료됨', 'info');
-- 프로젝트
insert into project values(seq_project.nextval, 'kh2020115', '개발1팀', default, '개발 1팀 프로젝트입니다', default, sysdate+10, null, null);
insert into project values(seq_project.nextval, 'kh2020122', '개발2팀', default, '개발 2팀 프로젝트입니다', default, null, null, 'PS1');
insert into project values(seq_project.nextval, 'kh2020108', '디자인팀', default, '디자인팀 프로젝트입니다', default, null, null, 'PS2');
insert into project values(seq_project.nextval, 'kh2020101', '기획팀', default, '기획팀 프로젝트입니다', default, null, null, 'PS3');
insert into project values(seq_project.nextval, 'kh2020122', 'projectList', default, null, default, sysdate+20, null, 'PS2');
--내 프로젝트
insert into project values(seq_project.nextval, 'kh2020122', '나의 워크패드', 'Y', null, null, null, null, null);
insert into project values(seq_project.nextval, 'kh2020123', '나의 워크패드', 'Y', null, null, null, null, null);
insert into project values(seq_project.nextval, 'kh2020127', '나의 워크패드', 'Y', null, null, null, null, null);
-- 프로젝트 팀원
insert into project_members values(seq_project_members.nextval, 1, 'kh2020115', 'Y', default);
insert into project_members values(seq_project_members.nextval, 1, 'kh2020116', default, default);
insert into project_members values(seq_project_members.nextval, 1, 'kh2020117', default, default);
insert into project_members values(seq_project_members.nextval, 1, 'kh2020118', default, default);
insert into project_members values(seq_project_members.nextval, 1, 'kh2020119', default, default);
insert into project_members values(seq_project_members.nextval, 1, 'kh2020120', default, default);
insert into project_members values(seq_project_members.nextval, 1, 'kh2020121', default, default);
insert into project_members values(seq_project_members.nextval, 2, 'kh2020122', 'Y', default);
insert into project_members values(seq_project_members.nextval, 2, 'kh2020123', default, default);
insert into project_members values(seq_project_members.nextval, 2, 'kh2020124', default, default);
insert into project_members values(seq_project_members.nextval, 2, 'kh2020125', default, default);
insert into project_members values(seq_project_members.nextval, 2, 'kh2020126', default, default);
insert into project_members values(seq_project_members.nextval, 2, 'kh2020127', default, default);
insert into project_members values(seq_project_members.nextval, 3, 'kh2020108', 'Y', default);
insert into project_members values(seq_project_members.nextval, 4, 'kh2020101', 'Y', default);
insert into project_members values(seq_project_members.nextval, 5, 'kh2020122', 'Y', default);
insert into project_members values(seq_project_members.nextval, 5, 'kh2020123', default, default);
insert into project_members values(seq_project_members.nextval, 6, 'kh2020122', 'Y', default);
insert into project_members values(seq_project_members.nextval, 7, 'kh2020123', default, default);
--중요표시 프로젝트
insert into project_important values (seq_project_important.nextval, 'kh2020122', 2);
insert into project_important values (seq_project_important.nextval, 'kh2020122', 5);
insert into project_important values (seq_project_important.nextval, 'kh2020123', 2);

--------------------------------------------------
--worklist/work 테이블 관련 insert문
--------------------------------------------------
-- 업무리스트
insert into worklist values(seq_worklist.nextval, 1, '해야할 일');
insert into worklist values(seq_worklist.nextval, 1, '진행중');
insert into worklist values(seq_worklist.nextval, 1, '완료');
insert into worklist values(seq_worklist.nextval, 2, '해야할 일');
insert into worklist values(seq_worklist.nextval, 2, '진행중');
insert into worklist values(seq_worklist.nextval, 2, '완료');
insert into worklist values(seq_worklist.nextval, 2, '테스트1');
--업무 태그
insert into work_tag values('WT1', 'priority', 'danger');
insert into work_tag values('WT2', 'important', 'primary');
insert into work_tag values('WT3', 'review', 'warning');
-- 업무
insert into work values(seq_work.nextval, 1, '회식하기', '내일 회식이요', 1, sysdate-10, null, null, default, 'WT1', null);
insert into work values(seq_work.nextval, 2, '밥먹기', '밥 먹는 중!', 2, sysdate-10, null, null, default, null, null);
insert into work values(seq_work.nextval, 4, '기능 정리하기', '기능 정리하기 업무입니다.', 3, sysdate-5, sysdate+20, null, default, 'WT2', null);
insert into work values(seq_work.nextval, 4, '테이블 설계하기', null, 5, sysdate-4, sysdate-2, null, default, 'WT1', null);
insert into work values(seq_work.nextval, 4, '깃 클론 하기', 'danbiilee/workGround 클론하세요!', 2, sysdate-4, null, null, default, null, null);
insert into work values(seq_work.nextval, 4, '.gitignore파일 만들기', null, 1, sysdate-4, sysdate-3, sysdate-3, 'Y', 'WT3', null);
insert into work values(seq_work.nextval, 4, '완료된 업무 보기', null, 2, sysdate, sysdate, sysdate, 'Y', null, null);
insert into work values(seq_work.nextval, 5, '테이블 수정 그만', '그만 고치자 제발......', 5, sysdate-3, sysdate+5, sysdate, 'Y', 'WT3', null);
insert into work values(seq_work.nextval, 5, '테이블 만들기', 'insert문까지 얼른 끝냅시다', 5, sysdate-8, sysdate+2, null, default, 'WT3', null);
insert into work values(seq_work.nextval, 6, '완료된 업무 페이지 수정', 'view다시 뿌려야 해...', 5, sysdate-3, sysdate+2, null, default, 'WT1', null);
insert into work values(seq_work.nextval, 6, '업무 검색기능', null, 0, sysdate-2, sysdate+1, sysdate-1, 'Y', null, null);
-- 업무 배정된 멤버
insert into work_charged_members values(seq_work_charged_members.nextval, 1, 'kh2020115');
insert into work_charged_members values(seq_work_charged_members.nextval, 1, 'kh2020116');
insert into work_charged_members values(seq_work_charged_members.nextval, 1, 'kh2020118');
insert into work_charged_members values(seq_work_charged_members.nextval, 2, 'kh2020117');
insert into work_charged_members values(seq_work_charged_members.nextval, 3, 'kh2020122');
insert into work_charged_members values(seq_work_charged_members.nextval, 3, 'kh2020123');
insert into work_charged_members values(seq_work_charged_members.nextval, 4, 'kh2020125');
insert into work_charged_members values(seq_work_charged_members.nextval, 5, 'kh2020126');
insert into work_charged_members values(seq_work_charged_members.nextval, 6, 'kh2020127');
insert into work_charged_members values(seq_work_charged_members.nextval, 7, 'kh2020124');
insert into work_charged_members values(seq_work_charged_members.nextval, 7, 'kh2020127');
insert into work_charged_members values(seq_work_charged_members.nextval, 8, 'kh2020127');
--업무 체크리스트
insert into checklist values(seq_checklist.nextval,1,'kh2020115',null,'회식 장소 답사하기',default,null,'N');
insert into checklist values(seq_checklist.nextval,3,'kh2020122',121,'프로젝트 관리 기능 정리',default,null,'Y');
insert into checklist values(seq_checklist.nextval,3,'kh2020122',121,'업무설정 기능 정리',default,null,'N');
insert into checklist values(seq_checklist.nextval,3,'kh2020122',5,'파일첨부 기능 정리',default,null,'N');
insert into checklist values(seq_checklist.nextval,7,'kh2020122',101,'on delete null잘 되나!?',default,null,'N');
insert into checklist values(seq_checklist.nextval,7,'kh2020122',null,'테이블 수정 그만',default,null,'N');
--업무 코멘트
insert into work_comment values(seq_work_comment.nextval, 2, 5,1,'뭐드시나요?',default,null);
insert into work_comment values(seq_work_comment.nextval, 2, 6,2,'뭐드시나요?',default,2);
insert into work_comment values(seq_work_comment.nextval, 3, 8,1,'언제 끝나나요?',default,null);
insert into work_comment values(seq_work_comment.nextval, 3, 9,2,'오늘 안에 끝날 것 같습니다!',default,4);
insert into work_comment values(seq_work_comment.nextval, 7, 10,1,'네 알겠습니다!',default,null);
insert into work_comment values(seq_work_comment.nextval, 7, 11,1,'넵!',default,null);
--업무 파일첨부
insert into attachment values(seq_attachment.nextval,2,3,'순무.jpg','test.jpg',sysdate);
insert into attachment values(seq_attachment.nextval,3,10,'순무.jpg','test.jpg',sysdate);
insert into attachment values(seq_attachment.nextval,3,12,'짱구.JPG','ff.JPG',sysdate);
insert into attachment values(seq_attachment.nextval,5,8,'가이드.pdf','guide_java.pdf',sysdate); 
insert into attachment values(seq_attachment.nextval,6,13,'테스트.txt','test.txt',sysdate);
insert into attachment values(seq_attachment.nextval,142,8,'야구.JPG','fs.JPG',sysdate);
insert into attachment values(seq_attachment.nextval,7,11,'신청서.hwp','application.hwp',sysdate);


commit;

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
select * from project_status;
select * from project;
select * from project_members;
select * from project_important;

--------------------------------------------------
--worklist/work 테이블 관련 select문
--------------------------------------------------
select * from worklist;
select * from work_tag;
select * from work where worklist_no = 321;
select * from work_charged_members;
select * from checklist;
select * from work_comment;
select * from attachment;
select * from work where work_no = 205;


--------------------------------------------------
--notice/community테이블 관련 select문
--------------------------------------------------
select * from notice;
select * from community;




--================================================
--뷰: member+department+job 
--================================================
create or replace view view_member as
select M.*, D.dept_title, J.job_title 
from member M left join department D on M.dept_code = D.dept_code
                          left join job J on M.job_code = J.job_code;
--select * from view_member;

--================================================
--뷰: project+project_status
--================================================
create or replace view view_project as 
select P.*, PS.project_status_title, PS.project_status_color
from project P left join project_status PS on P.project_status_code = PS.project_status_code; 
--select * from view_project;

--================================================
--뷰: view_project + project_members + member
--================================================
create or replace view view_projectMember as
select V.*, M.password, M.member_name, M.email, M.phone, M.date_of_birth, M.dept_code, M.job_code, M.quit_yn, M.manager_id, M.original_filename, M.renamed_filename, M.dept_title, M.job_title
from (select P.*, PM.manager_yn,  PM.member_id, PM.project_quit_yn 
      from view_project P left join project_members PM on P.project_no = PM.project_no
      order by P.project_no desc) V 
      left join view_member M on V.member_id = M.member_id;

--================================================
--뷰: work + work_tag
--================================================
create or replace view view_workTag as
select W.*, WT.work_tag_title, WT.work_tag_color
from work W left join work_tag WT on W.work_tag_code = WT.work_tag_code;

--================================================
--뷰: notice+member
--================================================
create or replace view view_noticeMember as 
select N.*, M.member_name, M.renamed_filename
from notice N left join member M on N.notice_writer = M.member_id; 
--drop view view_noticeMember;
--select * from view_noticeMember;

--================================================
--뷰: community+member
--================================================
create or replace view view_communityMember as 
select C.*, M.member_name, M.renamed_filename
from community C left join member M on C.commu_writer = M.member_id; 
--drop view view_communityMember;
--select * from view_communityMember;


--================================================
--트리거: 회원가입시 내 워크패드 생성  
--================================================
create or replace trigger trg_register_workpad
    after
    update on member
    for each row
declare
    vold_password varchar2(300) := :old.password;
    vnew_password varchar2(300) := :new.password;
begin
    --회원가입 한 경우
    if vold_password is null then 
        insert into project values(seq_project.nextval, :old.member_id, '나의 워크패드', 'Y', null, null, null, null, null);
    --계정삭제 한 경우
    elsif vnew_password is null then 
        delete from project where project_writer = :old.member_id and private_yn = 'Y';
    end if;
end;
/

--================================================
--트리거: 내 워크패드 생성 시 프로젝트 멤버에도 추가 
--================================================
create or replace trigger trg_project_members_workpad
    after
    insert on project
    for each row
declare
    vproject_no number := :new.project_no;
    vmember_id varchar2(30) := :new.project_writer;
begin
    --나의 워크패드인 경우
    if :new.private_yn = 'Y' then
        insert into project_members values(seq_project_members.nextval, vproject_no, vmember_id, 'Y', default);
    end if;
end;
/

--================================================
--트리거: project_members의 project_quit_yn이 N->Y로 변경될 때
--================================================
create or replace trigger trg_project_members_quit
    after
    update on project_members
    for each row
declare
    vproject_no number := :old.project_no;
    vmember_id varchar2(30) := :old.member_id;
    vwork_no number;
    
    cursor cur is
        select V.work_no                                      
        from (select V.*, W.worklist_no from (select * from work_charged_members where charged_member_id = vmember_id) V 
                    left join work W on V.work_no = W.work_no) V
                    left join worklist WL on V.worklist_no = WL.worklist_no
        where project_no = vproject_no;
begin

    --프로젝트에서 나가는 경우 
    if :new.project_quit_yn = 'Y' then
        open cur;
    
        loop
            fetch cur into vwork_no;
            exit when cur%notFound;
        
            delete from work_charged_members where charged_member_id = vmember_id and work_no = vwork_no;
        end loop;
        
    end if;
end;
/

-- club 관련 테이블

--========================================
-- 동호회
--========================================
create table club (
    club_no number, 
    club_name varchar2(30) not null, 
    club_enroll_date date default sysdate, 
    club_introduce varchar2(1000) not null, 
    club_meeting_date varchar2(100), 
    club_category varchar2(10) not null, 
    club_manager_id varchar2(30) not null,
    constraint pk_club_no primary key(club_no),
    constraint fk_club_manager_id foreign key(club_manager_id) references member(member_id)
);
create sequence seq_club_no;

--========================================
-- 동호회 활동사진
--========================================
create table club_photo(
    club_photo_no number, 
    club_photo_title varchar2(50) not null, 
    club_photo_original varchar2(50) not null, 
    club_photo_renamed varchar2(50) not null, 
    club_no not null, 
    club_photo_date date default sysdate, 
    constraint pk_club_photo_no primary key(club_photo_no), 
    constraint fk_club_no foreign key(club_no) references club(club_no) on delete cascade
);
create sequence seq_club_photo_no;

create table club_photo_comment(
    club_photo_comment_no number, 
    club_photo_no number, 
    club_photo_comment_level number, 
    club_member_no number, 
    club_photo_comment_content varchar2(3000), 
    club_photo_comment_date date default sysdate, 
    club_photo_comment_ref number, 
    club_no number, 
    constraint pk_club_photo_comment_no primary key(club_photo_comment_no), 
    constraint fk_club_photo_co_notice_no foreign key(club_photo_no) references club_photo(club_photo_no) on delete cascade, 
    constraint fk_club_photo_co_member_no foreign key(club_member_no) references club_member(club_member_no) on delete cascade, 
    constraint ck_club_photo_comment_level check (club_photo_comment_level in(1, 2)), 
    constraint fk_club_photo_com_ref foreign key(club_photo_comment_ref) references club_photo_comment(club_photo_comment_no) on delete cascade, 
    constraint fk_club_photo_comment_club_no foreign key(club_no) references club(club_no) on delete cascade
);
create sequence seq_club_photo_comment_no;

--=====================================
-- 동호회 멤버
--=====================================
create table club_member(
    club_member_no number,
    emp_id varchar2(20) not null,
    club_code number not null,
    club_manager_YN char(2),
    club_approve_YN char(2),
    constraint pk_club_member_no primary key(club_member_no),
    constraint fk_emp_id foreign key(emp_id) references member(member_id) on delete cascade,
    constraint fk_club_code foreign key(club_code) references club(club_no) on delete cascade,
    constraint ck_club_manager_YN check(club_manager_YN in ('Y','N')),
    constraint ck_club_approve_YN check(club_approve_YN in ('Y','N'))
);
create sequence seq_club_member_no;

--=====================================
-- 동호회 일정
--=====================================
create table club_plan(
    club_plan_no number, 
    club_plan_title varchar2(100) not null, 
    club_plan_content varchar2(4000), 
    club_plan_start date not null, 
    club_plan_end date not null, 
    club_plan_state varchar2(6), 
    club_plan_place varchar2(50) not null, 
    club_plan_manager varchar2(30) not null, 
    club_no number, 
    constraint pk_club_plan_no primary key(club_plan_no), 
    constraint fk_club_plan_club_no foreign key(club_no) references club(club_no) on delete cascade, 
    constraint ck_club_plan_state check (club_plan_state in('예정', '완료', '취소'))
);
create sequence seq_club_plan_no;

--drop table club_plan;
--drop sequence seq_club_plan_no;

--=====================================
-- 동호회 공지
--=====================================
create table club_notice (
    club_notice_no number, 
    club_notice_title varchar2(100) not null, 
    club_notice_content varchar2(4000) not null, 
    club_no number, 
    club_member_no number, 
    club_notice_date date default sysdate, 
    constraint pk_club_notice_no primary key (club_notice_no), 
    constraint fk_club_notice_club_no foreign key (club_no) references club(club_no) on delete cascade, 
    constraint fk_club_notice_club_member_no foreign key (club_member_no) references club_member(club_member_no) on delete cascade
);
create sequence seq_club_notice_no;

--drop table club_notice;
--drop sequence seq_club_notice_no;

create table club_notice_comment(
    club_notice_comment_no number, 
    club_notice_no number, 
    club_notice_comment_level number, 
    club_member_no number, 
    club_notice_comment_content varchar2(3000), 
    club_notice_comment_date date default sysdate, 
    club_notice_comment_ref number, 
    club_no number, 
    constraint pk_club_notice_comment_no primary key(club_notice_comment_no), 
    constraint fk_club_notice_co_notice_no foreign key(club_notice_no) references club_notice(club_notice_no) on delete cascade, 
    constraint fk_club_notice_co_member_no foreign key(club_member_no) references club_member(club_member_no) on delete cascade, 
    constraint ck_club_notice_comment_level check (club_notice_comment_level in(1, 2)), 
    constraint fk_club_notice_com_ref foreign key(club_notice_comment_ref) references club_notice_comment(club_notice_comment_no) on delete cascade, 
    constraint fk_club_notice_comment_club_no foreign key(club_no) references club(club_no) on delete cascade
);
create sequence seq_club_notice_comment_no;

create or replace procedure update_club_plan_state 
    is
begin
    update club_plan set club_plan_state = '완료', club_plan_color = 'warning' where club_plan_start < sysdate and club_plan_state = '예정';
commit;
end;
/

declare
    v_job_no number;
begin
    dbms_job.submit(job=> v_job_no, 
                  what=> 'update_club_plan_state;', 
                  next_date=> sysdate, 
                  interval=> 'sysdate + 1');
commit;
    dbms_output.put_line('v_job_no : ' || v_job_no);
end;
/

-- =====================================
-- Trigger
-- 동호회 개설시 개설자 자동으로 클럽 멤버에 등록
-- =====================================
commit;

create table club_plan(
    club_plan_no number, 
    club_plan_title varchar2(100) not null, 
    club_plan_content varchar2(4000), 
    club_plan_start date not null, 
    club_plan_end date not null, 
    club_plan_state varchar2(6), 
    club_plan_color varchar2(10), 
    club_plan_place varchar2(50) not null, 
    club_plan_manager varchar2(30) not null, 
    club_no number, 
    constraint pk_club_plan_no primary key(club_plan_no), 
    constraint fk_club_plan_club_no foreign key(club_no) references club(club_no) on delete cascade, 
    constraint ck_club_plan_state check(club_plan_state in('예정', '완료', '취소')), 
    constraint ck_club_plan_color check(club_plan_color in('success', 'warning', 'danger'))
);
create sequence seq_club_plan_no;

create table club_plan_attendee(
    club_plan_attendee_no number, 
    club_plan_no number, 
    club_member_no number, 
    club_plan_attendee_date date default sysdate, 
    constraint pk_club_plan_attendee_no primary key(club_plan_attendee_no), 
    constraint fk_attendee_club_plan_no foreign key(club_plan_no) references club_plan(club_plan_no) on delete cascade, 
    constraint fk_attendee_club_member_no foreign key(club_member_no) references club_member(club_member_no) on delete cascade
);
create sequence seq_club_plan_attendee_no;

--============================================
-- 동호회장이 동호회 생성시 자동으로 동호회장을 멤버리스트에 삽입
--============================================
create or replace trigger trig_insert_manager
after insert on CLUB
for each row
begin
        insert into club_member values(seq_club_member_no.nextval,:NEW.club_manager_id,:NEW.club_no,'Y','Y');
        end;
/        

--drop trigger trig_insert_manager;


-- channel 관련 테이블

--========================================
-- 채팅
--========================================
--채널 종류
create table channel_sort(
    channel_type char(3) NOT NULL,
	channel_sort_name varchar2(35) NOT NULL, 
    constraint pk_channel_type primary key(channel_type)
);
--채널
create table channel(
    channel_no varchar2(30), 
    channel_type char(3), 
    channel_title varchar2(30),
    status char(2) default 'Y', 
    last_check number default 0, 
    project_or_club_no number, 
    constraint pk_channel_no primary key(channel_no), 
    constraint fk_channel_type foreign key(channel_type) references channel_sort(channel_type) on delete cascade
);
--채널 멤버
create table channel_member(
    channel_member_no number, 
    channel_no varchar2(30), 
    member_id varchar2(30), 
    constraint pk_channel_member_no primary key(channel_member_no), 
    constraint fk_channel_mem_channel_no foreign key(channel_no) references channel(channel_no) on delete cascade, 
    constraint fk_channel_mem_mem_id foreign key(member_id) references member(member_id) on delete cascade
);

create sequence seq_channel_member_no;
--채팅 목록
create table chat(
    chat_no number, 
    channel_no varchar2(30), 
    sender varchar2(30) not null, 
    send_date date default sysdate, 
    msg varchar2(3000) not null, 
    constraint pk_chat_no primary key(chat_no), 
    constraint fk_chat_channel_no foreign key(channel_no) references channel(channel_no) on delete cascade
);
create sequence seq_chat_no;

--trigger
--동호회생성시 동호회장 club_member에 넣고, 채팅방 개설하고, 채팅멤버 넣어주기(성공)
create or replace trigger trig_insert_manager
    after insert on CLUB
    for each row
begin
    insert into club_member values(seq_club_member_no.nextval,:NEW.club_manager_id,:NEW.club_no,'Y','Y');
    insert into channel values('C' || :NEW.club_no,'CH2',:NEW.club_name,default,default,:NEW.club_no);
    insert into channel_member values(seq_channel_member_no.nextval, (select channel_no from channel where project_or_club_no = :NEW.club_no), :NEW.club_manager_id);
end;
/
--drop trigger trig_insert_manager;

-- 클럽멤버의 승인이 이루어질때 채팅멤버에 추가(성공)
create or replace trigger trig_update_c_chatroom_member
    after update on club_member
    for each row
begin
    if (:NEW.club_approve_yn = 'Y') then
        insert into channel_member values(seq_channel_member_no.nextval, (select channel_no from channel where project_or_club_no = :NEW.club_code), :NEW.emp_id);
    end if;
end;
/

-- 클럽이 삭제 될때
create or replace trigger trig_delete_c_channel
    before delete on club
    for each row
begin
        delete from channel where project_or_club_no = :OLD.club_no;
end;
/

--프로젝트가 개설되면 채팅방 생성
create or replace trigger trig_insert_p_channel
        after insert on project
    for each row
begin
    insert into channel values('P' || :NEW.project_no,'CH2',:NEW.project_title,default,default,:NEW.project_no);
end;
/

--프로젝트가 삭제되면 채팅방, 멤버 삭제
create or replace trigger trig_delete_p_channel
    before delete on project
    for each row
begin
        delete from channel where project_or_club_no = :OLD.project_no;
end;
/
	
--프로젝트에 멤버가 추가될때
create or replace trigger trig_insert_p_channel_member
    after insert on project_members
    for each row
begin
        insert into channel_member values(seq_channel_member_no.nextval, (select channel_no from channel where project_or_club_no = :NEW.project_no), :NEW.member_id);
end;
/

--프로젝트에 멤버가 quit될때
create or replace trigger trig_delete_p_channel_member
    after update on project_members
    for each row
begin
        if (:NEW.project_quit_yn = 'Y') then
            delete channel_member where channel_no = 'P'||:NEW.project_no;
    end if;
end;
/

SELECT * FROM ALL_TRIGGERS;





