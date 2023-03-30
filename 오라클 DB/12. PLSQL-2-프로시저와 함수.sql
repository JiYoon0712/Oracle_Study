-- ■ PL/SQL
 -- ※ 프로시저
     -- : 자주 실행해야 하는 업무 흐름(SQL)을 미리 작성하여 데이터베이스 내에 저장해 두었다가 필요할 때마다 호출하여 실행
    -- >  반드시 COMMIT 해줘야 함.
     -------------------------------------------------------
     -- 테이블 작성
     CREATE TABLE test (
        num   NUMBER PRIMARY KEY,
        name  VARCHAR2(30) NOT NULL,
        score NUMBER(3) NOT NULL,
        grade VARCHAR2(10) NOT NULL
     );
     
     
     -- 시퀀스 작성
     CREATE SEQUENCE test_seq
     INCREMENT BY 1 
     START WITH 1
     NOMAXVALUE
     NOCYCLE
     NOCACHE;
     
     --
        SELECT * FROM test;
     
     -- 프로시저 만들기
     CREATE PROCEDURE pInsertTest
     IS
        -- 변수 선언
     BEGIN 
        -- 몸체
        INSERT INTO test(num, name, score, grade) VALUES (test_seq.NEXTVAL, '김자바', 80, 'A');
        COMMIT;
     END;
/

    -- 프로시저의 목록 확인
        SELECT * FROM user_procedures;

    -- 프로시저의 소스 확인
        SELECT * FROM user_source WHERE name = UPPER('pInsertTest');

    -- 의존관계 확인
        SELECT * FROM user_dependencies;
    
    -- 프로시저 실행
        EXEC pInsertTest;
        
        SELECT * FROM test;
        
        
    ---------------------------------------------------
    -- 프로시저 수정 : IN 파라미터 ( IN 생략 가능 ) - 프로시저로 전달되는 인수, 읽기전용(값 변경 불가)
     CREATE OR REPLACE PROCEDURE pInsertTest
     (
        pName IN VARCHAR2,
            -- 파라미터는 자료형의 크기를 명시하지 않는다.
        -- pName IN emp.name%TYPE,
        pScore IN NUMBER
     )
     IS
        vGrade VARCHAR2(10);
     BEGIN 
        IF pScore >= 90 THEN vGrade := 'A';
        ELSIF pScore >= 80 THEN vGrade := 'B';
        ELSIF pScore >= 70 THEN vGrade := 'C';
        ELSIF pScore >= 60 THEN vGrade := 'D';
        ELSE vGrade := 'F';
        END IF;
    
        INSERT INTO test(num, name, score, grade) VALUES (test_seq.NEXTVAL, pName, pScore, vGrade);
        COMMIT;
     END;
/        

    -- 실행
    EXEC pInsertTest('홍길동',90);    
    EXEC pInsertTest('다자바',75);
    SELECT * FROM test;
    
 -------------------------------------------------------------------------   
    -- 프로시저 수정 : 유효성 검사 - 예외 처리
     CREATE OR REPLACE PROCEDURE pInsertTest
     (
        pName IN VARCHAR2,
        pScore IN NUMBER
     )
     IS
        vGrade VARCHAR2(10);
     BEGIN 
        IF pScore < 0 OR pScore >100 THEN
            -- 예외를 발생시킴
            -- 사용자 정의 예외 번호 : -20999~ -20000 사이
            RAISE_APPLICATION_ERROR(-20001, '점수는 0~100 사이만 가능합니다.');        
        END IF;
       
        IF pScore >= 90 THEN vGrade := 'A';
        ELSIF pScore >= 80 THEN vGrade := 'B';
        ELSIF pScore >= 70 THEN vGrade := 'C';
        ELSIF pScore >= 60 THEN vGrade := 'D';
        ELSE vGrade := 'F';
        END IF;
                                     --> 오류 확인 : VALUE 로 작성시 왼쪽 sky > 프로시저 엑박뜬거 확인. 고치고 새로고침 해주기
        INSERT INTO test(num, name, score, grade) VALUES (test_seq.NEXTVAL, pName, pScore, vGrade);
        COMMIT;
     END;
