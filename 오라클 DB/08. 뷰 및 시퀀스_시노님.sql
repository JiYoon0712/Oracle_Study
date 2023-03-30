-- ■ 뷰 및 시퀀스, 시노님
 -- ※ 뷰(VIEW)
   -- : 가상의 테이블
   -- : 뷰를 만들수 있는 권한이 있어야 뷰를 만들 수 있다.
   -- : 권한이 없는 경우 다음의 에러가 발생
      -- ORA-01031: 권한이 불충분합니다.

     -------------------------------------------------------
     -- 
       SELECT b.bCode, bName, bPrice, p.pNum, pName, sDate, c.cNum, cName, qty, bPrice*qty amt
       FROM book b
       JOIN pub p ON b.pNum = p.pNum
       JOIN dsale d ON b.bCode = d.bCode
       JOIN sale s ON d.sNum = s.sNum
       JOIN cus c ON s.cNum = c.cNum;
     
     -- sky 계정 : 자신의 시스템 권한 확인
        SELECT * FROM user_sys_privs;

     -- sky에게 뷰를 만들수 있는 권한 부여
        -- 관리자 계정(sys 또는 system)
          GRANT CREATE VIEW TO sky;  --> 관리자에서 실행
       
     -- 뷰 만들기
        CREATE VIEW panmai
        AS 
           SELECT b.bCode, bName, bPrice, p.pNum, pName, sDate, c.cNum, cName, qty
           FROM book b
           JOIN pub p ON b.pNum = p.pNum
           JOIN dsale d ON b.bCode = d.bCode
           JOIN sale s ON d.sNum = s.sNum
           JOIN cus c ON s.cNum = c.cNum;
        
     -- 뷰 확인
        SELECT * FROM tab;
            -- tabtype : VIEW 로 표시
            
      -- 뷰 컬럼 확인
        DESC panmai;
        SELECT * FROM col WHERE tname = UPPER('panmai');
        
     -- 뷰 소스 확인
        SELECT view_name, text FROM user_views;
        
     -- 뷰를 이용하여 레코드 출력
        SELECT * FROM panmai;
        SELECT SUM(qty*bPrice) FROM panmai;
        SELECT SUM(qty*bPrice) FROM panmai WHERE TO_CHAR(sDate,'YYYY') = TO_CHAR(SYSDATE,'YYYY');
             --> 이변년도 판매 합
    
     -- 뷰를 수정하기 (OR REPLACE : 없으면 만들고, 있으면 수정)
        CREATE OR REPLACE VIEW panmai
        AS 
           SELECT b.bCode, bName, bPrice, p.pNum, pName, sDate, c.cNum, cName, qty, bPrice*qty amt
           FROM book b
           JOIN pub p ON b.pNum = p.pNum
           JOIN dsale d ON b.bCode = d.bCode
           JOIN sale s ON d.sNum = s.sNum
           JOIN cus c ON s.cNum = c.cNum;  
           
        SELECT * FROM panmai;
      -------------------------------------------------------        
       -- empView 라는 이름으로 뷰 작성
        -- empNo, name, gender, birth, dept, pos, hireDate, sal, bonus, tot_pay(sal+bonus)
            -- gender, birth : rrn 이용
            -- tax : tot_pay >= 300만원 -> 3%, 200만원이상 -> 2%, 나머지 0
        
        CREATE OR REPLACE VIEW empView
        AS(
             SELECT empNo, name, 
                   DECODE(MOD(SUBSTR(rrn,8,1),2),0,'여자','남자') gender, 
                   TO_DATE( CASE
                                WHEN SUBSTR(rrn,8,1) IN (1,2,5,6) THEN '19'
                                WHEN SUBSTR(rrn,8,1) IN (3,4,7,8) THEN '20' 
                                ELSE '18'
                            END || SUBSTR(rrn,1,6),'YYYYMMDD') birth, 
                   dept, pos, hireDate, sal, bonus, (sal+bonus) tot_pay,
                   ROUND( CASE 
                            WHEN (sal+bonus) >=300 THEN 0.03
                            WHEN (sal+bonus) >=200 THEN 0.02
                            ELSE 0
                          END *(sal+bonus)+4, -1) tax
            FROM emp
        );
        
        SELECT * FROM empView;
        SELECT empNo, name, gender,birth,
                TRUNC(MONTHS_BETWEEN(SYSDATE,birth)/12) age
        FROM empView;
