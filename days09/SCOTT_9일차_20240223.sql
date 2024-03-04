-- SCOTT
-- 오라클 자료형
-- CHAR 고정길이 2000byte
-- N + CHAR 고정길이 2000byte
-- VAR + CHAR2 가변길이 4000byte
-- N + VAR + CHAR2 가변길이 4000byte
-- LONG 2GB



-- 1) NUMBER [(p)[,s]]
--  p(정밀도) : 1~38 전체 자리수 (소수점 이하에서는 .0012 에서 00은 전체 자리수로 안보기 때문에 전체 자리수는 2개가 된다. )
--  s(규모)   : -84~127 소수점 이하 자리수
DESC dept;

INSERT INTO dept (deptno, dname, loc) VALUES ( 100, 'QC', '서울' );
INSERT INTO dept (deptno, dname, loc) VALUES ( -20, 'QC', '서울' );
ROLLBACK;

DEPTNO NUMBER(2) == NUMBER(2,0) == 2자리 정수 ==> -99 ~ 99 정수
KOR    NUMBER(3) == NUMBER(3,0) == 3자리 정수 ==> -999 ~ 999 정수

SELECT *
FROM dept;



-- 국어 점수를 랜덤하게 발생해서 저장
INSERT INTO 성적테이블 ( kor, eng, mat)
VALUES (SYS.dbms_random.value(0,100), SYS.dbms_random.value(0,100), SYS.dbms_random.value(0,100) );

SELECT *
FROM  tbl_score;

-- 학번(PK), 학생명, 국어, 영어, 수학, 총점, 평균, 등수
CREATE TABLE tbl_score
(
     no     NUMBER(2,0) PRIMARY KEY NOT NULL  -- PRIMARY KEY ==> NOT NULL과 UK(유일성 제약조건)가 같이 설정된다.
    ,name   VARCHAR2(30) NOT NULL  
    ,kor    NUMBER(3)
    ,eng    NUMBER(3)
    ,mat    NUMBER(3)
    ,tot    NUMBER(3)
    ,avg    NUMBER(5,2)
    ,rk     NUMBER(2)

);


INSERT INTO tbl_score ( no, name, kor, eng, mat ) VALUES ( 1, '홍길동', 90, 87, 88.89 );
--INSERT INTO tbl_score ( no, name, kor, eng, mat ) VALUES ( 2, '서영학', 990, -88, 65 );
INSERT INTO tbl_score ( no, name, kor, eng, mat ) VALUES ( 2, '서영학', 99, 88, 65 );
--INSERT INTO tbl_score ( no, name, kor, eng, mat ) VALUES ( 3, '김병훈', 1999, 68, 82 ); --  value larger than specified precision allowed for this column
INSERT INTO tbl_score ( no, name, kor, eng, mat ) VALUES ( 3, '김병훈', 19, 68, 82 );
COMMIT;
ROLLBACK;
DESC tbl_score;


UPDATE tbl_score
SET eng = 0
WHERE no = 2;
INSERT INTO tbl_score ( no, name, kor, eng, mat ) VALUES ( 2, '서영학', 99, 88, 65 );

UPDATE tbl_score
SET tot = kor + eng + mat, avg = (kor+eng+mat)/3, rk = 1;

UPDATE tbl_score p
SET p.rk = ( SELECT COUNT(*)+1 FROM tbl_score c WHERE c.tot > p.tot );



-- FLOAT(P) 숫자 자료형, 내부적으로 NUMBER 처리


-- 날짜 자료형
1) DATE      : 7바이트, 고정길이, 초 까지 저장
2) TIMESTAMP : 기본값 6 바이트( 초 아래 6자리 까지 ) 0 ~ 9 바이트 까지


-- 이진 데이터 자료     ???.png (이미지)를 101010101010101010 이진 데이터를 저장하고 싶을때
1) RAW(SIZE)  2000byte 까지 저장
2) LONG RAW   2GB 까지 저장


