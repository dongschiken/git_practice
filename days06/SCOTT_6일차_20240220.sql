-- SCOTT

CREATE TABLE emp (
EMPNO NUMBER PRIMARY KEY,
ENAME VARCHAR2(15) NOT NULL,
JOB VARCHAR2(15) NOT NULL,
MANAGENO NUMBER,
HIREDATE DATE NOT NULL,
SAL NUMBER NOT NULL,
COMM NUMBER,
DEPTNO NUMBER NOT NULL
)
INSERT INTO EMP VALUES( 7839, 'KING', 'PRESIDENT', null, to_date('1996-11-17','yyyy-mm-dd'), 5000, null, 10);
INSERT INTO EMP VALUES( 7698, 'BLAKE', 'MANAGER', 7839, to_date('1991-1-05','yyyy-mm-dd'), 2850, null, 30);
INSERT INTO EMP VALUES( 7782, 'CLARK', 'MANAGER', 7839, to_date('1999-9-06','yyyy-mm-dd'), 2450, null, 10);
INSERT INTO EMP VALUES( 7566, 'JONES', 'MANAGER', 7839, to_date('2001-02-04','yyyy-mm-dd'), 2975, null, 20);
INSERT INTO EMP VALUES( 7788, 'SCOTT', 'ANALYST', 7566, to_date('2003-06-17','yyyy-mm-dd'), 3000, null, 20);
INSERT INTO EMP VALUES( 7902, 'FORD', 'ANALYST', 7566, to_date('1981-03-12','yyyy-mm-dd'), 3000, null, 20);
INSERT INTO EMP VALUES( 7369, 'SMITH', 'CLERK', 7902, to_date('2007-12-1','yyyy-mm-dd'), 800, null, 20);
INSERT INTO EMP VALUES( 7499, 'ALLEN', 'SALESMAN', 7698, to_date('20-2-1981','dd-mm-yyyy'), 1600, 300, 30);
INSERT INTO EMP VALUES( 7521, 'WARD', 'SALESMAN', 7698, to_date('22-2-1981','dd-mm-yyyy'), 1250, 500, 30);
INSERT INTO EMP VALUES( 7654, 'MARTIN', 'SALESMAN', 7698, to_date('28-9-1981','dd-mm-yyyy'), 1250, 1400, 30);
INSERT INTO EMP VALUES( 7844, 'TURNER', 'SALESMAN', 7698, to_date('8-9-1981','mm-dd-yyyy'), 1500, 0, 30);
INSERT INTO EMP VALUES( 7876, 'ADAMS', 'CLERK', 7788, to_date('13-7-87', 'dd-mm-yy') - 51, 1100, null, 20);
INSERT INTO EMP VALUES( 7900, 'JAMES', 'CLERK', 7698, to_date('3-12-1981','mm-dd-yyyy'), 950, null, 30);
INSERT INTO EMP VALUES( 7934, 'MILLER', 'CLERK', 7782, to_date('2003-1-23','yyyy-mm-dd'), 1300, null, 10);

SELECT *
FROM emp;


SELECT sal + NVL(comm, 0) pay
    , (SELECT ROUND(AVG(sal + NVL(comm, 0)), 2) AVG_PAY FROM emp) AVG_PAY
    , (CEIL((sal + NVL(comm, 0)  - (SELECT AVG(sal + NVL(comm, 0)) AVG_PAY FROM emp))*100))/100 ���ø�
    , ROUND(sal + NVL(comm, 0)  - (SELECT AVG(sal + NVL(comm, 0)) AVG_PAY FROM emp), 2) "�� �ݿø�"
    , TRUNC(sal + NVL(comm, 0)  - (SELECT AVG(sal + NVL(comm, 0)) AVG_PAY FROM emp), 2) ������
FROM emp;



-- WITH�� ����ؼ� Ǯ��
WITH temp AS
    (SELECT comm, sal, sal + NVL(comm, 0) pay , (SELECT AVG(sal + NVL(comm, 0)) FROM emp) AVG_PAY FROM emp)
SELECT ename, deptno 
    , CEIL( ((t.sal + NVL(t.comm, 0)) - t.AVG_PAY) *100 )/100 CEIL_PAY
    , ROUND(( t.pay - t.avg_pay), 2) ROUND_PAY
    , TRUNC(( t.pay - t.avg_pay), 2) TRUNC_PAY
FROM temp t;

