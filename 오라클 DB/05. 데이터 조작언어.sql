-- ■ 데이터 조작언어(DML)
-- 트랜잭션
    -- COMMIT : 트랜잭션 완료(INSERT, UPDATE, DELETE)된 상태로 DB에 데이터가 저장
    -- ROLLBACK : 트랜잭션 취소(INSERT, UPDATE, DELETE)된 상태로 DB에 데이터가 저장되지 않음 

    -- INSERT, UPDATE, DELETE 후 DDL(CREATE, ALTER, DROP) 명령을 사용하면 자동으로 COMMIT 됨

 -- ※ INSERT
   -- ο 단일 행 입력
     -------------------------------------------------------
     -- 기본형식
         INSERT INTO 테이블명 VALUES (값, 값);
         INSERT INTO 테이블명 (컬럼, 컬럼) VALUES (값, 값);
    
     -- 예
        CREATE TABLE test1(
            num NUMBER PRIMARY KEY,
            name VARCHAR2(30) NOT NULL,
            birth DATE NOT NULL,
            memo VARCHAR2(10)
        );

     -- 데이터 추가 : 모든 컬럼에 데이터를 추가하는 경우 컬럼명을 생략할 수 있다.
        -- 테이블을 작성할 때 컬럼의 순서대로 값을 입력해야 한다.
        INSERT INTO test1 VALUES(1,'홍길동','2020-10-10','테스트');
        SELECT * FROM test1;
        
     -- 컬럼명을 명시하여 데이터 추가
        INSERT INTO test1(num, name, memo, birth) VALUES(2,'김자바','예2','2000-11-10' );
        SELECT * FROM test1;
        
     -- 추가 예
        INSERT INTO test1 VALUES(3,'노노노','2020-11-11'); 
            -- 에러 : 컬럼의 개수와 값의 개수가 다름
        
        INSERT INTO test1(num, name, birth) VALUES(3,'노노노','2020-11-11');
        SELECT * FROM test1;

        INSERT INTO test1(num, name, birth) VALUES(3,'헐헐헐','2020-11-11');
            -- 에러 : ORA-00001
            -- 기본키 제약 조건 위반. (기본키는 동일한 값을 가질 수 없다.)
            
        INSERT INTO test1 VALUES(4,'헐헐헐','2020-11-11','');
            -- ''(길이가 0인 문자열)은 오라클에서는 NULL
        SELECT * FROM test1;
        
        INSERT INTO test1 (num, name, birth, memo) VALUES(5,'구구구','2020-11-10','예3');
        SELECT * FROM test1;
        
        INSERT INTO test1 (num, name, birth, memo) VALUES(6,'미미미','05/05/90',NULL);
            -- 에러 : ORA-01847. 날짜 형식 오류
        INSERT INTO test1 (num, name, birth, memo) VALUES(6,'미미미',TO_DATE('05/05/90','MM/DD/RR'),NULL);
        SELECT * FROM test1;
        
        INSERT INTO test1 (num, name, memo) VALUES(7,'머머머','예4');
            -- 에러 : ORA-01400, birth NOT NULL 제약 위반
            
        INSERT INTO test1 (num, name, birth, memo) VALUES(7,'머머머','2001-02-07','반가워요');
            -- 에러 : ORA-12899, 입력값이 컬럼폭보다 큼(memo에는 한글 3자까지만 가능)
        
        INSERT INTO test1 (num, name, birth) VALUES(7,'머머머',SYSDATE); 
            -- 시스템 날짜를 입력
        SELECT * FROM test1;
        
        
        COMMIT; -- 트랜잭션 완료. DB에 저장완료
        --ROLLBACK; --트랜잭션 취소 (DB에 저장되지 않음)
        
        --[문제]--
        -- test1 테이블의 memo 컬럼을 다음과 같이 폭을 변경한다.
          -- memo VARCHAR2(100);
          ALTER TABLE test1 MODIFY (memo VARCHAR2(100));
           
        -- test1 테이블에 다음 컬럼을 추가한다.
            -- 컬럼명 : created
            -- 타입 : TIMESTAMP
            ALTER TABLE test1 ADD(created TIMESTAMP);
            
        -- test1 테이블에 다음을 추가한다.
            -- num : 8, name : 자바다, birth : 901010, created : 20230306172100100   
            -- TO_DATE('901010', 'RRMMDD')
            -- TO_TIMESTAMP('20230306172100100','YYYYMMDDHH24MISSFF3')
            INSERT INTO test1 (num, name, birth, created) VALUES(8,'자바다',TO_DATE('901010', 'RRMMDD'),TO_TIMESTAMP('20230306172100100','YYYYMMDDHH24MISSFF3'));
         
            SELECT * FROM test1 ORDER BY num;
  
  ------------------------------------------------------------
  -- (3/7)
        -- 예제
        -- test2 테이블 작성
            hak    문자(30) PRIMARY KEY
            name   문자(30)  NOT NULLL
            kor    숫자(3)   NOT NULLL
            eng    숫자(3)   NOT NULLL
            mat    숫자(3)   NOT NULLL
            tot    숫자(3)   가상컬럼 kor + eng + mat
            ave    숫자(4,1)  가상컬럼 (kor + eng + mat) /3
            -- 가상 컬럼 : 값을 저장할 수 없고, 수식을 테이블을 만들때 저장
  
            CREATE TABLE test2 (
                hak    VARCHAR2(30) PRIMARY KEY,
                name   VARCHAR2(30) NOT NULL,
                kor    NUMBER(3) NOT NULL,
                eng    NUMBER(3) NOT NULL,
                mat    NUMBER(3) NOT NULL,
                tot    NUMBER(3) GENERATED ALWAYS AS (kor+eng+mat) VIRTUAL,
                ave    NUMBER(4,1) GENERATED ALWAYS AS ((kor+eng+mat)/3) VIRTUAL
            );                                          -- >가상컬럼에서 가상컬럼연산 X
            
            DESC test2;  
            SELECT * FROM col WHERE tname = 'TEST2';
                        -- DEFAULTVAL 컬럼에서 수식을 확인
            SELECT * FROM cols WHERE table_name = 'TEST2';
                        -- DATA_DEFALUT 컬럼에서 수식확인
  
            -- test2 테이블에 데이터 추가
                INSERT INTO test2 VALUES('1111','홍길동',90,90,90);
                        -- 에러
                INSERT INTO test2 VALUES('1111','홍길동',90,90,90,270,90);
                        -- 에러 : 가상컬럼에 값을 등록할 수 없다.
    
                INSERT INTO test2(hak,name,kor,eng,mat) VALUES('1111','홍길동',90,90,90);
                SELECT * FROM test2;
   ------------------------------------------------------------
   -- test3 테이블 작성               
        -- empNo   문자(30)  PRIMARY KEY
        -- name    문자(30)  NOT NULL
        -- pay     숫자(10)  NOT NULL
        
        CREATE TABLE test3(
            empNo   VARCHAR2(30) PRIMARY KEY,
            name    VARCHAR2(30)  NOT NULL,
            pay     NUMBER(10)    NOT NULL
        );
        
    -- test3 테이블에 다음의 가상컬럼을 추가
        -- tax 숫자(10) 
        -- pay가 300만원이상이면 pay의 3%
        -- pay가 250만원이상이면 pay의 2%
        -- 기타 0
        
        ALTER TABLE test3 ADD(
            tax NUMBER(10) GENERATED ALWAYS AS(
                ROUND(
                    CASE
                        WHEN pay >= 3000000 THEN pay *0.03
                        WHEN pay >= 2500000 THEN pay *0.02
                        ELSE 0
                    END 
                ,-1)
            )VIRTUAL
        );
        
        -- test3에 다음의 값 등록
            -- '1001' 홍길동 3500000
            INSERT INTO test3(empNo, name, pay) VALUES('1001','홍길동',3500000);
            SELECT * FROM test3;
  
  
  
  
   -- ο subquery를 이용한 다중 행 입력 : 하나의 테이블에 다중 행 추가
     -------------------------------------------------------
     -- 기본형식
        INSERT INTO 테이블명 [( 컬럼, 컬럼 )]  SELECT 문;
            
     -- emp 테이블의 empNo, name, dept, pos 컬럼의 구조 복사하여 emp1 테이블 작성. 내용을 복사하지 않음
        CREATE TABLE emp1 AS
            SELECT empNo, name, dept, pos FROM emp WHERE 1=0;
            
        DESC emp1;
        SELECT * FROM emp1;
            
     -- emp 테이블의 개발부 자료만 emp1 테이블에 추가 : 서브쿼리 이용
            SELECT empNo, name, dept, pos FROM emp WHERE dept='개발부';
        
            INSERT INTO emp1
                SELECT empNo, name, dept, pos FROM emp WHERE dept='개발부';
        
            SELECT * FROM emp1;
            
        
        
        
        
  -- > 알아두면 편리       
   -- ο unconditional INSERT ALL : : 여러 테이블에 다중 행 추가
     -------------------------------------------------------
     -- 기본형식
        INSERT ALL
              INTO 테이블명1 [( 컬럼, 컬럼 )] VALUES (수식1,수식2)
              INTO 테이블명2 [( 컬럼, 컬럼 )] VALUES (수식1,수식2)
              ...
         subquery;
    
     -- 여러 테이블에 여러 행 추가 : emp 테이블의 개발부 데이터를 emp2, emp3에 추가
        CREATE TABLE emp2 AS
            SELECT empNo, name, dept, pos FROM emp WHERE 1=0;

        CREATE TABLE emp3 AS
            SELECT empNo, sal, bonus FROM emp WHERE 1=0;
                        
        SELECT * FROM emp2;
        SELECT * FROM emp3;
 

        INSERT ALL 
            INTO emp2(empNo, name, dept, pos) VALUES (empNo,name,dept,pos)
            INTO emp3(empNo, sal, bonus) VALUES(empNo,sal,bonus)
        SELECT * FROM emp WHERE dept = '개발부';
        COMMIT;
        
        SELECT * FROM emp2;
        SELECT * FROM emp3;
        
    -- 두개의 테이블에 동시에 새로운 데이터 추가 : emp2, emp3 테이블에 데이터 추가     
        empNo : '9999', name : '나자바' , dept : '개발부', pos : '사원', sal : 2000000, bonus : 100000
        
        INSERT ALL 
            INTO emp2(empNo, name, dept, pos) VALUES ('9999','나자바','개발부','사원')
            INTO emp3(empNo, sal, bonus) VALUES('9999',2000000,100000)
        SELECT * FROM dual; 
                -- > SELECT * FROM emp WHERE dept = '개발부'; 넣으면
                --   개발부 개수만큼 똑같은 행이 와ㅑ댜댜댜ㅑ 출력
        
        SELECT * FROM emp2;
        SELECT * FROM emp3;
        
        
        
        
   -- ο conditional INSERT {ALL | FIRST}
      -------------------------------------------------------
     -- 기본형식
        INSERT ALL
               WHEN 조건1 THEN
                   INTO 테이블명1 [( 컬럼, 컬럼 )] VALUES (수식1,수식2)
               WHEN 조건2 THEN
                   INTO 테이블명2 [( 컬럼, 컬럼 )] VALUES (수식1,수식2)
                  ...
               ELSE
                   INTO 테이블명n [( 컬럼, 컬럼 )] VALUES (수식1,수식2)
         subquery;


     -- 남자와 여자 사원 분리
        CREATE TABLE emp4 AS
                 SELECT empNo, name, rrn, dept, pos FROM emp WHERE 1=0;
     
        CREATE TABLE emp5 AS
                SELECT empNo, name, rrn, dept, pos FROM emp WHERE 1=0;
     
        INSERT ALL 
            WHEN MOD(SUBSTR(rrn,8,1),2)=0 THEN
                INTO emp4 VALUES ( empNo, name, rrn, dept, pos )
            WHEN MOD(SUBSTR(rrn,8,1),2)=1 THEN
                INTO emp5 VALUES ( empNo, name, rrn, dept, pos )
            SELECT * FROM emp;      
     
        SELECT * FROM emp4;
        SELECT * FROM emp5;
        
        
      
     -- 테이블 삭제
        DROP TABLE emp1 PURGE;
        DROP TABLE emp2 PURGE;
        DROP TABLE emp3 PURGE;
        DROP TABLE emp4 PURGE;
        DROP TABLE emp5 PURGE;
        
        DROP TABLE test1 PURGE;
        DROP TABLE test2 PURGE;
        DROP TABLE test3 PURGE;
        
        SELECT * FROM tab;
   
         
 -- ※ UPDATE
   -- ο UPDATE  : 데이터 수정
     -------------------------------------------------------
     -- 기본형식
       UPDATE 테이블명 SET 컬럼=값, 컬럼=값 WHERE 조건;
       UPDATE 테이블명 SET 컬럼=값, 컬럼=값;   -- 모든레코드 수정
       
     -- emp_score 테이블 : empNo 1002의 com=90, excel=95로 변경
        UPDATE emp_score SET com=90, excel=95;
                -- 모든 레코드가 수정된다.
                -- > 이렇게 수정하면 회사에서 욕을 많이 먹고 쫓겨난다.^___^
        SELECT * FROM emp_score;
        ROLLBACK;
                                                --> 어떠한 경우라도 조건 없는 UPDATE는 없다.
        UPDATE emp_score SET com=90, excel=95 WHERE empNo ='1002';
        SELECT * FROM emp_score;
        COMMIT;


     -- emp_score 테이블 : empNo, com, excel, word, tot(com+excel+word), ave((com+excel+word)/3), grade
        -- 평균은 소수점 2째자리에서 반올림
        -- grade : 모든 과목 점수가 40점이상이고 평균이 60이상이면 합격, 평균이 60이상이고 한과목이라도 40미만이면 과락,
        --          그렇지 않으면 불합격
        SELECT empNo, com, excel, word,(com+excel+word) tot, 
            ROUND(((com+excel+word)/3),1) ave, 
            CASE 
                WHEN com >=40 AND excel >=40 AND word >=40 AND (com+excel+word)/3 >=60 THEN '합격'
                WHEN (com+excel+word)/3 >=60 THEN '과락'
                ELSE '불합격'
            END grade
        FROM emp_score;
        
        
     -- emp, emp_score 테이블을 이용하여 개발부 직원의 empNo, com, excel, word 출력
        SELECT empNo, com, excel, word
        FROM emp_score
        WHERE empNo IN (SELECT empNo FROM emp WHERE dept ='개발부');
        
        
     -- 개발부 사원의 com 점수를 100 더하기
        UPDATE emp_score SET com = com+100
        WHERE empNo IN (SELECT empNo FROM emp WHERE dept = '개발부');
        
        SELECT * FROM emp_score;
        ROLLBACK;
        
   -------------------------------------------------
   -- 제약 조건을 위반하면 수정이 불가능 하다. 
    SELECT * FROM user_constraints WHERE table_name = 'EMP_SCORE';
    
    UPDATE emp_score SET empNo = '1002' WHERE empNo = '1001';
        -- 에러 : ORA-00001
        -- empNo는 기본키로 수정이 가능하지만, '1002'가 이미 존재하므로 '1001'을 '1002'로 수정할 수 없다.
        


 -- ※ DELETE
   -- ο DELETE : 데이터 삭제
     -------------------------------------------------------
     -- 기본형식
       DELETE FROM 테이블명 WHERE 조건;
       DELETE FROM 테이블명;  -- 모든레코드 삭제

     -- 삭제
        CREATE TABLE emp1 AS SELECT * FROM emp;
        CREATE TABLE emp_score1 AS SELECT * FROM emp_score;
        
        SELECT * FROM emp1;
        SELECT * FROM emp_score1;
        
        -- emp_score 테이블중 empNo가 '1001'인 데이터 삭제
        DELETE FROM emp_score1 WHERE empNo='1001';
        SELECT * FROM emp_score1;
        COMMIT;

        -- 서브쿼리를 이용하여 삭제
            DELETE FROM emp_score1 WHERE empNo IN(SELECT empNo FROM emp1 WHERE dept='개발부');
            SELECT * FROM emp_score1;
        
        -- 
            DELETE FROM emp1 WHERE dept = '개발부';
            SELECT * FROM emp1;
            COMMIT;
            
        -- 제약조건을 위반하면 삭제할 수 없다.
            DELETE FROM emp WHERE dept = '개발부';
                -- 에러
                -- emp_score 테이블이 emp 테이블을 참조하고 있으며, 개발부 데이터가 emp_score에 존재하므로 삭제가 불가능
          
         -- 전체 데이터 삭제 : 구조는 삭제되지 않음
            DELETE FROM emp1;
            SELECT * FROM emp1;
            COMMIT;
            
         --
            DROP TABLE emp1 PURGE;
            DROP TABLE emp_score1 PURGE;
            
            DROP TABLE emp_score PURGE;
            
            SELECT * FROM tab;
            
         -- 실수로 삭제한 경우 복구하기
            DELETE FROM emp WHERE city='서울';
            COMMIT;
            SELECT * FROM emp;
            
         -- 20분전의 emp 테이블
            SELECT * FROM emp
            AS OF TIMESTAMP(SYSTIMESTAMP - INTERVAL '20' MINUTE);
            
        -- 20분전의 emp 테이블로 삭제된 데이터를 복구
            INSERT INTO emp (
                SELECT * FROM emp 
                AS OF TIMESTAMP(SYSTIMESTAMP - INTERVAL '20' MINUTE)
                WHERE city ='서울'
            );
            SELECT * FROM emp;
            COMMIT;
            
            
 -- ※ MERGE
   -- ο MERGE : 데이터 병합
     -------------------------------------------------------
     -- 기본형식
       MERGE INTO 대상테이블명
           USING 비교할테이블 ON ( 조건 )
             WHEN MATCHED THEN
                 UPDATE SET 컬럼=값, 컬럼=값
            WHEN NOT MATCHED THEN
                INSERT [ (컬럼, 컬럼) ] VALUES (값, 값)
             ;
      
    ----------------------------------------------------------
    -- 예제
    CREATE TABLE emp1 AS
        SELECT empNo, name, city, dept, sal FROM emp WHERE city = '인천';
        
    CREATE TABLE emp2 AS
        SELECT empNo, name, city, dept, sal FROM emp WHERE dept= '개발부';
        
    MERGE INTO emp1 e1 -- > 별명
           USING emp2 e2 ON ( e1.empNo = e2.empNo )
             WHEN MATCHED THEN
                 UPDATE SET e1.sal = e1.sal + e2.sal
            WHEN NOT MATCHED THEN
                INSERT (e1.empNo, e1.name, e1.city, e1.dept, e1.sal) -- >  반드시 어디껀지 기재
                        VALUES (e2.empNo, e2.name, e2.city, e2.dept, e2.sal);
                        
    SELECT * FROM emp1;
    COMMIT;
    
    DROP TABLE emp1 PURGE;
    DROP TABLE emp2 PURGE;
   
                        

    