B + FILE    Binary 데이터를 외부에 file형태로 (264 -1바이트)까지 저장 
B + LOB    Binary 데이터를 4GB까지 저장 (4GB= (232 -1바이트)) 
C + LOB    Character 데이터를 4GB까지 저장 
NC + LOB    Unicode 데이터를 4GB까지 저장 

-- 집계함수 COUNT()를 single과 같이 사용하려면 COUNT() OVER() 사용하면 된다
SELECT buseo, name, basicpay
--    , COUNT(*) OVER(ORDER BY basicpay ASC)
    , COUNT(*) OVER(PARTITION BY buseo ORDER BY basicpay ASC) "1"
    , SUM(basicpay) OVER(ORDER BY basicpay ASC) "2"
    , (SELECT COUNT(*) FROM insa) "3"
    , SUM(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay ASC) "4"
    , AVG(basicpay) OVER(ORDER BY basicpay ASC) "5"
    , AVG(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay ASC) "6"
FROM insa;



-- 각 지역별 급여 평균
SELECT city, name, basicpay
--    , AVG(basicpay)
    , ROUND(AVG(basicpay) OVER( PARTITION BY city ORDER BY city ASC),2) "1"
    , basicpay - ROUND(AVG(basicpay) OVER( PARTITION BY city ORDER BY city ASC),2) "2"
FROM insa;



-- [ 테이블 생성, 수정, 삭제 ] + 테이블 레코드 추가, 수정, 삭제 

1) 테이블 ? : 데이터 저장소
2) DB 모델링 -> 테이블 생성
 예) 게시판의 게시글을 저장하기 위한 테이블 생성
    ㄱ. 테이블명 : tbl_board
    ㄴ. 논리적 컬럼명  물리적 컬럼명     자료형
        글번호 (PK)    seq            NUMBER P38 S127        NOT NULL
        작성자         wirter         VARCHAR2(20)           NOT NULL
        비밀번호       password       VARCHAR2(15)           NOT NULL
        제목          title          VARCHAR2(100)          NOT NULL
        내용          contente        CLOB
        작성일         regdate         DATE                 DEFAULT SYSDATE
        조회수         readno          NUMBER(100000000)    DEFAULT 0
        
        
        
        
        
【간단한형식】
    CREATE [GLOBAL TEMPORARY] TABLE [schema.] table
      ( 
        열이름  데이터타입 [DEFAULT 표현식] [제약조건] 
       [,열이름  데이터타입 [DEFAULT 표현식] [제약조건] ] 
       [,...]  
      ); 


ex)
-- TEMPORARY : 임시
--CREATE GLOBAL TEMPORARY TABLE tbl_board
--(
--
--    seq          NUMBER       NOT NULL PRIMARY KEY
--    ,writer      VARCHAR(20)  NOT NULL
--    ,passwd      VARCHAR(10)  NOT NULL
--    ,title       VARCHAR(100) NOT NULL
--    ,content     CLOB
--    ,regdate     DATE         DEFAULT SYSDATE
--
--);


CREATE TABLE tbl_board
(

    seq          NUMBER       NOT NULL PRIMARY KEY
    ,writer      VARCHAR(20)  NOT NULL
    ,passwd      VARCHAR(10)  NOT NULL
    ,title       VARCHAR(100) NOT NULL
    ,content     CLOB
    ,regdate     DATE         DEFAULT SYSDATE

);

DESC tbl_board;


-- 테이블 생성 : CREATE TABLE (DDL)
-- 테이블 삭제 : DROP TABLE (DDL)
-- 테이블 수정 : ALTER TABLE (DDL)
--? alter table ... add 컬럼, 제약조건 추가
--? alter table ... modify 컬럼 수정
--? alter table ... drop[constraint] 제약조건 삭제 
--? alter table ... drop column 컬럼 삭제

