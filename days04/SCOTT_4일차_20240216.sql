-- SCOTT   

SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn, '^7[0-9]12\d-[13579]');

SELCECT *
FROM empl;

SELECT *
FROM insa;

SELECT *
FROM insa
WHERE EXTRACT( YEAR FROM TO_DATE(SUBSTR(ssn, 1, 6))) BETWEEN '1970' AND '1979';

SELECT DISTINCT BUSEO
FROM insa
ORDER BY buseo ASC;

SELECT ssn 
    , SUBSTR(ssn, 1, 2) YEAR
    , SUBSTR(ssn, 3, 2) MONTH
    , SUBSTR(ssn, 5, 2) "DATE"
    , SUBSTR(ssn, 8, 1) GENDER
FROM insa;


SELECT *
FROM emp;

SELECT ename, hiredate
    , TO_CHAR( hiredate, 'YYYY') YEAR
    , SUBSTR(hiredate, 4, 2) MONTH
    , SUBSTR(hiredate, 7, 2) "DATE"
    , TO_CHAR(hiredate, 'DD') "DATE2"
    , TO_CHAR(hiredate, 'DDD') "DATE3" -- ���߿� ���� °?
    , TO_CHAR(hiredate, 'D') "DATE4"   -- �� �ֿ� ����°?
FROM emp;


SELECT name, ssn
FROM insa
--WHERE ssn LIKE '7_12%'
WHERE REGEXP_LIKE( ssn, '^7?\d(12)')
ORDER BY ssn ASC;


SELECT *
FROM dept;

INSERT INTO dept VALUES( 50, 'QC', 'SEOUL' );

UPDATE dept
SET loc = 'POHANG', dname = dname || '2'
WHERE dname = 'QC';

SELECT name, ssn, 


SELECT *
FROM   (
    SELECT ename, sal + NVL(comm, 0) pay, deptno
    FROM emp
    ) t
WHERE t.pay BETWEEN 1000 AND 3000 AND t.deptno != 30;


SELECT name, ssn
    , MOD(SUBSTR(ssn, 8, 1), 2) GENDER
FROM insa
--WHERE ssn LIKE '7%' AND SUBSTR(ssn, 8, 1) IN (1, 3, 5, 7, 9);
WHERE ssn LIKE '7%' AND MOD(SUBSTR(ssn, 8, 1), 2) = 1;


SELECT name, ssn
    , SUBSTR(ssn, 8, 1) || 'O' GENDER
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d*-[13579]');

SELECT ename
FROM emp
WHERE UPPER(ename) LIKE '%LA%';
--WHERE ename LIKE '%' || UPPER('la') || '%';

SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn, '^7\d*-[13579]');

SELECT *
FROM insa
WHERE CITY NOT IN ('����', '���', '��õ');

SELECT temp.name, temp.ssn
    , REPLACE( REPLACE (temp.gender, 1, 'O'), 0, 'X') GENDER
FROM(
    SELECT name, ssn
    , MOD( SUBSTR (ssn, 8, 1), 2) GENDER
    FROM insa
) temp;

-- NULLIF(VALUE1, VALUE2)
-- VALUE1 == VALUE2 ==> NULL�� ��ȯ
-- VALUE1 != VALUE2 ==> ù ���� ��ȯ

SELECT ename,job
    ,lengthb(ename)
    ,lengthb(job),
NULLIF(lengthb(ename),lengthb(job)) nullif_result
FROM emp   
WHERE deptno=20;

SELECT name
    , LENGTH(name) -- 3
    , LENGTHB(name) -- 9 LENGTHB�� B�� ����Ʈ�� �ǹ� (����Ŭ���� �ѱ��� 3����Ʈ�� ������)
FROM insa;

-- �Լ��� ���� Ȱ���� �����Ѵ�.
SELECT name, ssn
    ,NVL2(NULLIF(MOD(SUBSTR(ssn, 8, 1), 2) , 1), 'O', 'X') GENDER
FROM insa;

SELECT *
FROM emp
WHERE REGEXP_LIKE(ename, 'king', 'i'); -- i�� �ǹ� : ��ҹ��� �������

--
DESC insa;