WITH t AS
    (
SELECT  name, ssn, MOD(SUBSTR(ssn, 8, 1),2) "SSN2"
FROM insa
    )
SELECT t.name, t.ssn, t.ssn2, DECODE(t.ssn2, 0 , '����' , '����') GENDER
FROM t;
    
WITH t AS
    (
    SELECT ename, empno, deptno, sal + NVL(comm, 0) pay
    , (SELECT AVG(sal + NVL(comm, 0)) AVG_PAY FROM emp) avg_pay
    , (SELECT COUNT(*) COUNT FROM emp)
    FROM emp
    )
SELECT t.ename, t.empno, t.deptno, t.pay, ROUND((t.avg_pay),2), DECODE(SIGN(t.pay - t.avg_pay), -1, '����', 1, '����', '����') MY_PAY
FROM t;
    
    
WITH t AS
    (
    SELECT comm, sal, sal + NVL(comm, 0), ename, (SELECT(AVG( sal+NVL(comm, 0))) FROM emp) AVG_PAY FROM emp
    )
SELECT ROUND((t.sal+NVL(t.comm, 0) - t.AVG_PAY),2) ROUND_PAY
    , CEIL((t.sal+NVL(t.comm, 0) - t.AVG_PAY)*100)/100 CEIL_PAY
    , TRUNC((t.sal+NVL(t.comm, 0) - t.AVG_PAY),2) TRUNC_PAY
FROM t;



SELECT empno, ename
    , sal + NVL(comm, 0) pay
    , (SELECT ROUND(AVG(sal + NVL(comm, 0)), 2) AVG_PAY FROM emp) AVG_PAY
    , REPLACE(REPLACE(SIGN(sal + NVL(comm, 0) - (SELECT AVG(sal + NVL(comm, 0)) FROM emp)), -1 , '����') , 1, '����') AB
FROM emp GROUP BY empno, ename, sal + NVL(comm, 0);


SELECT DISTINCT (SELECT COUNT(*) FROM insa WHERE REGEXP_LIKE(ssn, '\d-[13579]')) "���� �����"
    , (SELECT COUNT(*) FROM insa WHERE REGEXP_LIKE(ssn, '\d-[24680]')) "���� �����"
    , REPLACE( MOD(SUBSTR(ssn, 8, 1), 2), 1, '����'), 0
FROM insa;


SELECT '���ڻ����' "����", COUNT(*) �����
FROM insa
WHERE MOD(SUBSTR(ssn, 8, 1), 2) = 1
UNION
SELECT '���ڻ����' "����", COUNT(*)
FROM insa
WHERE MOD(SUBSTR(ssn, 8, 1), 2) = 0;


SELECT REPLACE(REPLACE( MOD(SUBSTR(ssn, 8, 1), 2), 1, '����'), 0, '����')||'�����' GENDER, COUNT(*) �����
FROM insa
GROUP BY MOD(SUBSTR(ssn, 8, 1), 2);


SELECT *-- COUNT(*)/14
FROM insa;



SELECT ename, empno, job, mgr, hiredate, deptno, sal + NVL(comm, 0) pay
    , REPLACE(REPLACE(  sal + NVL(comm, 0), (SELECT MAX(sal + NVL(comm, 0)) pay FROM emp) , '�ְ� �޿���'), (SELECT MIN(sal + NVL(comm, 0)) pay FROM emp) , '���� �޿���') "etc"
FROM emp
WHERE sal + NVL(comm, 0) >= ANY (SELECT MAX(sal + NVL(comm, 0)) pay FROM emp)
    OR sal + NVL(comm, 0) <= ANY (SELECT MIN(sal + NVL(comm, 0)) pay FROM emp);
    
    
SELECT *
FROM emp
--WHERE sal+NVL(comm,0) IN ( 5000, 800 );
--WHERE sal+NVL(comm,0) = (SELECT MAX(sal+NVL(comm,0)) max_pay FROM emp) 
--     OR sal+NVL(comm,0) = (SELECT MIN(sal+NVL(comm,0)) min_pay FROM emp);
WHERE sal+NVL(comm,0) IN (
                   (SELECT MAX(sal+NVL(comm,0)) max_pay FROM emp)
                  , (SELECT MIN(sal+NVL(comm,0)) min_pay FROM emp) 
      );     

SELECT emp.* , '�ְ� �޿���' max_min
FROM emp
WHERE sal + NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) pay FROM emp)
UNION ALL
SELECT emp.* , '���� �޿���'
FROM emp 
WHERE sal + NVL(comm, 0) = (SELECT MIN(sal + NVL(comm, 0)) pay FROM emp);


