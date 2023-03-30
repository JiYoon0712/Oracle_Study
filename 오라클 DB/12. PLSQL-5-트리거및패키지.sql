-- ■ PL/SQL
 -- ※ 트리거
   -- : 미리 정해 놓은 특정 조건이 만족하거나 어떤 동작이 수행하면 자동으로 실행하도록 정의한 동작
   -- : 예를 들어 DML(INSERT, UPDATE, DELETE) 문장이 실행되거나 DDL(CREATE, ALTER, DROP) 문장이 실행될 때 트리거가 실행될 수 있다.
   -- : 트리거는 CREATE TRIGGER 시스템 권한이 있어야 생성 가능하다.

   -- 관리자 계정(sys, system)
      GRANT CREATE TRIGGER TO sky;
      
   -- sky 계정
      SELECT * FROM user_sys_privs;
      
      

     -------------------------------------------------------
     -- 문장 트리거 
        -- : 하나의 DML 문에서 트리거는 한번 일어난다.
        -- : 예를 들어 "DELETE FROM 테이블;" 문장으로 5개의 레코드가 삭제 되어도 트리거도 한번 실행 된다.
        -- : 테이블에 레코드가 입력, 수정, 삭제 등의 로그 기록

        -- 로그 저장 문장 트리거 작성
            CREATE TABLE test
            (
                num NUMBER PRIMARY KEY,
                name VARCHAR2(50) NOT NULL,
                content VARCHAR2(4000) NOT NULL
            );  
            
            CREATE TABLE test_info
            (
                memo VARCHAR2(100) NOT NULL,
                created DATE DEFAULT SYSDATE
            );
            
            -- test 테이블에 DML 작업이 일어난 경우 DML 작업이 일어난 시간을 기록하는 트리거 작성
            CREATE OR REPLACE TRIGGER testInfoTrigger
            AFTER INSERT OR UPDATE OR DELETE ON test
            BEGIN
                IF INSERTING THEN
                    INSERT INTO test_info(memo) VALUES('데이터 추가');
                ELSIF UPDATING THEN
                    INSERT INTO test_info(memo) VALUES('데이터 수정');
                ELSIF DELETING THEN
                    INSERT INTO test_info(memo) VALUES('데이터 삭제');
                END IF;
                -- 트리거 안에서 INSERT, UPDATE, DELETE 후에는 자동 COMMIT된다.
                --> 트리거 안에서는 COMMIT 사용할 수 없음
            END;
            /
            
            -- 트리거 확인
                SELECT * FROM user_triggers;

            -- 의존성 확인
                SELECT * FROM user_dependencies;
                
            -- 확인
                INSERT INTO test(num, name, content) VALUES(1,'a','aa');
                INSERT INTO test(num, name, content) VALUES(2,'b','bb');
                INSERT INTO test(num, name, content) VALUES(3,'c','cc');
                COMMIT;
                
                SELECT * FROM test;
                SELECT * FROM test_info;

                DELETE FROM test;
                COMMIT;
                
                SELECT * FROM test;
                SELECT * FROM test_info;
                
            -- 트리거 삭제
                DROP TRIGGER testInfoTrigger;
                SELECT * FROM user_triggers;


     -------------------------------------------------------
     -- 문장 트리거 : 지정된 시간에만 DML 작업을 할 수 있는 트리거 작성
        --> 문장 당 한번. 트리거 한 번
        CREATE OR REPLACE TRIGGER testTrigger
        BEFORE INSERT OR UPDATE OR DELETE ON test
        BEGIN
            IF TO_CHAR(SYSDATE,'D') IN(1,7) OR
                -- (TO_CHAR(SYSDATE,'HH24') < 9 OR TO_CHAR(SYSDATE,'HH24')>18)  THEN
                   (TO_CHAR(SYSDATE,'HH24') > 12 OR TO_CHAR(SYSDATE,'HH24') < 13)  THEN
                RAISE_APPLICATION_ERROR(-20001,'근무시간이 아니다.');
            END IF;
        END;
        /
     
        INSERT INTO test(num, name, content) VALUES(1,'a','aa');
        SELECT * FROM test;
        
        DROP TRIGGER testTrigger;
        SELECT * FROM user_triggers;
        
        
                
     -------------------------------------------------------
     -- 행 트리거
        -- : DML 문에서 조건만족하는 모든 행에 대하여 트리거나 일어난다.
        -- : 예를 들어 "DELETE FROM 테이블;" 문장으로 5개의 레코드가 삭제된 경우 트리거는 5번 실행 된다.
        -- : OLD 와 NEW 레코드
          -- 행 트리거에서만 사용 가능
          -- :OLD 
            UPDATE 에서는 수정전 레코드, DELETE 에서는 삭제할 레코드
          -- :NEW
            INSERT에서는 추가할 레코드, UPDATE 에서는 수정할 레코드

     -------------------------------------------------------
     -- 행 트리거 예
        DROP TABLE score2 PURGE;
        DROP TABLE score1 PURGE;
        
        DELETE FROM score2;
        DELETE FROM score1;
        COMMIT;
        
        CREATE TABLE score1 (
          hak VARCHAR2(20) NOT NULL
          ,name VARCHAR2(30) NOT NULL
          ,kor NUMBER(3) NOT NULL
          ,eng NUMBER(3) NOT NULL
          ,mat NUMBER(3) NOT NULL
          ,CONSTRAINT pk_score1_hak PRIMARY KEY(hak)
      );

      CREATE TABLE score2 (
          hak VARCHAR2(20) NOT NULL
          ,kor NUMBER(2,1) NOT NULL
          ,eng NUMBER(2,1) NOT NULL
          ,mat NUMBER(2,1) NOT NULL
          ,CONSTRAINT pk_score2_id PRIMARY KEY(hak)
          ,CONSTRAINT fk_score2_id FOREIGN KEY(hak)
              REFERENCES score1(hak)
      );

      CREATE OR REPLACE FUNCTION fnGrade
      (
          pScore NUMBER
      )
      RETURN NUMBER
      IS
         n NUMBER(2,1);
      BEGIN
         IF  pScore<0 OR  pScore>100 THEN
              RAISE_APPLICATION_ERROR(-20001, '점수는 0~100사이만 가능합니다.');
         END IF;

         IF pScore>=95 THEN n:=4.5;
         ELSIF pScore>=90 THEN n:=4.0;
         ELSIF pScore>=85 THEN n:=3.5;
         ELSIF pScore>=80 THEN n:=3.0;
         ELSIF pScore>=75 THEN n:=2.5;
         ELSIF pScore>=70 THEN n:=2.0;
         ELSIF pScore>=65 THEN n:=1.5;
         ELSIF pScore>=60 THEN n:=1.0;
         ELSE n:=0.0;
         END IF;

         RETURN n;
      END;
      /
    
    -- INSERT 에 대한 행 트리거 : score1 테이블에 INSERT가 일어나면 score2 테이블에 INSERT 되는 트리거 작성
    CREATE OR REPLACE TRIGGER scoreInsertTri
    AFTER INSERT ON score1
    FOR EACH ROW    -- 행트리거
    DECLARE
        -- 변수 선언
    BEGIN
        -- :NEW -> score1 테이블에 INSERT 하는 레코드
        -- 트리거 안에서는 DML 문 다음에는 COMMIT 하지 않는다.(오류 발생, 자동 COMMIT)
        INSERT INTO score2(hak, kor, eng, mat) VALUES
            (:NEW.hak, fnGrade(:NEW.kor),fnGrade(:NEW.eng),fnGrade(:NEW.mat));
    END;
    /
    
    INSERT INTO score1(hak, name, kor, eng, mat) VALUES('1111','하하하',85,90,95);
    INSERT INTO score1(hak, name, kor, eng, mat) VALUES('1112','가가가',100,75,90);
    COMMIT;

    SELECT * FROM score1;
    SELECT * FROM score2;


    -- UPDATE 에 대한 행 트리거 : score1 테이블에 UPDATE가 일어나면 score2 테이블에 UPDATE 되는 트리거 작성
    CREATE OR REPLACE TRIGGER scoreUpdateTri
    AFTER UPDATE ON score1
    FOR EACH ROW    -- 행트리거
    DECLARE
        -- 변수 선언
    BEGIN
        -- :NEW -> score1 테이블에 새로 UPDATE 하는 레코드, : OLD -> score1 테이블에서 UPDATE 되기 전의 레코드
        UPDATE score2 SET kor = fnGrade(:NEW.kor) , eng =fnGrade(:NEW.eng) , mat =fnGrade(:NEW.mat)
        WHERE hak = :OLD.hak;
    END;
    /
    
    UPDATE score1 SET kor=100 WHERE hak = '1111';
    
    COMMIT;

    SELECT * FROM score1;
    SELECT * FROM score2;
    -- 학번 변경
        UPDATE score1 SET hak = '2000' WHERE hak ='1111';
            -- ORA-02292 : 자식이 존재하는 경우 부모의 기본키 변경 불가
            --> 이럴경우 트리거 이용하면 짱 편함 BUT...

    -- 트리거를 이용하여 부모의 기본키를 변경하면 자식의 참조키도 변경되도록 할 수 있다.
    --> 엄청난 부하. 실무에서 사용하지말거라.
    CREATE OR REPLACE TRIGGER scoreUpdateTri
    AFTER UPDATE ON score1
    FOR EACH ROW    -- 행트리거
    DECLARE
    BEGIN
        UPDATE score2 SET 
            hak = :NEW.hak, kor = fnGrade(:NEW.kor) , eng =fnGrade(:NEW.eng) , mat =fnGrade(:NEW.mat)
        WHERE hak = :OLD.hak;
    END;
    /
    -- 학번 변경
        UPDATE score1 SET hak = '2000' WHERE hak ='1111';
        COMMIT;
        
        SELECT * FROM score1;
        SELECT * FROM score2;

  -- DELETE 에 대한 행 트리거 : score1 테이블에 DELETE 일어나면 score2 테이블에서도 DELETE 되는 트리거 작성
    CREATE OR REPLACE TRIGGER scoreDeleteTri
    BEFORE DELETE ON score1     -- AFTER 도 가능
    FOR EACH ROW    -- 행트리거
    DECLARE
    BEGIN
        -- :OLD -> score1 테이블에서 DELETE되기 전의 레코드
        
        DELETE FROM score2 WHERE hak = :OLD.hak;
    END;
    /
    
    DELETE FROM score1 WHERE hak = '2000';
    COMMIT;
    
    SELECT * FROM score1;
    SELECT * FROM score2;





 -- ※ 패키지(Package)
     -------------------------------------------------------
     -- 패키지 선언
     CREATE OR REPLACE PACKAGE pEmp IS
        FUNCTION fnTax(p IN NUMBER) RETURN NUMBER;
        PROCEDURE empList(pName VARCHAR2);
        PROCEDURE empList;  -- > 파라미터 없을 경우 () 기재 x
     END pEmp;
     /

    -- 패키지 구현
    CREATE OR REPLACE PACKAGE BODY pEmp IS
        FUNCTION fnTax(p IN NUMBER) 
        RETURN NUMBER
        IS
            t NUMBER :=0;
        BEGIN
            IF p>=3000000 THEN t := TRUNC(p*0.03,-1);
            ELSIF p>=200000 THEN t := TRUNC(p*0.02,-1);
            END IF;
            
            RETURN t;
        END;
        
        PROCEDURE empList(pName VARCHAR2)   -- > pName : 검색하고 싶은 이름
        IS
            vName VARCHAR2(30);
            vSal  NUMBER;
            CURSOR cur_emp IS
                SELECT name, sal FROM emp WHERE INSTR(name, pName) >=1;
        BEGIN
            OPEN cur_emp;
            LOOP
                FETCH cur_emp INTO vName, vSal;
                EXIT WHEN cur_emp%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE(vName||' '||vSal);
            END LOOP;
            CLOSE cur_emp;
        END;
        
        PROCEDURE empList
        IS
        BEGIN
            FOR rec IN ( SELECT name, sal+bonus pay, fnTax(sal+bonus) tax FROM emp) LOOP
                DBMS_OUTPUT.PUT_LINE(rec.name || ' ' || rec.pay||' '||rec.tax);
            END LOOP;
        END;
         
    END pEmp;
    /
    
    EXEC pEmp.empList();
    EXEC pEmp.empList('이');
    