-- SCOTT
create table tbl_emp(
    id number primary key, 
    name varchar2(10) not null,
    salary  number,
    bonus number default 100
    );
-- Table TBL_EMP이(가) 생성되었습니다.

insert into tbl_emp(id,name,salary) values(1001,'jijoe',150);
insert into tbl_emp(id,name,salary) values(1002,'cho',130);
insert into tbl_emp(id,name,salary) values(1003,'kim',140);
COMMIT;
select * 
from tbl_emp;


create table tbl_bonus
    (id number
    , bonus number default 100
    );
    
    
insert into tbl_bonus(id)
 (select e.id from tbl_emp e);
 
select * from tbl_bonus;

INSERT INTO tbl_bonus VALUES(1004, 50);
COMMIT;

MERGE INTO tbl_bonus b 
USING (SELECT id, salary FROM tbl_emp) e
ON (b.id = e.id) 
WHEN MATCHED THEN  --- 일치하면 UPDATE
    UPDATE SET b.bonus = b.bonus + e.salary * 0.01
WHEN NOT MATCHED THEN --- 일치하지 않으면 INSERT
    INSERT (b.id, b.bonus) VALUES(e.id, e.salary * 0.01)
;



CREATE TABLE tbl_merge1
    ( id NUMBER PRIMARY KEY
    , name VARCHAR2(20)
    , pay NUMBER
    , sudang NUMBER
    );

CREATE TABLE tbl_merge2
    ( id NUMBER PRIMARY KEY
    , sudang NUMBER
    );

INSERT INTO tbl_merge1 VALUES( 1, 'a', 100, 10);
INSERT INTO tbl_merge1 VALUES( 2, 'b', 150, 20);
INSERT INTO tbl_merge1 VALUES( 3, 'c', 130, 0);

INSERT INTO tbl_merge2 VALUES( 2, 5);
INSERT INTO tbl_merge2 VALUES( 3, 10);
INSERT INTO tbl_merge2 VALUES( 4, 20);

COMMIT;

SELECT *
--FROM tbl_merge1;
FROM tbl_merge2;

-- MERGE : tbl_merge1 ( 소스 ) -> tbl_merge2 ( 타겟 ) 병합
--              1                      INSERT
--              2, 3                   UPDATE
ROLLBACK;
MERGE INTO tbl_merge2 t2
USING (SELECT id, pay, sudang FROM tbl_merge1) t1
ON (t1.id = t2.id)
WHEN MATCHED THEN
    UPDATE SET t2.sudang = t2.sudang + t1.sudang
WHEN NOT MATCHED THEN
    INSERT (t2.id, t2.sudang) VALUES ( t1.id, t1.sudang)
    


-- 제약 조건( CONSTRAINT )
-- SCOTT 이 소유하고 있는 테이블 조회
SELECT *
FROM user_tables;

-- SCOTT이 소유하고 있는 제약조건 조회
SELECT *
FROM user_constraints
WHERE table_name  =  UPPER('emp');

-- 제약조건은 테이블에 INSERT / UPDATE / DELETE 할때의 규칙으로 사용 -> 데이터 무결성(올바른 데이터가 들어가도록)을 위해서
INSERT INTO dept VALUES( 10, 'QC', 'SEOUL' ); <- -- 개체 무결성에 위배

UPDATE emp
SET deptno = 90
WHERE empno = 7369; <- --integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found : 참조 무결성 위배

tbl_score
    kor  0~100 정수 제약조건

INSERT INTO tbl_score kor VALUES  ( 111 ) <- --도메인 무결성

