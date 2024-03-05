--------------------------------------------------------
--  파일이 생성됨 - 월요일-3월-04-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table T_MEMBER
--------------------------------------------------------

  CREATE TABLE "SCOTT"."T_MEMBER" 
   (	"MEMBERSEQ" NUMBER(4,0), 
	"MEMBERID" VARCHAR2(20 BYTE), 
	"MEMBERPASSWD" VARCHAR2(20 BYTE), 
	"MEMBERNAME" VARCHAR2(20 BYTE), 
	"MEMBERPHONE" VARCHAR2(20 BYTE), 
	"MEMBERADDRESS" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON COLUMN "SCOTT"."T_MEMBER"."MEMBERSEQ" IS '회원SEQ';
   COMMENT ON COLUMN "SCOTT"."T_MEMBER"."MEMBERID" IS '회원아이디';
   COMMENT ON COLUMN "SCOTT"."T_MEMBER"."MEMBERPASSWD" IS '비밀번호';
   COMMENT ON COLUMN "SCOTT"."T_MEMBER"."MEMBERNAME" IS '회원명';
   COMMENT ON COLUMN "SCOTT"."T_MEMBER"."MEMBERPHONE" IS '휴대폰';
   COMMENT ON COLUMN "SCOTT"."T_MEMBER"."MEMBERADDRESS" IS '주소';
   COMMENT ON TABLE "SCOTT"."T_MEMBER"  IS '회원';
--------------------------------------------------------
--  DDL for Table T_POLLSUB
--------------------------------------------------------

  CREATE TABLE "SCOTT"."T_POLLSUB" 
   (	"POLLSUBSEQ" NUMBER(38,0), 
	"ANSWER" VARCHAR2(100 BYTE), 
	"ACOUNT" NUMBER(4,0), 
	"POLLSEQ" NUMBER(4,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON COLUMN "SCOTT"."T_POLLSUB"."POLLSUBSEQ" IS '답변항목SEQ';
   COMMENT ON COLUMN "SCOTT"."T_POLLSUB"."ANSWER" IS '답변항목';
   COMMENT ON COLUMN "SCOTT"."T_POLLSUB"."ACOUNT" IS '답변항목선택수';
   COMMENT ON COLUMN "SCOTT"."T_POLLSUB"."POLLSEQ" IS '설문SEQ';
   COMMENT ON TABLE "SCOTT"."T_POLLSUB"  IS '설문항목';
--------------------------------------------------------
--  DDL for Table T_POLL
--------------------------------------------------------

  CREATE TABLE "SCOTT"."T_POLL" 
   (	"POLLSEQ" NUMBER(4,0), 
	"QUESTION" VARCHAR2(256 BYTE), 
	"SDATE" DATE, 
	"EDATE" DATE, 
	"ITEMCOUNT" NUMBER(1,0) DEFAULT 1, 
	"POLLTOTAL" NUMBER(4,0), 
	"REGDATE" DATE DEFAULT sysdate, 
	"MEMBERSEQ" NUMBER(4,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON COLUMN "SCOTT"."T_POLL"."POLLSEQ" IS '설문SEQ';
   COMMENT ON COLUMN "SCOTT"."T_POLL"."QUESTION" IS '질문';
   COMMENT ON COLUMN "SCOTT"."T_POLL"."SDATE" IS '시작일';
   COMMENT ON COLUMN "SCOTT"."T_POLL"."EDATE" IS '종료일';
   COMMENT ON COLUMN "SCOTT"."T_POLL"."ITEMCOUNT" IS '답변항목수';
   COMMENT ON COLUMN "SCOTT"."T_POLL"."POLLTOTAL" IS '총참여수';
   COMMENT ON COLUMN "SCOTT"."T_POLL"."REGDATE" IS '작성일';
   COMMENT ON COLUMN "SCOTT"."T_POLL"."MEMBERSEQ" IS '작성자(회원SEQ)';
   COMMENT ON TABLE "SCOTT"."T_POLL"  IS '설문조사';
--------------------------------------------------------
--  DDL for Table T_VOTER
--------------------------------------------------------

  CREATE TABLE "SCOTT"."T_VOTER" 
   (	"VECTORSEQ" NUMBER, 
	"USERNAME" VARCHAR2(20 BYTE), 
	"REGDATE" DATE, 
	"POLLSEQ" NUMBER(4,0), 
	"POLLSUBSEQ" NUMBER(38,0), 
	"MEMBERSEQ" NUMBER(4,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON COLUMN "SCOTT"."T_VOTER"."VECTORSEQ" IS '투표SEQ';
   COMMENT ON COLUMN "SCOTT"."T_VOTER"."USERNAME" IS '사용자이름';
   COMMENT ON COLUMN "SCOTT"."T_VOTER"."REGDATE" IS '투표일';
   COMMENT ON COLUMN "SCOTT"."T_VOTER"."POLLSEQ" IS '설문SEQ';
   COMMENT ON COLUMN "SCOTT"."T_VOTER"."POLLSUBSEQ" IS '답변항목SEQ';
   COMMENT ON COLUMN "SCOTT"."T_VOTER"."MEMBERSEQ" IS '회원SEQ';
   COMMENT ON TABLE "SCOTT"."T_VOTER"  IS '투표자';
--------------------------------------------------------
--  DDL for Index PK_T_MEMBER
--------------------------------------------------------

  CREATE UNIQUE INDEX "SCOTT"."PK_T_MEMBER" ON "SCOTT"."T_MEMBER" ("MEMBERSEQ") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index PK_T_POLLSUB
--------------------------------------------------------

  CREATE UNIQUE INDEX "SCOTT"."PK_T_POLLSUB" ON "SCOTT"."T_POLLSUB" ("POLLSUBSEQ") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index PK_T_POLL
--------------------------------------------------------

  CREATE UNIQUE INDEX "SCOTT"."PK_T_POLL" ON "SCOTT"."T_POLL" ("POLLSEQ") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index PK_T_VOTER
--------------------------------------------------------

  CREATE UNIQUE INDEX "SCOTT"."PK_T_VOTER" ON "SCOTT"."T_VOTER" ("VECTORSEQ") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table T_MEMBER
--------------------------------------------------------

  ALTER TABLE "SCOTT"."T_MEMBER" ADD CONSTRAINT "PK_T_MEMBER" PRIMARY KEY ("MEMBERSEQ")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "SCOTT"."T_MEMBER" MODIFY ("MEMBERID" NOT NULL ENABLE);
  ALTER TABLE "SCOTT"."T_MEMBER" MODIFY ("MEMBERSEQ" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table T_POLLSUB
--------------------------------------------------------

  ALTER TABLE "SCOTT"."T_POLLSUB" ADD CONSTRAINT "PK_T_POLLSUB" PRIMARY KEY ("POLLSUBSEQ")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "SCOTT"."T_POLLSUB" MODIFY ("POLLSEQ" NOT NULL ENABLE);
  ALTER TABLE "SCOTT"."T_POLLSUB" MODIFY ("ANSWER" NOT NULL ENABLE);
  ALTER TABLE "SCOTT"."T_POLLSUB" MODIFY ("POLLSUBSEQ" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table T_POLL
--------------------------------------------------------

  ALTER TABLE "SCOTT"."T_POLL" ADD CONSTRAINT "PK_T_POLL" PRIMARY KEY ("POLLSEQ")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "SCOTT"."T_POLL" MODIFY ("REGDATE" NOT NULL ENABLE);
  ALTER TABLE "SCOTT"."T_POLL" MODIFY ("ITEMCOUNT" NOT NULL ENABLE);
  ALTER TABLE "SCOTT"."T_POLL" MODIFY ("EDATE" NOT NULL ENABLE);
  ALTER TABLE "SCOTT"."T_POLL" MODIFY ("SDATE" NOT NULL ENABLE);
  ALTER TABLE "SCOTT"."T_POLL" MODIFY ("QUESTION" NOT NULL ENABLE);
  ALTER TABLE "SCOTT"."T_POLL" MODIFY ("POLLSEQ" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table T_VOTER
--------------------------------------------------------

  ALTER TABLE "SCOTT"."T_VOTER" ADD CONSTRAINT "PK_T_VOTER" PRIMARY KEY ("VECTORSEQ")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "SCOTT"."T_VOTER" MODIFY ("VECTORSEQ" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table T_POLLSUB
--------------------------------------------------------

  ALTER TABLE "SCOTT"."T_POLLSUB" ADD CONSTRAINT "FK_T_POLL_TO_T_POLLSUB" FOREIGN KEY ("POLLSEQ")
	  REFERENCES "SCOTT"."T_POLL" ("POLLSEQ") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table T_POLL
--------------------------------------------------------

  ALTER TABLE "SCOTT"."T_POLL" ADD CONSTRAINT "FK_T_MEMBER_TO_T_POLL" FOREIGN KEY ("MEMBERSEQ")
	  REFERENCES "SCOTT"."T_MEMBER" ("MEMBERSEQ") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table T_VOTER
--------------------------------------------------------

  ALTER TABLE "SCOTT"."T_VOTER" ADD CONSTRAINT "FK_T_MEMBER_TO_T_VOTER" FOREIGN KEY ("MEMBERSEQ")
	  REFERENCES "SCOTT"."T_MEMBER" ("MEMBERSEQ") ENABLE;
  ALTER TABLE "SCOTT"."T_VOTER" ADD CONSTRAINT "FK_T_POLLSUB_TO_T_VOTER" FOREIGN KEY ("POLLSUBSEQ")
	  REFERENCES "SCOTT"."T_POLLSUB" ("POLLSUBSEQ") ENABLE;
  ALTER TABLE "SCOTT"."T_VOTER" ADD CONSTRAINT "FK_T_POLL_TO_T_VOTER" FOREIGN KEY ("POLLSEQ")
	  REFERENCES "SCOTT"."T_POLL" ("POLLSEQ") ENABLE;
      
--------------------------------------------------------------------------------
SELECT * FROM t_member;
SELECT * FROM t_poll;
SELECT * FROM t_pollsub;
SELECT * FROM t_voter;

1) 회원 가입/수정/탈퇴 쿼리..
DESC T_MEMBER;
이름            널?       유형            
------------- -------- ------------- 
MEMBERSEQ     NOT NULL NUMBER(4)       PK
MEMBERID      NOT NULL VARCHAR2(20)  
MEMBERPASSWD           VARCHAR2(20)  
MEMBERNAME             VARCHAR2(20)  
MEMBERPHONE            VARCHAR2(20)  
MEMBERADDRESS          VARCHAR2(100) 

  ㄱ. T_MEMBER  -> PK 확인.
SELECT *  
FROM user_constraints  
WHERE table_name LIKE 'T_M%'  AND constraint_type = 'P';
    
  ㄴ.  회원가입
  시퀀스(sequence)  자동으로 번호 발생시키는 객체 == 은행 (번호)
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  1,         'admin', '1234',  '관리자', '010-1111-1111', '서울 강남구' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  2,         'hong', '1234',  '홍길동', '010-1111-1112', '서울 동작구' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  3,         'kim', '1234',  '김기수', '010-1111-1341', '경기 남양주시' );
    COMMIT;
  ㄷ. 회원 정보 조회
  SELECT * 
  FROM t_member;
  
  ㄹ. 회원 정보 수정
  로그인 -> (홍길동) -> [내 정보] -> 내 정보 보기 -> [수정] -> [이름][][][][][][] -> [저장]
  PL/SQL
  UPDATE T_MEMBER
  SET    MEMBERNAME = , MEMBERPHONE = 
  WHERE MEMBERSEQ = 2;
  ㅁ. 회원 탈퇴
  DELETE FROM T_MEMBER 
  WHERE MEMBERSEQ = 2;
  
--------------------------------------------------------------------------------
1) 회원 가입/수정/탈퇴 쿼리..    
   ㄱ. 관리자로 로그인         
   ㄴ. [설문작성] 메뉴 선택
   ㄷ. 설문 작성 페이지로 이동...
   INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 1  ,'좋아하는 여배우?'
                          , TO_DATE( '2024-02-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-02-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 5
                          , 0
                          , TO_DATE( '2023-01-15 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
    ㄹ. 설문 항목                  
 
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (1 ,'배슬기', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (2 ,'김옥빈', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (3 ,'아이유', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (4 ,'김선아', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (5 ,'홍길동', 0, 1 );      
   COMMIT;
--
   ㄷ. 설문 작성 페이지로 이동...
   INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 3  ,'좋아하는 색?'
                          , TO_DATE( '2024-03-25 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-04-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 3
                          , 0
                          , TO_DATE( '2024-03-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
    ㄹ. 설문 항목                  
 
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (10 ,'빨강', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (11 ,'녹색', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (12 ,'파랑', 0, 3 );

   
   COMMIT;
--
SELECT *
FROM t_poll;
SELECT *
FROM t_pollsub; 
 
   설문 수정, 설문 삭제 query
 
 11:03 수업...
--------------------------------------------------------------------------------
3) 회원이 로그인했습니다.     [ 설문목록페이지  ]
   2 설문 : 좋아하는 과목 "제목" 클릭
SELECT *
FROM t_member;   
  --> 3   kim   1234   김기수 (인증)
SELECT *
FROM (
    SELECT  pollseq 번호, question 질문, membername 작성자
         , sdate 시작일, edate 종료일, itemcount 항목수, polltotal 참여자수
         , CASE 
              WHEN  SYSDATE > edate THEN  '종료'
              WHEN  SYSDATE BETWEEN  sdate AND edate THEN '진행 중'
              ELSE '시작 전'
           END 상태 -- 추출속성   종료, 진행 중, 시작 전
    FROM t_poll p JOIN  t_member m ON m.memberseq = p.memberseq
    ORDER BY 번호 DESC
) t 
WHERE 상태 != '시작 전';  

--------------------------------------------------------------------------------  
3)  3(김기수) 로그인 상태 +  2번 설문 참여..( 좋아하는 과목 ) [ 투표 페이지 ]
   업무 프로세스 
   설문 목로페이지에서 설문참여하기 위해서 2번 질문을 클릭
   [설문 보기 페이지]
   1) 2번 설문의 내용이 SELECT-> 출력
       ㄱ. 설문내용 
           질문, 작성자, 작성일, 시작일, 종료일, 상태, 항목수 조회
           SELECT question, membername
               , TO_CHAR(regdate, 'YYYY-MM-DD AM hh:mi:ss')
               , TO_CHAR(sdate, 'YYYY-MM-DD')
               , TO_CHAR(edate, 'YYYY-MM-DD')
               , CASE 
                  WHEN  SYSDATE > edate THEN  '종료'
                  WHEN  SYSDATE BETWEEN  sdate AND edate THEN '진행 중'
                  ELSE '시작 전'
               END 상태
               , itemcount
           FROM t_poll p JOIN t_member m ON p.memberseq = m.memberseq
           WHERE pollseq = 2;
       ㄴ. 설문항목
           SELECT answer
           FROM t_pollsub
           WHERE pollseq = 2;
   2) 총참여자수 7명
      배 []
      .  []
      .  []
    -- 2번 설문의 총참여자수   
    SELECT  polltotal  
    FROM t_poll
    WHERE pollseq = 2;
    -- 
    SELECT answer, acount
        , ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) totalCount
        -- ,  막대그래프
        , ROUND (acount /  ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) * 100) || '%'
     FROM t_pollsub
    WHERE pollseq = 2;
  
  3) [ 투표하기 ] 버튼 클릭
     - 2질문의 항목을 선택을 해야된다. 
    자바
    오라클 (체크)  PK 7  ( 질문항목  PK 값인 7을 선택)
    HTML5
    JSP
    
    SELECT *
    FROM t_voter;
    -- (1) t_voter
    INSERT INTO t_voter 
    ( vectorseq, username, regdate, pollseq, pollsubseq, memberseq )
    VALUES
    (      1   ,  '김기수'      , SYSDATE,   2  ,     7 ,        3 );
    COMMIT;
    
    -- 1)         2/3 자동 UPDATE  [트리거]
    -- (2) t_poll   totalCount = 1증가
    UPDATE   t_poll
    SET polltotal = polltotal + 1
    WHERE pollseq = 2;
    
    -- (3)t_pollsub   account = 1증가
    UPDATE   t_pollsub
    SET acount = acount + 1
    WHERE  pollsubseq = 7;
    
    commit;
    
    SELECT *
    FROM t_poll;      
        
    SELECT *
    FROM t_pollsub;     



CREATE SEQUENCE 시퀀스명
[ INCREMENT BY 정수] -- 증가값
[ START WITH 정수]   -- 시작값
[ MAXVALUE n ? NOMAXVALUE]  -- 최대값
[ MINVALUE n ? NOMINVALUE]  -- 최소값
[ CYCLE ? NOCYCLE]          -- 사이클
[ CACHE n ? NOCACHE];       

-- dept테이블에서 사용할 시퀀스 생성
SELECT *
FROM dept;
-- 시퀀스 설정할 때 해당하는 속성의 범위를 생각해서 MAX값 설정

CREATE SEQUENCE SEQ_dept 
INCREMENT BY 10 
START WITH 50 
MAXVALUE 90 
MINVALUE 1 
NOCYCLE NOCACHE;

CREATE SEQUENCE SEQ_test INCREMENT BY 10 START WITH 50;
SELECT *
FROM user_sequences;

DROP SEQUENCE seq_dept;
-- NEXTVAL를 먼저 사용하고 CURRVAL를 사용해야 에러가 떨어지지 않는다.
--ORA-08002: sequence SEQ_DEPT.CURRVAL is not yet defined in this session
--08002. 00000 -  "sequence %s.CURRVAL is not yet defined in this session"
--*Cause:    sequence CURRVAL has been selected before sequence NEXTVAL
--*Action:   select NEXTVAL from the sequence before selecting CURRVAL
SELECT seq_dept.CURRVAL
FROM dual;


INSERT INTO dept (deptno, dname, loc ) VALUES ( seq_dept.NEXTVAL, 'QC', '서울' );

INSERT INTO dept (deptno, dname, loc ) VALUES ( seq_dept.NEXTVAL, 'QC2', '포항' );

DESC dept;

SELECT seq_dept.NEXTVAL, seq_dept.CURRVAL
FROM dual;

SELECT *
FROM dept;

DELETE FROM dept
WHERE deptno >= 50;
COMMIT;

PL/SQL = Procedural Language (절차적인 언어) 확장된 SQL
         상수, 변수, 프로시저, 함수, 제어문 사용
PL/SQL은 블럭 구조의 언어이다. - 3가지 블럭이 있다.
 1) 선언 블럭 : DECLARE문 
 2) 실행 블럭 : BEGIN문
 3) 예외 처리 블럭 : EXCEPTION문
 
DECLARE(생략가능)
    -- 선언 블럭 : DECLARE문 
BEGIN
    -- 실행 블럭 : BEGIN문
    /* */ : PL/SQL의 블럭 안에서는 자바처럼 여러개의 주석처리 가능
    
    SELECT 문;
    INSERT 문;
    SELECT 문;
    UPDATE 문;
    DELETE 문;
    SELECT 문;
    COMMIT;
EXCEPTION(생략가능)
    -- 예외 처리 블럭 : EXCEPTION문
END;


DESC emp;

DBMS_output 패키지
PUT
PUT_LINE


PL/SQL의 5가지 종류
1) 익명 프로시저 (anonymous procedure) : DECLARE로 시작하는 프로시저
-- 사원번호가 7369인 사원의 이름, pay를 얻어와서 변수에 저장하고 출력
DECLARE
   --변수, 상수 선언하는 블럭
   --변수라서 이름앞에 v를 붙인다.(vename)
   -- BIGIN에서 선언된 쿼리의 결과값을 DECLARE에 선언된 변수에 저장 SMITH 800
--   vename VARCHAR2(10);
   -- 테이블 구조가 자주 변경될 때 TYPE형 변수로 선언해서 사용
   vename emp.ename%TYPE; -- TYPE형 변수로 선언 emp테이블의 ename의 자료형을 가져와서 변수로 선언
   vpay NUMBER;
   -- 오라클에서 상수 선언 CONSTANT
   -- 오라클에서 대입연산자 := 
   vpi CONSTANT NUMBER := 3.141592;
BEGIN
--    vpay := 0;
    SELECT ename, sal + NVL(comm, 0) pay
        INTO vename, vpay -- INTO구문으로 변수에 값을 할당
    FROM emp
    WHERE empno = 7369;
     -- 오라클에서 출력할수있는 형식DBMS_OUTPUT.PUT_LINE()
     -- 보기(v)에서 DBMS 출력눌러서 SCOTT으로 접속한 다음 출력하면 자바 console창처럼 나온다.
--    DBMS_OUTPUT.PUT_LINE('Hello World');
      DBMS_OUTPUT.PUT_LINE(vename || ' ' || vpay || ' ' || vpi);
    
--EXCEPTION
END;

SELECT *
FROM emp;

DECLARE
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vpay   NUMBER;

BEGIN
    SELECT empno, ename, sal
        INTO vempno, vename, vpay
    FROM emp
    WHERE deptno = 10 AND sal = (SELECT MAX(sal) FROM emp WHERE deptno =10);
    
    DBMS_OUTPUT.PUT_LINE(vempno || ' ' || vename || ' ' || vpay );
END;
    
변수값 지정 방법  
방법1) := 연산자에 의한 지정 
 예) 
   vpi CONSTANT NUMBER := 3.141592;
   bonus := current_salary*0.10; 
   amount := TO_NUMBER(SUBSTR('750 dollars',1,3)); 
   valid := FALSE; 
   
방법2) select나 fetch에 의해서 변수값 지정 
다음은 emp 테이블에서 sal을 select하여 10%의 보너스를 오라클이 계산하는 예이다. 
 예) 
   SELECT sal * 0.10 INTO bonus FROM emp WHERE empno=emp_id; 

-- 문제 : dept테이블에서 30번 부서의 부서명을 얻어와서 출력하는 익명 프로시저를 작성

DECLARE
   vdname dept.dname%TYPE;
BEGIN
    SELECT dname
        INTO vdname
    FROM dept
    WHERE deptno = 30;
    
    DBMS_OUTPUT.PUT_LINE( '부서명 : ' || vdname );
--EXCEPTON
END;



DECLARE
    vdname dept.dname%TYPE;
    vloc dept.loc%TYPE;
BEGIN
    SELECT loc
        INTO vloc
    FROM dept
    WHERE deptno = 30;
    
    UPDATE dept
    SET loc = vloc
    WHERE deptno = 10;
END;

ROLLBACK;

SELECT *
FROM dept;
-- 문제 : 30번 부서의 지역명을 얻어와서 10번 부서의 지역명으로 설정

DECLARE 
    vloc dept.loc%TYPE;
BEGIN
    SELECT loc
        INTO vloc
    FROM dept
    WHERE deptno = 30;

    UPDATE dept
    SET loc = vloc
    WHERE deptno = 10;
    DBMS_OUTPUT.PUT_LINE( '지역명 : ' || vloc ); 
--EXCEPTON
END;

ROLLBACK;

SELECT *
FROM emp;

-- 문제 10번 부서원 중에 최고급여를 받는 사원의 정보를 출력

[1] 번 풀이
DECLARE
    vename emp.ename%TYPE;
    vempno emp.empno%TYPE;
    vsal   emp.sal%TYPE;
    vdeptno emp.deptno%TYPE;
BEGIN 
    SELECT ename, empno, sal+NVL(comm, 0) sal, deptno
        INTO vename, vempno, vsal, vdeptno
    FROM emp
    WHERE deptno = 10 AND sal+NVL(comm, 0) = (
    SELECT MAX(sal + NVL(comm, 0)) sal
    FROM emp
    WHERE deptno = 10
    );
    
    DBMS_OUTPUT.PUT_LINE( vename || ' ' || vempno || ' ' || vsal || ' ' || vdeptno);
END;

[2] 번 풀이
DECLARE
    vename emp.ename%TYPE;
    vempno emp.empno%TYPE;
    vjob emp.job%TYPE;
    vmgr emp.mgr%TYPE;
    vhiredate emp.hiredate%TYPE;
    vsal   emp.sal%TYPE;
    vdeptno emp.deptno%TYPE;
BEGIN 
    
    WITH t AS (
    SELECT ename
        ,empno
        ,job
        ,mgr
        ,hiredate
        ,sal + NVL(comm, 0) sal 
        ,deptno
        ,RANK() OVER(ORDER BY sal+NVL(comm, 0) DESC) RANK
    FROM emp
    WHERE deptno = 10
    )
    SELECT t.ename, t.empno, t.job, t.mgr, t.hiredate, t.sal, t.deptno
        INTO vename, vempno, vjob, vmgr, vhiredate, vsal, vdeptno
    FROM t
    WHERE t.rank = 1;
    
    
    DBMS_OUTPUT.PUT_LINE( vename || ' ' || vempno || ' ' || 
    vjob || ' ' || vmgr || ' ' || vhiredate || ' ' || vsal || ' ' || vdeptno);
END;

[3]번 풀이
DECLARE
  vmax_sal_10 emp.sal%TYPE;
  vemp_row.emp%ROWTYPE;
BEGIN
  SELECT MAX(sal) INTO vmax_sal_10
  FROM emp
  WHERE deptno = 10;
  
  SELECT empno, ename, job, sal, hiredate, deptno
   INTO  vemp_row.empno, vename_row.ename, vjob_row.job, vsal_row.sal, vhiredate_row.hiredate, vdeptno_rwo.deptno
  FROM emp
  WHERE deptno = 10 AND sal = vmax_sal_10;
  
  DBMS_OUTPUT.PUT_LINE( '사원번호 :'  || vempno );
  DBMS_OUTPUT.PUT_LINE( '사원명 :'    || vename );
  DBMS_OUTPUT.PUT_LINE( '입사일자 :'  || vhiredate );
-- EXCEPTION
END;

-- insa테이블에서 1001번의 이름과 pay를 출력
-- 커서
DECLARE
    vname insa.name%TYPE := '익명';
    vpay NUMBER := 0;
    vmessage VARCHAR2(100);
BEGIN
    -- PL/SQL에서 여러개의 행을 처리할 때는 반드시 "커서"를 사용해야 한다. (암기)
    SELECT name, basicpay + sudang pay
        INTO vname, vpay
    FROM insa;
--    WHERE num = 1001;
    
    vmessage := vname || +  ', ' || vpay;
    DBMS_OUTPUT.PUT_LINE(vmessage);
--EXCEPTION
END;
--오류 보고 -
--ORA-06550: line 12, column 14:
--PL/SQL: ORA-00933: SQL command not properly ended
--ORA-06550: line 7, column 5:
--PL/SQL: SQL Statement ignored
--06550. 00000 -  "line %s, column %s:\n%s"
--*Cause:    Usually a PL/SQL compilation error.

-- 1) 익명 프로시저 + 대입연산자 ( := ) , 제어문
DECLARE
    a NUMBER :=1;
    b NUMBER := 1;
    c NUMBER := 0;
BEGIN
    c := a + b;
    
    DBMS_OUTPUT.PUT_LINE( c );
END;

-- PL/SQL문 안에서 사용하는 제어문의 종류
자바에서의 if문
if(){}
if(){}else{}
if(){}else if(){}else{}

--오라클에서의 IF문 == 자바 if(){}문
IF 조건식 THEN
END IF;

--오라클에서의 IF ELSE == 자바 if(){}else{}
IF 조건식 THEN
ELSE
END IF;

--오라클에서 IF ELSE IF == 자바 if(){}else if(){} else{}
IF 조건식 THEN
ELSIF 조건식 THEN
ELSIF 조건식 THEN
ELSIF 조건식 THEN
ELSE
END IF;

-- 만약 프로시저 테스트 할때는 새창 접속해서 1번라인부터 시작
-- 문제) 하나의 정수를입력받아서 홀수 / 짝수라고 출력...(익명 프로시저)


