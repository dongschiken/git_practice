-- ���� 1 employees ���̺��� ����� ���� �̸��� Name, ������ job, �޿��� ������ 100 �߰�
SELECT first_name || last_name "Name" 
    , job_id job
    , salary
    , salary*12+100 "Increased Ann-Salary" 
    , salary+100 "Increased Salary"
FROM employees;

SELECT *
FROM employees;

-- ���� 2 employees ���̺��� ��� ����� ��, ������ �� : 1 Year Salary = $���� �������� ��� 
SELECT last_name || ' : 1 Year Salary = $' || salary*12 "1 Year Salary"
FROM employees;


-- ���� 3 �μ����� ����ϴ� ������ �ѹ��� ���
SELECT DISTINCT DEPARTMENT_ID, JOB_ID
FROM employees;


-- ���� 4 ����� �̸� �߿� 'e' 'o' ���ڰ� ���Ե� ����� ��� ��Ī�� e and o Name
SELECT last_name
FROM employees
WHERE REGEXP_LIKE(last_name, '[eo]');
WHERE last_name LIKE '%e%' OR last_name LIKE '%o%';



-- ���� 5 ��¥ �Լ� �̿��ؼ� 2006�� 05�� 20�� ���� 2007�� 05�� 20�� ���̿� ���� ���
SELECT first_name || ' ' || last_name  "Name"
    , job_id, hire_date
FROM employees
WHERE hire_date BETWEEN TO_DATE('2006-05-20', 'YYYY/MM/DD') AND TO_DATE('2007-05-20', 'YYYY/MM/DD')
ORDER BY hire_date ASC;



-- ���� 6 ����޴� ��� ����� ���� �̸�, �޿�, ����, ����� ��� �޿� ���� ������� -> ����� ū ������� ����
SELECT first_name || ' ' || last_name  "Name"
    , salary
    , job_id
    , commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC, commission_pct DESC;


-- ���� 7 ���� 's'�� ������ ����� �̸��� �����̸��� ���� ù �ڸ� �빮�� ( INITCAP() ) ������ ��� �빮��
WITH t AS 
    (
    SELECT INITCAP(first_name) || ' ' || INITCAP(last_name) || ' is a ' || job_id "Employee JOBs" FROM employees
    )
SELECT t.*
FROM t;

-- ���� 8 ���� �ۼ� ��, �̸�, �޿�, ����, ������ ������ sal + comm, ���� ������ sal only
SELECT  first_name || ' ' || last_name  "Name" 
        ,salary
        ,salary*12 "Annual Salary"
        ,salary*(1+NVL(commission_pct, 0))*12 "Annual Salary*commission"
        , CASE NVL(commission_pct, 0)
            WHEN 0 THEN 'salary only'
            ELSE 'salary + commission'
            END "commission ?"
FROM employees
ORDER BY "Annual Salary" DESC;


-- ���� 9 ��� ����� ��, �̸�, �Ի���, �Ի� ������ ����Ͻÿ� // �̶� ��(week)�� ������ �Ͽ��� ���� ���
SELECT  first_name || ' ' || last_name  "Name" 
    ,   hire_date
    ,   TO_CHAR(hire_date, 'day') "Day of the week"
FROM employees
ORDER BY "Day of the week" ASC;


-- ���� 10 �� ����� �μ����� �޿� �հ�, �޿� ���, �޿� �ִ밪, �޿� �ּڰ��� ���� 
SELECT department_id, TO_CHAR(SUM(salary), '$999,999.00') "Sum Salary"
    , TO_CHAR(AVG(salary), '$999,999.00') "Avg Salary"
    , TO_CHAR(MAX(salary), '$999,999.00') "Max Salary"
    , TO_CHAR(MIN(salary), '$999,999.00') "Min Salary"
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY department_id ASC;


-- ���� 11 ������ ��ü �޿� ����� $10,000 ���� ū ��츦 ��ȸ ������ �޿� ��� ��ȸ
SELECT job_id, AVG(salary)
FROM employees
WHERE job_id NOT LIKE '%CLERK%'
GROUP BY job_id
HAVING AVG(salary) > 10000
ORDER BY AVG(salary) DESC;