SELECT name, ibsadate
    , TO_CHAR( ibsadate, 'YYYY.MM.DD') ibsadate2
    , TO_CHAR( ibsadate, 'YYYY') 
FROM insa
WHERE ibsadate >= '2000.01.01';
--WHERE TO_CHAR( ibsadate, 'YYYY') >= 2000;
WHERE EXTRACT( YEAR FROM ibsadate) >= 2000;

SELECT SYSDATE, CURRENT_TIMESTAMP
FROM dual;

DESC dual;

-- ��� ������
SELECT 5+3, 5-3, 5*3, 5/3, MOD(5,3)
-- SELECT 5/0 :  "divisor is equal to zero" 0���� ���� �� ����.
SELECT MOD(5,0)
FROM dual;


SELECT *
FROM emp;

-- SYNONYM ����� ���
-- ORA-00905: missing keyword
-- public SYNONYM�� DBA������ ���� ��Ű�������� ���� �����ϴ�.
CREATE PUBLIC SYNONYM scott.arirang
FOR scott.emp;

SELECT name, ssn
    ,CONCAT( SUBSTR( ssn, 1, 6) , SUBSTR( ssn, 8)) SSN
FROM insa;

-- REPLACE �Լ� ����ؼ� �ٲٱ�
SELECT name, ssn
--    ,CONCAT( SUBSTR( ssn, 1, 6) , SUBSTR( ssn, 8)) SSN
    ,REPLACE( ssn, '-', '') ssn
    ,REPLACE( ssn, '-') ssn -- 3��° ���ڰ� ���ָ� 2��° ���ڰ� �����Ѵ�.
FROM insa;


SELECT 
     TO_DATE( '2024', 'YYYY')
    ,TO_DATE( '2024/03', 'YYYY/MM' )
    ,TO_DATE( '2024/05/21' )
FROM dual;

-- EX) �μ��� : QC100%T, �ѱ�_����

-- 18. insa ���̺��� ����   �达, �̾� �� 70��� 12������ ����� ��ȸ.

SELECT name, ssn
FROM insa
WHERE REGEXP_LIKE( name, '^[����]') AND ssn LIKE '7_12%'; 

--WHERE dname LIKE '%\_%' ESCAPE '\';


-- ���⼭ YY�� RR�� ������
-- RR�� YY�� �Ѵ� �⵵�� ������ ���ڸ��� ����� ������, ���� system���� ����� ��Ÿ������ �ϴ� �⵵�� ���⸦ ���� ���� �� ��µǴ� ���� �ٸ���.
-- RR�� �ý��ۻ�(1900���)�� �⵵�� �������� �Ͽ� ���� 50�⵵���� ���� 49������� ���س⵵�� ����� 1850�⵵���� 1949�⵵������ ������ ǥ���ϰ�, 
-- �� ������ ���Ƴ� ��� �ٽ� 2100���� �������� ���� 50�⵵���� ���� 49������� ���� ����Ѵ�.
-- YY�� ������ system���� �⵵�� ������.

SELECT TO_CHAR( SYSDATE, 'CC') -- CC�� ���⸦ ��Ÿ���� 21����
FROM dual;

SELECT
     TO_CHAR( TO_DATE('97/01/10', 'YY,MM.DD') , 'YYYY')  -- 2097
    ,TO_CHAR( TO_DATE('97/01/10', 'RR,MM.DD') , 'YYYY')  -- 1997
    ,TO_CHAR( TO_DATE('05/01/10', 'YY,MM.DD') , 'YYYY')  -- 2005
    ,TO_CHAR( TO_DATE('05/01/10', 'RR,MM.DD') , 'YYYY')  -- 2005
--SELECT TO_CHAR( '05/01/10', 'RR.MM.DD')
FROM dual;



SELECT deptno, ename, sal + NVL(comm, 0) pay
FROM emp
-- 1�������� ASC �����ϰ� �� �� PAY�� �������� �������� ���� �ϰڴ�.
--ORDER BY 1 ASC , 3 DESC -- 1�� Į���� ���� ������ ����ϰڴ�, 3���� �������� DESC�ϰڴ�.
ORDER BY deptno ASC, pay DESC;