DECLARE
    vnum NUMBER := 0;
    vresult VARCHAR2(6);

BEGIN
    vnum := :bindNumber; 
    IF MOD(vnum, 2) = 0 THEN vresult := '짝수';  
    ELSE vresult := '홀수';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(vresult);
END;




DECLARE
    vnum NUMBER(2) := 0;
    vresult VARCHAR2(2 CHAR);
    
BEGIN
    vnum := :bindNumber; -- :바인딩변수명;
    IF MOD(vnum,2) = 0 
    THEN vresult := '짝수';--DBMS_OUTPUT.PUT_LINE('짝수');
    ELSE vresult := '홀수';--DBMS_OUTPUT.PUT_LINE('홀수');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(vresult);
--EXCEPTION
END;


-- 국어점수 입력받아서 수우미양가 등급출력 (익명프로시저)
[1]번 방법
DECLARE
    vkor NUMBER(3) := 0;
    vgrade VARCHAR2(1 CHAR);

BEGIN
    vkor := :bindNumber;
--    IF vkor >=90 AND vkor <= 100 THEN vgrade := '수';
    IF vkor BETWEEN 90 AND 100 THEN vgrade := '수';
    ELSIF vkor BETWEEN 80 AND 89 THEN vgrade := '우';
    ELSIF vkor BETWEEN 70 AND 79 THEN vgrade := '미';
    ELSIF vkor BETWEEN 60 AND 69 THEN vgrade := '양'; 
    ELSIF vkor BETWEEN 0 AND 59 THEN vgrade := '가';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(vgrade);
