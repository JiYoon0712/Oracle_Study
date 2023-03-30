-- ■ 오라클 계정관리
 -- ※ 계정관리
    -- ◎ 개요


    -- ◎ 계정 생성 및 관리
         ---------------------------------------------------------
         -- 사용 예
         -- 계정 생성 형식
           CREATE USER 사용자명
               IDENTIFIED BY 패스워드
               [ DEFAULT TABLESPACE tablespace_name ]
               [ TEMPORARY TABLESPACE temp_tablespace_name ]
               [ QUOTA  { size_clause | UNLIMITED } ON tablespace_name ]
               ;

         -- 계정 수정 형식
           ALTER USER 사용자명
               IDENTIFIED BY 패스워드
               | DEFAULT TABLESPACE tablespace_name
               | TEMPORARY TABLESPACE temp_tablespace_name
               | QUOTA  { size_clause | UNLIMITED } ON tablespace_name
               | ACCOUNT { LOCK | UNLOCK };

         -- 계정 삭제 형식
           DROP USER 사용자명 [CASCADE];


         ---------------------------------------------------------
         -- 계정 조회  - 관리자 계정 : sys 또는 system
           SELECT * FROM all_users;
           SELECT username, default_tablespace, temporary_tablespace FROM dba_users;
           SELECT object_name, object_type FROM dba_object  WHERE OWNER='사용자명'; 


         ---------------------------------------------------------
         -- 


 -- ※ 권한(Privilege)과 롤(ROLE)
    -- ◎ 시스템 권한(System Privilege)
         ---------------------------------------------------------
         -- 사용 예
         -- 시스템 권한 부여 형식
            GRANT 시스템_권한
                TO { 사용자명 | PUBLIC }
                [WITH ADMIN OPTION];

         -- 시스템 권한 회수 형식
             REVOKE 시스템_권한 FROM { 사용자명 | PUBLIC  };

         -- 전체 시스템 권한 목록 확인 - 관리자 계정 : sys 또는 system
            SELECT * FROM system_privilege_map;

         -- 모든 유저에 부여된 모든 시스템 권한 조회  - 관리자 계정 : sys 또는 system
           SELECT * FROM dba_sys_privs;

         -- 사용자의 시스템 권한(privilege) 확인(일반 유저)
           SELECT * FROM user_sys_privs; 

         -- 접속한 SESSION 에게 할당된 권한 조회
           SELECT * FROM session_privs;


         ---------------------------------------------------------
         -- 



    -- ◎ 오브젝트 권한(Object Privilege)
         ---------------------------------------------------------
         -- 사용 예
         -- 가지고 있는 객체 권한 확인(객체 권한의 소유자, 객체 권한 부여자, 객체 권한 피부여자)
           SELECT * FROM user_tab_privs;

         -- 다른 사용자로 부터 받은 객체 권한 확인
           SELECT * FROM user_tab_privs_recd;

         -- 사용자가 부여한 모든 객체 권한
            SELECT * FROM user_tab_privs_made;


         ---------------------------------------------------------
         -- 




    -- ◎ 롤(ROLE)
         ---------------------------------------------------------
         -- 사용 예
         -- ROLE 확인  - 관리자 계정 : sys 또는 system
            SELECT * FROM dba_roles;

         -- 유저에 부여된 롤(역할) 확인
            SELECT * FROM user_role_privs;

         -- 롤안의 롤 확인
             SELECT * FROM role_role_privs WHERE role='롤_이름';

         -- 롤의 시스템 권한 확인
            SELECT * FROM role_sys_privs WHERE role='롤_이름';


         ---------------------------------------------------------
         -- 