SELECT *
FROM emp
--WHERE sal >= null;
--WHERE sal != 1250;
--WHERE sal < 1250;
--WHERE sal <= 1250;
--WHERE sal > 1250;
--WHERE sal >= 1250;
WHERE sal = 1250;

ANY
SOME
ALL

-- emp ���̺��� ��ձ޿����� ���� �޴� ������� ������ ��ȸ.
-- 1. emp ���̺��� ��� �޿�?

SELECT AVG( sal + NVL(comm, 0)) "AVG PAY"
FROM emp;

-- UNION�� ���� 3���� �������� ���ļ� ���
SELECT *
FROM emp
WHERE deptno = 10 AND sal + NVL(comm, 0) >= (SELECT AVG(sal + NVL(comm, 0)) avg_pay FROM emp WHERE deptno = 10)
UNION 
SELECT *
FROM emp
WHERE deptno = 20 AND sal + NVL(comm, 0) >= (SELECT AVG(sal + NVL(comm, 0)) avg_pay FROM emp WHERE deptno = 20)
UNION 
SELECT *
FROM emp
WHERE deptno = 30 AND sal + NVL(comm, 0) >= (SELECT AVG(sal + NVL(comm, 0)) avg_pay FROM emp WHERE deptno = 30);

     
-- [����] �� �μ��� ��� �޿����� ���� �޴� ������� ������ ��ȸ

SELECT AVG( sal + NVL(comm, 0)) "10AVG PAY"
FROM emp
WHERE deptno = 10;  -- 2916.666666666666666666666666666666666667

SELECT AVG( sal + NVL(comm, 0)) "20AVG PAY"
FROM emp
WHERE deptno = 20;  -- 2258.333333333333333333333333333333333333

SELECT AVG( sal + NVL(comm, 0)) "30AVG PAY"
FROM emp
WHERE deptno = 30;  -- 1933.333333333333333333333333333333333333



-- ANY, ALL, SOME�� �� �񱳿����ڿ� �Բ� ����ؾ� �Ѵ�.

-- 30�� �μ��� �ְ� �޿����� ���� �޴� ������� ������ ��ȸ
SELECT *
FROM emp
WHERE sal + NVL(comm, 0) > ALL (SELECT sal + NVL(comm, 0) FROM emp WHERE deptno = 30);
WHERE sal + NVL(comm, 0) > (SELECT MAX(sal + NVL(comm, 0)) FROM emp WHERE deptno = 30);


SELECT ename,empno, deptno, job
FROM emp
WHERE deptno=10 AND job='CLERK';

SELECT ename,empno
FROM emp
WHERE deptno=10 OR job='CLERK';

SELECT ename,empno, deptno, job
FROM emp
WHERE deptno NOT IN(10,30);

WITH temp AS
    (
    SELECT sal + NVL(comm, 0) pay
    FROM emp
    ) 
SELECT MAX(t.pay), AVG(t.pay), SUM(t.pay), MIN(t.pay)
--FROM temp t; -- �׽�Ƽ�� ���� ����
FROM ( SELECT sal + NVL(comm, 0) pay
       FROM emp) t -- �ζ��� ��
;