-- 제약조건을 생성하는 시기에 따라
    ㄱ. CREATE TABLE 문 : 테이블 생성 + 제약조건 추가 / 삭제
        1. IN-LINE 제약조건     (= 컬럼 레벨 ) 제약조건 설정 방법
            - NOT NULL 제약조건 설정
            - 하나의 컬럼의 제약조건을 설정할 때
        2. OUT-OF-LINE 제약조건 (= 테이블 레벨) 제약조건 설정 방법   
            - 두개 이상의 컬럼의 제약조건을 설정할 때...
            [ 사원 급여 지급 테이블 ]
            급여 지급 날짜 + 회원 ID ==> PK로 설정(복합키)  2024/01/25+7369 
            순번을 추가해서 복합키 말고 순번을 PK로 사용하게 하는 방법( 역 정규화 )
            순번 급여 지급 날짜, 회원 ID, 급여액 ...
             1   2024/01/25     7369    3000000
             2   2024/01/25     7666    3000000
             3   2024/01/25     8223    3000000
            .
            .
             4   2024/02/25     7369    3000000
             5   2024/02/25     7666    3000000
             6   2024/02/25     8223    3000000
    ㄴ. ALTER TABLE 문 : 테이블 수정 + 제약조건 추가 / 삭제;
    

SELECT *
FROM emp
WHERE ename = 'KING';

UPDATE emp
SET deptno = NULL
WHERE empno = 7839;
COMMIT;


-- PK : 해당 컬럼 값은 반드시 존재해야 하고 유일해야 한다.( NOT NULL + UK 제약조건 합친 형태)
-- FK : 해당 컬럼값은 참조되는 테이블의 컬럼 값 중의 하나와 일치하거 NULL을 가짐
-- UK : 유일성 제약조건 (테이블 내에서 해당 컬럼값은 항상 유일해야한다. .. 주민등록번호, 전화번호 등등)

-- 실습) CREATE TABLE문에서 COLUMN LEVEL 방식으로 제약조건 설정하는 예
DROP TABLE tbl_constraint1;
CREATE TABLE tbl_constraint1
(
--    empno NUMBER(4) NOT NULL PRIMARY KEY  제약조건명 명시하지 않으면 SYS_XXXXXX로 기본값 잡힌다.
--    empno NUMBER(4) NOT NULL CONSTRAINT 제약조건_테이블명_컬럼명 PRIMARY KEY
    empno NUMBER(4) NOT NULL CONSTRAINT PK_tblconstraint1_empno PRIMARY KEY
    , ename VARCHAR2(20) NOT NULL                           --참조     dept테이블(deptno) // FK : 외래키(포린키), 참조키
    , deptno NUMBER(2) CONSTRAINT FK_tblconstraint1_deptno REFERENCES dept(deptno)
    , email VARCHAR2(150) CONSTRAINT UK_tblconstraint1_email UNIQUE
    , kor NUMBER(3) CONSTRAINT CK_tblconstraint1_kor CHECK( kor BETWEEN 0 AND 100 ) -- CHECK : 국어점수가 0점에서 100점사이인지(유효성 검사)
    , city VARCHAR2(20) CONSTRAINT CK_tblconstraint1_city CHECK( city IN ('서울', '대구', '대전'))
);

-- 제약조건의 비활성화 / 활성화
-- city 컬럼의 서울 대구 대전 체크제약조건 -> 부산을 추가하고 싶을 때

ALTER TABLE tbl_constraint1
DISABLE CONSTRAINT CK_TBLCONSTRAINT1_CITY; -- 제약조건 비 활성화
ENABLE CONSTRAINT CK_TBLCONSTRAINT1_CITY;  -- 제약조건 활성화



-- 제약조건의 삭제
SELECT *
FROM user_constraints
WHERE table_name LIKE '%CONSTR%';

ALTER TABLE tbl_constraint1
DROP PRIMARY KEY;

-- 제약조건 이름으로 삭제
ALTER TABLE tbl_constraint1
DROP CONSTRAINT 'PK_TBLCONSTRAINT1_EMPNO';
CASCADE 옵션 추가 : FK도 같이 삭제

-- 제약조건 이름으로 삭제
ALTER TABLE tbl_constraint1
DROP CONSTRAINT 'CK_TBLCONSTRAINT1_CITY';

ALTER TABLE tbl_constraint1
DROP UNIQUE(email);



