-- ■ 트랜잭션
 -- ※ 트랜잭션(Transaction)
   -- ο COMMIT 과 ROLLBACK
    
    CREATE TABLE guest( 
        num NUMBER PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        content VARCHAR2(4000) NOT NULL,
        reg_date DATE DEFAULT SYSDATE
    );
    
    CREATE SEQUENCE guest_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;
    
    
    SELECT * FROM tab;
    SELECT * FROM seq;
    
    INSERT INTO guest(num,name,content, reg_date) VALUES (guest_seq.NEXTVAL,'a','aa',SYSDATE);
    INSERT INTO guest(num,name,content, reg_date) VALUES (guest_seq.NEXTVAL,'b','bb',SYSDATE);
    SELECT * FROM guest;
  --  
    SAVEPOINT a; -- 트랜잭션 지점 설정
    INSERT INTO guest(num, name, content, reg_date) VALUES(guest_seq.NEXTVAL,'c','cc',SYSDATE);
    
    SELECT * FROM guest;
    
    ROLLBACK TO a;  -- 마지막 INSERT 만 롤백
    SELECT * FROM guest;
    
    ROLLBACK; -- 모두 롤백
    SELECT * FROM guest;
    
    INSERT INTO guest(num, name, content, reg_date) VALUES(guest_seq.NEXTVAL,'a','aa',SYSDATE);
    COMMIT;     -- COMMIT 또는 DDL을 만나면 커밋(트랜잭션 완료)
    
    ROLLBACK ;  -- COMMIT 이후의 ROLLBACK은 의미없음
    
    SELECT * FROM guest;
 
    INSERT INTO guest(num, name, content, reg_date) VALUES(guest_seq.NEXTVAL,'a','aa',SYSDATE);
    COMMIT;




   -- ο 트랜잭션 관련 설정
     -- 1) SET TRANSACTION : 다양한 트랜잭션 속성을 지정

     -- 2) LOCK TABLE
        -- : 현재 트랜잭션이 진행되고 있는 데이터에 대해 다른 다른 트랜잭션의 검색이나 변경을 막아 여러 트랜잭션이 동시에 같은 데이터를 사용하도록 설정
        
        -- SQL Developer
           SELECT * FROM guest;
           
           INSERT INTO guest(num, name, content, reg_date) VALUES(guest_seq.NEXTVAL,'e','ee',SYSDATE);
           SELECT * FROM guest;
           
        -- VS Code
           SELECT * FROM guest;
                    -- e는 출력 안됨 > 당연함 커밋 안함;;;
        
        -- SQL Developer       
           COMMIT;
           
        -- VS Code 
           SELECT * FROM guest;
                -- e 출력
   
   
      -------------------------------------------------------
      -- VS Code
         SET TRANSACTION READ ONLY;
                -- SELECT 만 가능(INSERT, UPDATE, DELETE 불가능)
         SELECT * FROM guest;

         DELETE * FROM guest;  -- 에러
         ROLLBACK;
         
         SET TRANSACTION READ WRITE;
         
         DELETE FROM guest;
         SELECT * FROM guest;
         
         ROLLBACK;
         SELECT * FROM guest;
 
      -------------------------------------------------------
      -- SQL Developer
        LOCK TABLE guest IN EXCLUSIVE MODE;
                --EXCLUSIVE: 잠긴 테이블에서 SELECT 만 허용
        INSERT INTO guest(num,name,content,reg_date) VALUES(guest_seq.NEXTVAL,'f','ff',SYSDATE);
      
      -- VS Code
         DELETE FROM guest;
         
      -- SQL Developer    
         ROLLBACK;
      
      -- VS Code
        -- 대기 멈추가 DELETE 실행
        ROLLBACK;
        
      -- SQL Developer 
        DROP TABLE guest PURGE;
        DROP SEQUENCE guest_seq;
          
          select * from tab;

   -- ο COMMIT이 되지 않는 상태 확인
      -------------------------------------------------------
      -- 관리자(sys 또는 system) 계정에서 확인
        SELECT s.inst_id inst, s.sid||','||s.serial# sid, s.username,
                    s.program, s.status, s.machine, s.service_name,
                    '_SYSSMU'||t.xidusn||'$' rollname, --r.name rollname, 
                    t.used_ublk, 
                   ROUND(t.used_ublk * 8192 / 1024 / 1024, 2) used_bytes,
                   s.prev_sql_id, s.sql_id
        FROM gv$session s,
                  --v$rollname r,
                  gv$transaction t
        WHERE s.saddr = t.ses_addr
        ORDER BY used_ublk, machine;