-- ���� 12 employees, deparments ���̺��� ���� �ľ� �� ������� 5�� �̻��� �μ��� �μ���� ����� �����
SELECT e.department_id, COUNT(*)
FROM employees e LEFT OUTER JOIN departments d ON e.department_id = d.department_id
GROUP BY e.department_id
HAVING COUNT(*) >= 5
ORDER BY COUNT(*) DESC;


SELECT *
FROM job_grades;

SELECT *
FROM employees;

-- ���� 13 �� ����� �޿��� ���� �޿� ��� ���
WITH t AS
    (
SELECT DISTINCT employee_id,  first_name || ' ' || last_name  "Name"
            , department_id, hire_date, salary
            , grade_level
FROM employees , job_grades
WHERE salary BETWEEN lowest_sal AND highest_sal
    )
SELECT t.*, department_name
FROM t t LEFT OUTER JOIN departments d ON t.department_id = d.department_id
ORDER BY t.grade_level ASC;


-- ���� 15 ����� �޿� ���� �� ������ �ּ� �޿��� �ް� �ִ� ����� ���� �̸� ���
SELECT  
        ,  job_id
        ,  MIN(salary) salary
FROM employees
GROUP BY  job_id;

WITH t AS
    (
    SELECT  
          job_id
        ,  MIN(salary) salary
    FROM employees
    GROUP BY  job_id
    )
SELECT e.first_name || ' ' || e.last_name  "Name", t.job_id , t.salary
FROM t LEFT OUTER JOIN employees e ON t.job_id = e.job_id ;


-- ���� 16 �ҼӺμ��� ��� �޿����� ���� �޿��� �޴� ����� �̸��� ��
WITH t AS
    (
    SELECT AVG(salary) pay FROM employees GROUP BY department_id
    )
SELECT DISTINCT e.first_name || ' ' || e.last_name  "Name", e.salary, e.department_id, e.job_id
FROM t, employees e
WHERE e.salary > t.pay;

-- ���� 17 ������� ������ �ٹ� ��Ȳ�� ��ȸ�ϰ��� �Ѵ�, ���� �̸��� ���� 'O'�� �����ϴ� ������ ����ִ� ����� ���, ���� �̸� ����, �Ի����� ���



-- ���� 18  UNION ALL �ؼ� ����� ���� ������� ���
SELECT employee_id, job_id, department_id
FROM employees
UNION ALL
SELECT employee_id, job_id, department_id
FROM job_history
ORDER BY employee_id;


-- ���� 19 INTERSECT ���
SELECT employee_id, job_id
FROM employees
INTERSECT
SELECT employee_id, job_id
FROM job_history
ORDER BY employee_id;


-- ���� 20 MINUS ���
SELECT employee_id
FROM employees
MINUS
SELECT employee_id
FROM job_history;



-- ���� 21 �μ��� �޿� �հ� 
WITH t AS (
    SELECT department_id, SUM(salary) pay 
    FROM employees
    GROUP BY department_id
        )
SELECT t.department_id, t.pay,
    CASE 
    WHEN pay > 100000 THEN 'Excellent'
    WHEN pay > 50000 THEN 'Good'
    WHEN pay > 10000 THEN 'Medium'
    ELSE 'well'
    END "Department Grade Salary"
FROM t
ORDER BY "Department Grade Salary" ASC;


-- ���� 22 2005�� ������ �Ի��� ����� MGR�̸� 15%�λ�, MAN�̸� 20%�λ�
SELECT employee_id
    , first_name || ' ' || last_name  "Name"
    , job_id, hire_date
    , salary
    , salary * CASE SUBSTR(job_id, 4, 3)
        WHEN 'MGR' THEN 1.15
        WHEN 'MAN' THEN 1.2
        ELSE 1.25
      END "Department Grade Salary"
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') < '2005'
--WHERE hire_date < '2005.01.01'
ORDER BY hire_date

-- ���� 21