SELECT emp.* , '�ְ� �޿���' max_min
FROM emp
WHERE sal + NVL(comm, 0) >= ALL (SELECT sal + NVL(comm, 0)FROM emp)
UNION ALL
SELECT emp.* , '���� �޿���'
FROM emp 
WHERE sal + NVL(comm, 0) <= ALL (SELECT sal + NVL(comm, 0)FROM emp);
    
    
    
    
SELECT ename, sal, comm 
FROM emp
WHERE comm is null OR comm <= 400;

-- LNNVL() �Լ�
-- LNNVL(NULL) => true
-- LNNVL(400) => false
SELECT ename, sal, comm 
FROM emp
WHERE LNNVL(comm >= 400);


SELECT CEIL(COUNT(*)/14) "�� ����"
FROM insa;

SELECT ename, empno, sal + NVL(comm, 0) pay, deptno
FROM emp p
WHERE sal + NVL(comm, 0) >= ANY ( SELECT MAX(sal + NVL(comm, 0)) FROM emp c WHERE c.deptno = p.deptno)
ORDER BY deptno ASC;



SELECT ename, empno, sal + NVL(comm, 0) pay
FROM emp
WHERE deptno = 10 AND sal+NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = 10)
UNION
SELECT ename, empno, sal + NVL(comm, 0) pay
FROM emp
WHERE deptno = 20 AND sal+NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = 20)
UNION
SELECT ename, empno, sal + NVL(comm, 0) pay
FROM emp
WHERE deptno = 30 AND sal+NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = 30);



SELECT TO_CHAR(LAST_DAY(SYSDATE) , 'DD')
FROM dual;



-- ��ȣ 14�ڸ�

SELECT  ssn, RPAD(SUBSTR(ssn,1, 8), 14, '*') RPAD_SSN
FROM insa;

SELECT deptno, ename 
    ,(sal + NVL(comm, 0)) pay
    ,RPAD( ' ' , ROUND((sal + NVL(comm, 0))/100)+1, '#')  BAR_LENGTH
FROM emp
WHERE deptno = 30
ORDER BY sal + NVL(comm, 0) DESC;



SELECT TRUNC( SYSDATE, 'YEAR' )
    , TRUNC( SYSDATE, 'MONTH' )      
    , TRUNC( SYSDATE  )
FROM dual;


SELECT TO_CHAR(NEXT_DAY( SYSDATE, '��'), 'DD')
FROM dual;


SELECT hiredate
    , ADD_MONTHS(hiredate, 12*10+5)+20 ADD_MONTH
FROM emp ;

SELECT SUBSTR(ssn, 1, 2) || TO_CHAR(SYSDATE, 'MM') || TO_CHAR(SYSDATE, 'DD') || SUBSTR(ssn, 7, 14)
FROM insa
WHERE num = 1002;


WITH temp AS 
    (
    SELECT ename, empno, sal + NVL(comm, 0) pay, (SELECT ROUND(AVG(sal + NVL(comm, 0)),2) FROM emp)avg_pay FROM emp
    )
SELECT temp.ename, temp.empno, temp.pay, temp.avg_pay
FROM temp
WHERE temp.pay > temp.avg_pay;

SELECT ename, sal+NVL(comm, 0) pay
    , ROUND((sal+NVL(comm, 0)) / (SELECT MAX(sal+NVL(comm, 0)) FROM emp)*10) "�� ����"
    , RPAD( ' ' , ROUND((sal+NVL(comm, 0)) / (SELECT MAX(sal+NVL(comm, 0)) FROM emp)*10)+1, '*') ��
FROM emp GROUP BY ename, sal+NVL(comm, 0);

WITH t AS (
SELECT ename, sal + NVL(comm, 0) pay
    , ( SELECT SUM(sal + NVL(comm, 0) )  FROM emp) sum_pay
FROM emp
)
SELECT t.pay, t.ename, t.sum_pay
    , ROUND( t.pay / t.sum_pay * 100 , 3) PERSENT
    , RPAD (' ' , ROUND( t.pay / t.sum_pay * 100 )+1 , '*') "��"
FROM t;

