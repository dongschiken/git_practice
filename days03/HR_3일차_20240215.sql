-- HR

DESC employees;

SELECT first_name, last_name, first_name ||' '||last_name "NAME"
FROM employees;

SELECT *
FROM tabs;


-- [NOT] LIKE SQL 연산자 설명
-- 문자의 패턴 일치 여부 체크하는 연산자
-- 와일드 카드 ( %, _ ) 기호는 이렇게 두개만 사용 가능
-- % : 0 ~ 여러 개의 문자
-- _ : 한 개의 문자
-- 와일드 카드를 일반 문자처럼 사용하려면 ESCAPE 옵션을 사용하라...

SELECT last_name, salary 
FROM employees
WHERE last_name LIKE 'R%'
ORDER BY salary;


SELECT last_name, salary 
FROM employees
WHERE last_name = 'R%'
ORDER BY salary;


SELECT last_name, salary 
FROM employees
-- R로 시작하고 그 뒤에 문자가 3개 오는 것 Rajs
WHERE last_name LIKE 'R___'  --  ☜ underscore(_)가 3개임
ORDER BY salary;