SELECT *
FROM tbl_board;

ROLLBACK;
INSERT INTO tbl_board (seq, writer, passwd, title, content, regdate)
VALUES (1, '홍길동', '1234', 'test-1', 'test-1', SYSDATE);

INSERT INTO tbl_board (seq, writer, passwd, title, content, regdate)
VALUES (2, '권맑음', '1234', 'test-2', 'test-2', SYSDATE);

INSERT INTO tbl_board 
VALUES (3, '김영진', '1234', 'test-3', 'test-3', SYSDATE);

INSERT INTO tbl_board (seq, writer, passwd, title, content)
VALUES (4, '이동찬', '1234', 'test-4', 'test-4');

INSERT INTO tbl_board (seq, writer, passwd, title, content, regdate )
VALUES (5, '이시은', '1234', 'test-5', 'test-5', null);
COMMIT;

-- 제약조건이름을 지정해서 제약조건을 설정할 수 있고
-- 제약조건이름을 설정하지 않으면 SYS_XXXX 이름으로 자동 부연된다,
-- 제약조건 이름 : SCOTT.SYS_C007034
SELECT *
--FROM tabs;
FROM user_constraints
WHERE table_name LIKE '%BOARD%';

ALTER TABLE tbl_board
ADD readed NUMBER DEFAULT 0; -- 개의 컬럼만 추가할 경우 () 생략 가능하다.
ADD()


INSERT INTO tbl_board ( writer, seq, passwd, title)
VALUES                ('이새롬' , (SELECT NVL(MAX(seq),0)+1 FROM tbl_board), '1234', 'test-6');
COMMIT;


-- content가 null인 경우 " 내용없음"

UPDATE tbl_board
SET content = '내용없음'
WHERE content IS NULL;



-- 게시판의 작성자 ( writer NOT NULL VARCHAR2(20) -> VARCHAR(40) )
DESC tbl_board;

-- 테이블 수정
-- 테이블 수정할때는 제약조건은 수정할 수 없다.(NOT NULL도 제약조건이라서 수정 불가능)
-- 삭제 -> 새로 추가하면 수정하는 것처럼 된다.
--ALTER TABLE tbl_board
--MODIFY ( WRITER NOT NULL VARCHAR(40) );
ALTER TABLE tbl_board
MODIFY ( WRITER VARCHAR(40) );


-- 컬럼명을 수정 ( title -> subject )
-- 직접적으로 변경은 불가능 하고 별칭(alias)을 줘서 수정한것 처럼 사용 가능하다. 
SELECT title AS subject , content
FROM tbl_board;

-- 컬럼명을 수정하는 방법 RENAME COLUMN 사용
ALTER TABLE tbl_board
RENAME COLUMN title TO subject;

-- 컬럼 추가
ALTER TABLE tbl_board
ADD bigo VARCHAR2(100);


DESC tbl_board;

SELECT *
FROM tabs;

-- 컬럼 삭제
ALTER TABLE tbl_board
DROP COLUMN bigo;

-- 테이블의 이름을 tbl_board -> tbl_test로 변경
RENAME tbl_board TO tbl_test;


DROP TABLE tbl_test;


-- 테이블 생성하는 방법
--subquery를 이용한 테이블 생성
--기존 테이블에 원하는 데이터가 이미 존재할 경우 subquery를 이용하여 테이블을 생성한다면 테이블 생성과 데이터 입력을 동시에 할 수 있다.
--【형식】
--	CREATE TABLE 테이블명 [컬럼명 (,컬럼명),...]
--	AS subquery;
--? 다른 테이블에 존재하는 특정 컬럼과 행을 이용한 테이블을 생성하고 싶을 때 사용
--? Subquery의 결과값으로 table이 생성됨
--? 컬럼명을 명시할 경우 subquery의 컬럼수와 테이블의 컬럼수를 같게해야 한다.
--? 컬럼을 명시하지 않을 경우, 컬럼명은 subquery의 컬럼명과 같게 된다.
--? subquery를 이용해 테이블을 생성할 때 CREATE TABLE 테이블명 뒤에 컬럼명을 명시해 주는 것이 좋다