-- TOP_N �� ����ؼ� �޿� ���� ���� �޴� ����� ��ȸ
-- ���� �������� �ʴ� �÷��� �����ϴ� ���� ���� �÷�(�ǻ� �÷�) �̶�� �Ѵ�. ==> rownum 
SELECT e.*, ROWNUM 
FROM (
    SELECT empno, ename, hiredate, sal, comm, sal + NVL(comm, 0) pay
    FROM emp 
    ORDER BY sal + NVL(comm, 0) DESC
    ) e
--WHERE ROWNUM BETWEEN 3 AND 5;   : 1����� ~N�� ������ ������ �� ������ 3�� ~ 5��� ���� ���̿� �ִ� ���� ����� �ȳ��´�. �� 1~N������ ���
WHERE ROWNUM<= 3;
    
-- RANK �Լ� ����ؼ� DESC �޿� ���� ���� �޴� ��� / ASC �ϸ� �޿� ���� ���� �޴� ���
-- 3��� ~ 5�� ������ ������ �� �ִ�.
SELECT e.*
FROM (
SELECT 
      RANK() OVER( ORDER BY sal + NVL(comm, 0) ASC) RANK
    , empno, ename, hiredate, sal + NVL(comm, 0) pay
FROM emp
) e
WHERE e.rank BETWEEN 3 AND 5;

-- �� �μ��� PAY 2����� ���
SELECT e.*
FROM(
SELECT 
    deptno
    , RANK() OVER( PARTITION BY deptno ORDER BY sal + NVL(comm, 0) DESC, ename ) "dept_pay_rank"
    , deptno, empno, ename, hiredate, sal + NVL(comm, 0) pay
FROM emp
) e
WHERE e.dept_pay_rank = 1;

SELECT ename, empno, sal + NVL(comm, 0) pay, deptno
FROM emp p
WHERE sal + NVL(comm, 0) >= ANY ( SELECT MAX(sal + NVL(comm, 0)) FROM emp c WHERE c.deptno = p.deptno)
ORDER BY deptno ASC;

-- ���� �ֹ� ��ȣ 801007-1544236
UPDATE insa
SET ssn = SUBSTR(ssn, 1, 2) || TO_CHAR(SYSDATE, 'MMDD') || SUBSTR(ssn, 7, 14)
WHERE num = 1002;

SELECT *--SUBSTR(ssn, 1, 2) || TO_CHAR(SYSDATE, 'MMDD') || SUBSTR(ssn, 7, 14)
FROM insa
WHERE num = 1002;

-- TRUNC�� ���� ��¥���� ��, ��, �� �����ؼ� �ٽ� ���
SELECT name, ssn, SYSDATE
    , SUBSTR(ssn, 3, 4) ssn_mmdd
    , TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD')
    , SIGN(TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE))
    , REPLACE(REPLACE(REPLACE( SIGN(TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)), -1 , '����') , 1 , '������ ����'), 0, '����')
    , DECODE(SIGN(TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)), -1, '����', 1, '������', '����')
FROM insa;
-- JOIN(����)
--               ����
-- dept(�μ�)   �ҼӰ���    emp(���)
--     1                     0    (�μ��� 1�� �̻� �� �־���ϰ�, ����� 0�� �־ �ȴ�)
-- �θ� ���̺�             �ڽ� ���̺�


-- [ ���� ] ��� ������ ��� ( �μ���ȣ, �μ���, �����,�Ի����� ) JOIN ���
-- dept : deptno, dname, loc
-- emp  : deptno, empno, ename, sal, job, comm, hiredate
-- ORA-00918: column ambiguously defined : �÷��� �ָ��ϰ� ����Ǿ� �ִ�.
-- deptno�� dept���̺�� emp���̺� �Ѵ� �־ dept.deptno �Ǵ� emp.deptno��� �ؾ��Ѵ�.
-- [1]��
SELECT dept.deptno, dname ,ename, hiredate
FROM emp , dept  -- ���̺� 2�� �����ϸ� JOIN
WHERE emp.deptno = dept.deptno  -- JOIN ������
ORDER BY dept.deptno;  

-- [2]��
SELECT dept.deptno, dname ,ename, hiredate
FROM emp JOIN dept ON emp.deptno = dept.deptno   -- JOIN ������
ORDER BY dept.deptno;



-- ���� ���� --
TO_CHAR(NUMBER) : ���ڸ� -> ���ڷ� ��ȯ
TO_CHAR(DATE)   : ��¥�� -> ���ڷ� ��ȯ


--WW  ���� ���° �� (sysdate,'WW') 44 
--W   ���� ���° �� (sysdate,'W') 4 
--IW  1���� ��°�� (systimestamp,'IW') 07 

