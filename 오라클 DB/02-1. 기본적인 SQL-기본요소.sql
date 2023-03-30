-- ■ SQL*Plus
 -- ※ sqlplus 실행
   -- 관리자 계정으로 sqlplus 실행
      cmd> sqlplus sys/"패스워드" AS SYSDBA

      또는
      cmd> sqlplus  / AS SYSDBA
           -- 위 방법은 경우에 따라 접속 되지 않을 수 있다.

      SQL> SHOW USER    -- 접속 사용자 확인

   -- 일반 사용자 계정으로 sqlplus 실행
      cmd> sqlplus 계정명/"패스워드"
      SQL> SHOW USER

      cmd> sqlplus sky/"java$!"
      SQL> SHOW USER
      SQL> SELECT name FROM emp;

      SQL> conn hr/HR				//  > 처음 만들때는 sqlplus 사용, 나중에 사용시 conn 사용
      SQL> SHOW USER

 -- ※ SQL*Plus 기본 명령어
    -- ο CONNECT 
       -- 관리자 계정으로 접속
           SQL> CONN sys/"패스워드" AS SYSDBA
           SQL> SHOW USER 

       -- 일반 사용자 계정으로 계정으로 접속
           SQL> CONN 계정명/"패스워드"
           SQL> SHOW USER


    -- ο EXIT
       - SQLPLUS 종료

      SQL> EXIT


-- ■ SQL 기본요소
 -- ※ 산술 연산자 및 연결 연산자
     -- ο 산술 연산자   

    -- ο 연결 연산자



 -- ※ DUAL 테이블과 테이블 목록 및 테이블 구조
    -- ο  DUAL 테이블
 	SELECT * FROM dual;

    -- ο 테이블 목록
      -- 1) USER_TABLES(TABS) 딕셔너리
           -- 사용 예 : 사용자가 소유한 테이블명과 테이블의 테이블스페이스 조회

            SELECT * FROM USER_TABLES;
            SELECT * FROM TABS;

      -- 2) TAB 뷰(VIEW)
           -- 사용 예 : 현재 사용자가 소유한 테이블 목록 조회
             SELECT * FROM TAB;

      -- 3) ALL_TABLES
          -- 사용 예 : HR 계정의 테이블에 대한 정보 조회
          -- 관리자 계정
                 SELECT * FROM ALL_TABLES WHERE owner = 'HR';

    -- ο 테이블 구조
      -- 1) USER_TAB_COLUMNS(COLS) 딕셔너리
          -- 사용 예 : EMP 테이블에 존재하는 모든 컬럼 명, 데이터 타입, 데이터 길이 조회

          -- 모든 테이블의 모든 컬럼 출력
		SELECT * FROM USER_TAB_COLUMNS;
		SELECT * FROM COLS;

          -- emp 테이블의 모든 컬럼 출력
		SELECT * FROM USER_TAB_COLUMNS WHERE table_name = 'EMP';
		SELECT * FROM COLS WHERE table_name = 'EMP';

      -- 2) COL 뷰(VIEW)
           -- 사용 예 : EMP 테이블에 존재하는 모든 컬럼 명, 데이터 타입, 데이터 길이 조회
		   --emp 테이블의 모든 컬럼출력
				SELECT * FROM col WHERE tname = 'EMP';

      -- 3) DESCRIBE(DESC)
	  	--emp 테이블의 모든 컬럼 출력
		DESC emp;



---------------------------------------------------------------
> 사용한 쿼리
 SELECT * FROM dual;
 
 SELECT * FROM USER_TABLES;
 SELECT * FROM TABS;
 
 SELECT * FROM TAB;
 
 SELECT * FROM USER_TAB_COLUMNS;
 SELECT * FROM COLS;
 
 SELECT * FROM USER_TAB_COLUMNS WHERE table_name = 'EMP';
 SELECT * FROM COLS WHERE table_name = 'EMP';
 
 SELECT * FROM col WHERE tname = 'EMP';
 DESC emp; 