END;

DECLARE 
    vkor NUMBER(3) :=0;
    vgrade VARCHAR2(1 CHAR);
    
BEGIN
    vkor := :bindNumber;
    IF vkor < 0 OR vkor > 100 THEN DBMS_OUTPUT.PUT_LINE('0~100사이의 정수 입력해라');
    END IF;
    vkor := TRUNC(vkor / 10);
    IF vkor = 10 THEN vgrade := '수';
    ELSIF vkor = 9 THEN vgrade := '수';
    ELSIF vkor = 8 THEN vgrade := '우';
    ELSIF vkor = 7 THEN vgrade := '미';
    ELSIF vkor = 7 THEN vgrade := '양';
    ELSE vgrade := '가';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(vgrade);
END;
[2]번 방법
DECLARE
   vkor NUMBER(3) := 0;
   vgrade VARCHAR2(3) := '수';
BEGIN
   vkor := :bindNumber; -- 바인드변수
   IF  (vkor BETWEEN 90 AND 100) THEN   
     vgrade := '수';
   ELSIF vkor BETWEEN 80 AND 89 THEN   
     vgrade := '우';
   ELSIF vkor BETWEEN 70 AND 79 THEN
     vgrade := '미';
   ELSIF vkor BETWEEN 60 AND 69 THEN
     vgrade := '양';
   ELSIF vkor BETWEEN 0 AND 59 THEN
     vgrade := '가';
     -- 강제로 입력 잘못!! 예외 발생..
   END IF;
   DBMS_OUTPUT.PUT_LINE( vgrade );   
