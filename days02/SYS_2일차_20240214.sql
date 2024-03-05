--  SYS
	SELECT *
--	FROM all_users;
	FROM dba_users;
    
    -- v$는 데이터 사전
    select a.spid, b.name, c.server, c.type
    from v$process a, v$bgprocess b, v$session c
    where b.PADDR(+) = a.ADDR AND a.ADDR = c.PADDR
    AND b.NAME is NULL;
    -- 테이블스페이스 조회(확인) --

    -- 테이블 스페이스 조회    
    SELECT *
    FROM dba_data_files;
    
    -- 테이블 스페이스 조회 / 테이블 스페이스 이름과 상태만 출력
    SELECT tablespace_name,status 
    FROM dba_tablespaces;
    
    GRANT CONNECT, RESOURCE TO SCOTT;
    