SELECT SYSDATE
    , TO_CHAR(SYSDATE, 'CC')  A -- ����
    , TO_CHAR(SYSDATE, 'DDD') B-- �ش� ������ ������ ��������
    , TO_CHAR(SYSDATE, 'WW')  C-- 08  ���� ���° ��
    , TO_CHAR(SYSDATE, 'W')   D-- 3   ���� ���° ��
    , TO_CHAR(SYSDATE, 'IW')  E-- 08  1���� ��°��
FROM dual;

-- WW�� �� ������ 1~7�� �������� ���� ǥ��
SELECT TO_CHAR( TO_DATE ('2024.01.01'), 'WW') A
    , TO_CHAR( TO_DATE ('2024.01.02'), 'WW') B
    , TO_CHAR( TO_DATE ('2024.01.03'), 'WW') C
    , TO_CHAR( TO_DATE ('2024.01.04'), 'WW') D
    , TO_CHAR( TO_DATE ('2024.01.05'), 'WW') E
    , TO_CHAR( TO_DATE ('2024.01.06'), 'WW') F
    , TO_CHAR( TO_DATE ('2024.01.07'), 'WW') G
    , TO_CHAR( TO_DATE ('2024.01.08'), 'WW') H
    , TO_CHAR( TO_DATE ('2024.01.14'), 'WW') I
    , TO_CHAR( TO_DATE ('2024.01.15'), 'WW') J
FROM dual;

-- IW�� �Ͽ����� �������� ���� ǥ��
-- 1�� 1�� �� 1�� 2���� ��, �Ͽ��� �̶� 2019�⿡ ���ԵǾ 52��� ���ڰ� ���´�.
SELECT TO_CHAR( TO_DATE ('2022.01.01'), 'IW') 52
    , TO_CHAR( TO_DATE ('2022.01.02'), 'IW') 52
    , TO_CHAR( TO_DATE ('2022.01.03'), 'IW') 01
    , TO_CHAR( TO_DATE ('2022.01.04'), 'IW') 01
    , TO_CHAR( TO_DATE ('2022.01.05'), 'IW') 01
    , TO_CHAR( TO_DATE ('2022.01.06'), 'IW')
    , TO_CHAR( TO_DATE ('2022.01.07'), 'IW')
    , TO_CHAR( TO_DATE ('2022.01.08'), 'IW')
    , TO_CHAR( TO_DATE ('2022.01.14'), 'IW')
    , TO_CHAR( TO_DATE ('2022.01.15'), 'IW')
FROM dual;


SELECT 
    TO_CHAR( SYSDATE, 'BC')  A-- ���� ���
    , TO_CHAR( SYSDATE, 'Q') B-- 1�б� ~ 4�б� ���
    , TO_CHAR( SYSDATE, 'HH24') C-- 15 // 24�ð� ����
    , TO_CHAR( SYSDATE, 'HH')   D-- 3  // 12�ð� ����
    , TO_CHAR( SYSDATE, 'SS')   E
    , TO_CHAR( SYSDATE, 'MI')   F
    , TO_CHAR( SYSDATE, 'DY')  G -- ȭ
    , TO_CHAR( SYSDATE, 'DAY')  H-- ȭ����
    , TO_CHAR( SYSDATE, 'DL')   I-- 2024�� 2�� 20�� ȭ����
    , TO_CHAR( SYSDATE, 'DS')  J -- 2024/02/20
FROM dual;



SELECT ename, hiredate
    , TO_CHAR( hiredate, 'DL')
    , TO_CHAR( hiredate, 'DS')
    , TO_CHAR( SYSDATE , 'TS') -- ���� 3:50:12 �ð��� ���
    , TO_CHAR( CURRENT_TIMESTAMP, 'HH24:MI.SS.FF9') NANO-- TIMESTAMP ����ϸ� FF���� �༭ ���� �����尪�� ������ �� �ִ�.
FROM emp;

-- TO_CHAR() : ��¥, ���� -> ���� �������� ��ȯ
-- [ ���� ] : ���� ��¥�� TO_CHAR()  ����ؼ� 
-- 2024�� 02�� 20�� ���� 16:05:29 (ȭ)

SELECT TO_CHAR( SYSDATE, 'YYYY"��" MM"��" DD"��" TS "("DY")"')
FROM dual;


SELECT TO_CHAR( CURRENT_TIMESTAMP, 'YYYY"��" MM"��" DD"��" PM HH24:MI:SS.FF5 (DY)')
FROM dual;