--EXCEPTION
END;

[3]번 방법
DECLARE
   vkor NUMBER(3) := 0;
   vgrade VARCHAR2(3) := '수';
BEGIN
   vkor := :bindNumber; -- 바인드변수
   IF vkor BETWEEN 0 AND 100 THEN
    vgrade := CASE TRUNC(vkor/10)
              WHEN 10 THEN '수'
              WHEN 9 THEN '수'
              WHEN 8 THEN '우'
              WHEN 7 THEN '미'
              WHEN 6 THEN '양'
              ELSE '가'
              END;
   ELSE
    DBMS_OUTPUT.PUT_LINE( '국어점수 0~100으로 입력해야합니다.');
    
   END IF;
   
   DBMS_OUTPUT.PUT_LINE(vgrade);
END;

-- 1) WHITE LOOF문
자바 while
while(조건식){
}

오라클 PL/SQL WHILE문
WHILE (조건식)LOOP

WHILE (조건식){
} END LOOP

-- -- 문제 1~10까지의 합 오라클에서 구해라(익명 프로시저 사용)
DECLARE
    vi NUMBER := 1;
    vsum NUMBER := 0;
BEGIN
    WHILE( vi <= 10 )
    LOOP
        IF vi = 10 THEN DBMS_OUTPUT.PUT(vi);
        ELSE
        DBMS_OUTPUT.PUT(vi || '+');
        END IF;
        vi := vi + 1;
        vsum := vsum + vi;
    END LOOP;
    
        DBMS_OUTPUT.PUT_LINE( ' = ' || vsum );
