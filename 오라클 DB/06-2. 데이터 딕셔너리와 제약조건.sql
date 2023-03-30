-- ■ 데이터 딕셔너리와 제약조건
 -- ※ 제약 조건(constraint)
    -- ο 기본 키(PRIMARY KEY)
        -- 유일성, NOT NULL
        -- 테이블당 기본키는 하나만 가능
        -- 두개 이상의 컬럼으로 기본키를 만들 수 있다.
    
    -- 1) 테이블 생성과 동시에 기본 키 설정
      -- (1) 컬럼 레벨 방식의 PRIMARY KEY 설정(inline constraint) : 하나의 컬럼으로만 기본키를 만들 수 있음
        -----------------------------------------------------
        -- 기본 형식
        CREATE TABLE 테이블명 (
               컬럼  데이터타입  [ CONSTRAINT 제약조건명 ]  PRIMARY KEY
                                 :
        );

        -- 컬럼레벨방식으로 기본키 만들기
            CREATE TABLE test1(
                id VARCHAR2(50) PRIMARY KEY,
                PW VARCHAR2(100) NOT NULL,
                name VARCHAR2(30) NOT NULL
            );
            
         -- 제약조건확인
            SELECT * FROM user_constraints WHERE table_name = 'TEST1';
                    -- 제약조건 종류 확인
                    -- 제약조건이름을 부여하지 않으면 이름은 SYS_Cxxx... 형식
            SELECT * FROM user_cons_columns WHERE table_name = 'TEST1';
                    -- 제약조건이 있는 컬럼 확인


            -- 컬럼레벨방식으로 기본키 만들기: 이름부여
            CREATE TABLE test2(
                id VARCHAR2(50) CONSTRAINT pk_test2_id PRIMARY KEY,
                PW VARCHAR2(100) NOT NULL,
                name VARCHAR2(30) NOT NULL
            );
            
            SELECT * FROM user_constraints WHERE table_name = 'TEST2';


      -- (2) 테이블 레벨 방식의 PRIMARY KEY 설정(out of line constraint)
        -----------------------------------------------------
        -- 기본 형식
        CREATE TABLE 테이블명 (
               컬럼  데이터타입   [ 제약조건 ],
                                 :
               [ CONSTRAINT 제약조건이름 ] PRIMARY KEY (컬럼 [,컬럼])
        );
        
        -- 테이블 생성과 동시에 기본키 부여
            CREATE TABLE test3(
                id VARCHAR2(50),
                PWd VARCHAR2(100) NOT NULL,
                name VARCHAR2(30) NOT NULL,
                PRIMARY KEY(id)
            );
            
            SELECT * FROM user_constraints WHERE table_name = 'TEST3';
            
            -- 복합키(두개 이상의 컬럼)로 기본키 부여 : 제약조건 이름 부여
            CREATE TABLE test4(
                num NUMBER,
                code VARCHAR2(100),
                name VARCHAR2(30) NOT NULL,
                CONSTRAINT pk_test4_num_code PRIMARY KEY(num,code)
            );
            
            SELECT * FROM user_constraints WHERE table_name = 'TEST4';
            SELECT * FROM user_cons_columns WHERE table_name = 'TEST4';
    --------------------------------------------------------
    INSERT INTO test3(id,pwd,name) VALUES('a1','123','가가가');
    
    INSERT INTO test3(id, pwd, name) VALUES('a1','555','나나나');
                -- 에러 : ORA-00001, 기본키 제약 위반(기본키는 중복값을 가질 수 없다)

    INSERT INTO test4(num, code, name) VALUES (1,'a10','가가가');
    INSERT INTO test4(num, code, name) VALUES (1,'b10','나나나');
            -- num + code가 기본키이므로 가능
            
    INSERT INTO test4(num, code, name) VALUES (2,NULL,'나나나');
            -- 에러 기본키는 NULL이 될 수 없다.
            
    UPDATE test3 SET id = '11' WHERE id = 'a1';
        -- 기본키는 제약조건을 위반하지 않으면 변경 가능하다.
    
    COMMIT;        
            
    
    -- 2) 존재하는 테이블에 기본 키 설정
       -----------------------------------------------------
       -- 기본 형식
       ALTER TABLE 테이블명 ADD [ CONSTRAINT 제약조건명 ]  PRIMARY KEY (컬럼 [,컬럼]);

        CREATE TABLE test5(
                id VARCHAR2(50),
                pwd VARCHAR2(100) NOT NULL,
                name VARCHAR2(30) NOT NULL
            );
            
            INSERT INTO test5(id,pwd,name) VALUES ('1','1','a');
            INSERT INTO test5(id,pwd,name) VALUES ('1','2','b');
            SELECT * FROM test5;

            ALTER TABLE test5 ADD PRIMARY KEY(id);
                -- 에러. 기본키 제약에 위반하는 데이터가 존재
            
            DELETE FROM test5;
            SELECT * FROM test5;
            
            -- 존재하는 테이블에 기본키 추가
            ALTER TABLE test5 ADD PRIMARY KEY(id);
            
            SELECT * FROM user_constraints WHERE table_name = 'TEST5';
            
    

    -- 3) 기본키 제약 조건 삭제
       -----------------------------------------------------
       -- 기본 형식
       ALTER TABLE 테이블명 DROP PRIMARY KEY;
       ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
       
         -- 존재하는 테이블에 기본키 제거
            ALTER TABLE test5 DROP PRIMARY KEY;
            
            SELECT * FROM user_constraints WHERE table_name = 'TEST5';

        -- 
            DROP TABLE test5 PURGE;
            DROP TABLE test4 PURGE;
            DROP TABLE test3 PURGE;
            DROP TABLE test2 PURGE;
            DROP TABLE test1 PURGE;



   -- ο UNIQUE 제약 조건   --> 너무 많이 사용하면 좋지않다.
    -- 유일성.
    -- PRIMARY KEY 컬럼을 제외한 유일성의 속성을 부여하기 위해
    -- UNIQUE 는 두개 이상 작성 가능
   
    -- 1) 테이블 생성과 동시에 UNIQUE 제약 조건 설정
      -- (1) 컬럼 레벨 방식의 UNIQUE 제약 설정
        -----------------------------------------------------
        -- 기본 형식
        CREATE TABLE 테이블명 (
               컬럼  데이터타입   [ CONSTRAINT 제약조건명 ]  UNIQUE
                                 :
        );

      -- (2) 테이블 레벨 방식의 UNIQUE 제약 조건 설정
        -----------------------------------------------------
        -- 기본 형식
        CREATE TABLE 테이블명 (
               컬럼  데이터타입  [ 제약조건 ] ,
                                 :
               [ CONSTRAINT 제약조건명 ] UNIQUE (컬럼 [,컬럼])
        );
        
        CREATE TABLE test1(
            id  VARCHAR2(50),
            pwd VARCHAR2(100) NOT NULL,
            name VARCHAR2(30) NOT NULL,
            email VARCHAR2(100),
            CONSTRAINT pk_test1_id PRIMARY KEY(id),
            CONSTRAINT uq_test1_email UNIQUE(email)
        );
        
        SELECT * FROM user_constraints WHERE table_name = 'TEST1';
        
        INSERT INTO test1(id, pwd, name, email) VALUES('1','1','a','aa');
        
        INSERT INTO test1(id, pwd, name, email) VALUES('2','2','b','aa');
                -- ORA-00001 : UNIQUE 제약 위반

        INSERT INTO test1(id, pwd, name, email) VALUES('2','2','b',NULL);
                -- 가능. email은 NULL 허용
        INSERT INTO test1(id, pwd, name, email) VALUES('3','3','c',NULL);
                -- 가능. NULL은 중복가능 
                
        
                
    -- 2) 존재하는 테이블에 UNIQUE 제약 조건 설정
     -------------------------------------------------------
     -- 기본 형식
       ALTER TABLE 테이블명 ADD [ CONSTRAINT 제약조건명 ]  UNIQUE (컬럼 [,컬럼]);




    -- 3) UNIQUE 제약 조건 삭제
     -------------------------------------------------------
     -- 기본 형식
       ALTER TABLE 테이블명 DROP UNIQUE (컬럼 [,컬럼]);
       ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

        -- test1 UNIQUE 제약조건 삭제
            ALTER TABLE test1 DROP CONSTRAINT uq_test1_email;
            또는
            ALTER TABLE test1 DROP UNIQUE(email);
        
            
        -- 제약조건 확인
            SELECT * FROM user_constraints WHERE table_name='TEST1';
           


   -- ο NOT NULL 제약 조건
        -- NULL : 데이터를 입력하지 않은 상태
        -- 문자열 길이가 0('')인 경우도 NULL
        
     -- 1) 테이블 생성시 NOT NULL 제약 조건 설정
       -----------------------------------------------------
       -- 기본 형식
        CREATE TABLE 테이블명 (
           컬럼   데이터타입  NOT NULL
                :
          );


     -- 2) 존재하는 테이블에 NOT NULL 제약 조건 설정
       -----------------------------------------------------
       -- 기본 형식
         ALTER TABLE 테이블명 MODIFY 컬럼  NOT NULL;
         ALTER TABLE 테이블명 ADD [ CONSTRAINT 제약조건이름 ] CHECK(컬럼 IS NOT NULL);


     -- 3) NOT NULL 제약 조건 삭제
       -----------------------------------------------------
       -- 기본 형식
         ALTER TABLE 테이블명 MODIFY 컬럼 NULL;
         ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건이름;
         
       -----------------------------------------------------
        CREATE TABLE test2(
            id  VARCHAR2(50),
            pwd VARCHAR2(100),
            name VARCHAR2(30),
            PRIMARY KEY(id)
        );

        -- name 컬럼에 NOT NULL 제약 조건 추가
        ALTER TABLE test2 MODIFY name NOT NULL;
        
        SELECT * FROM user_constraints WHERE table_name = 'TEST2';
        
        INSERT INTO test2(id,pwd,name) VALUES('1','1',NULL);
            -- ORA-01400 : NOT NULL 제약 위반
            
        
   -- > DEFAULT는 제약 조건은 아님
   -- ο DEFAULT : 데이터를 추가하거나 수정할때 기본값 설정
     -- 1) 테이블 생성시 DEFAULT 설정
     -------------------------------------------------------
     -- 기본 형식
          CREATE TABLE 테이블명 (
                    컬럼  데이터타입  DEFAULT 수식
                                 :
         );
        
        CREATE TABLE test3(
            num NUMBER PRIMARY KEY,
            name VARCHAR2(50) NOT NULL,
            subject VARCHAR2(500) NOT NULL,
            content VARCHAR2(4000) NOT NULL,
            created DATE DEFAULT SYSDATE,
            hitCount NUMBER DEFAULT 0 NOT NULL
        );
            -- DEFAULT와 NOT NULL을 같이 설정하는 경우 NOT NULL을 뒤에 기술
        
        -- 제약조건 확인
            SELECT * FROM user_constraints;
            
        -- default 확인
            SELECT * FROM user_tab_columns WHERE table_name = 'TEST3'; -- > DATA_DEFAULT에서 확인
            SELECT * FROM cols WHERE table_name = 'TEST3';
            
        -- 추가
            INSERT INTO test3(num, name, subject, content) VALUES(1,'a','aa','aaa');
                -- created : sysdate, hitCount:0 이 들어감
            SELECT * FROM test3;
            
            -- > DEFAULT 위험하기때문에 되도록 이렇게 모두 써주는 것이 안전
            INSERT INTO test3(num, name, subject, content, created, hitCount) VALUES(2,'b','bb','bbb',SYSDATE,0);
            SELECT * FROM test3;
            
            INSERT INTO test3(num, name, subject, content, created, hitCount) VALUES(3,'c','cc','ccc',NULL,0);
            SELECT * FROM test3;
            
            INSERT INTO test3(num, name, subject, content, created) VALUES(4,'d','dd','ddd',DEFAULT);
            SELECT * FROM test3;
        
            UPDATE test3 SET created = DEFAULT WHERE num = 1;
            UPDATE test3 SET created = SYSDATE WHERE num = 2;
            
            COMMIT;
            
            
     -- 2) DEFAULT 확인
         SELECT column_name, data_type, data_precision, data_length, nullable, data_default 
         FROM user_tab_columns WHERE table_name='테이블명';

     -- 3) DEFAULT 제거
       ------------------------------------------------------
       -- 기본 형식
          ALTER TABLE 테이블명 MODIFY 컬럼 DEFAULT NULL;




   -- ο CHECK 제약 조건
    -- 1) 테이블 생성과 동시에 CHECK 제약 조건 설정
      -- (1) 컬럼 레벨 방식의 CHECK 제약 설정
       ------------------------------------------------------
       -- 기본 형식
           CREATE TABLE 테이블명 (
                 컬럼  데이터타입  [ CONSTRAINT 제약조건명 ] CHECK ( 조건 )
                                 :
             );


      -- (2) 테이블 레벨 방식의 CHECK 제약 설정
       ------------------------------------------------------
       -- 기본 형식
           CREATE TABLE 테이블명 (
                   컬럼  데이터타입,
                               :
                   [ CONSTRAINT 제약조건명 ] CHECK ( 조건 )
          );


    -- 2) 존재하는 테이블에 CHECK 제약 조건 설정
     -------------------------------------------------------
     -- 기본 형식
       ALTER TABLE 테이블명
                  ADD [ CONSTRAINT 제약조건명 ] CHECK ( 조건 );


    -- 3) CHECK 제약 조건 삭제
     -------------------------------------------------------
     -- 기본 형식
        ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
      
       ------------------------------------------------------
        CREATE TABLE test4(
            num NUMBER PRIMARY KEY,
            name VARCHAR2(30) NOT NULL,
            kor NUMBER(3) NOT NULL,
            eng NUMBER(3) DEFAULT 0 CHECK(eng BETWEEN 0 AND 100),  -- > DEFAULT, CHECK 같이 있으면 DEFAULT 먼저
            CONSTRAINT ck_test4_kor CHECK(kor BETWEEN 0 AND 100)
        );
            
        SELECT * FROM user_constraints WHERE table_name = 'TEST4';
        
      -- 다음의 컬럼을 추가한다.
        -- gender 문자(6), 'M','F'만 추가 가능하도록 CHECK 제약 사용
            ALTER TABLE test4 ADD (gender VARCHAR2(6) CHECK(gender IN('M','F')));   
                                            -- > CHECK 조건절은 WHERE절에 기재하는 것처럼.
            
            SELECT * FROM user_constraints WHERE table_name = 'TEST4';
            
        -- test4 테이블 : 다음의 컬럼을 추가한다.
            -- sdate DATE NOT NULL, edate DATE NOT NULL
            ALTER TABLE test4 ADD (sdate DATE NOT NULL, edate DATE NOT NULL);
        
        -- test4 테이블 : 다음의 CHECK 제약을 추가한다.
            -- sdate <= edate
            ALTER TABLE test4 ADD CONSTRAINT ck_test4_dates CHECK ( sdate <= edate );
            
            SELECT * FROM user_constraints WHERE table_name = 'TEST4';
            
            INSERT INTO test4(num, name, kor, eng, gender, sdate, edate)
                VALUES(1,'a',90,90,'M','2023-03-07','2023-03-08');
            
            INSERT INTO test4(num, name, kor, eng, gender, sdate, edate)
                VALUES(2,'b',90,90,'M','2023-03-07','2023-03-06');
                    -- 에러: CHECK 제약 위반 
        
        -- 참고
         CREATE TABLE test4(
            num NUMBER PRIMARY KEY,
            sdate DATE NOT NULL,
            edate DATE CHECK (sdate <= edate)
        ); -- 에러. 다른 컬럼 참조 불가
        
        CREATE TABLE test4(
            num NUMBER PRIMARY KEY,
            sdate DATE NOT NULL,
            edate DATE NOT NULL,
            CONSTRAINT ck_test4_dates CHECK (sdate <= edate)
        ); -- 가능
        
        
        DROP TABLE test1 PURGE;        
        DROP TABLE test2 PURGE;       
        DROP TABLE test3 PURGE;       
        DROP TABLE test4 PURGE;
        
        SELECT * FROM tabs;
        
        
   --> 반드시. 알아야 함
   -- ο 참조 키(외래 키, FOREIGN KEY)
     -- 1) 테이블 생성과 동시에 FOREIGN KEY 제약 조건 설정
       -- (1) 컬럼 레벨 방식의 FOREIGN KEY 제약 설정
        -----------------------------------------------------
        -- 기본 형식
           CREATE TABLE 테이블명 (
                    컬럼  데이터타입  [ CONSTRAINT 제약조건명 ] 
                                            REFERENCES 참조할테이블명(컬럼)
                                            [ON DELETE { CASCADE | SET NULL } ]
                                 :
            );
   
      
     

       -- (2) 테이블 레벨 방식의 FOREIGN KEY 제약 설정 --> 보통 이렇게 사용
        -----------------------------------------------------
        -- 기본 형식
            CREATE TABLE table_name (
                    컬럼  데이터타입,
                               :
                     [ CONSTRAINT 제약조건명 ] FOREIGN KEY ( 컬럼 [,컬럼] )
                             REFERENCES  참조할테이블명(컬럼 [,컬럼])
                             [ON DELETE { CASCADE | SET NULL } ]
             );

 -----------------------------------------------------------
    -- test1 : 부모 테이블
    CREATE TABLE test1(
        code    VARCHAR2(30) PRIMARY KEY,
        subject VARCHAR2(100) NOT NULL
    );
    
    -- exam1 : 자식 테이블
    CREATE TABLE exam1(
        id VARCHAR2(30) PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        code VARCHAR2(30),               --> code로 같지 않아도 됨. 타입 크기만 맞으면 됨. NULL 허용.           
        CONSTRAINT fk_exam1_code FOREIGN KEY(code) REFERENCES test1(code) -- R
    );                                                      --> code는 기본키 or UNIQUE        
    
    SELECT * FROM user_constraints WHERE table_name = 'TEST1';
    SELECT * FROM user_constraints WHERE table_name = 'EXAM1';  --> R : 참조
    
    -- exam1 테이블에 데이터 추가
        INSERT INTO exam1(id, name, code) VALUES('1','a','x100');
            -- 에러 : ORA-02291
            -- 부모테이블이 없는 code값은 추가 불가

        INSERT INTO exam1(id, name, code) VALUES('1','a',NULL);
            -- 가능. 참조키가 NULL을 허용하므로

    -- test1 테이블에 데이터 추가(부모 테이블)
        INSERT INTO test1(code, subject) VALUES('x100','aaa');
        INSERT INTO test1(code, subject) VALUES('x101','bbb');
        INSERT INTO test1(code, subject) VALUES('x102','ccc');
        
    -- exam1 테이블에 데이터 추가
        INSERT INTO exam1(id,name,code) VALUES('2','b','x100');
        INSERT INTO exam1(id,name,code) VALUES('3','c','x102');
        INSERT INTO exam1(id,name,code) VALUES('4','d','x100');
        
        SELECT * FROM test1;
        SELECT * FROM exam1;
        
        UPDATE test1 SET code='x200' WHERE code = 'x100';
            -- 에러. code 'x100'은 exam1 테이블에서 참조하고 있으므로 수정이 불가능하다.
            
         UPDATE test1 SET code='x201' WHERE code = 'x101';
            -- 가능. 참조당하고 있지 않으므로 수정 가능
         SELECT * FROM test1;
         
         DELETE FROM test1 WHERE code='x100';
            -- 에러. code 'x100'은 exam1 테이블에서 참조하고 있으므로 삭제가 불가능
        
         DELETE FROM test1 WHERE code='x201';
            -- 가능 : 참조 당하고 있지 않으므로
            
         DROP TABLE test1 PURGE;
            -- 에러. 자식 테이블이 존재하면 삭제 불가능
            -- 자식 테이블을 먼저 지우고 부모 테이블을 삭제해야 함
        
         -- 강제 삭제 : 참조키도 삭제 됨
            DROP TABLE test1 CASCADE CONSTRAINTS PURGE;         
                            -- >  자식 관계 다 끊고 삭제
            SELECT * FROM user_constraints WHERE table_name = 'EXAM1';

            DROP TABLE exam1 PURGE;
            
    ----------------------------------------------
    -- 참조하는 컬럼과 참조당하는 컬럼은 타입 및 크기는 일치해야 하지만 컬럼명은 다를 수 있다.
      -- test1 : 부모 테이블
        CREATE TABLE test1(
            code VARCHAR2(30) PRIMARY KEY,
            subject VARCHAR2(100) NOT NULL 
        );
        
        --exam1 : 자식 테이블
        CREATE TABLE exam1(
            id VARCHAR2(30) PRIMARY KEY,
            name VARCHAR2(30) NOT NULL,
            scode VARCHAR2(30) NOT NULL,
            FOREIGN KEY(scode) REFERENCES test1(code)       --> 이름 잘 확인
        );                       

        DROP TABLE exam1 PURGE;
        DROP TABLE test1 PURGE;
    ----------------------------------------------
    -- 관계 => 1:1, 1:N(1:0)
    -- 회원테이블
    CREATE TABLE member1(
        id VARCHAR2(30) PRIMARY KEY,
        pwd VARCHAR2(100) NOT NULL,
        name VARCHAR2(30) NOT NULL
    );
    
    -- 1:1 관계 
        -- 식별관계 : 기본키이면서 참조키
    CREATE TABLE member2 (
        id VARCHAR2(30),
        birth DATE,
        tel VARCHAR2(50),
        CONSTRAINT pk_member2_id  PRIMARY KEY(id),
        CONSTRAINT fk_member2_id  FOREIGN KEY(id) REFERENCES member1(id)
    );
    
    -- 1:다 관계 
        -- 비식별관계 : 단순한 참조키
    CREATE TABLE guest(     
        num NUMBER PRIMARY KEY,
        id VARCHAR2(30) NOT NULL,
        content VARCHAR2(400) NOT NULL,
        reg_date DATE DEFAULT SYSDATE,
        FOREIGN KEY(id) REFERENCES member1(id)
    );
    
    -- 2개의 컬럼을 기본키로 설정
        -- 두개의 테이블을 참조
        -- member1:guestLike => 1:다,  guest:guestLike => 1:다
        -- 식별관계 : 기본키이면서 참조키
      CREATE TABLE guestLike(   --> 좋아요 테이블
        num NUMBER,
        id VARCHAR2(30),
        PRIMARY KEY(num, id),
        FOREIGN KEY (num) REFERENCES guest(num),
        FOREIGN KEY (id) REFERENCES member1(id)
      );
      
    --> 컬러명에는 _(언더바) 사용 지양  
    -- 하나의 테이블을 두번 참조 : 쪽지 테이블
        -- 1:다, 비식별관계
        CREATE TABLE note(     
            num NUMBER PRIMARY KEY,
            sendId VARCHAR2(30) NOT NULL,
            receiveId VARCHAR2(30) NOT NULL,
            content VARCHAR2(4000) NOT NULL,
            FOREIGN KEY (sendId) REFERENCES member1(id),
            FOREIGN KEY (receiveId) REFERENCES member1(id)
        );

      -- member1 테이블을 참조하는 모든 테이블 확인 ( 자식 테이블 목록 확인 )
        SELECT fk.owner, fk.constraint_name , fk.table_name 
        FROM all_constraints fk, all_constraints pk 
        WHERE fk.r_constraint_name = pk.constraint_name 
                   AND fk.constraint_type = 'R' 
                   AND pk.table_name = UPPER('member1')
        ORDER BY fk.table_name;
        --> 참조 2번하면 두개 나옴. (ex.NOTE)
        
      -- guestLike 테이블이 참조하고 있는 테이블 목록 출력(모든 부모 테이블 목록 확인)
        SELECT table_name FROM user_constraints
        WHERE constraint_name IN (
              SELECT r_constraint_name 
              FROM user_constraints
              WHERE table_name = UPPER('guestLike') AND constraint_type = 'R'
        );
        
        --guestLike 테이블이 참조하고 있는 테이블 목록 및 부모컬럼 출력(모든 부모 테이블 목록 확인)
        SELECT fk.constraint_name, fk.table_name child_table, fc.column_name child_column,
                    pk.table_name parent_table, pc.column_name parent_column
        FROM all_constraints fk, all_constraints pk, all_cons_columns fc, all_cons_columns pc
        WHERE fk.r_constraint_name = pk.constraint_name
                   AND fk.constraint_name = fc.constraint_name
                   AND pk.constraint_name = pc.constraint_name
                   AND fk.constraint_type = 'R'
                   AND pk.constraint_type = 'P'
                   AND fk.table_name = UPPER('guestLike');

        -- 테이블 삭제 ( > 자식부터. 만든 순서 거꾸로 지우면 됨 )
            DROP TABLE note PURGE;
            DROP TABLE guestLike PURGE;
            DROP TABLE guest PURGE;
            DROP TABLE member2 PURGE;
            DROP TABLE member1 PURGE;

            -- DROP TABLE member1 CASCADE CONSTRAINTS PURGE;
     ----------------------------------------------
      -- 자기 자신 참조 : 대분류, 중분류 등
      CREATE TABLE test1(
        num NUMBER PRIMARY KEY,
        subject VARCHAR2(100) NOT NULL,
        snum NUMBER,
        FOREIGN KEY(sunm) REFERENCES test1(num)
      );
      
      DROP TABLE test1 PURGE;
     ----------------------------------------------
      -- ON DELETE CASCADE : 부모 테이블의 데이터가 삭제되면 자식 테이블의 데이터도 삭제
      CREATE TABLE test1(
        sdate NUMBER(4),
        code VARCHAR2(10),
        subject VARCHAR2(100) NOT NULL,
        PRIMARY KEY(sdate,code)
      );
      
      CREATE TABLE test2(
        num NUMBER PRIMARY KEY,
        sdate NUMBER(4) NOT NULL,
        code VARCHAR2(10) NOT NULL,
        name VARCHAR2(100) NOT NULL,
        qty NUMBER DEFAULT 0,
        FOREIGN KEY(sdate, code) REFERENCES test1(sdate,code) ON DELETE CASCADE
      );
      
      INSERT INTO test1(sdate, code, subject) VALUES (2023,'a100','프로그래밍');
      INSERT INTO test1(sdate, code, subject) VALUES (2023,'b100','데이터베이스');
      INSERT INTO test1(sdate, code, subject) VALUES (2023,'c100','웹');
      
      INSERT INTO test2(num, sdate, code, name, qty) VALUES (1,2023,'a100','자바',0);
      INSERT INTO test2(num, sdate, code, name, qty) VALUES (2,2023,'a100','C',0);
      INSERT INTO test2(num, sdate, code, name, qty) VALUES (3,2023,'a100','파이썬',0);
         
      INSERT INTO test2(num, sdate, code, name, qty) VALUES (4,2023,'b100','오라클',0);
      INSERT INTO test2(num, sdate, code, name, qty) VALUES (5,2023,'b100','마리아디비',0);
      
      INSERT INTO test2(num, sdate, code, name, qty) VALUES (6,2023,'c100','HTML',0);
      
      SELECT * FROM test1;
      SELECT * FROM test2;
      
      DELETE FROM test1 WHERE sdate= 2023 AND code='a100';
      SELECT * FROM test1;
      SELECT * FROM test2;
      
      DROP TABLE test2 PURGE;
      DROP TABLE test1 PURGE;


     -- 2) 존재하는 테이블에 FOREIGN KEY 제약 조건 설정
       ------------------------------------------------------
       -- 기본 형식
          ALTER TABLE 테이블명
              ADD [ CONSTRAINT 제약조건명 ] FOREIGN KEY( 컬럼 [,컬럼] )
                     REFERENCES  참조할테이블명(컬럼 [,컬럼]);


     -- 3) FOREIGN KEY 제약 조건 삭제
      -------------------------------------------------------
      -- 기본 형식
        ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;





   -- ο 제약 조건 활성화 및 비활성화
     -- 1) 존재하는 테이블의 제약 조건 비 활성화
     -------------------------------------------------------
     --
      ALTER TABLE 테이블명 DISABLE CONSTRAINT 제약조건명 [ CASCADE ];


     -- 2) 테이블의 제약 조건 활성화
     -------------------------------------------------------
     --
       ALTER TABLE 테이블명 ENABLE CONSTRAINT 제약조건명;
 
    
     -------------------------------------------------------
     -- 테이블 작성 : dept_test(부서)
        dept_id(부서코드)      VARCHAR2(30)     기본키
        dept_name(부서명)      VARCHAR2(50)     NOT NULL
        manager_id(부서장코드)  VARCHAR2(30)     NOT NULL
        
        CREATE TABLE dept_test (
            dept_id     VARCHAR2(30)  PRIMARY KEY,
            dept_name   VARCHAR2(50)  NOT NULL,
            manager_id  VARCHAR2(30)  NOT NULL
        );       


      -- 테이블 작성 : emp_test(사원)
        emp_id(사원아이디)   VARCHAR2(30)    기본키
        name(이름)          VARCHAR2(50)    NOT NULL
        email(이메일)       VARCHAR2(50)     NOT NULL
        dept_id(부서코드)    VARCHAR2(30)    NOT NULL
        
        CREATE TABLE emp_test (
            emp_id        VARCHAR2(30)    PRIMARY KEY,
            name          VARCHAR2(50)     NOT NULL,
            email         VARCHAR2(50)     NOT NULL,
            dept_id       VARCHAR2(30)     NOT NULL
        );
         
        
      -- dept_test 테이블에 참조키 추가
        manager_id 컬럼은 emp_test 테이블의 emp_id를 참조
        
        ALTER TABLE dept_test
              ADD FOREIGN KEY ( manager_id )
                     REFERENCES  emp_test(emp_id);
                     
                     
      -- emp_test 테이블에 참조키 추가
        dept_id 컬럼은 dept_test 테이블의 dept_id 를 참조
         
         ALTER TABLE emp_test
              ADD FOREIGN KEY( dept_id )
                     REFERENCES  dept_test(dept_id);


      -- 다음의 데이터 추가  
        dept_test 테이블 : 'a1', '영업부', '1001'
        emp_test 테이블 : '1001', '김영업', 'kim@test.com','a1'
        
        INSERT INTO dept_test (dept_id, dept_name, manager_id) VALUES ('a1', '영업부', '1001');
            -- 에러 : 부모 테이블에 값이 없음   >> 서로 참조하고 있고, NOT NULL 조건
            
        INSERT INTO emp_test (emp_id, name, email, dept_id) VALUES ('1001', '김영업', 'kim@test.com','a1');
            -- 에러 : 부모 테이블에 값이 없음        
        
        
      -- 참조키를 비활성화
         SELECT * FROM user_constraints WHERE table_name = 'DEPT_TEST';
            -- R
         ALTER TABLE dept_test DISABLE CONSTRAINT SYS_C007819 CASCADE;
            
         SELECT * FROM user_constraints WHERE table_name = 'EMP_TEST';
            -- R
         ALTER TABLE emp_test DISABLE CONSTRAINT SYS_C007820 CASCADE;
         
      -- 비활성화 확인
         SELECT * FROM user_constraints WHERE table_name = 'DEPT_TEST';
         SELECT * FROM user_constraints WHERE table_name = 'EMP_TEST';
                -- status 컬럼 : DISABLE
        
      -- 참조키를 비활성화 하면 제약 조건을 위반하는 데이터도 추가가 가능
         INSERT INTO dept_test (dept_id, dept_name, manager_id) VALUES ('a1', '영업부', '1001');
         INSERT INTO dept_test (dept_id, dept_name, manager_id) VALUES ('b1', '개발부', '2001');
         INSERT INTO dept_test (dept_id, dept_name, manager_id) VALUES ('c1', '총무부', '3001');
         SELECT * FROM dept_test;
         
         INSERT INTO emp_test (emp_id, name, email, dept_id) VALUES ('1001', '김영업', 'kim@test.com','a1');
         INSERT INTO emp_test (emp_id, name, email, dept_id) VALUES ('2001', '이이이', 'lee@test.com','b1');
         SELECT * FROM emp_test;      
         
      -- 참조키를 활성화
         ALTER TABLE dept_test ENABLE CONSTRAINT SYS_C007819;
            -- 에러 : 제약조건 위반하는 데이터가 존재  >> emp_test에 3001번이 없어.
            
        INSERT INTO emp_test (emp_id, name, email, dept_id) VALUES ('3001', '다다다', 'da@test.com','c1');
         
        ALTER TABLE dept_test ENABLE CONSTRAINT SYS_C007819;
        ALTER TABLE emp_test ENABLE CONSTRAINT SYS_C007820;
         
      -- 테이블 삭제
         DROP TABLE dept_test CASCADE CONSTRAINTS PURGE;
         DROP TABLE emp_test CASCADE CONSTRAINTS PURGE;
         
         
         
         
         
         
         
         
         
         
         