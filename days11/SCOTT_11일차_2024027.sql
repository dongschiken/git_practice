-- 계층적 질의
--관계형 데이터베이스는 2차원 테이블 구조에 의해 모든 데이터를 저장한다.
--하지만, 실무에서는 기업의 조직도, 집안의 족보처럼 계층적인 데이터 구조를 많이 사용하고 있다.
--따라서 평면적인 구조를 가지는 테이블에서도 계층적인 데이터를 저장하여 조회할 수 있는 방법이 필요하다.
--테이블에서 기업의 조직도와 같은 계층적인 데이터 자체를 저장하기는 어렵다. 하지만, 
--관계형 데이터베이스에서도 데이터간의 부모-자식 관계를 표현할 수 있는 컬럼을 지정하여 계층적인 관계를 표현할 수 있다.


-- 쇼핑몰 사이트 구현 : 대분류 / 중분류 / 소분류
-- 1개 테이블 (계층구조)로 구현 가능
-- 3개 테이블 구현 가능


SELECT 	[LEVEL] {*,컬럼명 [alias],...}
FROM	테이블명
WHERE	조건
START WITH 조건(시작조건)
CONNECT BY [PRIOR 컬럼1명  비교연산자  컬럼2명]
		또는 
		   [컬럼1명 비교연산자 PRIOR 컬럼2명]
           

SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= 31;


SELECT mgr, empno
    , LPAD( ' ' , (LEVEL-1)*3) || ename ename
    , LEVEL
FROM emp
START WITH mgr IS NULL
--CONNECT BY PRIOR mgr = empno;
CONNECT BY PRIOR empno = mgr;



다음은 mgr=7698인 BLAKE를 메니저로 둔 empno를 나열한 예이다.
SELECT mgr,empno,ename,LEVEL
FROM emp
WHERE mgr = 7698
START WITH mgr IS NULL
CONNECT BY PRIOR empno=mgr;


create table tbl_test(
deptno number(3) not null primary key,
dname varchar2(24) not null,
college number(3),
loc varchar2(10));

    DEPTNO DNAME                   COLLEGE LOC
---------- -------------------- ---------- ----------
       101 컴퓨터공학과                100 1호관
       102 멀티미디어학과              100 2호관
       201 전자공학과                  200 3호관
       202 기계공학과                  200 4호관
       100 정보미디어학부               10
       200 메카트로닉스학부             10
        10 공과대학

SELECT *
FROM tbl_test;

INSERT INTO tbl_test VALUES(101, '컴퓨터공학과', 100, '1호관');
INSERT INTO tbl_test VALUES(102, '멀티미디어학과', 100, '2호관');
INSERT INTO tbl_test VALUES(201, '전자공학과', 200, '3호관');
INSERT INTO tbl_test VALUES(202, '기계공학과', 200, '4호관');
INSERT INTO tbl_test VALUES(100, '정보미디어학부', 10, null);
INSERT INTO tbl_test VALUES(200, '메카트로닉스학부', 10, null);
INSERT INTO tbl_test VALUES(10, '공과대학', null, null);

SELECT deptno, dname, college, level
FROM tbl_test
START WITH  college IS NULL
CONNECT BY PRIOR deptno = college;


SELECT deptno, dname, college, level
FROM tbl_test
START WITH dname = '공과대학'
CONNECT BY PRIOR deptno = college;

SELECT deptno, dname, college, DECODE(level, 1, '학부', '학과') 
FROM tbl_test
START WITH dname = '정보미디어학부'
CONNECT BY PRIOR deptno = college;

DROP TABLE tbl_test PURGE;


SELECT LPAD( 'ㄴ', (LEVEL-1)*3) || dname
FROM tbl_test
START WITH college IS NULL
CONNECT BY PRIOR deptno = college AND dname != '정보미디어학부';