SELECT name, ssn
    , SUBSTR(ssn, 1, 6)
    , TO_DATE(SUBSTR(ssn, 1, 6))
    , TO_CHAR(TO_DATE(SUBSTR(ssn, 1, 6)), 'DL')
FROM insa;


SELECT 
    TO_DATE( '0821', 'MMDD' ) -- MMDD�ָ� ��¥ ��ü�� ����� �ش�.
    , TO_DATE( '2024', 'YYYY') -- 24/02/01 2��1�� ��¥�� �ڵ����� ���õȴ�.
    , TO_DATE( '202312', 'YYYYMM') --  23/12/01
    , TO_DATE( '23��01��12��', 'YY"��"MM"��"DD"��"' ) -- ���ڿ��� ��¥ ��ü�� �ٲٰ� �������� " " �ٿ��� �ش��ϴ� ���� ���� ����Ѵ�.
FROM dual;


-- ���� : ������ '6/14' ���ú��� ���� �ϼ� ?
SELECT SYSDATE
    , TO_DATE( '6/14', 'MM"/"DD') "DATE"
    , CEIL(ABS(SYSDATE - TO_DATE( '6/14', 'MM"/"DD'))) CEIL_DATE
    , CEIL(ABS(TO_DATE( '6/14', 'MM"/"DD') - SYSDATE)) CEIL_DATE2
FROM dual;


-- ���� : 4�ڸ� �μ���ȣ�� ���
SELECT LPAD(deptno, 4, '0') deptno
    , TO_CHAR( deptno, '0999') deptno2
FROM emp;


-- DECODE �Լ�
-- �񱳿���� = �� ���� �� �ִ�.( > < �̷� �� �ȵȴ�)
    
DECODE( A, B, 'C')
DECODE( A, B, 'C', 'D')
DECODE( A, B, 'C', F, 'D', 'X')

SELECT empno, ename
    , sal + NVL(comm, 0) pay
    , (SELECT ROUND(AVG(sal + NVL(comm, 0)), 2) AVG_PAY FROM emp) AVG_PAY
    , REPLACE(REPLACE(SIGN(sal + NVL(comm, 0) - (SELECT AVG(sal + NVL(comm, 0)) FROM emp)), -1 , '����') , 1, '����') AB
    , DECODE(SIGN(sal + NVL(comm, 0) - (SELECT AVG(sal + NVL(comm, 0)) FROM emp)), -1, '����', 1, '����', '����') DECODE
FROM emp GROUP BY empno, ename, sal + NVL(comm, 0);


SELECT name, ssn
    , DECODE(MOD(SUBSTR(ssn, 8, 1), 2), 1, '��', '��') GENDER
    , DECODE(MOD(SUBSTR(ssn, 8, 1), 2), 1, '��', 0,'��') GENDER2
FROM insa;


-- INSA ���̺��� ������ �������� ������ ���� ���θ� ����ϴ� ����
SELECT t.name, t.ssn, t.����, 
    DECODE(t.s, -1, '����', 0, '����' , '������')
FROM
    (
SELECT name, ssn
        , DECODE(SIGN(TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)), -1, '���� ����', 0, '������ ����', '������ ������') "����"
        , SIGN(TO_DATE(SUBSTR(ssn, 3, 4), 'MMDD') - TRUNC(SYSDATE)) s
FROM insa
    ) t;
    
    
    
-- ���� emp ���̺��� �� ����� ��ȣ, �̸�, �޿� ���
-- ����1 : 10�� �μ������� �޿��� 15%�λ�
-- ����2 : 20�� �μ������� �޿��� 10%�λ�
-- ����3 : 30�� �μ������� �޿��� 5%�λ�

WITH t AS
    (
SELECT ename, empno, sal + NVL(comm, 0) pay, deptno
FROM emp
    )
SELECT t.ename, t.pay, t.deptno
    , DECODE(t.deptno, 10, '15%', 20, '10%', '5%') "�λ��"
    , DECODE(t.deptno, 10, t.pay*1.15 , 20, t.pay*1.1,  t.pay*1.05) "�λ�� ����"
FROM t;
    
    
    
    





SELECT empno, ename , sal
    , DECODE( deptno, 10, '15%', 20, '10%', '5%') "�λ��"
    , sal + DECODE( deptno, 10, sal*0.15, 20, sal*0.1, sal*0.05) "�λ��_PAY"
FROM emp;

