-------------------------------------------------------------------------
--회원테이블생성
-------------------------------------------------------------------------
CREATE TABLE MEMBER(
  MEMBERID VARCHAR2(15)
 ,PASSWORD VARCHAR2(300) NOT NULL
 ,MEMBERNAME  VARCHAR2(20) NOT NULL
 ,GENDER CHAR(1) NOT NULL
 ,AGE NUMBER
 ,EMAIL VARCHAR2(30)
 ,PHONE CHAR(11)  NOT NULL
 ,ADDRESS VARCHAR2(100)
 ,HOBBY VARCHAR2(50)
 ,ENROLLDATE DATE DEFAULT SYSDATE
 ,CONSTRAINT PK_MEMBERID PRIMARY KEY(MEMBERID)
 ,CONSTRAINT CK_MEMBER_GENDER CHECK(GENDER IN ('M','F'))
);

INSERT INTO SPRING.MEMBER VALUES ('abcde','1234','아무개','M',25,'abcde@naver.com','01012345678','서울시 강남구','운동,등산,독서',DEFAULT);
INSERT INTO SPRING.MEMBER VALUES ('qwerty','1234','김말년','F',30,'qwerty@naver.com','01098765432','서울시 관악구','운동,등산',DEFAULT);
INSERT INTO SPRING.MEMBER VALUES ('admin','1234','관리자','F',33,'admin@naver.com','01012345678','서울시 강남구','독서',DEFAULT);
COMMIT;