-- 예) emp 테이블을 이용해서 30번 부서원들의 empno, ename, hiredate, job만 새로운 테이블 생성

CREATE TABLE tbl_emp30 (no, name, hdate, job, pay)
AS 
(
    SELECT empno, ename, hiredate, job, sal + NVL(comm,0) pay
    FROM emp
    WHERE deptno = 30
);

DESC tbl_emp30;

SELECT *
FROM user_constraints
WHERE table_name LIKE '%EMP%';


-- 예) 기존 테이블 -> 새로운 테이블 생성 + 레코드 X 기존 테이블의 구조만 복사
CREATE TABLE tbl_emp20
AS
    (
        SELECT *
        FROM emp
        WHERE 1 = 0
    );
    
SELECT *
FROM tbl_emp20;

DROP TABLE tbl_empgrade;
SELECT *
FROM salgrade;

SELECT *
FROM emp;
-- 문제 emp, dept, salgrade 테이블을 이용해서
-- deptno, dname, empno, ename, hiredate, pay, grede 컬럼을 가진 새로운 테이블 생성

CREATE TABLE tbl_empgrade
AS
    (
    SELECT d.deptno, dname, empno, ename, hiredate, sal + NVL(comm, 0) pay
        , s.losal || ' - ' || s.hisal sal_grade , grade
    FROM dept d ,emp e , salgrade s 
    WHERE d.deptno = e.deptno  AND e.sal BETWEEN s.losal AND s.hisal
    );


SELECT d.deptno, dname, empno, ename, hiredate, sal + NVL(comm, 0) pay
    , s.losal || ' - ' || s.hisal , grade
FROM dept d JOIN emp e ON d.deptno = e.deptno 
            JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;
            
            
SELECT d.deptno, dname, empno, ename, hiredate, sal + NVL(comm, 0) pay
    , s.losal || ' - ' || s.hisal , grade
FROM dept d ,emp e , salgrade s 
WHERE d.deptno = e.deptno  AND e.sal BETWEEN s.losal AND s.hisal
            

SELECT *
FROM tbl_empgrade;

DROP TABLE tbl_empgrade;
PURGE RECYCLEBIN -- 휴지통 비우기 명령

-- 테이블 삭제 + 완전 삭제( 휴지통 비우기 )
DROP TABLE tbl_empgrade PURGE; -- 완전 테이블 삭제


-- [ MultiTable INSERT문 ] 4가지 종류 
-- 1) UNCONDITIONAL INSERT ALL    : 조건이 없는 INSERT ALL 
CREATE TABLE tbl_dept10 AS ( SELECT * FROM dept WHERE 1 = 0); -- WHERE조건 거짓이 되는값 주면 INSERT할때 테이블에서 값을 가져오지 않는다.
CREATE TABLE tbl_dept20 AS ( SELECT * FROM dept WHERE 1 = 0);
CREATE TABLE tbl_dept30 AS ( SELECT * FROM dept WHERE 1 = 0);
CREATE TABLE tbl_dept40 AS ( SELECT * FROM dept WHERE 1 = 0);


--  모든 테이블에 INSERT 하고싶을때 서브쿼리와 함께 주면 모든 테이블에 서브쿼리 값을 동일하게 넣는다.
INSERT ALL
INTO tbl_dept10 VALUES (deptno, dname, loc)
INTO tbl_dept20 VALUES (deptno, dname, loc)
INTO tbl_dept30 VALUES (deptno, dname, loc)
INTO tbl_dept40 VALUES (deptno, dname, loc)
SELECT deptno, dname, loc
FROM dept;


SELECT *
FROM tbl_dept40;

