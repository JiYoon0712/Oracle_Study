-- ■ PL/SQL
 -- ※ 커서(Cursor)
     -------------------------------------------------------
     -- 암시적 커서
         -- SQL%ROWCOUNT : 해당 SQL 문에 영향을 받는 행의 수
         -- SQL%FOUND : 해당 SQL 영향을 받는 행의 수가 1개 이상일 경우 TRUE
         -- SQL%NOTFOUND : 해당 SQL 문에 영향을 받는 행의 수가 없을 경우 TRUE
         -- SQL%ISOPEN : 항상 FALSE, 암시적 커서가 열려 있는지의 여부 검색

        DECLARE
            vempNo emp.empNo%TYPE;
            vCount NUMBER;
            
        BEGIN
            vempNo :='8001';
            DELETE FROM emp WHERE empNo = vempNo;
            vCount := SQL%ROWCOUNT;
            COMMIT;
            
            DBMS_OUTPUT.PUT_LINE(vCount ||'행이 삭제되었습니다.');
        END;
        /


        DECLARE
            vempNo emp.empNo%TYPE;
        BEGIN
            vempNo :='8001';
            DELETE FROM emp WHERE empNo = vempNo;
            
            IF SQL%NOTFOUND THEN
                RAISE_APPLICATION_ERROR(-20001,'없음');   --> try/catch의 catch로 보내준다.
            END IF;
            
            COMMIT;
            
            DBMS_OUTPUT.PUT_LINE('삭제되었습니다.');
        END;
        /


     -------------------------------------------------------
     -- 명시적 커서
     -- CURSOR 선언 -> 커서 OPEN -> FETCH -> 커서 CLOSE
    
        DECLARE 
            vname emp.name%TYPE;
            vsal emp.sal%TYPE;
        
            -- 1.커서선언
            CURSOR cur_emp IS SELECT name, sal FROM emp;    
        BEGIN
            -- 2. 커서 OPEN
            OPEN cur_emp;
            
            LOOP 
                -- 3. FETCH
                FETCH cur_emp INTO vname, vsal;
                EXIT WHEN cur_emp%NOTFOUND;
                
                 DBMS_OUTPUT.PUT_LINE(vname||'  '||vsal);
            END LOOP;
            
            -- 4. 커서 CLOSE
            CLOSE cur_emp; 
        END;
        /
    -- > 커서가 중요한 것이 아니라. 이 커서의 결과를 자바로 돌려주는 것이 중요하다. >> 아웃 파라미터
    
     -------------------------------------------------------
     -- 이름 검색 :  파라미터가 있는 커서를 이용
     CREATE OR REPLACE PROCEDURE pEmpSelect
     (
            pName emp.name%TYPE
     )
     IS
        vName emp.name%TYPE;
        vSal  emp.sal%TYPE;
     
        CURSOR cur_emp(cName emp.name%TYPE) IS
            SELECT name,sal FROM emp WHERE INSTR(name,cName) >0;
     BEGIN
        OPEN cur_emp( pName );
        LOOP
            FETCH cur_emp INTO vName, vSal;
            EXIT WHEN cur_emp%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE(vName||'  '||vSal);
        END LOOP;
        CLOSE cur_emp;
     END;
     /
     
     EXEC pEmpSelect('김');


     -- 이름 검색 : 조건 검색
     CREATE OR REPLACE PROCEDURE pEmpSelect
     (
            pName emp.name%TYPE
     )
     IS
        vName emp.name%TYPE;
        vSal  emp.sal%TYPE;
     
        CURSOR cur_emp IS
            SELECT name,sal FROM emp WHERE INSTR(name,pName) >0;
     BEGIN
        OPEN cur_emp;
        LOOP
            FETCH cur_emp INTO vName, vSal;
            EXIT WHEN cur_emp%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE(vName||'  '||vSal);
        END LOOP;
        CLOSE cur_emp;
     END;
     /
     
     EXEC pEmpSelect('이');
     
    -------------------------------------------------------
    -- Cursor FOR Loops : 자동 OPEN, 자동 FETCH, 자동 CLOSE
    CREATE OR REPLACE PROCEDURE pEmpSelect
    IS
        CURSOR cur_emp IS
            SELECT name,sal FROM emp;
    BEGIN
        FOR rec IN cur_emp LOOP
            DBMS_OUTPUT.PUT_LINE(rec.name||'  '||rec.sal);
        END LOOP;
    END;
    /




   ο 커서 변수(cursor variable)
     -------------------------------------------------------
     -- SYS_REFCURSOR  >>> 이게 제일 중요★★★
        -- : 약한 참조 커서 타입
        -- : 데이터 타입을 포함하고 있지 않기 때문에 모든 결과 셋을 저장할 수 있음
        -- : 프로시저 실행결과(SELECT 문)를 자바 등 프로그램에 전달 할때 사용
      -- 커서 변수 선언
        커서변수 SYS_REFCURSOR;
      -- 커서 변수 사용
         OPEN 커서변수 FOR SELECT 문
      -- 커서 변수에서 값 가져 오기
         FETCH 커서변수 INTO 변수, 변수;
         FETCH 커서변수 INTO 레코드변수;

     -------------------------------------------------------
     --  >> ★
     CREATE OR REPLACE PROCEDURE pEmpSelect
     (
            pName   IN  VARCHAR2,
            pResult OUT SYS_REFCURSOR
     )
     IS
     BEGIN
        -- 커서 변수 사용 : OPEN 커서변수 FOR SELECT문
        OPEN pResult FOR
            SELECT name, sal FROM emp WHERE INSTR(name, pName) > 0;
     END;
     /

    -- 확인용 프로시저
    CREATE OR REPLACE PROCEDURE pEmpResult
    IS
        vName   emp.name%TYPE;
        vSal    emp.sal%TYPE;
        vResult SYS_REFCURSOR;
    BEGIN
        -- 프로시저 호출
        pEmpSelect('이',vResult);
        
        LOOP
            FETCH vResult INTO vName, vSal;
            EXIT WHEN vResult%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vName||' '||vSal);
        END LOOP;
    END;
    /
     
    EXEC pEmpResult;
    
     
   -----------------------------------------------------
   -- 페이징 처리 테스트
   CREATE TABLE demo(
        num NUMBER PRIMARY KEY,
        name VARCHAR2(50) NOT NULL,
        content VARCHAR(4000) NOT NULL,
        reg_date DATE DEFAULT SYSDATE
   );
   
   CREATE SEQUENCE demo_seq
   INCREMENT BY 1
   START WITH 1
   NOMAXVALUE
   NOCYCLE
   NOCACHE;
   
   CREATE OR REPLACE PROCEDURE pInsertDemo
   IS
        n NUMBER := 0;
   BEGIN
        WHILE n<700000 LOOP
            n:= n+1;
            INSERT INTO demo(num, name, content) VALUES (demo_seq.NEXTVAL, '이름'||n,'내용이다 - '||n);
            COMMIT;
        END LOOP;
   END;
   /
   
   EXEC pInsertDemo;
   SELECT COUNT(*) FROM demo;

   -- num 내림차순 정렬하여 90001 ~ 90010 레코드 출력
   SELECT * FROM (
        SELECT ROWNUM rnum, tb.* FROM(
            SELECT num, name, content
            FROM demo
            ORDER BY num DESC
        ) tb WHERE ROWNUM <=90010
   ) WHERE rnum >= 90001;
    
    SELECT num, name, content
    FROM demo
    ORDER BY num DESC
    OFFSET 90000 ROWS FETCH FIRST 10 ROWS ONLY;
    
    DROP TABLE demo PURGE;
    DROP SEQUENCE demo_seq;
    DROP PROCEDURE pInsertDemo;
    

 ※ 동적쿼리(Dynamic SQL)
     -------------------------------------------------------
     -- EXECUTE IMMEDIATE
        -- : DDL, DML 구문을 실행
        -- : SELECT 구문 실행 시 INTO 절을 사용하여 단일 값을 반환 받을 때 사용
        -- : 프로시저 등에서 동적으로 쿼리를 생성하거나 텍스트 쿼리를 입력 받아 처리하는 경우 사용
        -- : RESOURCE 권한만 있으면 기본적으로 테이블생성, 시퀀스 생성등을 할수 있지만 EXECUTE IMMEDIATE 에서는 불가능하다.
        -- : EXECUTE IMMEDIATE 로 테이블을 생성하거나 시퀀스를 만들기 위해서는 다음의 시스템 권한이 필요 한다.
          CREATE TABLE, CREATE SEQUENCE

     -------------------------------------------------------
     -- 관리자 계정(sys, system)
        GRANT CREATE TABLE TO sky;
        GRANT CREATE SEQUENCE TO sky;

     -------------------------------------------------------
     -- sky 계정
     -- 시스템 권한 확인
        SELECT * FROM user_sys_privs;
        
     -- 동적으로 게시판 테이블을 만드는 프로시저 만들기
        CREATE OR REPLACE PROCEDURE pBoardCreate
        (
            pName VARCHAR2
        )
        IS
            s VARCHAR2(4000);
        BEGIN
            s := ' CREATE TABLE ' || pName ;
            s := s || ' ( num NUMBER PRIMARY KEY,';
            s := s || ' name VARCHAR2(30) NOT NULL,';
            s := s || ' subject VARCHAR2(300) NOT NULL,';
            s := s || ' content VARCHAR2(4000) NOT NULL,';
            s := s || ' hitCount NUMBER DEFAULT 0,';
            s := s || ' reg_date DATE DEFAULT SYSDATE)';
            
            FOR t IN ( SELECT tname FROM tab WHERE tname = UPPER(pName) ) LOOP
                EXECUTE IMMEDIATE 'DROP TABLE ' || pName || ' PURGE';
                DBMS_OUTPUT.PUT_LINE( pName || '테이블 삭제...');
            END LOOP;
            
            EXECUTE IMMEDIATE s;
            
            DBMS_OUTPUT.PUT_LINE( pName || '테이블 생성');
            
            FOR t IN ( SELECT sequence_name FROM seq WHERE sequence_name = UPPER(pName || '_seq') ) LOOP
                EXECUTE IMMEDIATE 'DROP SEQUENCE ' || pName || '_seq';
                DBMS_OUTPUT.PUT_LINE(pName || '_seq 시퀀스 삭제...');
            END LOOP;
            
            EXECUTE IMMEDIATE 'CREATE SEQUENCE '|| pName || '_seq';
            
            DBMS_OUTPUT.PUT_LINE( pName || '_seq 시퀀스 생성');
        END;
        /
        
        EXEC pBoardCreate('demo');
        
        SELECT * FROM tab;
        SELECT * FROM seq;
        