-- 실습) CREATE TABLE 문에서 TABLE LEVEL 방식으로 제약조건 설정하는 예
CREATE TABLE tbl_constraint2
(
--    empno NUMBER(4) NOT NULL PRIMARY KEY  제약조건명 명시하지 않으면 SYS_XXXXXX로 기본값 잡힌다.
--    empno NUMBER(4) NOT NULL CONSTRAINT 제약조건_테이블명_컬럼명 PRIMARY KEY
    empno NUMBER(4) NOT NULL 
    , ename VARCHAR2(20) NOT NULL                           --참조     dept테이블(deptno) // FK : 외래키(포린키), 참조키
    , deptno NUMBER(2) 
    , email VARCHAR2(150)
    , kor NUMBER(3)
    , city VARCHAR2(20) 
    
--    , CONSTRAINT PK_tblconstraint1_empno PRIMARY KEY(empno,ename) -- 복합키로 PK설정 // 복합키는 TABLE LEVEL에서만 설정 가능하다.
    , CONSTRAINT PK_tblconstraint2_empno PRIMARY KEY(empno) -- NOT NULL은 COLUMN LEVEL에서만 설정가능하다. 
    , CONSTRAINT FK_tblconstraint2_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno) 
    , CONSTRAINT UK_tblconstraint2_email UNIQUE(email)
    , CONSTRAINT CK_tblconstraint2_kor CHECK( kor BETWEEN 0 AND 100 ) -- kor이 명시되어 있어서 따로 이름설정 하지 않아도 된다.
    , CONSTRAINT CK_tblconstraint2_city CHECK( city IN ('서울', '대구', '대전')) -- city가 명시되어 있어서 따로 이름설정 하지 않아도 된다.
);


DROP TABLE tbl_constraint1;
DROP TABLE tbl_constraint2;


-- 실습 3) ALTER TABLE 문에서 제약조건 설정하는 예
CREATE TABLE tbl_constraint3
(
    empno NUMBER(4) 
    , ename VARCHAR2(20)
    , deptno NUMBER(2)
    

);
-- Table TBL_CONSTRAINT3이(가) 생성되었습니다.

1) empno 컬럼에 PK 제약조건 추가..
-- ALTER TABLE 사용해서 제약조건 추가 형식
ALTER TABLE 테이블명
ADD [CONSTRAINT 제약조건명] 제약조건타입 (컬럼명);

ALTER TABLE tbl_constraint3
ADD CONSTRAINT PK_tblconstraint3_empno PRIMARY KEY(empno);

2) deptno 컬럼에 FK 제약조건 추가..
ALTER TABLE tbl_constraint3
ADD CONSTRAINT FK_tblconstraint3_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno);

DROP TABLE tbl_constraint3;



3) ON DELETE CASCADE / ON DELETE SET NULL 실습
CREATE TABLE tbl_emp
AS 
    (
    SELECT * FROM emp
    );


CREATE TABLE tbl_dept
AS 
    (
    SELECT * FROM dept
    );

DROP TABLE tbl_dept;

SELECT *
FROM tbl_emp;

ALTER TABLE tbl_emp
ADD CONSTRAINT PK_tblemp_empno PRIMARY KEY(empno);

ALTER TABLE tbl_dept
ADD CONSTRAINT PK_tbldept_deptno PRIMARY KEY(deptno);


ALTER TABLE tbl_emp
ADD CONSTRAINT FK_tblemp_deptno FOREIGN KEY(deptno) REFERENCES tbl_dept(deptno)
ON DELETE CASCADE;

SELECT *
FROM tbl_dept;

SELECT *
FROM tbl_emp;

DELETE FROM tbl_dept
WHERE deptno = 30;

DROP TABLE tbl_dept;
DROP TABLE tbl_score;


ALTER TABLE tbl_emp
ADD CONSTRAINT pk_tblemp_deptno FOREIGN KEY(deptno)
                                REFERENCES tbl_dept(deptno)
                                ON DELETE SET NULL;
                                