-- 1. START WITH 절
-- 2. CONNECT BY 절 : 계층형 구조가 어떤 식으로 연결되는지를 기술하는 구문
-- PRIOR 연산자 :
-- 3. CONNECT_BY_ROOT : 계층형 쿼리에서 최상위 로우(행)을 반환하는 연산자
-- 4. CONNECT_BY_ISLEAF : CONNECT BY 조건에 정의된 관계에 따라 해당 행이 최하위 자식행이면 1, 그렇지 않으면 0으로 반환
-- 5. SYS_CONNECT_BY_PATH(column, char) : 루트 노드에서 시작해서 자신의 행까지 연결 경로를 반환하는 함수
-- 6. CONNECT_BY_ISCYCLE : 루프(반복) 알고리즘 의사컬럼 1 / 0 출력

--SELECT e.empno
----    , LPAD(' ', 3*(LEVEL-1)) || e.ename
----    , LEVEL
--    , d.dname, d.deptno
--FROM emp e, dept d
--WHERE e.deptno = d.deptno
--START WITH e.mgr IS NULL
--CONNECT BY PRIOR e.empno = e.mgr
--ORDER SIBLINGS BY e.deptno;


-- CONNECT BY ROOT
SELECT e.empno,
    LPAD(' ', 3*(LEVEL-1)) || e.ename
    , LEVEL
    , e.deptno
    , CONNECT_BY_ROOT ename
FROM emp e
START WITH e.mgr IS NULL
CONNECT BY PRIOR e.empno = e.mgr;


-- CONNECT_BY_ISLEAF
SELECT e.empno,
    LPAD(' ', 3*(LEVEL-1)) || e.ename
    , LEVEL
    , e.deptno
    , CONNECT_BY_ROOT ename
    , CONNECT_BY_ISLEAF ename2
FROM emp e
START WITH e.mgr IS NULL
CONNECT BY PRIOR e.empno = e.mgr;

-- SYS_CONNECT_BY_PATH(ename, '/')
SELECT e.empno,
    LPAD(' ', 3*(LEVEL-1)) || e.ename
    , LEVEL
    , e.deptno
    , CONNECT_BY_ROOT ename
    , CONNECT_BY_ISLEAF ename2
    , SYS_CONNECT_BY_PATH(ename, '/')
FROM emp e
START WITH e.mgr IS NULL
CONNECT BY PRIOR e.empno = e.mgr;

-- VIEW(뷰)
FROM user_tables;
FROM 테이블 또는 뷰