/        

    -- 실행
    EXEC pInsertTest('스프링',95);    
    EXEC pInsertTest('하자바',120);
    SELECT * FROM test;      
    
    --------------------------------------------------------------------------
    -- 프로시저 작성 : 수정
       CREATE OR REPLACE PROCEDURE pUpdateTest
       (
            pNum IN NUMBER,
            pName IN VARCHAR2,
            pScore IN NUMBER
       )
       IS
            vGrade VARCHAR2(10);
       BEGIN
         IF pScore < 0 OR pScore >100 THEN
            RAISE_APPLICATION_ERROR(-20001, '점수는 0~100 사이만 가능합니다.');        
        END IF;
       
        IF pScore >= 90 THEN vGrade := 'A';
        ELSIF pScore >= 80 THEN vGrade := 'B';
        ELSIF pScore >= 70 THEN vGrade := 'C';
        ELSIF pScore >= 60 THEN vGrade := 'D';
        ELSE vGrade := 'F';
        END IF;
        
        UPDATE test SET name = pName, score = pScore, grade = vGrade WHERE num = pNum;
        COMMIT;
        
       END;
/
    
    EXEC pUpdateTest(2,'하하하',85);
    SELECT * FROM test;
    
    
    --------------------------------------------------------------------------
    -- 프로시저 작성 : 삭제
    CREATE OR REPLACE PROCEDURE pDeleteTest
    (
        pNum IN NUMBER
    )
    IS
    BEGIN 
        DELETE FROM test WHERE num = pNum;
    END;
    /
    
    EXEC pDeleteTest(2);
    SELECT * FROM test;
    
    --------------------------------------------------------------------------
    -- 프로시저 작성 : 하나의 레코드 출력
        CREATE OR REPLACE PROCEDURE pSelectOneTest
        (
            pNum IN NUMBER
        )
        IS
            -- rec test%ROWTYPE;
            
            TYPE MYTYPE IS RECORD
            (
                num test.num%TYPE,
                name test.name%TYPE,
                score test.score%TYPE,
                grade test.grade%TYPE
            );
            
            rec MYTYPE;
            
        BEGIN
            SELECT num, name, score, grade INTO rec
            FROM test
            WHERE num = pNum;
            
            DBMS_OUTPUT.PUT_LINE(rec.num||' '||rec.name||' '||rec.score||' '||rec.grade);
            
        END;
        /
        
        EXEC pSelectOneTest(1);
    
    --------------------------------------------------------------------------
    -- 프로시저 작성 : 모든 레코드 출력
        CREATE OR REPLACE PROCEDURE pSelectListTest
        IS
        BEGIN
            FOR rec IN (SELECT num, name, score, grade FROM test ) LOOP
                DBMS_OUTPUT.PUT_LINE(rec.num||' '||rec.name||' '||rec.score||' '||rec.grade);
            END LOOP;
        END;
        /
        
        EXEC pSelectListTest;
    
    ----------------------------------------------------------------
    --
    DROP PROCEDURE pInsertTest;
    DROP PROCEDURE pUpdateTest;
    DROP PROCEDURE pDeleteTest;
    DROP PROCEDURE pSelectOneTest;
    DROP PROCEDURE pSelectListTest;
    
    DROP TABLE test PURGE;
    DROP SEQUENCE test_seq;
    
    SELECT * FROM tab;
    SELECT * FROM seq;
    SELECT * FROM user_procedures;
    
    ----------------------------------------------------------------
    -- 테이블 작성
        -- 테이블명 : ex1
        -- 컬럼 : num 숫자 기본키, name 문자(30) NOT NULL
        CREATE TABLE ex1(
            num NUMBER PRIMARY KEY,
            name VARCHAR2(30) NOT NULL
        )
        
        -- 테이블명 : ex2
        -- 컬럼 : num 숫자 기본키 ex1 테이블 num의 참조키, birth 날짜 NOT NULL
        CREATE TABLE ex2(
            num NUMBER PRIMARY KEY,
            birth DATE NOT NULL,
            FOREIGN KEY(num) REFERENCES ex1(num)
        )
        
        
        -- 테이블명 : ex3
        -- 컬럼 : num 숫자 기본키 ex1 테이블 num의 참조키, score 숫자(3) NOT NULL, grade 문자(10) NOT NULL
        CREATE TABLE ex3(
            num NUMBER PRIMARY KEY,
            score NUMBER(3) NOT NULL,
            grade VARCHAR2(10) NOT NULL,
            FOREIGN KEY(num) REFERENCES ex1(num)
        )    
        
        
        -- 시퀀스명 : ex_seq
            -- 1증가, 초기값 1, NOCYCLE, NOCACHE
         CREATE SEQUENCE ex_seq
         INCREMENT BY 1
         START WITH 1
         NOCYCLE
         NOCACHE;
            
        -- ex1, ex2, ex3 테이블에 데이터를 추가하는 프로시저 작성
            -- 프로시저명, pInsertEx
            -- 이름, 생년월일, 점수를 파라미터로 넘겨 받아 num은 시퀀스를 추가하며 grade는 점수를 이용하여 계산
            -- grade : 80 이상 -> 우수, 60 이상 -> 보통, 60 미만 -> 노력
            -- 점수는 0~100 이외의 점수는 예외를 발생시켜 추가하지 못하도록 작성
            -- 실행 예
                -- EXEC pInsertEx('김자바','2000-10-10',85);
        
        CREATE OR REPLACE PROCEDURE pInsertEx
       (
            pName IN VARCHAR2,
            pbirth IN VARCHAR2,
            pScore IN NUMBER
       )
       IS
            vGrade VARCHAR2(10);
       BEGIN
         IF pScore < 0 OR pScore >100 THEN
            RAISE_APPLICATION_ERROR(-20001, '점수는 0~100 사이만 가능합니다.');        
        END IF;
       
        IF pScore >= 80 THEN vGrade := '우수';
        ELSIF pScore >= 60 THEN vGrade := '보통';
        ELSE vGrade := '노력';
        END IF;
        
        INSERT INTO ex1(num,name) VALUES (ex_seq.NEXTVAL, pName);
        INSERT INTO ex2(num,birth) VALUES (ex_seq.CURRVAL, TO_DATE(pBirth,'YYYY-MM-DD'));
        INSERT INTO ex3(num,score,grade) VALUES (ex_seq.CURRVAL, pScore, vGrade); 
            