-- 2) CONDITIONAL INSERT ALL      : 조건이 있는 INSERT ALL

CREATE TABLE tbl_emp10 AS ( SELECT * FROM emp WHERE 1 = 0 );

CREATE TABLE tbl_emp20 AS ( SELECT * FROM emp WHERE 1 = 0 );

CREATE TABLE tbl_emp30 AS ( SELECT * FROM emp WHERE 1 = 0 );

CREATE TABLE tbl_emp40 AS ( SELECT * FROM emp WHERE 1 = 0 );


INSERT ALL
    WHEN deptno = 10 THEN
        INTO tbl_emp10 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 10 THEN
        INTO tbl_emp20 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 10 THEN
        INTO tbl_emp30 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 10 THEN
        INTO tbl_emp40 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT * FROM emp;

SELECT * FROM tbl_emp10;

-- 3) CONDITIONAL FIRST INSERT    : 조건이 있는 INSERT ALL

INSERT FIRST
    WHEN deptno = 10 THEN
        INTO tbl_emp10 VALUES()
    WHEN job = 'CLERK' THEN
        INTO tbl_emp_clerk VALUES()
    ELSE 
        INTO tbl_else VALUES()
SELECT * FROM emp;

SELECT * FROM emp
WHERE deptno = 10 AND job = 'CLERK';

-- 4) PIVOTING INSERT             
CREATE TABLE sales(
employee_id        NUMBER(6),       -- 판매를 한 사원 넘버
week_id            NUMBER(2),       -- 판매한 주
sales_mon          number(8,2),     -- 월요일 판매 수량
sales_tue          number(8,2),     
sales_wed          number(8,2),
sales_thu          number(8,2),
sales_fri          number(8,2));    -- 금요일 판매 수량


insert into sales values(1101,4,100,150,80,60,120);
insert into sales values(1102,5,300,300,230,120,150);
COMMIT;
SELECT *
FROM sales;

-- 

create table sales_data(
employee_id        number(6),
week_id            number(2),
sales              number(8,2));

-- PIVOT INSERT문 // 가로로 되어있던 정보를 세로로 바꿔서 넣기
INSERT ALL
    INTO sales_data VALUES( employee_id, week_id, sales_mon )
    INTO sales_data VALUES( employee_id, week_id, sales_tue )
    INTO sales_data VALUES( employee_id, week_id, sales_wed )
    INTO sales_data VALUES( employee_id, week_id, sales_thu )
    INTO sales_data VALUES( employee_id, week_id, sales_fri )
SELECT employee_id, week_id, sales_mon , sales_tue , sales_wed , sales_thu , sales_fri  
FROM sales;

SELECT *
FROM sales_data;

DROP TABLE sales; -- 테이블 자체를 삭제
DELETE FROM sales_data; -- 테이블 안의 모든 레코드(내용) 삭제
SELECT * FROM sales_data;

TRUNCATE TABLE sales_date; -- 테이블 안의 모든 레코드 삭제
-- 롤백할 수 없는 sql문이 TRUNCATE ==> 자동으로 COMMIT이 된다.

DROP TABLE sales_data PURGE;
COMMIT;


-- 문제 


SYS.dbms_random.value(0,101)
[문제1] insa 테이블에서 num, name 컬럼만을 복사해서 
      새로운 tbl_score 테이블 생성
      (  num <= 1005 )
      
CREATE TABLE tbl_score AS (SELECT num, name FROM insa WHERE num <= 1005);

[문제2] tbl_score 테이블에   kor,eng,mat,tot,avg,grade, rank 컬럼 추가
( 조건   국,영,수,총점은 기본값 0 )
(       grade 등급  char(1 char) )

ALTER TABLE tbl_score 
ADD (    
    
    kor     NUMBER(3) default 0
    ,eng    NUMBER(3) default 0
    ,mat    NUMBER(3) default 0
    ,tot    NUMBER(3) default 0
    ,avg    NUMBER(5,2)
    ,rk     NUMBER(2) 
    ,grade  CHAR(1 char) 
)
   

