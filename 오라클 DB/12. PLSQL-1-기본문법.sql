-- ■ PL/SQL
 -- ※ 기본 문법
    -- PL/SQL
       -- : 프로그래밍언어의 특성을 가지는 SQL의 확장
       -- : 데이터 조작과 질의 문장은 PL/SQL의 절차적 코드 안에 포함된다.

     -- PL/SQL 프로그래밍 단위
       -- ㆍPL/SQL 익명 블록
       -- ㆍ함수
       -- ㆍ프로시저
       -- ㆍ패키지 : 패키지 명세, 패키지 바디
       -- ㆍ트리거


   -- ο 기본 문법
     -------------------------------------------------------
       -- sqlpus : DBMS_OUTPUT 출력
        SQL> SET SERVEROUTPUT ON
        
      -- PL/SQL 에서의 일반적인 SELECT
        SELECT 컬럼, 컬럼 INTO 변수, 변수 FROM 테이블 WHERE 조건;

     -- 
     DECLARE 
        vname VARCHAR2(30);
        vpay   NUMBER;
     BEGIN
        SELECT name, sal+bonus pay INTO vname, vpay    -->> name > vname // sal+bonus > vpay
        FROM emp
        WHERE empNo = '1001';
        
        DBMS_OUTPUT.PUT_LINE('이름 : ' ||vname);      -->> 문제 있는지 확인하는 용도. LOG 같은 역할
        DBMS_OUTPUT.PUT_LINE('급여 : ' ||vpay);
     END;
     /      --> 보기 - DBMS출력 창 켜서 확인
     
     -- %TYPE 속성 : 테이블의 컬럼을 참조하는 변수를 선언
     DECLARE 
        vname  emp.name%TYPE;   --> SELECT 문에 name이 있기에 name이라고 하면 충돌일어남
        vpay   NUMBER;
     BEGIN
        SELECT name, sal+bonus pay INTO vname, vpay   
        FROM emp
        WHERE empNo = '1001';
        
        DBMS_OUTPUT.PUT_LINE('이름 : ' ||vname);     
        DBMS_OUTPUT.PUT_LINE('급여 : ' ||vpay);
     END;
     /
     
     -- %ROWTYPE 속성 : 테이블의 행을 참조하는 레코드변수를 선언
     DECLARE 
        vrec emp%ROWTYPE;
     BEGIN
        SELECT * INTO vrec   
        FROM emp
        WHERE empNo = '1001';
        
        DBMS_OUTPUT.PUT_LINE('이름 : ' ||vrec.name);     
        DBMS_OUTPUT.PUT_LINE('급여 : ' ||vrec.sal);
     END;
     /     

     -- 사용자 정의 레코드
     DECLARE 
        -- 레코드 유형 선언(정의)
        TYPE MYTYPE IS RECORD
        (
            name emp.name%TYPE,
            pay  emp.sal%TYPE
        );
        -- 레코드 변수 선언
        vrec MYTYPE;
        BEGIN
        SELECT name, sal INTO vrec.name, vrec.pay
        FROM emp
        WHERE empNo = '1001';
        
        DBMS_OUTPUT.PUT_LINE('이름 : ' ||vrec.name);     
        DBMS_OUTPUT.PUT_LINE('급여 : ' ||vrec.pay);
     END;
     /  
     
       
   -- ο 제어 구조
     -------------------------------------------------------
     -- IF
     DECLARE 
        a NUMBER := 10;
     BEGIN
        IF MOD(a,6) = 0 THEN
            DBMS_OUTPUT.PUT_LINE(a || ' 2또는 3의 배수');
        ELSIF MOD(a,3) =0 THEN
            DBMS_OUTPUT.PUT_LINE(a || ' 3의 배수');
        ELSIF MOD(a,2) =0 THEN
            DBMS_OUTPUT.PUT_LINE(a || ' 2의 배수');
        ELSE
            DBMS_OUTPUT.PUT_LINE(a || ' 2또는 3의 배수가 아님');
        END IF;
    END;
/

     -- emp 테이블 : empNo가 1001 인 레코드의 name, sal+bonus, tax 출력
        -- tax 는 IF 구문을 이용하여 계산. pay가 300만 이상 3%, 200만 이상 2%, 나머지 0 / 소수점 첫째자리 반올림
      DECLARE 
        vname emp.name%TYPE;
        vpay  NUMBER;
        vtax  NUMBER;
     BEGIN
        SELECT name, sal+bonus INTO vname, vpay   
        FROM emp
        WHERE empNo = '1001';
     
        IF vpay >= 3000000 THEN
            vtax := ROUND(vpay * 0.03);
        ELSIF vpay >= 2000000 THEN
            vtax := ROUND(vpay * 0.02);
        ELSE
            vtax := 0;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE(vname || ' ' || vpay ||' ' || vtax);
    END;
