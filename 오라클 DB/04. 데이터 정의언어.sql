-- ■ 데이터 정의 언어(Data Definition Language)
 -- ※ 데이터 정의 언어(DDL) 및 데이터 타입

   -- ο 데이터 타입 - 개요
      -- 데이터 타입 정보 확인
         SELECT DATA_TYPE, DATA_LENGTH, CHAR_LENGTH, CHAR_USED
         FROM USER_TAB_COLUMNS
         WHERE TABLE_NAME ='테이블명';


 -- ※ 테이블 생성 및 수정 삭제
   -- ο 테이블 생성 
     -------------------------------------------------------
     -- 기본 형식
         CREATE TABLE 테이블명
         (
              컬럼명  타입[(크기)]  [제약조건]
              ,컬럼명  타입[(크기)]  [제약조건]
          );

     -- 테이블명 : test
        컬럼명 컬럼타입    폭  제약조건 NULL
        num    NUMBER   10  기본키   X
        name   VARCHAR  30          X
        birth  DATE  
        city   VARCHAR2 30
    

        -- PRIMARY KEY는 기본적으로 NOT NULL 속성을 가지고 있음
        CREATE TABLE test(
                num NUMBER(10) PRIMARY KEY,
                name VARCHAR2(30) NOT NULL,
                birth DATE,
                city VARCHAR2(30)
            );
            
            SELECT * FROM tab;
            SELECT * FROM col WHERE tname = UPPER('test');
            DESC test;
            
   -- ο 테이블 생성 - 가상 컬럼(virtual column)
     -------------------------------------------------------
     --
 

   -- ο 테이블 생성 - subquery를 이용한 테이블 생성 
     -------------------------------------------------------
     -- 기본형식
      CREATE  TABLE  테이블명 [(컬럼명, 컬럼명,...)] AS subquery;

     -- 존재하는 테이블을 이용하여 테이블 작성 : 테이블 구조 및 데이터 복사
        SELECT empNo, name, sal, bonus, sal+bonus FROM emp;
        
        CREATE TABLE emp1 AS
            SELECT empNo, name, sal, bonus, sal+bonus FROM emp;
            --에러. sal+bonus는 컬럼명이 될 수 없다.
            
        CREATE table emp1 AS
            SELECT empNo, name, sal, bonus, sal+bonus pay from emp;
            -- NOT NULL 이외의 제약 조건은 복사되지 않는다.
        
        SELECT * FROM tab;
        DESC emp1;
        
        SELECT * FROM emp1;
        
        -- 제약조건 확인
            SELECT * FROM user_constraints;
                -- constraint_type => P : 기본키, U: UNIQUE, C : NOT NULL

        -- 컬럼명을 지정하여 테이블의 구조 및 데이터를 복사
            SELECT empNo, name, TO_DATE(SUBSTR(rrn,1,6),'RRMMDD') 
            FROM emp
            WHERE TO_DATE(SUBSTR(rrn,1,6),'RRMMDD')>= '1990-01-01';
            
            CREATE TABLE emp2(eno,name,birth) AS
                 SELECT empNo, name, TO_DATE(SUBSTR(rrn,1,6),'RRMMDD') 
                 FROM emp
                 WHERE TO_DATE(SUBSTR(rrn,1,6),'RRMMDD')>= '1990-01-01';
                -- SELECT 문에서 별명으로 이름을 바꾸어서 복사 가능
                
            DESC emp2; --> 테이블 구조 보기!    
            
            SELECT * FROM emp2;
            
         -- 테이블의 구조만 복사 : 컬럼명 및 타입과 크기
            -- NOT NULL은 복사 되지만 기타 제약 조건은 복사되지 않는다.
            
            SELECT * FROM emp WHERE 1=0;
            
            CREATE TABLE emp3 AS
                SELECT * FROM emp WHERE 1=0;    --> 구조는 가져오는데 데이터는 x
                
            DESC emp3;
            SELECT * FROM emp3; 
                
        
   -- ο ALTER TABLE ~ ADD
        -- 기존 테이블에 새로운 컬럼 추가
        -- 새로 추가된 컬럼은 가장 마지막에 위치
        
     -------------------------------------------------------
     -- 기본형식
       -- ALTER TABLE 테이블명 ADD (컬럼명 자료형(크기));
        
       -- 컬럼 추가
          DESC test;

          ALTER TABLE test ADD ( dept VARCHAR2(30), sal NUMBER(3) NOT NULL);        
          DESC test;
          
       -- 데이터가 존재하는 테이블에는 NOT NULL 속성의 컬럼을 추가할 수 없다.
            SELECT * FROM emp2;
            
            ALTER TABLE emp2 ADD(dept VARCHAR2(30) NOT NULL);
                -- 에러. 데이터가 존재하면 NOT NULL 속성의 컬럼 추가 불가
          
            ALTER TABLE emp2 ADD(dept VARCHAR2(30));
            DESC emp2;
            SELECT * FROM emp2;

   -- ο ALTER TABLE ~ MODIFY : 테이블에 존재하는 컬럼 타입, 크기등을 변경
   
     -------------------------------------------------------
     -- 기본형식
       -- ALTER TABLE 테이블명 MODIFY (컬럼명 자료형(크기));
       
       
       -- 컬럼 폭 변경
        DESC test;
        
        ALTER TABLE test MODIFY(sal NUMBER(8));
        DESC test;
           
        DESC emp2;
        ALTER TABLE emp2 MODIFY(name VARCHAR2(8));
            -- 에러. 데이터가 존재하면 데이터의 길이보다 크거나 같아야한다.

   -- ο ALTER TABLE ~ RENAME COLUMN : 컬럼명을 변경한다.
     -------------------------------------------------------
     -- 기본형식
       --ALTER TABLE 테이블명 RENAME COLUMN 컬럼명 TO 새로운컬럼명
       
       DESC emp2;
       
       ALTER TABLE emp2 RENAME COLUMN eno TO empNo; 
       DESC emp2;
    

   -- ο ALTER TABLE ~ DROP COLUMN : 컬럼 삭제. 데이터가 존재하면 데이터도 삭제된다.
     -------------------------------------------------------
     -- 기본형식
      --ALTER TABLE 테이블명 DROP COLUMN 컬럼명
      
      -- 컬럼 삭제
        DESC test;
        
        ALTER TABLE test DROP COLUMN dept;
        DESC test;
        
        SELECT * FROM emp2;
        ALTER TABLE emp2 DROP COLUMN name;
                -- 데이터가 존재하면 데이터도 같이 삭제됨
        DESC emp2;
        
        SELECT * FROM emp2;


   -- ο ALTER TABLE ~ SET UNUSED : 컬럼을 삭제하지는 않지만 논리적으로 사용을 제한
     -------------------------------------------------------
     -- 예
        SELECT * FROM emp1;
        
        ALTER TABLE emp1 SET UNUSED(pay);
        SELECT * FROM emp1;
            -- pay 안보임
        SELECT name, pay FROM emp1;
            -- 에러
        DESC emp1;
            -- pay 안보임


   -- ο ALTER TABLE ~ SET UNUSED에 의해 논리적으로 삭제된 컬럼의 정보 확인
     -------------------------------------------------------
     -- SET UNUSED에 의해 논리적으로 삭제된 컬럼은 확인하거나 복귀 불가
     -- 어떤 테이블에 몇개의 컬럼이 UNUSED 되었는지는 확인 가능
     
     -- UNUSED된 컬럼 개수 확인
        SELECT * FROM user_unused_col_tabs;


   -- ο ALTER TABLE ~ DROP UNUSED COLUMNS : SET UNUSED에 의해 논리적으로 삭제된 컬럼을 실제로 삭제
     -------------------------------------------------------
     -- 예
     ALTER TABLE emp1 DROP UNUSED COLUMNS;
     
     SELECT * FROM user_unused_col_tabs;


   -- ο  테이블 삭제
     -------------------------------------------------------
     -- 기본형식
      DROP TABLE 테이블;  -- 휴지통에 임시보관
      DROP TABLE 테이블 PURGE;  -- 휴지통에 임시보관 하지 않고 바로 삭제
      DROP TABLE 테이블명 CASCADE CONSTRAINTS PURGE;
         -- 테이블과 그 테이블을 참조하는 FOREIGN KEY의 제약조건을 동시에 삭제    
        
      CREATE TABLE demo AS
        SELECT * FROM emp;
      
      CREATE TABLE emp4 AS
        SELECT * FROM emp;
        
      SELECT * FROM tab;
      
      -- 데이터 및 테이블 구조 삭제
        DROP TABLE demo;  -- 휴지통으로 보냄
        DROP TABLE test;  -- 휴지통으로 보냄
        SELECT * FROM tab;
        
        DROP TABLE emp4 PURGE;  -- 완전 삭제
        SELECT * FROM tab;
     

   -- ο RENAME : 테이블의 이름을 변경
     -------------------------------------------------------
     -- 기본형식
       RENAME 옛이름 TO 새이름;
       
       SELECT * FROM tab;
       
       RENAME emp2 TO demo;
       SELECT * FROM tab; 
        


   -- ο 휴지통(RECYCLEBIN) 정보 확인
    -- 삭제된 개체(objects)확인
     -------------------------------------------------------
     -- 휴지통의 객체 확인
        SELECT * FROM recyclebin;
        SHOW recyclebin;
    
     -- 예
        DROP TABLE demo;
        SELECT * FROM tab;
        

   -- ο FLASHBACK TABLE : 휴지통 복원
     -------------------------------------------------------
     --예
        SELECT * FROM tab;
        
        FLASHBACK TABLE test TO BEFORE DROP;
            -- 동일한 오리지널이름이 두개이상이면 마지막에 삭제한 테이블 복원
        SELECT * FROM tab;
        
      -- BIN이름으로 복원
        SELECT * FROM tab;
        
        FLASHBACK TABLE "BIN$MvMZ8BvzTti0o/jfPPqCkg==$0" TO BEFORE DROP;    -- demo 삭제된 BIN 이름
        SELECT * FROM tab;
        
      -- 이름을 변경해서 복원
        FLASHBACK TABLE demo TO BEFORE DROP RENAME TO emp2;
            -- demo : 삭제전이름, emp2 : 복원할 이름
        SELECT * FROM tab;

   -- ο 휴지통 비우기
     -------------------------------------------------------
     -- 예
        DROP TABLE test;
        DROP TABLE demo;
        DROP TABLE emp2;
        
        SELECT * FROM recyclebin;
        
     -- 휴지통 비우기 : demo만 비우기
        PURGE TABLE demo;
        SELECT * FROM recyclebin;
        
     -- 휴지통 다 비우기
        PURGE recyclebin;
        SELECT * FROM recyclebin;
        
     -- 휴지통에 버리지않고 바로 삭제하기
        DROP TABLE 테이블 PURGE;
        
        
   -- ο TRUNCATE : 데이터 모두 지우기, 자동 COMMIT 되므로 회복불가
     -------------------------------------------------------
     -- 예
        SELECT * FROM emp1;
        
        -- 데이터만 모두 지우기. 테이블의 구조는 삭제되지 않는다
        -- 자동 COMMIT 되므로 회복 불가
        -- 모든 자료를 다 지울 경우 DELETE 보다 빠름
           TRUNCATE TABLE emp1;
           
           SELECT * FROM emp1;
           DESC emp1;
           
           DROP TABLE emp1 PURGE;
           
           