-- ��� ���� ����
-- [����] ��� ��ü���� �ְ� �޿��� �޴� ����� ������ ��ȸ  -  �����, �����ȣ, �޿���, �μ���ȣ
SELECT deptno, empno, ename, sal + NVL(comm, 0) pay
FROM emp
WHERE sal + NVL(comm, 0) ANY ( 
ORDER BY pay DESC;
-- [����] �� �μ��� �ְ� �޿��� �޴� ����� ������ ��ȸ
-- ����������� : ���������� �����������ִ� ���� �����ؼ� ����ϴ� ��
-- 10, 20, 30�� c���� �Ѱ��� �����Ǿ max_pay�� ������ش�.
-- child�� parent�� ����� c�� p�� �����ϰ� �ִ� ���� => p.deptno
SELECT deptno, empno, ename, sal + NVL(comm, 0) pay
FROM emp p
WHERE sal + NVL(comm, 0) = ( SELECT MAX(sal + NVL(comm, 0) ) max_pay
                            FROM emp c
                            WHERE deptno = p.deptno);

SELECT *
FROM emp;

-- ******* not a single-group group function(�߿��� �����޽���) : ������(�Ϲ� �÷��� ����) �Լ�, ������(SUM(), COUNT(), AVG(), MOD())�Լ��� ���� ������� �� �߻��ϴ� ����
-- ��Į�� �������� SELECT deptno, ename, sal, ( SELECT AVG (sal) FROM emp WHERE deptno = t1.deptno) ����ؼ� ������ �Լ��� ������ �� �� �ִ�. ���⼭�� ���輭�� ���� �̿��ؼ� t1�� ���� �����ؼ� deptno�� ���� ��� ���
SELECT deptno, ename, sal, ( SELECT AVG (sal) FROM emp WHERE deptno = t1.deptno) deptno_avg_sal
FROM emp t1
WHERE sal > (SELECT avg(sal)
            FROM emp t2
            WHERE deptno = t1.deptno)
ORDER BY deptno ASC;


SELECT *
FROM insa;

-- ibsa��¥�� ��������
WITH temp AS
    (
    SELECT TO_DATE(SUBSTR(ibsadate, 1, 2)) ibsadate FROM insa
    )
SELECT t.ibsadate
FROM temp t;


SELECT temp.ssn, CONCAT(ssn4, ssn3)
FROM 
    (
    SELECT ssn, SUBSTR(ssn, 1, 6) ssn3, SUBSTR(ssn, 8, 7) ssn4 FROM insa
    ) temp;


SELECT dname = temp.dname
FROM 
    (
    SELECT deptno, danme, loc FROM emp 
    WHERE  deptno = 20
    ) temp;


SELECT name, ibsadate
FROM insa
--WHERE TO_CHAR(ibsadate, 'YYYY') >= 2000
WHERE EXTRACT( YEAR FROM ibsadate) >= 2000
ORDER BY ibsadate ASC;





-- SSN���� ���� ã�ƿͼ� ���ڴ�(1, 3, 5, 7, 9) O ���ڴ� X

SELECT temp.name ,REPLACE(REPLACE(temp.gender, 1, 'M'), 0, 'W') GENDER, temp.gender
FROM 
    (
    SELECT name, MOD(SUBSTR(ssn, 8, 1), 2) GENDER FROM insa
    ) temp
;
-- 18. insa ���̺��� ����   �达, �̾� �� 70��� 12������ ����� ��ȸ.

SELECT *
FROM insa
WHERE REGEXP_LIKE( name, '^[����]' ) AND REGEXP_LIKE( ssn, '^7\d12' );


-- emp ���̺��� ��ձ޿����� ���� �޴� ������� ������ ��ȸ.
-- 1. emp ���̺��� ��� �޿�?

SELECT temp.avg_pay
FROM 
    (
    SELECT AVG( basicpay + sudang ) avg_pay FROM insa
    ) temp;

SELECT *
FROM insa p
WHERE basicpay > ( SELECT AVG(basicpay) max_pay FROM insa c WHERE buseo = p.buseo )
ORDER BY buseo ASC;

DESC insa;


-- ANY ��� ������������ �������� �������� �� �� ������ ���� �� �ϳ��� ������ �ִٸ� 
-- ALL ���� ������������ �������� �������� �� �� ������ ���� �� ���δ� ������ 

-- ANY, ALL, SOME�� �� �񱳿����ڿ� �Բ� ����ؾ� �Ѵ�.



-- [����] �� �μ��� ��� �޿����� ���� �޴� ������� ������ ��ȸ

-- 30�� �μ��� �ְ� �޿����� ���� �޴� ������� ������ ��ȸ



-- ���� ��� ����
-- [����] ��� ��ü���� �ְ� �޿��� �޴� ����� ������ ��ȸ  -  �����, �����ȣ, �޿���, �μ���ȣ



-- [����] �� �μ��� �ְ� �޿��� �޴� ����� ������ ��ȸ
-- ����������� : ���������� �����������ִ� ���� �����ؼ� ����ϴ� ��
-- 10, 20, 30�� c���� �Ѱ��� �����Ǿ max_pay�� ������ش�.
-- child�� parent�� ����� c�� p�� �����ϰ� �ִ� ���� => p.deptno