--EXCEPTION
END;

-- 2) LOOP END LOOP문
자바 무한루프 break;
while( true ){
 if (조건식) break;
}

-- 1~10까지 합 구하기 LOOP END LOOP문
DECLARE
    vi NUMBER := 1;
    vsum NUMBER := 0;
BEGIN
    LOOP
        IF vi = 10 THEN DBMS_OUTPUT.PUT(vi);
        ELSE
        DBMS_OUTPUT.PUT(vi || '+');
        END IF;
        vi := vi + 1;
        vsum := vsum + vi;
        EXIT WHEN vi = 10;
       
        
    END LOOP;
    
        DBMS_OUTPUT.PUT_LINE( ' = ' || vsum );
--EXCEPTION
END;

EXIT 조건식
END LOOP;


-- 3) FOR LOOP문
DECLARE
    vi NUMBER := 1;
    vsum NUMBER := 0;
BEGIN
   FOR i IN 1..10
   LOOP 
        IF i = 10 THEN DBMS_OUTPUT.PUT( i );
        ELSE DBMS_OUTPUT.PUT( i || '+' );
        END IF;
        vsum := vsum+i;
   END LOOP;
        DBMS_OUTPUT.PUT_LINE( ' = ' || vsum );
--EXCEPTION
END;


DECLARE
    vi NUMBER := 1;
    vsum NUMBER := 0;
