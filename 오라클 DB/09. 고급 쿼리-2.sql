-- ■ 고급 쿼리
 -- ※ 정규식(Regular Expression) - 주요 함수
    -- 1) REGEXP_LIKE(source_char, pattern [, match_parameter ] )
       -- : 패턴이 포함된 문자열 검색
       ---------------------------------------
       -- 
       SELECT * FROM reg;
       
       -- 이름이 한 또는 백으로 시작하는 레코드
       SELECT * FROM reg
       WHERE REGEXP_LIKE(name,'^[한백]');
       
       -- 이름이 강산으로 끝하는 레코드
       SELECT * FROM reg
       WHERE REGEXP_LIKE(name,'강산$');   
       
       -- 이메일이 com으로 끝나는 레코드
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'com$'); -- 대소문자 구분
       
       -- 이메일이 com으로 끝나는 레코드
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'com$','i'); -- 대소문자 구분 안함
       
       -- 이메일에 kim 이 포함된 레코드
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'kim');

       SELECT * FROM reg
       WHERE email LIKE('%kim%');

       -- 이메일이 "kim3" 다음에 하나 또는 0개의 3과 다음에 3을 포함하는 레코드 
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'kim3?3');    
       
       --  이메일이 "kim" 다음에 0~3 사이의 문자가 2번이상 반복하는 레코드
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'kim[0-3]{2}');       
        
       --  이메일이 "kim" 다음에 2~3 사이의 문자가 3~4번 반복하는 레코드
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'kim[2-3]{3,4}');        
       
       -- 부정
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'kim[^1]');  -- kim 다음에 1이 아닌
       
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'^[^k]'); -- k로 시작하지 않는
       
       -- 한글
       SELECT * FROM reg
       WHERE REGEXP_LIKE(name, '^[가-힣]{1,10}$');
       
       -- 숫자가 있는 이메일
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email, '[[:digit:]]');
       
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email, '[0-9]');
       
       -- 영문자
       SELECT * FROM reg
       WHERE REGEXP_LIKE(name, '[a-z|A-Z]');       
       
       
    -- 2) REGEXP_REPLACE(source_char, pattern [, replace_string [, position [, occurrence[, match_parameter ] ] ] ])
       -- : 패턴이 포함된 문자열을 다른 문자열로 치환
       ---------------------------------------
       --
       SELECT REGEXP_REPLACE('!1234^{}<>~12숫자,.특수문자_Test','[0-9]','')
       FROM dual;

       SELECT REGEXP_REPLACE('!1234^{}<>~12숫자,.특수문자_Test','[[:digit:]|[:punct:]]','')
       FROM dual;
            -- [:digit:] : 숫자, [:punct:] : 특수문자
        
        SELECT name, rrn FROM emp;
        SELECT name, REGEXP_REPLACE(rrn,'[0-9]','*',9) rrn FROM emp;
                -- 9번째 문자부터 [0-9]문자를 *로 치환
        



    -- 3) REGEXP_INSTR (source_char, pattern [, position [, occurrence [, return_option [, match_parameter ] ] ] ] )
       -- : 패턴이 포함된 문자열의 위치 반환
       ---------------------------------------
       --
       SELECT name, tel,REGEXP_INSTR(tel,'[-]') 위치 FROM emp;
       SELECT name, tel,REGEXP_INSTR(tel,'[\-]') 위치 FROM emp;

       SELECT name, tel
       FROM emp
       WHERE regexp_instr(name,'^[^이김]')=1;  -- 이씨 김씨 제외
        
        
        
    -- 4) REGEXP_SUBSTR(source_char, pattern [, position [, occurrence [, match_parameter ] ] ] )
       -- : 문자열에 존재하는 패턴문자열을 반환
       ---------------------------------------
       --


    -- 5) REGEXP_COUNT (source_char, pattern [, position [, match_param]])
       -- : 문자열에 존재하는 패턴문자열의 개수 반환
       ---------------------------------------
       --
       -- email 에서 a 개수
       SELECT email, REGEXP_COUNT(email,'a') FROM reg;

