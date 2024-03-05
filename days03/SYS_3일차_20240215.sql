-- SYS
SELECT *
FROM dba_users;

ALTER USER hr IDENTIFIED BY abcd;
ALTER USER hr ACCOUNT UNLOCK;

SELECT *
FROM dba_roles;

-- 예약어 목록이 나오는 쿼리문
SELECT *
FROM V$RESERVED_WORDS
WHERE keyword = 'DATE';

SELECT *
FROM dictionary
WHERE table_name LIKE '%WORDS%';