[문제3] 1001~1005 
  5명 학생의 kor,eng,mat점수를 임의의 점수로 수정(UPDATE)하는 쿼리 작성.
  UPDATE tbl_score
  SET  kor = TRUNC(SYS.dbms_random.value(0,101))
      ,eng = TRUNC(SYS.dbms_random.value(0,101))
      ,mat = TRUNC(SYS.dbms_random.value(0,101));
      
[문제4] 1005 학생의 k,e,m  -> 1001 학생의 점수로 수정 (UPDATE) 하는 쿼리 작성.

UPDATE tbl_score
SET kor = (SELECT kor FROM tbl_score WHERE num = 1001)
    ,eng = (SELECT eng FROM tbl_score WHERE num = 1001)
    ,mat = (SELECT mat FROM tbl_score WHERE num = 1001)
WHERE num = 1005;
COMMIT;
ROLLBACK;


[문제5] 모든 학생의 총점, 평균을 수정...
     ( 조건 : 평균은 소수점 2자리 )

UPDATE tbl_score
SET tot = kor + eng + mat
    ,avg = (kor+eng+mat)/3
    ,rk = 1;

SELECT *
FROM SALGRADE;

[문제6] 등급(grade) CHAR(1 char)  'A','B','c', 'D', 'F'
--  90 이상 A
--  80 이상 B
--  0~59   F  

INSERT ALL
    WHEN avg >= 90 THEN
         INTO tbl_score (grade) VALUES( 'A' )
    WHEN avg >= 80 THEN
         INTO tbl_score (grade) VALUES( 'B' )
    WHEN avg >= 70 THEN
         INTO tbl_score (grade) VALUES( 'C' )
    WHEN avg >= 60 THEN
         INTO tbl_score (grade) VALUES( 'D' )
    WHEN avg >= 0 THEN
         INTO tbl_score (grade) VALUES( 'E' )
SELECT * FROM tbl_score ;


SELECT avg, DECODE ( TRUNC(avg/10), 10, 'A', 9, 'A', 8, 'B', 7, 'C', 6, 'D', 'F')
FROM tbl_score;


UPDATE tbl_score
SET grade = DECODE ( TRUNC(avg/10), 10, 'A', 9, 'A', 8, 'B', 7, 'C', 6, 'D', 'F')


[문제7] tbl_score 테이블의 등수 처리.. ( UPDATE) 

UPDATE tbl_score s
--SET s.rk = (SELECT COUNT(*)+1 FROM tbl_score c WHERE c.avg > s.avg);
SET rk = (
            SELECT t.r
            FROM (
            
                SELECT num, tot, RANK() OVER(ORDER BY tot DESC) r
                FROM tbl_score
                
            ) t
            WHERE t.num = s.num
         );

SELECT empno, ename, sal
    , ROW_NUMBER() OVER( ORDER BY sal DESC ) rn_rank
    , RANK() OVER(ORDER BY sal DESC ) r_rank
    , DENSE_RANK() OVER(ORDER BY sal DESC ) r_rank
FROM emp;

COMMIT;
SELECT * 
FROM tbl_score;

ROLLBACK;
UPDATE tbl_score
SET eng = CASE
            WHEN eng+30 >= 100 THEN 100
            ELSE eng+30
          END; 
          
          
-- [ 문제 ] 1001 ~ 1005 학생 중에 남학생들만 5점씩 증가...

UPDATE tbl_score
SET kor = kor+5
WHERE num = ANY ( (SELECT num FROM insa WHERE MOD(SUBSTR(ssn, 8, 1),2) = 1) );
WHERE num IN( (SELECT num FROM insa WHERE MOD(SUBSTR(ssn, 8, 1),2) = 1) );