BEGIN
   FOR i IN REVERSE 1..10
   LOOP 
        IF i = 1 THEN DBMS_OUTPUT.PUT( i );
        ELSE DBMS_OUTPUT.PUT( i || '+' );
        END IF;
        vsum := vsum+i;
   END LOOP;
        DBMS_OUTPUT.PUT_LINE( ' = ' || vsum );
--EXCEPTION
END;


-- FOR 문 LOOP를 통해 구구단 가로 출력

BEGIN
  FOR i IN 2..9 LOOP
    FOR j IN 1..9 LOOP
      DBMS_OUTPUT.PUT(i || ' * ' || j || ' = ' || (i * j) || '  ');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(''); -- 각 단의 끝에서 줄바꿈
  END LOOP;
END;

이렇게 풀었는데 혹시 for 문 푸신 분?

EXIT 조건식
END LOOP;


-- GOTO 문 ~~ GOTO문은 쓰지말자
--DECLARE (생략가능)
BEGIN
  --
  GOTO first_proc;

-- WHILE문 사용해서 구구단 가로로 출력
-- FOR문 사용해서 구구단 세로로 출력
DECLARE
    vi NUMBER := 1;
    vj NUMBER := 1;
BEGIN
    LOOP
        vj := vj+1;
        vi := 1;
    LOOP     DBMS_OUTPUT.PUT( vj || '*' || vi || ' = ' || vi * vj ||' ');    
        vi := vi+1;
        EXIT WHEN vi = 10; 
    END LOOP;
        EXIT WHEN vj = 10;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
