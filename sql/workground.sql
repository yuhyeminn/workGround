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
    constraint fk_worklist_project_no foreign key(project_no) references project(project_no)
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
    constraint fk_checklist_work_no foreign key(work_no) references work(work_no),
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
create or replace trigger trg_member_workpad
    after
    update on member
    for each row
declare
    vold_password varchar2(300) := :old.password;
    vnew_password varchar2(300) := :new.password;
begin
    --회원가입 한 경우
    if vold_password = null then 
        insert into project values(seq_project.nextval, :old.member_id, '나의 워크패드', 'Y', null, null, null, null, null);
    --계정삭제 한 경우
    elsif vnew_password = null then 
        delete from project where project_writer = :old.member_id and private_yn = 'Y';
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