-- CREATE OR REPLACE는 항상 사용하는 구문(뷰가 있으면 기존 뷰를 지우고 다시 만들고, 없으면 뷰를 새롭게 만든다.)
CREATE OR REPLACE [FORCE | NOFORCE] VIEW 뷰이름
		[(alias[,alias]...]
AS subquery
[WITH CHECK OPTION]
[WITH READ ONLY];

OR REPLACE 같은 이름의 뷰가 있을 경우 무시하고 다시 생성 
FORCE 기본 테이블의 유무에 상관없이 뷰를 생성 
NOFORCE 기본 테이블이 있을 때만 뷰를 생성 
ALIAS 기본 테이블의 컬럼이름과 다르게 지정한 뷰의 컬럼명 부여 
WITH CHECK OPTION 뷰에 의해 access될 수 있는 행(row)만이 삽입, 수정 가능 
WITH READ ONLY DML 작업을 제한(단지 읽는 것만 가능) 


-- F10키 누르면 OPTIMIZER 볼 수 있다.
SELECT b.b_id, title, price, g.g_id
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai P ON p.b_id = b.b_id
            JOIN gogaek g ON g.g_id = p.g_id;

-- AS 에서 ( ) 빼면 ORDER BY 절 사용가능 
-- 뷰 생성 -> 보안성, 편리성, 성능
CREATE OR REPLACE VIEW panView
AS 

        SELECT b.b_id, title, price, g.g_id, g_name, p_date, p_su
        FROM book b JOIN danga d ON b.b_id = d.b_id
                    JOIN panmai P ON p.b_id = b.b_id
                    JOIN gogaek g ON g.g_id = p.g_id
        ORDER BY p_date DESC;


SELECT *
FROM panView;
--ORDER BY p_date DESC;

SELECT *
FROM user_sys_privs;

SELECT TEXT
FROM user_views;


DROP TABLE tbl_test;


SELECT *
FROM tabs;

-- 뷰 목록 조회 tab
SELECT *
FROM tab
WHERE tabtype = 'VIEW';


-- 뷰 사용 -> DML 작업 [실습]
--    - 단순뷰  O (사용  O)
--    - 복합뷰  X (거의 사용  X)


SELECT ANIMAL_ID, NAME
FROM ANIMAL_OUTS
WHERE NAME NOT IN (
        SELECT DISTINCT NAME
        FROM ANIMAL_OUTS
        WHERE NAME  IN  (
                SELECT NAME
                FROM ANIMAL_INS
                  )
                  )
ORDER BY ANIMAL_ID ASC;
   

SELECT SUM(p_su)
FROM panView;



CREATE TABLE testa (
   aid     NUMBER                  PRIMARY KEY
    ,name   VARCHAR2(20) NOT NULL
    ,tel    VARCHAR2(20) NOT NULL
    ,memo   VARCHAR2(100)
);
--Table TESTA이(가) 생성되었습니다.
CREATE TABLE testb (
    bid NUMBER PRIMARY KEY
    ,aid NUMBER CONSTRAINT fk_testb_aid 
            REFERENCES testa(aid)
            ON DELETE CASCADE
    ,score NUMBER(3)
);
--Table TESTB이(가) 생성되었습니다.


INSERT INTO testa (aid, NAME, tel) VALUES (1, 'a', '1');
INSERT INTO testa (aid, name, tel) VALUES (2, 'b', '2');
INSERT INTO testa (aid, name, tel) VALUES (3, 'c', '3');
INSERT INTO testa (aid, name, tel) VALUES (4, 'd', '4');

INSERT INTO testb (bid, aid, score) VALUES (1, 1, 80);
INSERT INTO testb (bid, aid, score) VALUES (2, 2, 70);
INSERT INTO testb (bid, aid, score) VALUES (3, 3, 90);
INSERT INTO testb (bid, aid, score) VALUES (4, 4, 100);

COMMIT;
SELECT *
FROM testa;
--FROM testb;
-- 1. 뷰 생성(단순뷰)
CREATE OR REPLACE VIEW aView
AS 
    SELECT aid, name, tel --, memo
    FROM testa;
-- View AVIEW이(가) 생성되었습니다.

-- 2. DML 실행 ( INSERT )
INSERT INTO testa (aid, name, memo) VALUES ( 5, 'f', '5');
INSERT INTO testa (aid, name, tel) VALUES ( 5, 'f', '5');
COMMIT;

SELECT * FROM testa;


-- testa, testb 복합뷰생성, DML 테스트
CREATE OR REPLACE VIEW abView
AS
    SELECT 
        a.aid, name, tel
        , bid, score
    FROM testa a JOIN testb b ON a.aid = b.bid;
-- View ABVIEW이(가) 생성되었습니다.

SELECT *
FROM abView;

-- 복합뷰를 사용해서 INSERT X
INSERT INTO abView (aid, name, tel, bid, score)
VALUES (10, 'x', 55, 20, 70);
-- SQL 오류: ORA-01776: cannot modify more than one base table through a join view
-- 동시에 두개의 테이블에 각각의 컬럼값들이 INSERT 할 수 없다.

-- 복합뷰를 사용해서 UPDATE : 한 테이블의 내용만 수정할 때만 가능하다.
UPDATE abView
SET score = 99
WHERE bid = 1;
ROLLBACK;


-- 복합뷰 사용해서 DELETE 
DELETE FROM abView
WHERE aid = 1;

SELECT * FROM testa;
SELECT * FROM testb;


DELETE FROM aView
WHERE aid = 5;
COMMIT;

UPDATE aView
SET tel = '44'
WHERE aid = '4';

-- WITH CHECK OPTION 절을 사용하면 뷰를 통해 참조 무결성(reference integrity)을 검사할 수 있고 DB 레벨에서의 constraint 적용이 가능하다.
-- 점수가 90점 이상인 뷰 생성
CREATE OR REPLACE VIEW bView
AS
    SELECT bid, aid, score
    FROM testb
    WHERE score >= 90
    WITH CHECK OPTION CONSTRAINT CK_bView_score;

SELECT bid, aid, score
FROM testb;

SELECT bid, aid, score
FROM bView;

-- 3의 점수를 -> 70점으로 수정
--  ORA-01402: view WITH CHECK OPTION where-clause violation 
-- CHECK OPTION(90점 이상)에 위배되는 값 70점을 업데이트 하려해서 오류
UPDATE bView
SET score = 98
WHERE bid = 3;

-- 뷰 : 물리

DROP VIEW bView;
DROP VIEW abView;
DROP TABLE testa;
DROP TABLE testb;


-- 문제 : 년도, 월, 판매금액합(년도별 월), (년도 , 월 오름차순) 
-- 
-- gogaek : 고객코드 ,고객명
-- panmai : 년도, 월, 수량
-- book : price(가격)

CREATE OR REPLACE VIEW gogaekView
AS 
    SELECT g.g_id, g_name
            , TO_CHAR(p_date, 'YYYY') 년도
            , TO_CHAR(p_date, 'MM') 월
            , SUM(price*p_su) 매출
    FROM PANMAI p JOIN gogaek g ON p.g_id = g.g_id
                  JOIN book b ON b.b_id = p.b_id
                  JOIN danga d ON d.b_id = b.b_id
    GROUP BY  g.g_id, g_name, TO_CHAR(p_date, 'YYYY'),  TO_CHAR(p_date, 'MM')
    ORDER BY 년도 ASC, 월 ASC;


SELECT *
FROM gogaekView;

DROP VIEW gogaekView

-- DB모델링 정의 + PL/SQL 작성
 1) 데이터 베이스(DataBase) : 서로 관련된 데이터의 집합(모임)
 2) DB모델링 ? : 현실세계에 업무적인 프로세스를 물리적으로 DB화 시키는 과정 
 // ex) 스타벅스에서 음료 주문( 현실세계의 업무 프로세스 ) -> 음료(상품) 검색 -> 주문 -> 결제 -> 대기 -> 상품픽업
 3) DB모델링 순서
    ㄱ. 업무 프로세스 파악 ( 요구 분석서 작성 ) 
    ㄴ. 개념적 DB 모델링(ERD 작성)
    ㄷ. 논리적 DB 모델링(스키마, 정규화)
    ㄹ. 물리적 DB 모델링(역 정규화, 인덱서, DBMS--오라클, MYSQL..._, 타입, 크기 정하기 등등)
    ㅁ. 업무 프로세스와 일치하는지 검토
    
 4) DB모델링 과정
 - 업무 프로세스 분석(요구 분석서 작성(명세서)) : 개인이 만들 데이터에 대해서 본인이 직접 명세서 작성하기
  ㄱ. 관련 분야에 대한 기본 지식과 상식 필요.
  ㄴ. 신입사원의 입장에서 업무 자체와 프로세스 파악, 분석
  ㄷ. 회사에서 사용하는 모든 실제 문서(서류, 장표, 보고서)를 수집하고 분석
  ㄹ. 담당자와의 인터뷰, 설문조사 등등 요구사항 직접 수렴
  ㅁ. 비슷한 업무 처리하는 DB 분석
  ㅂ. 백그라운드 프로세스 파악
  ㅅ. 사용자와의 요구 분석
  등등...
  
 - 개념적 DB 모델링(ERD 작성) 
  ㄱ. DB 모델링을 함에 있어 가장 먼저 해야할 일은 사용자가 필요로하는 데이터가 무엇인지 파악하고, 어떤 데이터를 DB에 저장해야되는지 충분히 분석
  ㄴ. 업무분석, 사용자 요구 분석등을 통해서 수집된 현실 세계의 정보들을 사람들이 이해할 수 있는 명확한 형태로 표현하는 단계를 "개념적 DB모델링"이라고 한다.
  ㄷ. 명확한 형태로 표현하는 방법 -> ERD(Entity Relation Diagram) 개체 관계 다이어그램
  ㄹ. 개체(Entity)에서 속성(Attribute)을 뽑아내고 객체들 간의 관계를 연결해야한다.
  개체 - 직사각형
  - 실체(Entity) 업무 수행을 위해 데이터로 관리되어져야할 사람, 사물, 장소, 사건...등을 "실체"라고 한다.
  - 구축하고자 하는 업무의 목적, 범위, 전략에 따라 데이터로 관리되어져야할 항목을 파악하는 것이 매우 중요하다.
  - 실체는 학생, 교수, 등과 같이 물리적으로 존재하는 유형 OR 학과, 과목 등과 같이 개념적으로 존재하는 무형 둘다 가능하다.
  - 실체는 테이블로 정의된다. ( 실체 == 테이블 )
  - 실체는 인스턴스라 불리는 개별적인 객체들의 집합이다.
    ex) 과목(실체) : 오라클, 자바, jsp..등등의 인스턴스의 집합 == 실체
        학과(실체) : 컴공, 전자공, 기계공 등등 인스턴스의 집합
  - 실체를 파악하는 요령 ( 가장 중요 )
    ex) 학원에서는 학생들의 출결상태와 성적들을 과목별로 관리하기를 원하고 있다.
        - 실체 : 학원, 학생, 출결상태, 성적, 과목
            반 테이블 - 과목컬럼, 선생님_ID, 선생님 이름
                - 학생속성 : 학번, 이름, 주소, 연락처, 학과, 성적 등등
                    - 출결상태속성 : 출결날짜, 출석시간, 퇴실시간 
        
  속성 - 타원형
  - 속성(Attribute) : 저장할 필요가 있는 실체에 대한 정보, 즉 속성은 실체의 성질, 분류, 수량, 상태, 특징, 특성 등등 세부 항목을 의미한다.
  - 속성 설정 시 가장 중요한 부분은 관리의 목적과 활용 방향에 맞는 속성의 설정이 필요
  - 속성의 갯수는 10개 내외가 좋다.
  - 속성은 컬럼으로 정의된다.
  - 속성의 유형
    1. 기초 속성 : 원래 갖고 있는 속성 ( ex - 사원 실체 : 사원번호 속성, 사원명 속성, 주민등록번호 속성, 입사일자 속성 등등)
    2. 추출 속성 : 기초 속성으로 계산해서 얻어질 수 있는 속성 ( ex - 기초속성 주민등록번호에서 생일, 성별, 나이 등등 추출해 낼 수 있다.) 판매금액 속성 = 단가 * 판매수량
    3. 설계 속성 : 실제로는 존재하지 않으나 시스템의 효율성을 위해서 설계자가 임의로 부여하는 속성
  - 속성 도메인 설정 : 속성이 가질수 있는 값들의 범위, 세부적인 업무, 제약조건 등 특성을 정의한 것. (ex - 성적(E) - 국어(A) 속성의 범위 0~100 정수) kor NUMBER(3) default 0 CHECK( kor BETWEEN 0 AND 100 )
  - 도메인 설정은 추후 개발 및 실체를 DB로 생성할 때 사용되는 산출물 이다.
  - 도메인 무결성
  - 식별자( Identifier ) : 대표적인 속성, 
        1) 한 실체 내에서 각각의 인스턴스를 구분할 수 있는 유일한 단일 속성 또는 속성 그룹을 식별자 라고 한다.( PK와 비슷한 의미 )
        2) 식별자가 없으면 데이터를 수정, 삭제할 대 문제가 발생한다.
        3) 식별자의 종류 
            ㄱ. 후보기( Candiate Key ) : 실체에 각각의 인스턴스를 구분할 수 있는 속성 
                  ex) 학생실체(Enti)  주민번호, 학번, 이메일, 전화번호 등등 속성(학생 한명 한명)을 구분짓기 위해 사용
                        인스턴스 - 홍길동 
                        인스턴스 - 김길동
            ㄴ. 기본키( Primary Key )
                 후보키 중에 대표적인 가장 적합한 후보키를 기본키로 설정한다.
                 업무적인 효율성, 활용도, 길이(크기) 등등을 파악해서 후보기 중에 하나를 기본키로 설정
            ㄷ. 대체키( Alternate Key )
                 후보키 - 기본키 = 나머지 후보키를 대체키라고 한다.
                 INDEX(인덱스)로 활용된다.
            ㄹ. 복합키( Composite Key )
            ㅁ. 대리키( Surrogate Key )
                 학번을 기본키로 사용하자고 결정 했지만 
                 식별자가 너무 길거나 여러개의 복합키로 구성되어 있는 경우 인위적으로 추가한 식별자(인공키)
                 전교생이 30명... (학번 -> 순번(일련번호) 1~30) ==> 역 정규화 작업을 뜻한다. // 성능, 효율성을 높이겠다.
  
  개체관계 - 마름모
    - 업무의 연관성에 다라서 실체들 간의 관계 설정..
        ex) 부서 실체(E)       <소속 관계>    사원 실체(E)
            부서 번호 속성(식별자)            사원 번호 속성(식별자)
            부서명 속성                      사원명
            지역명 속성                      입사 일자
            
           
           상품(E) 실선< 주문 관계 >실선 고객(E)
           
           관계 표현 
           - 두 개체간의 실선으로 연결하고 관계를 부여한ㄷ.
           - 관계 차수 표현 ( 부서 1  :  N 사원 ) // 1대 다(N) 관계
                           1 : 1 관계( 1 대 1  )
                           N : M 관계( 다 대 다 )  상품N0 < 주문 > 0M고객 관계 -- 0개 또는 N개 // 0개 또는 M개
           - 선택성도 표시 
  연결(링크) - 실선
  식별자 - 언더라인(글에 밑줄)
  
  
    - 논리적 DB 모델링 ( 스키마, 정규화 )
      1) 개념적 모델링의 결과물(ERD)를 -> 릴레이션 스키마 생성(변환)
      2) 부모테이블과 자식테이블 구분
        - 관계형 데이터 모델 
            - ex) 부서(dept)  < 소속관계 >  사원(emp)     생성순서로 부모 자식관계가 이루어진다.
            - ex) 고객(cos)   < 소속관계 >  상품          주문하는 관계에 따라서 부모 자식 관계가 이루어 진다. (고객 - 부모 // 상품 - 자식)
      3) 기본키(PK)와 외래키(FK)
        dept(deptno PK)
        emp (deptno FK)
      4) 식별 관계와 비 식별 관계
        식별 관계(실선) : 부모테이블의 PK가 자식 테이블의 PK로 전이되는 것
        비 식별 관계(점선) : 부모테이블의 PK가 자식 테이블의 FK로 전이되는 것
      5) ERD -> 5가지 규칙(매핑룰) -> 릴레이션 스키마 생성(변환) + 이상현상 발생 ->  정규화 과정 // 규칙 1~5번 순서대로 진행해야한다.
      규칙 1. : 모든 개체(E)는 릴레이션(TABLE)로 변환한다.  엔티티는 그대로 테이블로, 속성은 그대로 컬럼으로, 식별자는 기본키로 바꾸는 작업이 가장 처음에 해야할 작업
      규칙 2. : 다대다 관계는 릴레이션(테이블)으로 변환한다. 
      규칙 3. : 일대다 관계는 외래키로 표현한다.
      규칙 4. : 일대일 관계는 외래키로 표현한다. 
      규칙 5. : 다중값을 가지는 속성은 릴레이션(테이블)으로 변환한다. // 동그라미 2개 겹쳐진 모양
      
      
      