--EXCEPTION
END;

-- WHILE루프는 처리방법 모르겠음(어려움)
--DECLARE
--    vnum NUMBER := 1;
--    vdan NUMBER := 1;
--BEGIN
--    WHILE ( vnum < 10 )
--    LOOP
--       vdan := vdan+1;
--       vnum := 1;
--    LOOP
--       DBMS_OUTPUT.PUT( vdan || '*' || vnum || ' = ' || vdan*vnum ||' ');
--    END LOOP;
--    END LOOP;
--END;        


--DECLARE 
--    vnum NUMBER := 1;
--    vdan NUMBER := 1;
BEGIN
    FOR i IN 2..9
    LOOP
    FOR j IN 1..9
    LOOP
    DBMS_OUTPUT.PUT_LINE( i || '*' || j || ' = ' || j * i);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE( '' );
    END LOOP;
END;

DECLARE
    vnum NUMBER := 1;
    vdan NUMBER := 1;
BEGIN
    FOR vnum IN 2..9
    LOOP
    FOR vdan IN 1..9
    LOOP
    DBMS_OUTPUT.PUT( vnum || ' * ' || vdan || ' = ' || RPAD(vnum*vdan, 4, ' ') || ' ');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE( ' ' );
    END LOOP;
END;

DECLARE
    vnum NUMBER := 1;
    vdan NUMBER := 1;
BEGIN 
    LOOP
    vnum := 1;
    vdan := vdan + 1;
    LOOP
    vnum := vnum+1;
    DBMS_OUTPUT.PUT_LINE( vnum || ' * ' || vdan || ' = ' || RPAD(vnum*vdan, 4, ' ') || ' ');  
    EXIT WHEN vnum = 9;
    END LOOP;
    EXIT WHEN vdan = 9;
    DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
END;
  --
  <<second_proc>>
  DBMS_OUTPUT.PUT_LINE('> 2 처리 ');
  GOTO third_proc; 
  -- 
  --
  <<first_proc>>
  DBMS_OUTPUT.PUT_LINE('> 1 처리 ');
  GOTO second_proc; 
  -- 
  --
  --
  <<third_proc>>
  DBMS_OUTPUT.PUT_LINE('> 3 처리 '); 
--EXCEPTION
END;
-- 고친 내용
-- 또 바꾼내용
2) 저장 프로시저 (stored procedure) : 대표적인 PL/SQL (가장 많이 사용되는 PL/SQL)
3) 저장 함수    (stored function )
4) 패키지       (package)
5) 트리거       (trigger)
