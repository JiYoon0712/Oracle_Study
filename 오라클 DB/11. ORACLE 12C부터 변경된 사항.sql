-- ■ 오라클 12C부터 변경된 사항
 -- ※ 12C부터 추가된 새로운 기능
    -- ◎ Top-N 기능
      -----------------------------------------------
      -- 처음레코드부터 3개만 출력
        SELECT *
        FROM emp
        FETCH FIRST 3 ROWS ONLY;
        
       -- sal 내림차순 정렬하여 처음부터 5개만 출력
        SELECT *
        FROM emp
        ORDER BY sal DESC
        FETCH FIRST 5 ROWS ONLY;
        
       -- sal 내림차순 정렬하여 15개를 건너뛰고 5개만 출력
        SELECT *
        FROM emp
        ORDER BY sal DESC
        OFFSET 15 ROWS FETCH FIRST 5 ROWS ONLY;        
       
       -- sal 내림차순 정렬하여 상위 10%만 출력  
        SELECT *
        FROM emp
        ORDER BY sal DESC
        FETCH FIRST 10 PERCENT ROWS ONLY;         

        -- 페이징 처리 : 11g
            -- sal 내림차순 정렬해서 21~30번째 레코드 출력
            SELECT * FROM(
                SELECT ROWNUM rnum, tb.* FROM(
                      SELECT empNo, name, sal
                      FROM emp
                      ORDER BY sal DESC
                )tb WHERE ROWNUM <=31
            )WHERE rnum >=21;
        
        
        -- 페이징 처리 : 12C 이상
        SELECT empNo, name, sal
        FROM emp
        ORDER BY sal DESC
        OFFSET 20 ROWS FETCH FIRST 10 ROWS ONLY;
        
      -----------------------------------------------
      -- sal 내림차순 정렬하여 sal가 4540000인 사람의 바로 이전 레코드 출력(empNo, name, sal 출력)
        -- 출력 : 1003 이순애 4550000
        SELECT empNo, name, sal         --> 같은 값을 가진 사람이 없다는 가정하에
        FROM emp
        WHERE sal > 4540000            
        ORDER BY sal ASC
        FETCH FIRST 1 ROWS ONLY;
        
        SELECT * FROM( 
            SELECT empNo, name, sal
            FROM emp
            WHERE sal > 4540000
            ORDER BY sal ASC
        ) WHERE ROWNUM =1;
      
      -- sal 내림차순 정렬하여 sal가 4540000인 사람의 바로 이후 레코드 출력(empNo, name, sal 출력)
        -- 출력 : 1031 지재환 4450000
        SELECT empNo, name, sal
        FROM emp
        WHERE sal < 4540000
        ORDER BY sal DESC
        FETCH FIRST 1 ROWS ONLY;      
      
        SELECT * FROM( 
            SELECT empNo, name, sal
            FROM emp
            WHERE sal < 4540000
            ORDER BY sal DESC
        ) WHERE ROWNUM =1;
      

    -- ◎ INVISIBLE column : 보이지 않는 컬럼
      -----------------------------------------------
      -- 
      CREATE TABLE test(
        num NUMBER PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        tel VARCHAR2(30) INVISIBLE
      );
      
      -- 컬럼 확인
          -- DESC, col로는 확인 불가
          DESC test;
          SELECT * FROM col WHERE tname = 'TEST';
          
          -- INVISIBLE 컬럼은 cols, user_tab_cols 로 확인
            SELECT * FROM user_tab_cols WHERE table_name = 'TEST';
            SELECT * FROM cols WHERE table_name = 'TEST';
                    -- hidden_columns 컬럼에 Y 표시
            
          -- 데이터 추가
            INSERT INTO test VALUES(1,'a');  -- 가능
            
            INSERT INTO test VALUES(2,'b','010-1');  -- 에러
            
            INSERT INTO test (num, name, tel) VALUES(2,'b','010-1');  -- 가능
            
          -- 확인
             SELECT * FROM test;    -- INVISIBLE 컬럼은 보이지 않음
             
             SELECT num, name, tel FROM test;   -- INVISIBLE 컬럼도 보임
            
          -- VISIBLE 컬럼으로 변경
             ALTER TABLE test MODIFY (tel VISIBLE);
             DESC test;
             
          -- INVISIBLE 컬럼으로 변경
             ALTER TABLE test MODIFY (tel INVISIBLE);
             DESC test;   
             
             UPDATE test SET tel = '010-2' WHERE num =1;
             SELECT num, name, tel FROM test;
             COMMIT;
             
          -- INVISIBLE 컬럼에 NOT NULL 제약 추가
             ALTER TABLE test MODIFY (tel NOT NULL);
             
             INSERT INTO test VALUES(3,'c'); -- 에러(NOT NULL 제약 위반)
             SELECT num, name, tel FROM test;
             COMMIT;
            
        DROP TABLE test PURGE;
    


    -- ◎ IDENTITY column
      -- : 자동으로 숫자를 증가하는 컬럼
      -- : 내부적으로 시퀀스를 사용

      -----------------------------------------------
      --
      CREATE TABLE test(
        num NUMBER GENERATED AS IDENTITY PRIMARY KEY,
        subject VARCHAR2(100) NOT NULL
      );
      
      INSERT INTO test(subject) VALUES('자바');
      INSERT INTO test(subject) VALUES('오라클');
      INSERT INTO test(subject) VALUES('웹');
      SELECT * FROM test;
      
      SELECT * FROM user_objects;
            -- object_name : ISEQ$$_xxxxx -> IDENTITY 컬럼의 시퀀스
      
      SELECT ISEQ$$_74677.CURRVAL FROM dual;
            -- 3 출력
    
      INSERT INTO test(num, subject) VALUES(10,'HTML'); -- 에러. 수정 불가
      
      DROP TABLE test PURGE;



    -- ◎ DEFAULT 값 : 테이블을 만들거나 수정할때 DEFAULT로 시퀀스 값을 줄 수 있다.
      -----------------------------------------------
      --
      CREATE SEQUENCE test_seq;
      CREATE TABLE test(
        num NUMBER DEFAULT test_seq.NEXTVAL,
        subject VARCHAR2(100) NOT NULL,
        PRIMARY KEY (num)
      );
      
      INSERT INTO test(subject) VALUES('a');
      INSERT INTO test(subject) VALUES('b');
      SELECT * FROM test;
      