--          INSERT ALL 
--            INTO ex1(num,name) VALUES (ex_seq.NEXTVAL, pName)
--            INTO ex2(num,birth) VALUES (ex_seq.CURRVAL, TO_DATE(pBirth,'YYYY-MM-DD'))
--            INTO ex3(num,score,grade) VALUES (ex_seq.CURRVAL, pScore, vGrade)
--          SELECT * FROM dual;
          
        COMMIT;
       END;
/

    EXEC pInsertEx('가가가','2000-10-10',90);
    EXEC pInsertEx('가나다','2000-11-10',85);
    EXEC pInsertEx('나나나','2000-10-10',120); -- 하나의 테이블이라도 실패하면 모두 ROLLBACK
    SELECT * FROM ex1;
    SELECT * FROM ex2;
    SELECT * FROM ex3;
    
    
    -- ex1, ex2, ex3 테이블에 데이터를 수정하는 프로시저 작성 : pUpdateEx
        -- 프로시저 파라미터 : 수정할 번호, 이름, 생일, 점수
        CREATE OR REPLACE PROCEDURE pUpdateEx(
            pNum IN NUMBER, pName IN VARCHAR2, pbirth IN VARCHAR2, pScore IN NUMBER
        )
        IS
             vGrade VARCHAR2(10);
        BEGIN
            IF pScore < 0 OR pScore >100 THEN
                RAISE_APPLICATION_ERROR(-20001, '점수는 0~100 사이만 가능합니다.');        
            END IF;
        
            IF pScore >= 80 THEN vGrade := '우수';
            ELSIF pScore >= 60 THEN vGrade := '보통';
            ELSE vGrade := '노력';
            END IF;
        
            UPDATE ex1 SET name = pName WHERE num = pNum;
            UPDATE ex2 SET birth = TO_DATE(pbirth,'YYYY-MM-DD') WHERE num = pNum;
            UPDATE ex3 SET score = pScore, grade = vGrade WHERE num = pNum;
           
            COMMIT;
        END;
        /
        
        EXEC pUpdateEx(4, '김지윤','1999-07-12',100);
        SELECT * FROM ex1;
        SELECT * FROM ex2;
        SELECT * FROM ex3;
        
        
    -- ex1, ex2, ex3 테이블에 데이터를 삭제하는 프로시저 작성 : pDeleteEx
        -- 프로시저 파라미터 : 삭제할 번호
        CREATE OR REPLACE PROCEDURE pDeleteEx(
            pNum NUMBER
        )
        IS
        BEGIN 
            IF pScore < 0 OR pScore >100 THEN
                RAISE_APPLICATION_ERROR(-20001, '점수는 0~100 사이만 가능합니다.');        
            END IF;
        
            IF pScore >= 80 THEN vGrade := '우수';
            ELSIF pScore >= 60 THEN vGrade := '보통';
            ELSE vGrade := '노력';
            END IF;
            
            DELETE FROM ex3 WHERE num = pNum;
            DELETE FROM ex2 WHERE num = pNum;
            DELETE FROM ex1 WHERE num = pNum;
            
            COMMIT;
        END;
        /
        
        EXEC pDeleteEx(4);
        SELECT * FROM ex1;
        SELECT * FROM ex2;
        SELECT * FROM ex3;    
    
    -- num을 파라미터로 넘겨받아 ex1, ex2, ex3 테이블 내용을 출력하는 프로시저 작성: pSelectOneEx
        -- 프로시저 파라미터 : 출력할 번호
        -- 결과 : 번호 이름 생년월일 점수 판정
        -- 힌트 : INNER JOIN!
        
        CREATE OR REPLACE PROCEDURE pSelectOneEx(
            pNum IN NUMBER
        )
        IS
            TYPE MYTYPE IS RECORD
            (
                num ex1.num%TYPE,
                name ex1.name%TYPE,
                birth ex2.birth%TYPE,
                score ex3.score%TYPE,
                grade ex3.grade%TYPE
            );
            
            rec MYTYPE;
        BEGIN 
              SELECT e1.num, name, birth, score, grade INTO rec
              FROM ex1 e1
              JOIN ex2 e2 ON e1.num = e2.num
              JOIN ex3 e3 ON e1.num = e3.num
              WHERE e1.num = pNum; 
              
              DBMS_OUTPUT.PUT_LINE(rec.num ||' '||rec.name||' '||rec.birth||' '||
                    rec.score||' '||rec.grade);
        END;
        /
        
        EXEC pSelectOneEx(5);
     -------------------------------------------------------
     -- OUT 파라미터 : 프로시저가 정보를 호출자에게 돌려주는 기능. 프로시저에서 값 변경 가능
        -- OUT 파라미터는 프로시저 처리 결과를 프로그램(JAVA 등)으로 넘겨줄 때 사용할 수 있다.
        CREATE OR REPLACE PROCEDURE pSelectOneEx
        (
            pNum IN NUMBER,
            pName OUT VARCHAR2,
            pBirth OUT VARCHAR2,
            pScore OUT NUMBER,
            pGrade OUT VARCHAR2
        )
        IS
        BEGIN
            --pNum := 1;    -- 에러. IN 파라미터는 읽기 전용. OUT 파라미터는 값 변경 가능
            SELECT name, TO_CHAR(birth,'YYYY-MM-DD'), score, grade
                INTO pName, pBirth, pScore, pGrade
            FROM ex1 e1
            JOIN ex2 e2 ON e1.num = e2.num
            JOIN ex3 e3 ON e1.num = e3.num
            WHERE e1.num = pNum;
        END;
        /
        
      -- OUT 파라미터 확인용 프로시저
      CREATE OR REPLACE PROCEDURE pSelectResultEx
      IS
        vName  VARCHAR2(30);
        vBirth VARCHAR2(10);
        vScore NUMBER(3);
        vGrade VARCHAR(10);
      BEGIN
        -- 다른 프로시저 호출
        pSelectOneEx(5, vName, vBirth, vScore, vGrade); -- 5 : ex1테이블에 존재하는 num 번호
                    --> IN 넣어주고 OUT 받아오기
        
        DBMS_OUTPUT.PUT_LINE(vName||' '||vBirth||' '||vScore||' '||vGrade);
      END;
      /
      
      EXEC pSelectResultEx;
     
     
   
    
    
    
 -- ※ 함수
    -- : 사용자가 직접 로직을 구현하여 구현한 함수
    -- : 내장 함수(빌트인 함수)처럼 쿼리에서 호출하거나 EXECUTE 문을 통해 실행 가능

     -------------------------------------------------------
     -- 합 구하는 함수
     CREATE OR REPLACE FUNCTION fnSum
     ( 
        n IN NUMBER   
      )
      RETURN NUMBER
      IS
        s NUMBER := 0;
      BEGIN
        FOR i IN 1..n LOOP
            s := s+i;
        END LOOP;
        RETURN s;
      END;
      /
      
      SELECT * FROM user_procedures;
      
      SELECT fnSum(100) FROM dual;
     
     -------------------------------------------------------
     -- 주민번호를 이용하여 성별, 생년월일, 나이 구하는 함수 만들기

     -- 성별
     CREATE OR REPLACE FUNCTION fnGender
     (
        rrn IN VARCHAR2
     )
     RETURN VARCHAR2
     IS
        s NUMBER(1);
        b VARCHAR2(6) := '여자';
     BEGIN
        IF LENGTH(rrn) = 14 THEN
            s := SUBSTR(rrn, 8,1);
        ELSIF LENGTH(rrn) = 13 THEN
            s := SUBSTR(rrn,7,1);
        ELSE 
            RAISE_APPLICATION_ERROR(-20001,'주민번호 오류');
        END IF;
        
        IF MOD(s,2) = 1 THEN
           b := '남자';
        END IF;
        
        RETURN b;
     END;
     /
     
     SELECT name, rrn, fnGender(rrn) FROM emp;
     
     
     -- 생년월일
     CREATE OR REPLACE FUNCTION fnBirth
     (
        rrn IN VARCHAR2
     )
     RETURN DATE
     IS
        s NUMBER(1);
        b VARCHAR2(8);
     BEGIN
        IF LENGTH(rrn) = 14 THEN
            s := SUBSTR(rrn, 8,1);
        ELSIF LENGTH(rrn) = 13 THEN
            s := SUBSTR(rrn,7,1);
        ELSE 
            RAISE_APPLICATION_ERROR(-20002,'주민번호 오류');
        END IF;
        
        b :=SUBSTR(rrn,1,6);
        CASE 
            WHEN s IN (1,2,5,6) THEN b := '19'|| b;
            WHEN s IN (3,4,7,8) THEN b := '20'|| b;
            ELSE b:= '18'||b;
        END CASE;
        
     RETURN TO_DATE(b,'YYYY-MM-DD');
     END;
     /
     
     SELECT name, rrn, fnGender(rrn), fnBirth(rrn) FROM emp;     
     
     -- 나이
     CREATE OR REPLACE FUNCTION fnAge      --(1)
     (
        birth IN DATE
     )
     RETURN NUMBER
     IS
     BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE,birth)/12);
     END;
     /    
     
     CREATE OR REPLACE FUNCTION fnAge2      --(2)
     (
        rrn IN VARCHAR2
     )
     RETURN NUMBER
     IS
     BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE,fnBirth(rrn))/12);
     END;
     /    
     
     SELECT name, rrn, fnGender(rrn), fnBirth(rrn), fnAge(fnBirth(rrn)),fnAge2(rrn) FROM emp;     

     -------------------------------------------------------
     -- 문제
     -- score1 테이블 작성
          hak     문자(20)  기본키
          name   문자(30)  NOT  NULL
          kor      숫자(3)     NOT  NULL
          eng      숫자(3)    NOT  NULL
          mat      숫자(3)    NOT  NULL
      
      CREATE TABLE score1(
        hak VARCHAR2(20) PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        kor NUMBER(3) NOT NULL,
        eng NUMBER(3) NOT NULL,
        mat NUMBER(3) NOT NULL
      )    
          

      -- score2 테이블 작성
          hak     문자(20)  기본키, score1 테이블의 참조키
          kor      숫자(2,1)     NOT  NULL
          eng      숫자(2,1)    NOT  NULL
          mat      숫자(2,1)    NOT  NULL
          
     CREATE TABLE score2(
        hak VARCHAR2(20) PRIMARY KEY,
        kor NUMBER(2,1) NOT NULL,
        eng NUMBER(2,1) NOT NULL,
        mat NUMBER(2,1) NOT NULL,
        FOREIGN KEY(hak) REFERENCES score1(hak)
      )   
     
     -- 평점을 구하는 함수 작성
         -- 함수명 : fnGrade(s)
             95~100:4.5    90~94:4.0
             85~89:3.5     80~84:3.0
             75~79:2.5     70~74:2.0
             65~69:1.5     60~64:1.0
             60미만 0
             
        CREATE OR REPLACE FUNCTION fnGrade
        (
            score NUMBER
        ) 
        RETURN VARCHAR2
        IS 
            grade NUMBER;
        BEGIN
            CASE
                WHEN score >=95 THEN grade :=4.5;
                WHEN score >=90 THEN grade :=4.0;
                WHEN score >=85 THEN grade :=3.5;
                WHEN score >=80 THEN grade :=3.0;
                WHEN score >=75 THEN grade :=2.5;
                WHEN score >=70 THEN grade :=2.0;
                WHEN score >=65 THEN grade :=1.5;
                WHEN score >=60 THEN grade :=1.0;
                ELSE grade:=0;
            END CASE;
            
            RETURN TO_CHAR(grade,'FM9.99');
        END;
        /
       
       
      -- score1 테이블과 score2 테이블에 데이터를 추가하는 프로시저 만들기
         프로시저명 : pScoreInsert
         실행예 : EXEC pScoreInsert('1111', '가가가', 80, 60, 75);
   
         score1 테이블 => '1111', '가가가', 80, 60, 75  정보 추가
         score2 테이블 => '1111',            3.0, 1.0, 2.5 정보 추가(국, 영, 수 점수가 평점으로 계산되어 추가)
   
         단, 국어, 영어, 수학 점수는 0~100 사이가 아니면 예외 발생하고 종료
        CREATE OR REPLACE PROCEDURE pScoreInsert
        (
            phak IN VARCHAR2,
            pname IN VARCHAR2,
            pkor IN NUMBER,
            peng IN NUMBER,
            pmat IN NUMBER
        )
        IS 
        BEGIN
            IF pkor < 0 OR pkor >100 OR  peng < 0 OR peng >100 OR pmat < 0 OR pmat >100 THEN
                RAISE_APPLICATION_ERROR(-20003,'점수는 0~100 사이만 가능합니다.');   
            END IF;
        
            INSERT INTO score1(hak,name,kor,eng,mat) VALUES (phak,pname,pkor,peng,pmat);
            INSERT INTO score2(hak,kor,eng,mat) VALUES (phak,fnGrade(pkor),fnGrade(peng),fnGrade(pmat));
            COMMIT;
        END;
        /
        
 
     -- score1 테이블과 score2 테이블에 데이터를 수정하는 프로시저 만들기
         프로시저명 : pScoreUpdate
         실행예 : EXEC pScoreUpdate('1111', '가가가', 90, 60, 75);
   
         score1 테이블 => 학번이 '1111' 인 자료를  '가가가', 90, 60, 75  으로 정보 수정
         score2 테이블 => 학번이 '1111' 인 자료를           4.0, 1.0, 2.5 으로 정보 수정(국, 영, 수 점수가 평점으로 계산되어 수정)
   
         단, 국어, 영어, 수학 점수는 0~100 사이가 아니면 예외 발생하고 종료
        CREATE OR REPLACE PROCEDURE pScoreUpdate
        (
            phak VARCHAR2,
            pname VARCHAR2,
            pkor NUMBER,
            peng NUMBER,
            pmat NUMBER      
        )
        IS
        BEGIN
            IF pkor < 0 OR pkor >100 OR peng < 0 OR peng >100 OR pmat < 0 OR pmat >100 THEN
                RAISE_APPLICATION_ERROR(-20003,'점수는 0~100 사이만 가능합니다.');   
            END IF;
        
        UPDATE score2 SET  kor = fnGrade(pkor), eng = fnGrade(peng), mat = fnGrade(pmat)  WHERE hak = phak;
        UPDATE score1 SET name = pname, kor = pkor, eng = peng, mat = pmat  WHERE hak = phak;

        COMMIT;
        END;
        /
        

      -- score1 테이블과 score2 테이블에 데이터를 삭제하는 프로시저 만들기
         프로시저명 : pScoreDelete
         실행예 : EXEC pScoreDelete('1111');
         score1 과 score2 테이블 정보 삭제
        CREATE OR REPLACE PROCEDURE pScoreDelete
        (
            phak VARCHAR2
        )
        IS
        BEGIN
            DELETE FROM score2 WHERE hak = phak;
            DELETE FROM score1 WHERE hak = phak;
            
            COMMIT;
        END;
        /