/
     
     
     -------------------------------------------------------
     -- CASE
    DECLARE
        --변수지정
        vname emp.name%TYPE;
        vpay NUMBER;
        vtax NUMBER;
    BEGIN
        --db속에서 데이터 가져오는 작업
        SELECT name, sal+bonus INTO vname, vpay--하나의변수는 하나의값만 가질수있음 where절안쓰면 오류
        FROM emp
        WHERE empNo = '1001';
        
        CASE
            WHEN vpay>=3000000  THEN
                vtax := ROUND(vpay*0.03);
            WHEN vpay>=2000000  THEN
                vtax := ROUND(vpay*0.02);
            ELSE
                vtax := 0;
        END CASE;
        DBMS_OUTPUT.PUT_LINE(vname || ' ' || vpay||' '||vtax);
    END;
/

     -------------------------------------------------------
     -- basic LOOP, EXIT, CONTINUE
        -- 무한 번복
        -- EXIT를 만나면 빠져 나감

     -------------------------------------------------------
     -- WHILE-LOOP
        -- 1~100까지 합 구하기      
        DECLARE
            n NUMBER := 0;
            s NUMBER := 0;
        BEGIN
            -- WHERE 조건 LOOP
            WHILE n <100 LOOP
            n := n+1;
            s := s+n;
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('결과:'||s);
        END;
        
            
        -- 1~100까지 홀수합 구하기
        DECLARE
            n NUMBER := 1;
            s NUMBER := 0;
        BEGIN
            WHILE n <100 LOOP
                s := s+n;
                n := n+2;
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('결과:'||s);
        END;       
   
 
        -- 2~9단가지 구구단 출력
        DECLARE
            a NUMBER;
            b NUMBER;
        BEGIN
            a:=1;
            WHILE a<9 LOOP
                a := a+1;
                DBMS_OUTPUT.PUT_LINE('**' ||a||'단**');
                
                b := 0;
                WHILE b <9 LOOP
                    b := b+1;
                    DBMS_OUTPUT.PUT_LINE(a||'*'||b||'='||(a*b));
                END LOOP;
            END LOOP;
        END;  
    
    
        -- 무한 LOOP, EXIT
       DECLARE
            n NUMBER := 0;
            s NUMBER := 0;
        BEGIN
           LOOP
                n := n+1;
                s := s+1;
                EXIT WHEN n = 100;
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('결과 : '|| s);
        END; 
        
         
        -- CONTINUE, 1~100까지 수를 출력. 단 2 또는 3의 배수 제외     
        DECLARE
            n NUMBER := 0;
        BEGIN
            WHILE n <100 LOOP
            n := n+1;
            CONTINUE WHEN MOD(n,2) =0 OR MOD(n,3)=0;
            DBMS_OUTPUT.PUT(n||' ');
                --DBMS_OUTPUT.PUT():출력후 라인을 넘기지 않음
                --DBMS_OUTPUT.NEW_LINE()또는 DBMS_OUTPUT.PUT_LINE()을 만나야 출력함
            END LOOP; 
            DBMS_OUTPUT.NEW_LINE();--라인을 넘김
        END;
        
     -------------------------------------------------------
     -- FOR-LOOP
        DECLARE
            s NUMBER := 0;
        BEGIN
                --FOR에서 사용된 변수는 선언하지 않는다.
            FOR n IN 1..100 LOOP
            s := s+n;
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('결과:'||s);
        END;
  
        -- ABCD...
        DECLARE
        BEGIN
            FOR n IN 65..90 LOOP
                 DBMS_OUTPUT.PUT(CHR(n));
            END LOOP;
            DBMS_OUTPUT.NEW_LINE( );
        END;    
        
        -- ZYX....
        DECLARE
        BEGIN
                -- 역으로 반복(90,89,....)
            FOR n IN REVERSE 65..90 LOOP        -- >  90...65는 안됨.
                 DBMS_OUTPUT.PUT(CHR(n));
            END LOOP;
            DBMS_OUTPUT.NEW_LINE( );
        END;      
        
        


     -------------------------------------------------------
     -- SQL Cursor FOR LOOP
     
     DECLARE
        vname emp.name%TYPE;
        vsal  emp.sal%TYPE;
     BEGIN
        SELECT name, sal INTO vname, vsal
        FROM emp;   --에러: 하나의 레코드만 가져올 수 있다. 여러 레코드를 가져오기 위해서는 커서를 사용해야함.
        
        DBMS_OUTPUT.PUT_LINE(vname || ' ' || vsal);
     END;
/
     
    -- FOR 문을 이용하여 모든 레코드 출력
     DECLARE
     BEGIN
        FOR rec IN (  SELECT name, sal FROM emp ) LOOP
            DBMS_OUTPUT.PUT_LINE(rec.name || ' ' || rec.sal);
        END LOOP;
     END;
/