-- JOIN(조인)연습
CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- 책ID
      ,title      VARCHAR2(100) NOT NULL  -- 책 제목
      ,c_name  VARCHAR2(100)    NOT NULL     -- c 이름
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK이(가) 생성되었습니다.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '데이터베이스', '서울');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '데이터베이스', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '운영체제', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '운영체제', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '워드', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '엑셀', '대구');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '파워포인트', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '엑세스', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '엑세스', '서울');

COMMIT;

SELECT *
FROM book;



-- 단가테이블( 책의 가격 )
CREATE TABLE danga(
       b_id  VARCHAR2(10)  NOT NULL  -- PK , FK   (식별관계 ***)
      ,price  NUMBER(7) NOT NULL    -- 책 가격
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- Table DANGA이(가) 생성되었습니다.
-- book  - b_id(PK), title, c_name
-- danga - b_id(PK,FK), price 
 
INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT; 

SELECT *
FROM danga; 



-- 책을 지은 저자테이블
 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '저팔개');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '손오공');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '사오정');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '김유신');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '유관순');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '김하늘');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '심심해');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '허첨');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '이한나');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '정말자');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '이영애');

COMMIT;

SELECT * 
FROM au_book;


-- 출판사에서 서점(고객)으로 책을 판매하는 가정
 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

 INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '우리서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '도시서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '지구서점', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '서울서점', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '수도서점', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '강남서점', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '강북서점', '777-7777');

COMMIT;

SELECT *
FROM gogaek;



--  판매 테이블
 CREATE TABLE panmㄴㄴai(
       id         ㄹㄴㅇㄻㄴㅇㄹ(5) NOT NULL PRIMARY KEY
      ,g_id       
      
      (5) NOT NULL CONSTRAINT FK_PANMAI_GID  -- 어떤 서점에게
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID   -- 어떤 책을
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE      -- 몇일날 판매
      ,p_su       NUMBER(5)  NOT NULL -- 수량(몇권)
);

INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;   


-- EQUI JOIN

-- 문제 : 책ID, 책 제목, 출판사, 단가 컬럼 출력
-- book : b_id, title, c_name
-- danga : b_id(PK,FK), [ price ]  
--  ㄱ. 오라클에선 natural join 이라고 부른다.
    SELECT book.b_id, title, c_name, price
    FROM book, danga
    WHERE book.b_id = danga.b_id; -- 조인 조건 -> equi 조인
    
--  ㄴ. 별칭 사용해서 equi 조인
    SELECT b.b_id, title, c_name, price
    FROM book b, danga d
    WHERE b.b_id = d.b_id; -- 조인 조건 -> equi 조인
    
--  ㄷ. JOIN - ON
    SELECT b.b_id, title, c_name, price
    FROM book b JOIN danga d ON b.b_id = d.b_id;

--  ㄹ. USING절 사용  :   b.b_id, book.b_id(이런형식 사용 불가)
    SELECT b_id, title, c_name, price
    FROM book JOIN danga USING(b_id);
    
--  ㅁ. NATURAL JOIN ==> ON b.b_id = d.b_id; 이 조건형식이 포함되어 있다.
    SELECT b_id, title, c_name, price
    FROM book NATURAL JOIN danga;
    
--  문제 :판매금액 출력

-- BOOK : 책 ID, 책 제목
-- DANGA : 책 ID, 단가
-- GOGAEK : 서점명
-- PANMA : 판매수량, 판매 수량 * 단가

SELECT *
FROM panmai;

SELECT *
FROM book;

SELECT *
FROM gogaek;

SELECT *
FROM danga;


1) 위의 ㄱ, ㄴ 방법 사용해서 풀기

SELECT book.b_id, title, price, g_name, p_su, p_su*price 판매금액
FROM panmai, book, danga, gogaek
WHERE panmai.b_id = danga.b_id AND panmai.g_id = gogaek.g_id AND danga.b_id = book.b_id
ORDER BY panmai.b_id;