--03/10    
      -------------------------------------
      -- 뷰 삭제
      DROP VIEW 뷰 이름;

        
        
    --> 반드시 알아야 해!!!!!!!!!       
 -- ※ 시퀀스(sequence)
     -- 연속적인 유일의 정수값 생성(1, 2, 3, ...)
     -- 시퀀스 값을 기본키의 값으로 사용 할 수 있다.
     -- 트랜잭션의 커밋 또는 롤백과 상관없이 시퀀스는 증가한다.
     -- 12C 이상부터는 테이블 생성시 DEFAULT 값으로 시퀀스 값을 할당 할 수 있다.
     -- 시퀀스 목록 확인
        SELECT * FROM seq;
     -- 시퀀스 값 가져오기
        시퀀스이름.NEXTVAL : 다음 시퀀스 값
        시퀀스이름.CURRVAL : 현재 시퀀스 값

     -------------------------------------------------------
     -- 시퀀스 만들기
        -- 시퀀스 이름을 seq로 작성하면 목록을 확인할때 오류가 발생한다.
        
        
     -- 1부터 1씩 증가하는 시퀀스 만들기    
         CREATE SEQUENCE test_seq  --> 뒤에 옵션 없이 한줄만 작성해도 시퀀스 만들기는 가능  -- >> 반드시 암기해야 함
         INCREMENT BY 1     --> 1씩 증가
         START WITH 1       --> 초기값 : 1
         NOMAXVALUE         --> 최대값 지정 X
         NOCYCLE            --> 싸이클 형성 X
         NOCACHE;           
     
     -- 시퀀스 목록 확인
        SELECT * FROM user_sequences;
        SELECT * FROM seq;
        
     -- 시퀀스 값 가져오기
        SELECT test_seq.NEXTVAL FROM dual;  -- 1
        SELECT test_seq.NEXTVAL FROM dual;  -- 2
        SELECT test_seq.NEXTVAL FROM dual;  -- 3  --> 한 번 쓰면 절대 이전 값으로 못돌아감
     
     -- 현재 시퀀스 값 확인
        SELECT test_seq.CURRVAL FROM dual;  -- 3
        
     -- 시퀀스 삭제
        DROP SEQUENCE 시퀀스이름;
     
        DROP SEQUENCE test_seq;
        SELECT * FROM seq;
     -------------------------------------------------------
     -- 시퀀스 이용
        CREATE TABLE board(
            num      NUMBER PRIMARY KEY,
            name     VARCHAR2(30) NOT NULL,
            subject  VARCHAR2(500) NOT NULL,
            content  VARCHAR2(4000) NOT NULL,
            reg_date DATE DEFAULT SYSDATE,
            hitCount NUMBER DEFAULT 0
        );
     
        SELECT * FROM tab;
        DESC board;
        
         CREATE SEQUENCE board_seq  
         INCREMENT BY 1     
         START WITH 1       
         NOMAXVALUE         
         NOCYCLE            
         NOCACHE;         
     
        SELECT * FROM seq;
        
        INSERT INTO board (num, name, subject, content, reg_date, hitCount)
            VALUES(board_seq.NEXTVAL, '김자바','자바공부하고싶어요','열심히',SYSDATE,0);
        
        INSERT INTO board (num, name, subject, content, reg_date, hitCount)
            VALUES(board_seq.NEXTVAL, '너자바','자바란 ?','어려워요',SYSDATE,0);
        
        SELECT * FROM board;
        ROLLBACK;   
        
        -- ROLLBACK 해도 시퀀스는 다시 1로 돌아가지 않는다. --> 시퀀스를 다시 지우고 만드는 수밖에는 없음
        
        INSERT INTO board (num, name, subject, content, reg_date, hitCount)         
            VALUES(board_seq.NEXTVAL, '김자바','자바공부하고싶어요','열심히',SYSDATE,0);        
            
        SELECT * FROM board;  
        
        DROP TABLE board PURGE;
        DROP SEQUENCE board_seq;
        
        
     -------------------------------------------------------
     -- 1부터 증가하는 시퀀스. 기본 캐시 : 20개
        CREATE SEQUENCE test_seq;
            -- 기본캐시 20 : 미리 20개의 시퀀스를 만들어 놓음
            -- 현재 시퀀스가 3인 상태에서 오라클 서버가 재실행되면 다음 시퀀스는 21부터 시작
            
        SELECT * FROM seq;
        
     -- 10~20 까지 2씩 증가하는 시퀀스. 캐시:5개
         CREATE SEQUENCE test_seq2
         INCREMENT BY 2     
         START WITH 10
         MINVALUE 10
         MAXVALUE 20    
         CACHE 5;    
         
        SELECT test_seq2.NEXTVAL FROM dual;
            -- 20 넘으면 오류
        
     -- 10~20 까지 3씩 증가하는 시퀀스. 캐시:5개. 끝에 도달하면 1부터 다시 시작
         CREATE SEQUENCE test_seq3
         INCREMENT BY 3     
         START WITH 10
         MINVALUE 1
         MAXVALUE 20 
         CYCLE
         CACHE 5; 
         
         SELECT test_seq3.NEXTVAL FROM dual;
            -- 10 13 16 19 1 4 ...
            
     -------------------------------------------------------
       DROP TABLE board PURGE;
         
       DROP SEQUENCE board_seq;
       DROP SEQUENCE test_seq;
       DROP SEQUENCE test_seq2;
       DROP SEQUENCE test_seq3;  
         
         
        
 -- ※ 시노님(synonym) : 동의어
     -------------------------------------------------------
     -- sky 계정 : hr 계정의 employees 테이블을 SELECT
        SELECT * FROM hr.employees;
            -- 에러. 테이블이 없습니다. (권한이 없음)
    
    -- hr 계정 : sky 계정에게 employees 테이블을 SELECT 할 수 있는 권한 부여
        GRANT SELECT ON employees TO sky;
        
     -- sky 계정 : hr 계정의 employees 테이블을 SELECT
        SELECT * FROM hr.employees;        
        
     -- 관리자 계정(sys, system) : sky 계정에게 synonym을 만들 수 있는 권한 부여        
        GRANT CREATE synonym TO sky;
        
     -- sky 계정
        -- sky 계정이 가지고 있는 시스템 권한 확인
            SELECT * FROM user_sys_privs;
            
        -- hr.employees를 employees 라는 시노님 작성    --> employees 객체가 이미 있으면 안됨
            CREATE SYNONYM employees FOR hr.employees;
            
        -- SYNONYM 확인    
            SELECT * FROM syn;
            
        -- employees 시노님으로 테이블의 내용 확인
            SELECT * FROM employees;
            
        -- SYNONYM 삭제  
            DROP SYNONYM employees;
            
            SELECT * FROM syn;            
            
