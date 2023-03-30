-- ■ 인덱스(index)
 -- ※ 인덱스
       ---------------------------------------------------
       -- 형식
         -- UNIQUE 옵션은 사용자가 직접 unique한 인덱스를 생성하고 할 때 사용한다. 디폴트는 non-unique 인덱스로 생성한다.
         -- 현재 중복적이 값이 없고, 향후 중복적인 값이 존재할 가능성이 있는 경우 UNIQUE 인덱스를 생성하지 않는다.

         -- B-Tree 인덱스
             CREATE INDEX 인덱스명 ON 테이블명(컬럼명, ...);

             -- 단일 인덱스(Single Index) : 하나의 컬럼을 사용하여 인덱스를 만드는 것
                 CREATE INDEX 인덱스명 ON 테이블명(컬럼명);

             -- 결합 인덱스(Composite Index) : 두개 이상의 컬럼을 사용하여 인덱스를 만드는 것
                CREATE INDEX 인덱스명 ON 테이블명(컬럼명, 컬럼명, ...);

             -- 고유 인덱스(Unique INdex) : 유일한 값을 갖는 컬럼에 대해서만 인덱스를 설정
                 CREATE UNIQUE INDEX 인덱스명 ON 테이블명(컬럼명, ...);

         -- Bitmap 인덱스(Express는 지원하지 않음a)
             CREATE BITMAP INDEX 인덱스명 ON 테이블명(컬럼명, ...);

         -- 함수기반 인덱스
             CREATE INDEX 인덱스명 ON 테이블명(함수식(컬럼명) | 산술식);

         -- 역방향 인덱스
             CREATE INDEX 인덱스명 ON 테이블명(컬럼명1,컬럼명2, ...) REVERSE;

         -- 내림차순 인덱스
             CREATE INDEX 인덱스명 ON 테이블명(컬럼명1,컬럼명2, ... DESC);


--03/16
       ---------------------------------------------------
       -- 예제
       -- 인덱스 확인
          SELECT * FROM emp;
          
          SELECT * FROM user_indexes WHERE table_name='EMP';
          SELECT * FROM user_ind_columns WHERE table_name='EMP';
          
          
        -- 인덱스 작성
          -- 인덱스 생성 전 : 범위 설정 전 F10으로 확인
          SELECT empNo, name, sal FROM emp WHERE name = '심심해';
          
          CREATE INDEX idx_emp_name ON emp(name);
                -- NONUNIQUE
          
          SELECT * FROM user_indexes WHERE table_name='EMP';
          SELECT * FROM user_ind_columns WHERE table_name='EMP';
          
          -- 인덱스 생성 후 : 범위 설정 전 F10으로 확인
          SELECT empNo, name, sal FROM emp WHERE name = '심심해';
                    -- 인덱스 사용
                        
          SELECT empNo, name, sal FROM emp WHERE SUBSTR(name,1,1) = '이';
                    -- 인덱스 사용 안함
          
    -- 인덱스 삭제
        DROP INDEX idx_emp_name;
        SELECT * FROM user_indexes WHERE table_name = 'EMP';

    -- 결합 인덱스
        CREATE INDEX idx_emp_comp ON emp(name,dept);
          
        --CREATE INDEX idx_emp_comp ON emp(dept,name);
                -- 부서에서 이름을 검색하므로 위보다 속도가 느림
                
        SELECT empNo, name, dept, sal FROM emp WHERE name ='김신애' AND dept ='개발부';
        
        DROP INDEX idx_emp_comp;
    
    -- 함수기반 인덱스
        CREATE INDEX idx_emp_fun ON emp (MOD(SUBSTR(rrn,8,1),2));
        
        SELECT empNo, name, rrn, sal FROM emp WHERE (MOD(SUBSTR(rrn,8,1),2))=0;

        DROP INDEX idx_emp_fun;



    -- ◎ 인덱스 관리
       ---------------------------------------------------
       -- 예제
        CREATE TABLE test(
            num NUMBER
        );
        
        BEGIN
            FOR n IN 1..10000 LOOP
                INSERT INTO test VALUES (n);
            END LOOP;
            COMMIT;
        END;
        / 
       
        CREATE INDEX idx_test_num ON test ( num );
        
        -- 인덱스 상태 확인
        ANALYZE INDEX idx_test_num VALIDATE STRUCTURE;  -- 분석

        SELECT * FROM index_stats WHERE name = 'IDX_TEST_NUM'; 
        
        SELECT (DEL_LF_ROWS_LEN)/(LF_ROWS_LEN)*100 
        FROM index_stats 
        WHERE name = 'IDX_TEST_NUM';
            -- 0에 가까울 수록 좋은 상태

    -- 데이터 삭제
        DELETE FROM test WHERE num <= 4000;
        COMMIT;
        
        ANALYZE INDEX idx_test_num VALIDATE STRUCTURE;  -- 분석
        
        SELECT (DEL_LF_ROWS_LEN) / (LF_ROWS_LEN) *100
        FROM index_stats
        WHERE name='IDX_TEST_NUM';
            -- 40% 정도 밸런싱이 망가짐
            
    -- 인덱스 REBUILD
        ALTER INDEX idx_test_num REBUILD;
        
        ANALYZE INDEX idx_test_num VALIDATE STRUCTURE;  -- 분석
        
        SELECT (DEL_LF_ROWS_LEN) / (LF_ROWS_LEN) *100
        FROM index_stats
        WHERE name='IDX_TEST_NUM';
            -- 0


    -- ◎ 힌트(hint)
       ---------------------------------------------------
       -- 옵티마이저에게 SQL문 실행을 위한 데이터 스캐닝 경로, 조인 방법등을 알려주기 위해 사용
       -- 형식
          SELECT /*+ Hint_name(param)*/ 컬럼, 컬럼 FROM 테이블명;
        
        -- 페이징 처리 예  
        SELECT * FROM (
            SELECT ROWNUM rnum, empNo, name FROM (
                SELECT empNo, name
                FROM emp
                ORDER BY empNo DESC
            )tb WHERE ROWNUM <= 30
        )WHERE rnum >=21;          
       
        -- 힌트(hint)를 이용한 페이징 처리
        SELECT rnum, empNo, name FROM (
                SELECT /*+ INDEX_DESC(emp PK_EMP_EMPNO)*/ ROWNUM rnum,empNo,name 
                FROM emp
                WHERE ROWNUM <= 30          --> ORDER BY와 ROWNUM 같이 사용 X.
        )WHERE rnum >=21;                   --> PK_EMP_EMPNO를 DESC 한 INDEX를 사용하였기에 ROWNUM 사용 가능
       
        -- INDEX_ASC, INDEX_DESC : 가장 많이 사용하는 힌트로 인덱스를 순서, 역순으로 이용할지를 지정
        
       
       
       
       
       
       
       