SELECT b.b_id, title, price, g_name, p_su, p_su*price 판매금액
FROM panmai p , book b , danga d , gogaek g
WHERE p.b_id = d.b_id AND p.g_id = g.g_id AND d.b_id = b.b_id
ORDER BY p.b_id;


2) JOIN-ON 구문 풀기
SELECT b.b_id, title, price, g_name, p_su, p_su*price 판매금액
FROM panmai p JOIN book b   ON p.b_id = b.b_id 
              JOIN gogaek g ON p.g_id = g.g_id
              JOIN danga d  ON d.b_id = b.b_id;

              
3) USING절 사용해서 풀기
SELECT b_id, title, price, g_name, p_su, p_su*price 판매금액
FROM panmai   JOIN book    USING(b_id)
              JOIN gogaek  USING(g_id)
              JOIN danga   USING(b_id);
              
              
              
-- NONE EQUI JOIN 연습
-- 일정한 관계 X
-- BETWEEN A AND B

SELECT ename, sal, grade, losal || ' ~ ' || hisal lo_hi
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;

SELECT ename, sal, grade, losal || ' ~ ' || hisal lo_hi
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;


SELECT *
FROM emp;
SELECT *
FROM dept;

SELECT d.deptno, ename, hiredate
FROM emp e LEFT OUTER JOIN dept d ON e.deptno = d.deptno;

SELECT d.deptno, ename, hiredate
FROM emp e, dept d 
WHERE e.deptno(+) = d.deptno;

SELECT d.deptno, ename, hiredate
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno;

SELECT d.deptno, ename, hiredate
FROM emp e , dept d 
WHERE e.deptno = d.deptno(+);

SELECT d.deptno, ename, hiredate
FROM emp e ,dept d 
WHERE e.deptno(+) = d.deptno(+);


-- SELT JOIN
-- 사원번호, 사원명, 입사일자, 직속상사 사원번호, 직속상사의 사원명
SELECT m.empno, m.ename, m.hiredate, m.mgr, e.ename
FROM emp e,  emp m 
WHERE e.empno = m.mgr;


SELECT m.empno, m.ename, m.hiredate, m.mgr, e.ename
FROM emp e JOIN emp m ON e.empno = m.mgr;




-- CROSS JOIN
SELECT e.*, d.*
FROM emp e, dept d;



 문제) 책ID, 책제목, 판매수량, 단가, 서점명(고객), 판매금액(판매수량*단가) 출력 
 
 SELECT b.b_id, title, p_su, price, price*p_su "판매금액"
 FROM book b , panmai p , danga d , gogaek g
 WHERE b.b_id = p.b_id AND d.b_id = p.b_id AND g.g_id = p.g_id;
 
 
 문제) 출판된 책들이 각각 총 몇권이 판매되었는지 조회     
      (    책ID, 책제목, 총판매권수, 단가 컬럼 출력   )
 
  
       
 SELECT b.b_id, title, SUM(p_su), price
 FROM book b , panmai p , danga d , gogaek g
 WHERE b.b_id = p.b_id AND d.b_id = p.b_id AND g.g_id = p.g_id
 GROUP BY b.b_id, title, price;
   
    
 문제) 판매권수가 가장 많은 책 정보 조회 
 WITH s AS(
 SELECT b.b_id, title, SUM(p_su), RANK() OVER(ORDER BY SUM(p_su) DESC) "P_RANK", price
 FROM book b , panmai p , danga d , gogaek g
 WHERE b.b_id = p.b_id AND d.b_id = p.b_id AND g.g_id = p.g_id
 GROUP BY b.b_id, title, price
          ) 
 SELECT s.*
 FROM s
 WHERE s.p_rank = 1;
 
 문제) 올해 판매권수가 가장 많은 책(수량을 기준으로)
      (  책ID, 책제목, 수량 )
WITH t AS (      
         SELECT b.b_id, title, SUM(p_su) P_SU
            , RANK() OVER(ORDER BY SUM(p_su) DESC) rank
         FROM book b , panmai p , danga d , gogaek g
         WHERE b.b_id = p.b_id 
                                AND d.b_id = p.b_id 
                                AND g.g_id = p.g_id 
                                AND TO_CHAR(p_date, 'YYYY') = 2024 
         GROUP BY b.b_id, title, price
         ORDER BY p_su DESC
            )
SELECT t.*
FROM t
WHERE t.rank = 1;


 문제) book 테이블에서 판매가 된 적이 없는 책의 정보 조회

 SELECT b.b_id, title, price
 FROM book b, danga d
 WHERE  d.b_id = b.b_id AND b.b_id != ALL (
 
                             SELECT b.b_id
                             FROM book b , panmai p , danga d , gogaek g
                             WHERE b.b_id = p.b_id AND d.b_id = p.b_id AND g.g_id = p.g_id
                             GROUP BY b.b_id, title, price
                             
                                            );
  

                


SELECT *
FROM book;
-- 판매 X 책
-- b-2, e-1, f-2

-- 판매된 책 
--a-1, b-1, c-1, d-1, f-1, a-2
SELECT *
FROM panmai;

 문제) book 테이블에서 판매가 된 적이 있는 책의 정보 조회
      ( b_id, title, price  컬럼 출력 )
      
 SELECT b.b_id, title, price
 FROM book b, danga d
 WHERE  d.b_id = b.b_id AND b.b_id = ANY (
 
                                 SELECT b.b_id
                                 FROM book b , panmai p , danga d , gogaek g
                                 WHERE b.b_id = p.b_id AND d.b_id = p.b_id AND g.g_id = p.g_id
                                 GROUP BY b.b_id, title, price
                                        );
 
 문제) 고객별 판매 금액 출력 (고객코드, 고객명, 판매금액)
 
 SELECT g.g_id, g_name, SUM(p_su * price) "판매금액"
 FROM gogaek g JOIN panmai p ON g.g_id = p.g_id
               JOIN danga  d ON d.b_id = p.b_id
 GROUP BY g.g_id, g_name;
 
 
 
 문제) 년도, 월별 판매 현황 구하기  
    SELECT 
    TO_CHAR(p_date, 'YYYY') "년도별 판매"
    ,  TO_CHAR(p_date, 'MM') "월별 판매"
    , SUM(p_su*price)
    FROM book b , panmai p , danga d , gogaek g
    WHERE b.b_id = p.b_id AND d.b_id = p.b_id AND g.g_id = p.g_id
    GROUP BY  TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM') ;
    
 
SELECT *
FROM panmai;


-- 문제) 서점별 년도별 판매현황 구하기
    SELECT 
    g.g_id
    , g_name
    , TO_CHAR(p_date, 'YYYY') "년도"
    , SUM(p_su*price) "판매 금액"
    , SUM(p_su) "총판매 현황"
    FROM book b , panmai p , danga d , gogaek g
    WHERE b.b_id = p.b_id AND d.b_id = p.b_id AND g.g_id = p.g_id
    GROUP BY g.g_id, g_name, TO_CHAR(p_date, 'YYYY')
    ORDER BY g_name ;
    

-- 문제) 책의 총판매금액이 15000원 이상 팔린 책의 정보를 조회
--      ( 책ID, 제목, 단가, 총판매권수, 총판매금액 )
WITH t AS 
    (
     SELECT b.b_id, title, SUM(p_su) "총판매권수" ,SUM(p_su*price) "총판매금액", price
     FROM book b , panmai p , danga d , gogaek g
     WHERE b.b_id = p.b_id AND d.b_id = p.b_id AND g.g_id = p.g_id
     GROUP BY b.b_id, title, price
   )
SELECT t.*
FROM t
WHERE t.총판매금액 >= 15000;

SELECT b.b_id, title, SUM(p_su) "총판매권수" ,SUM(p_su*price) "총판매금액", price
FROM book b , panmai p , danga d , gogaek g
WHERE b.b_id = p.b_id AND d.b_id = p.b_id AND g.g_id = p.g_id
GROUP BY b.b_id, title, price
HAVING SUM(p_su*price) >= 15000;
