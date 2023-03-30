-- ■ SQL 함수

 -- ※ 단일행 숫자 함수
    -- ο 숫자 함수 종류
       -- ABS(n) : 절대값
			SELECT ABS(20)  FROM emp;	-- emp 60개이므로 60개 출력
			
			SELECT ABS(-20), ABS(20) FROM dual;

       -- SIGN(n) : 양수 1, 0은 0, 음수 -1
			SELECT SIGN(-20), SIGN(20) FROM dual;

       -- MOD(n2, n1): 나머지
	       -- 내부 연산 : n2 - n1* FLOOR(n2/n1)   
       -- REMAINDER(n2, n1) 
		   -- 내부연산 : n2 - n1 * ROUND(n2/n1)
	   
			SELECT MOD(11,4) FROM dual;	-- 3
			
			SELECT 13-5 *FLOOR(13/5) FROM dual;  --3
			SELECT MOD(13,5) FROM dual;	--3

			SELECT 13-5 *ROUND(13/5) FROM dual;  --  -2
			SELECT REMAINDER(13,5) FROM dual;	--  -2

       -- CEIL(n) : n 보다 크거나 같은 가장 적은 정수
		    SELECT CEIL(20), CEIL(20.6), CEIL(-20.6) FROM dual;		-- 20, 21, -20

       -- FLOOR(n) : n 보다 적거나 같은 가장 큰 정수
			SELECT FLOOR(20), FLOOR(20.6), FLOOR(-20.6) FROM dual;		-- 20, 20 , -21

       -- ROUND(n [, integer ]) : 반올림
			SELECT 10/3 FROM dual;		-- 3.33333333333333333333333333333333333333
 
			SELECT ROUND(15.673, 1) FROM dual;	--소수점 1자리 출력(소수점 둘째자리에서 반올림)
								-- 15.7
			SELECT ROUND(15.673, 2) FROM dual;	-- 15.67
													
			SELECT ROUND(15.673) FROM dual;	-- 소수점 첫째자리에서 반올림
								-- 16
								
			SELECT ROUND(15.673, -1) FROM dual;		-- 일의 자리에서 반올림
								--20
								
       -- TRUNC(n1 [, n2 ]) : 절삭
			SELECT TRUNC(15.693,1) FROM dual;		-- 소수점 이하 1자리 표시. 둘째자리에서 버림
								-- 15.6

			SELECT TRUNC(15.693,2) FROM dual;		-- 15.69
			SELECT TRUNC(15.693) FROM dual;		-- 15
			SELECT TRUNC(15.693,0) FROM dual;		-- 15
			SELECT TRUNC(15.693,-1) FROM dual;	-- 10, 일의 자리 절삭
			
			SELECT name, sal, TRUNC(sal/10000) 만원권 FROM emp;
			
			-- emp : name, sal, 5만원권, 1만원권, 나머지 금액
			SELECT name, sal, 
				TRUNC (sal/10000) "5만원권", TRUNC (MOD(sal,50000)/10000) "1만원권",
				MOD(sal,10000) 나머지
			FROM emp;

			
       -- SIN(n), COS(n), TAN(n) 등
			SELECT SIN(30/180 * 3.141592) FROM dual;
--?????????????????????????????????????????????????????????????????????????????

       -- EXP(n), POWER(n2, n1), SQRT(n), LOG(n2, n1), LN(n) 등
		--    지수     거듭제곱    제곱근      로그         자연로그 



------------------------------------------------------------------------	
 -- ※ 단일행 문자 함수
    -- ο 문자 함수 종류
       -- LOWER(char) : 영문자를 모두 소문자로   => 기억
			SELECT LOWER('KOREA SEOUL') FROM dual;
			
			SELECT * FROM col WHERE tname = 'emp';		-- 테이블명이 대문자로 저장되어 아무것도 출력되지 않는다.
			
			SELECT * FROM col WHERE LOWER(tname)= 'emp';	

			SELECT * FROM col WHERE tname= UPPER('emp');	


       -- UPPER(char) : 영문자를 모두 대문자로
			SELECT UPPER('korea seoul') FROM dual;


       -- INITCAP(char) : 각 단어의 첫글자를 대문자로
			SELECT INITCAP('korea seoul') FROM dual;


       -- CHR(n [ USING NCHAR_CS ]) : ASCII 값에 해당하는 문자
			SELECT CHR(65) || CHR(66) FROM dual;		-- AB


       -- ASCII(char) : 첫글자의 ASCII 코드값
			SELECT ASCII('ABC') FROM dual;	--65


       -- ASCIISTR(char)
			-- 문자열의 ASCII 버전 반환. 즉, 영숫자는 그대로 출력하고, non ASCII 문자는 유니코드 출력
			SELECT ASCIISTR('ABC123'), ASCIISTR('대한') FROM dual;


       -- SUBSTR(char, position [, substring_length ]) : 인덱스는 1부터
			SELECT SUBSTR('seoul korea',7,3) FROM dual;	-- kor, 7번째에서부터 3개

			SELECT SUBSTR('seoul korea',-5,3) FROM dual;	-- kor, 뒤에서부터 5번째에서 3개 
			
			SELECT SUBSTR('seoul korea',7) FROM dual;	-- korea, 7번째에서부터 마지막까지
		
		-- 2000년대 사람 출력(rrn이용) : emp 테이블 -  empNo, name, rrn, city
			SELECT empNo, name, rrn, city
			FROM emp
			WHERE SUBSTR(rrn,8,1) IN (3,4,7,8);

		-- 생년월일이 78~82년생만 출력(rrn이용) : emp 테이블 -  empNo, name, rrn, city
			SELECT empNo, name, rrn, city
			FROM emp
			WHERE SUBSTR(rrn,1,2) >=78 AND SUBSTR(rrn,1,2) <=82;
		
		-- city가 서울이면서 김씨만 출력 : emp 테이블 -  empNo, name,  city
			SELECT empNo, name, city
			FROM emp
			WHERE city = '서울' AND SUBSTR(name,1,1)='김';
		
		-- 생년월일이 80~89년생만 rrn 오름차순 출력(rrn이용) : emp 테이블 -  empNo, name, rrn, city
			SELECT empNo, name, rrn, city
			FROM emp
			WHERE SUBSTR(rrn,1,1)= '8'	-- => 자동 형변환이 일어나서 '8'을 8로 써도 무방 
			ORDER BY rrn;
	
		-- 김, 이, 최 씨만 출력 : emp 테이블 -  empNo, name,  city
			SELECT empNo, name, city
			FROM emp
			WHERE SUBSTR(name,1,1) IN ('김','이','최');
		
		-- 홀수달에 태어난 사람만 sal 내림차순 출력(rrn이용) : emp 테이블 -  empNo, name, rrn, city
			SELECT empNo, name, rrn, city
			FROM emp
			WHERE MOD(SUBSTR(rrn,3,2),2)=1
			ORDER BY sal DESC;


       -- INSTR(string , substring [, position [, occurrence ] ]) : 문자를 검색하여 위치를 반환. 없으면 0
			SELECT INSTR('korea seoul', 'e') FROM dual;	--4
			SELECT INSTR('korea seoul', 'abc') FROM dual; --0
			SELECT INSTR('korea seoul', 'e',7) FROM dual;		--8(7번째부터 검색)
			SELECT INSTR('korea seoul', 'e',1,2) FROM dual;		--8(1번째부터 검색하여 2번째 e의 위치)
													
			-- 김씨
				SELECT empNo, name, city
				FROM emp
				WHERE INSTR(name,'김')=1;
			
			-- 성씨를 포함하여 이름에 '이'가 있는 사람
				SELECT empNo, name, city
				FROM emp
				WHERE INSTR(name,'이')>0;	-- > 0이면 문자가 없다는 말				
			
			-- 전화번호 분리(02-333-3333, 010-1111-2222 ....) : 자바에서 분리하는게 유리 ( split )
				SELECT name, tel,
					SUBSTR(tel,1,INSTR(tel, '-')-1) 서비스번호
				FROM emp;
			
       -- LENGTH(char)
			SELECT LENGTH('대한민국') FROM dual;	-- 문자수. 4
			SELECT LENGTHB('대한민국') FROM dual;	-- 바이트수. 12    > 한글은 한글자에 3바이트
			


       -- REPLACE(char, search_string [, replacement_string])
			SELECT REPLACE('seoul korea', 'seoul', 'busan') FROM dual;	-- busan korea
		
			SELECT REPLACE('1234565785','5') FROM dual;	-- 1234678. 모든 5제거

			SELECT name, REPLACE(tel,'-') FROM emp;		-- 전화번호 -제거
		
			SELECT name, dept FROM emp;
			
			SELECT name, REPLACE(dept,'부','팀') FROM emp;
						-- 모든 부를 팀으로 변경
						
			SELECT name, SUBSTR(dept,1,2) || '팀' dept FROM emp;
						-- 부서명이 네글자 이상이면 이상한 결과
						
			SELECT name, SUBSTR(dept,1,LENGTH(dept)-1) || '팀' dept FROM emp;
			
       -- CONCAT(char1, char2)
			SELECT CONCAT('서울','한국') FROM dual;
			SELECT '서울' || '한국' FROM dual;
			
			
       -- LPAD(expr1, n [, expr2])
       -- RPAD(expr1, n [, expr2])
			-- 남은 여백을 expr2로 채움
		
			SELECT LPAD('korea', 12, '*') FROM dual;		-- *******korea
			SELECT RPAD('korea', 12, '*') FROM dual;		-- korea*******
			
			SELECT LPAD('korea', 3, '*') FROM dual;			-- kor
			SELECT LPAD('korea', 0, '*') FROM dual;			-- null

			SELECT LPAD('대한', 6, '*') FROM dual;				--**대한
					-- 한글은 한글자를 2칸으로 처리


			-- name, rrn(성별다음부터는 *로)
			SELECT name, rrn FROM emp;
			
			SELECT name, SUBSTR(rrn,1,8)||'******' rrn FROM emp;
			
			SELECT name, RPAD(SUBSTR(rrn,1,8),14,'*') rrn FROM emp;
			
			-- name, tel(뒤 3자리는 *로. 단, 12,13자리일 수 있다.)
			SELECT name, RPAD(SUBSTR(tel,1,LENGTH(tel)-3), LENGTH(tel), '*') tel
			FROM emp;
            
			-- name, sal, 그래프 : 그래프는 sal(기본급) 100000원당 * 하나 출력
			SELECT name,sal,
				LPAD('*', TRUNC(sal/100000),'*') 그래프
			FROM emp;
            --???????????????????????????????????????????????????????????????
			
			
			-- last_name을 총 9자리로 출력하며, 오른쪽 빈자리는 해당 자릿수에 해당하는 숫자 출력
			-- 출력 예
				-- last_name change_name
				-- kim            kim456789
				-- -> 힌트 : SUBSTR,RPAD
				
				WITH tb AS(
					SELECT 'kim' last_name FROM dual
						UNION ALL
					SELECT 'seoul' last_name FROM dual
						UNION ALL
					SELECT 'haha' last_name FROM dual
				)
				SELECT last_name, RPAD(last_name, 9, SUBSTR('123456789',LENGTH(last_name)+1)) change_name
				FROM tb;


       -- LTRIM(char [,set])
       -- RTRIM(char [,set])
       -- TRIM([[LEADING | TRAILING | BOTH] trim_character FROM] trim_score)
		
			SELECT ':'  || LTRIM(' 우리 나라 ') ||':' FROM dual;
			SELECT ':'  || RTRIM(' 우리 나라 ') ||':' FROM dual;
			SELECT ':'  || TRIM(' 우리 나라 ') ||':' FROM dual;

			SELECT ':' || REPLACE(' 우리 나라  ',' ') ||':' FROM dual;
			
			SELECT LTRIM('AABBCBDEF','BA') FROM dual;	-- CBDEF
						-- 시작하는 위치에 B 또는 A가 있으면 제거
			SELECT RTRIM('영업부','부') FROM dual;	-- 영업
						-- 마지막 위치의 부 제거
			SELECT TRIM('A' FROM 'AABBCCAA') FROM dual;	-- BBCC
						-- 앞 또는 뒤 A제거. 단, 제거 문자는 하나만 가능
			
			SELECT name, RTRIM(dept, '부') || '팀' dept FROM emp;


       -- TRANSLATE(expr, from_string, to_string) : 문자 변경
			SELECT TRANSLATE('abcabccc', 'c', 'n') FROM dual;	-- abnabnnn
										-- c 를 n으로 대체
										
			SELECT REPLACE('abcabccc', 'c') FROM dual;	-- abab : c 제거
			
			SELECT TRANSLATE('abcabcccx', 'abc', 'ab') FROM dual;	-- ababx
							-- c제거. ababx
							-- a는 a, b는 b, c는 제거
	
			SELECT TRANSLATE('2KRW139', '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', 
			'0123456789XXXXXXXXXXXXXXXXXXXXXXXXXX') FROM dual; -- 2XXX229

			SELECT TRANSLATE('2KRW139', '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', 
			'0123456789') 
			FROM dual; -- 2139   --> 알파벳은 모두 제거
			
    ------------------------------------------------------------------------	
    ------------------------------------------------------------------------	
 -- ※ 단일행 날짜 함수
    -- ο  날짜형 데이터 연산
			-- 날짜 + 숫자 : 숫자만큼 날 수 (일수)를 더함
			-- 날짜 - 숫자 : 숫자만큼 날 수 (일수)를 뺌
			-- 날짜 + 숫자/24 : 숫자만큼 시간을 더함
			-- 날짜1 - 날짜2 : 날짜1에서 날짜2를 빼면 두 날짜 사이의 일수가 나온다.
			
			SELECT SYSDATE FROM dual; -- 시스템 날짜 및 시간(디벨로퍼 : 23/02/28 => RR/MM/DD)
			
			SELECT SYSDATE - 1 FROM dual;	-- 오늘날짜 및 시간 - 1일
			SELECT SYSDATE - 1/24 FROM dual;	-- 오늘날짜 및 시간 - 1시간
			SELECT SYSDATE - 1/24/60 FROM dual;	-- 오늘날짜 및 시간 - 1분
			
			SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS' ) FROM dual;
						-- 날짜를 문자로 변환.

			SELECT TO_DATE('2000-10-10','YYYY-MM-DD' ) FROM dual;
						-- 문자를 날짜로 변환.
						
			-- 30분 후 
			SELECT TO_CHAR(SYSDATE+30/24/60,'YYYY-MM-DD HH24:MI:SS' ) FROM dual;
						
			-- 살아온 날 수 
			SELECT TRUNC(SYSDATE-TO_DATE('1999/07/12','YYYY/MM/DD'))FROM dual;
		
			-- 몇일 후
			SELECT TO_DATE('2018/10/13','YYYY/MM/DD')+100 FROM dual;
			
			-- emp 테이블에서 입사한지 100일이 되지 않는 사원 출력(name, hireDate, 근무일수)
			SELECT name, hireDate, TRUNC(SYSDATE - hireDate) 근무일수
			FROM emp
			WHERE SYSDATE - hireDate < 100;
			
			
	
    -- ο  INTERVAL Literals(간격 리터럴)을 이용한 날짜 가감
            -- 1년후 오늘
                SELECT SYSDATE  + (INTERVAL '1' YEAR) FROM dual;
        
            -- 1년전 오늘
                 SELECT SYSDATE  - (INTERVAL '1' YEAR) FROM dual;           
            
            SELECT SYSDATE + (INTERVAL '1' MONTH) FROM dual;
            SELECT SYSDATE + (INTERVAL '1' DAY) FROM dual;
            SELECT SYSDATE + (INTERVAL '1' HOUR) FROM dual;
            SELECT SYSDATE + (INTERVAL '1' MINUTE) FROM dual;
            SELECT SYSDATE + (INTERVAL '1' SECOND) FROM dual;
            SELECT SYSDATE + (INTERVAL '02:10' HOUR TO MINUTE) FROM dual;
            
            SELECT TO_CHAR(SYSDATE + (INTERVAL '02:10' HOUR TO MINUTE), 'YYYY-MM-DD HH24:MI:SS')FROM dual;

            SELECT TO_DATE('2023-03-31', 'YYYY-MM-DD') - (INTERVAL '1' MONTH) FROM dual;
                -- 에러. 2월 31일 없음
                
            SELECT TO_DATE('2023-03-31', 'YYYY-MM-DD') + (INTERVAL '1' DAY) FROM dual;
                -- 23/04/01
            ------------------------------------------------------
            -- emp 에서 근속년수가 1년 미만인 사람(name, hireDate)
                SELECT name, hireDate
                FROM emp
                WHERE hireDate + (INTERVAL '1' YEAR) > SYSDATE;
            
            -- 내년은 1월 1일
                SELECT TRUNC(SYSDATE + (INTERVAL '1' YEAR),'YYYY') add_year
                FROM dual;  -- 24/01/01
                
                SELECT TO_CHAR(SYSDATE + (INTERVAL '1' YEAR),'YYYY')add_year
                FROM dual;  -- 2024
            
    -- ο  날짜 함수 종류
       -- SYSDATE : 컴퓨터 시스템 날짜(YYYY-MM-DD HH24:MI:SS)
       -- CURRENT_DATE : 컴퓨터 시스템 날짜
       -- SYSTIMESTAMP : 밀리초까지 반환
       
        SELECT SYSDATE, CURRENT_DATE FROM dual;  -- YYYY-MM-DD HH24:MI:SS
        SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual;
        
        SELECT SYSTIMESTAMP FROM dual;      -- YYYY-MM-DD HH24:MI:SS.FF3;  --> 그지같이 출력. FF뒤 숫자 소수점 자리 개수
        SELECT TO_CHAR(SYSTIMESTAMP,'YYYY-MM-DD HH24:MI:SS.FF3') FROM dual;

       -- EXTRACT( { YEAR | MONTH | DAY | HOUR | MINUTE | SECOND | TIMEZONE_HOUR | TIMEZONE_MINUTE | TIMEZONE_REGION | TIMEZONE_ABBR } FROM { expr } )
        -- 지정된 날짜 또는 시간 추출

        SELECT name, hireDate, EXTRACT(YEAR FROM hireDate) 입사년도
        FROM emp;
        
        SELECT name, hireDate
        FROM emp
        WHERE EXTRACT(YEAR FROM hireDate) >=2010;
        
       -- MONTHS_BETWEEN(date1, date2) :  날짜사이의 월수 반환     
    
            --  문자열을 날짜로 반환
                SELECT TO_DATE('2020-10-10','YYYY-MM-DD') FROM dual;   --> 아래 말고 이것 사용해야함.
                SELECT TO_DATE('2020-10-10') FROM dual; -- 환경설정에 따라 에러가 나올 수 있음
                
            -- 예
                SELECT MONTHS_BETWEEN(TO_DATE('2021-05-20', 'YYYY-MM-DD'),
                        TO_DATE('2021-04-10','YYYY-MM-DD')) 차이
                FROM dual;     -- 1.32258064516129032258064516129032258065
            
                SELECT MONTHS_BETWEEN(TO_DATE('2021-05-20', 'YYYY-MM-DD'),
                        TO_DATE('2021-04-20','YYYY-MM-DD')) 차이
                FROM dual;      -- 1
                
                SELECT MONTHS_BETWEEN(TO_DATE('2021-05-19', 'YYYY-MM-DD'),
                        TO_DATE('2021-04-20','YYYY-MM-DD')) 차이
                FROM dual;      -- 0.9677419354838709677419354838709677419355

            -- emp : name, hireDate, 근속년수 
                SELECT name, hireDate,  TRUNC(MONTHS_BETWEEN(SYSDATE,hireDate)/12) 근속년수
                FROM emp;
    
            -- 나이
                SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE('1999-07-12','YYYY-MM-DD'))/12) 나이
                FROM dual;
                
            -- emp : empNo, name, rrn, birth, age, gender 
                SELECT empNo, name, rrn, TO_CHAR(TO_DATE(SUBSTR(rrn,1,6),'RRMMDD'),'YYYY-MM-DD') birth
                FROM emp;   -- RR은 문제를 발생할 수 있다. ex) 49년생은 2049로 처리
                
                SELECT empNo,name,
                    CASE
                        WHEN SUBSTR(rrn,8,1) IN(1,2,5,6) THEN TO_DATE('19'||SUBSTR(rrn,1,6),'YYYYMMDD')
                        WHEN SUBSTR(rrn,8,1) IN(3,4,7,8) THEN TO_DATE('20'||SUBSTR(rrn,1,6),'YYYYMMDD')
                        ELSE TO_DATE('18'||SUBSTR(rrn,1,6),'YYYYMMDD')
                    END AS birth
                FROM emp;
                
                
               WITH tb AS(
                    SELECT empNo,name,rrn,
                        CASE
                            WHEN SUBSTR(rrn,8,1) IN(1,2,5,6) THEN TO_DATE('19'||SUBSTR(rrn,1,6),'YYYYMMDD')
                            WHEN SUBSTR(rrn,8,1) IN(3,4,7,8) THEN TO_DATE('20'||SUBSTR(rrn,1,6),'YYYYMMDD')
                            ELSE TO_DATE('18'||SUBSTR(rrn,1,6),'YYYYMMDD')
                        END birth  
                    FROM emp 
               ) 
               SELECT empNo, name, rrn, TO_CHAR(birth,'YYYY-MM-DD') birth,
                        TRUNC(MONTHS_BETWEEN(SYSDATE,birth)/12) age,
                        DECODE(MOD(SUBSTR(rrn,8,1),2),0,'여자','남자') gender
               FROM tb;
               
               
               -- emp 테이블에서 나이 내림차순 정렬 : name, rrn, birth
               WITH tb AS(
                    SELECT empNo,name,rrn,
                        CASE
                            WHEN SUBSTR(rrn,8,1) IN(1,2,5,6) THEN TO_DATE('19'||SUBSTR(rrn,1,6),'YYYYMMDD')
                            WHEN SUBSTR(rrn,8,1) IN(3,4,7,8) THEN TO_DATE('20'||SUBSTR(rrn,1,6),'YYYYMMDD')
                            ELSE TO_DATE('18'||SUBSTR(rrn,1,6),'YYYYMMDD')
                        END birth  
                    FROM emp 
               )  
               SELECT empNo, name, rrn, TO_CHAR(birth,'YYYY-MM-DD') birth
                FROM tb
                ORDER BY birth;
               
            
       -- ADD_MONTHS(date, integer) : d을 더함
            -- 2023-03-30 + 6개월 =>  2023년 9월 30
            -- 2023-03-31 + 6개월 =>  2023년 9월 30
            
            SELECT ADD_MONTHS(SYSDATE,1) 다음달 FROM dual;
            SELECT ADD_MONTHS(SYSDATE,-1) 이전달 FROM dual;
            SELECT ADD_MONTHS(TO_DATE('20230330','YYYYMMDD'),6),    -- 앞뒤 형식 맞춰서 YYYY-MM-DD / YYYYMMDD
                    ADD_MONTHS(TO_DATE('20230331','YYYYMMDD'),6)
            FROM dual;
            
            -- 최근 6개월 이내에 입사한 사람(name, hireDate)
            SELECT name, hireDate
            FROM emp
            WHERE ADD_MONTHS(hireDate,6) > SYSDATE;


       -- LAST_DAY(date) : 월의 마지막 날짜
            SELECT SYSDATE, LAST_DAY(SYSDATE) FROM dual;
            
            SELECT LAST_DAY(SYSDATE)- SYSDATE FROM duaL;    -- 마지막 날짜까지 남은 일수


       -- ROUND(date [, fmt ]) : 지정된 단위로 날짜를 반올림
            -- 년도 : 7월 1일부터 반올림
                SELECT ROUND(TO_DATE('2023-07-10','YYYY-MM-DD'),'YEAR') FROM dual;
                            -- 24/01/01
                SELECT ROUND(TO_DATE('2023-06-10','YYYY-MM-DD'),'YEAR') FROM dual;
                            -- 23/01/01
          
             -- 월 : 16일 기준
                SELECT ROUND(TO_DATE('2023-07-20','YYYY-MM-DD'),'MONTH') FROM dual;
                            -- 23/08/01
                SELECT ROUND(TO_DATE('2023-07-10','YYYY-MM-DD'),'MONTH') FROM dual;
                            -- 23/07/01
                            
                            
       -- TRUNC(date [, fmt ]) : 반내림 
                 SELECT TRUNC(TO_DATE('2023-07-10','YYYY-MM-DD'),'YEAR') FROM dual;
                             -- 23/01/01
                 SELECT TRUNC(TO_DATE('2023-07-20','YYYY-MM-DD'),'MONTH') FROM dual;
                             -- 23/07/01
                
                SELECT TRUNC(SYSDATE,'D') FROM dual;
                             -- 23/02/26.   D : 주를 기준으로 내림.  그 주의 일요일
                
                SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')FROM dual;             
                SELECT TO_CHAR(TRUNC(SYSDATE), 'YYYY-MM-DD HH24:MI:SS')FROM dual;
                        -- 시분초가 0으로
                        
                -- 올해 1월 1일 부터 오늘까지 몇일이 지났나요?
                SELECT TRUNC(SYSDATE - TRUNC(SYSDATE,'YEAR'))
                FROM dual;
                
                -- 홍길동의 생일은 1995-10-15일 입니다. 생일까지 남은 일 수는?
                SELECT TRUNC(TO_DATE(EXTRACT(YEAR FROM SYSDATE) || SUBSTR('1995-10-15',5),
                            'YYYY-MM-DD') - TRUNC(SYSDATE)) 일수
                FROM dual;
                
                -- emp : name, rrn, birth, 생일까지 남은 일 수 ( 단, 생일이 지난 경우 내년생일까지 남은 일 수 )
                       WITH tb AS(
                SELECT empNo,name,rrn,
                    CASE--생일을 구하는 조건문
                         WHEN SUBSTR(rrn,8,1)IN(1,2,5,6) THEN TO_DATE('19'||SUBSTR(rrn,1,6),'YYYYMMDD')--주민번호가 1,2,5,6 이면 1900년대
                         WHEN SUBSTR(rrn,8,1)IN(3,4,7,8) THEN TO_DATE('20'||SUBSTR(rrn,1,6),'YYYYMMDD')--주민번호가 3,4,7,8 이면 1900년대
                         ELSE TO_DATE('18'||SUBSTR(rrn,1,6),'YYYYMMDD')--나머진 1800년대
                     END  birth,--조건문 끝 별명부여
                    TO_DATE(EXTRACT(YEAR FROM SYSDATE)|| SUBSTR(rrn,3,4),'YYYYMMDD') sdate--올해 내생일
            FROM emp
            )
            SELECT empNo,name,rrn,TO_CHAR(birth,'YYYY-MM-DD')birth,
                CASE
                    WHEN TRUNC(SYSDATE)<= sdate THEN sdate - TRUNC(SYSDATE)
                    ELSE(sdate + (INTERVAL '1' YEAR)) - TRUNC(SYSDATE)
                END AS 남은일수
            FROM tb;
                
       -- NEXT_DAY(date, char) : date 이후의 char 이름으로 지정된 첫번째 요일의 날짜 반환
            -- char은 숫자도 가능(1: 일요일, ... 7:토요일)
            
            -- 오늘을 기준으로 가장 가까운 토요일
                SELECT SYSDATE, NEXT_DAY(SYSDATE,'토요일') FROM dual;
                SELECT SYSDATE, NEXT_DAY(SYSDATE,7) FROM dual;

            -- 오늘을 기준으로 가장 가까운 수요일
                SELECT SYSDATE, NEXT_DAY(SYSDATE,4) FROM dual;                

            -- 오늘, 이번주 일요일, 이번주 토요일
                SELECT SYSDATE 날짜, 
                                NEXT_DAY(SYSDATE,1)-7 일요일,
                                NEXT_DAY(SYSDATE-1,7) 토요일
                FROM dual;
                

            -- 2023-03-04이 있는 날의 일요일,토요일
                SELECT TO_DATE('2023-03-04', 'YYYY-MM-DD') 날짜, 
                                NEXT_DAY(TO_DATE('2023-03-04','YYYY-MM-DD'),1)-7 일요일,
                                NEXT_DAY(TO_DATE('2023-03-04','YYYY-MM-DD')-1,7) 토요일
                FROM dual;
                
                
 -------------------------------------------------------------------------------------------               
 -- ※ 단일행 변환 함수
    -- ο 암시적(implicitly) 형 변환 : 자동으로 형변환
        VARCHAR2, CHAR -> NUMBER
        VARCHAR2, CHAR -> DATE
        NUMBER -> VARCHAR2
        DATE -> VARCHAR2
        
        SELECT 30 + '30' FROM dual; -- 자동으로 문자가 숫자로 변환
        SELECT 30 + '1,000' FROM dual;   -- 에러
        
        SELECT 30 || '30' FROM dual;    -- 3030, 자동으로 숫자가 문자로 변환
        SELECT 30 || '대' FROM dual;
        

    -- ο 통화기호, 날짜 등 출력 형식
      -- 통화기호, 날짜 등의 출력 형식 확인
         SELECT * FROM NLS_SESSION_PARAMETERS;


      -- 국가별 설정 변경 :  KOREAN으로 변경
         ALTER SESSION SET NLS_LANGUAGE ='KOREAN';

      -- 통화기호 변경 : ￦로 변경
         ALTER SESSION SET NLS_CURRENCY ='￦';

      -- 날짜 출력 형식 변경 : KOREAN 형식으로 변경
         ALTER SESSION SET NLS_DATE_LANGUAGE ='KOREAN';

      -- 날짜 출력 형식 변경(디폴트 : RR/MM/DD)
         ALTER SESSION SET NLS_DATE_FORMAT ='YYYY-MM-DD';
         SELECT SYSDATE FROM dual;

         ALTER SESSION SET NLS_DATE_FORMAT ='RR/MM/DD';
         SELECT SYSDATE FROM dual;


    -- ο 변환 함수
       -- TO_CHAR(n [, fmt [, 'nlsparam' ] ])  : 숫자를 서식에 따라 VARCHAR2로 변환        
        
            SELECT TO_CHAR(12345,'999,999') FROM dual;
            SELECT TO_CHAR(12345,'9,999') FROM dual;        -- > ######. 주의!!!!!!!!!!!!! 자리수 부족하면 #. 자리수 꼭 맞춰줘

            SELECT TO_CHAR(12345,'9,999,999') FROM dual;   -- 공백12,345
            SELECT TO_CHAR(12345,'0,999,999') FROM dual;   --  0,012,345

            SELECT TO_CHAR(12.67,'99') FROM dual;   -- 13
            SELECT TO_CHAR(12.37,'99') FROM dual;   -- 12
            
            SELECT TO_CHAR(12.667,'99.9') FROM dual;    -- 12.7
            
            SELECT TO_CHAR(0.03,'99.9') FROM dual;    --   .0
            SELECT TO_CHAR(0.03,'90.9') FROM dual;    --   0.0
            SELECT TO_CHAR(0.03,'90.0') FROM dual;    --   0.0            
            SELECT TO_CHAR(0.03,'99') FROM dual;    --   0
            
            SELECT TO_CHAR(-1234, '99999') FROM dual;   --   -1234
            SELECT TO_CHAR(1234,'99999MI') FROM dual;    --   1234  
            SELECT TO_CHAR(-1234,'99999MI') FROM dual;   --   1234-
            
            SELECT TO_CHAR(1234,'99999PR') FROM dual;    --   1234  
            SELECT TO_CHAR(-1234,'99999PR') FROM dual;    --   <1234>
            
            SELECT TO_CHAR(1234,'99999V9999') FROM dual;    --   12340000
            
            SELECT TO_CHAR(1234,'L9,999,999') FROM dual;    --   ￦1,234 
            
            SELECT TO_CHAR(1234,'9,999,999')||'원' FROM dual;    --   1,234원

            SELECT name, TO_CHAR(sal+bonus, 'L9,999,999') pay              
            FROM emp;
            
            
       -- TO_CHAR({ datetime | interval } [, fmt [, 'nlsparam' ] ]) : 날짜를 VARCHAR2로 변환
          SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY HH24:MM:SS') FROM dual;
         
          SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DY HH24:MM:SS') FROM dual;
          
          -- 2020년 10월 10일
            SELECT name, TO_CHAR(hireDate, 'YYYY"년" MM"월" DD"일" DAY') hireDate  -- ""로 가둬야함.
            FROM emp;
            
            SELECT name, hireDate
            FROM emp
            WHERE EXTRACT(YEAR FROM hireDate)=2023;     --> 숫자
            
            SELECT name, hireDate
            FROM emp
            WHERE TO_CHAR(hireDate,'YYYY')=2023;        --> 문자. 형변환이 되어서 가능
            
           -- 월을 한글, 영어
           SELECT TO_CHAR(SYSDATE, 'MON DD DAY') 디폴트,
           TO_CHAR(SYSDATE, 'MON DD DAY', 'NLS_DATE_LANGUAGE=american')en,
           TO_CHAR(SYSDATE, 'MON DD DAY','NLS_DATE_LANGUAGE=korean') ko
           FROM dual;
           
           SELECT TO_CHAR(SYSDATE, 'MON DD DAY') 디폴트,
           TO_CHAR(SYSDATE, 'month DD dy', 'NLS_DATE_LANGUAGE=american')en,  -- 대소문자 다르게 주면 다르게 나옴
           TO_CHAR(SYSDATE, 'Month DD Dy','NLS_DATE_LANGUAGE=american') en2
           FROM dual;
          
          -- w : 월기준주차(1일~7일 : 1주, 8일~14일 : 2주...)
            -- ww : 년기준주차(1월 1일~ 1월7일: 1주...)
            -- iw : 년기준주차(주는 월요일이 시작, 한해의 첫주에는 1월 4일이 포함, 한해의 마지막에 1월 1,2,3일이 포함될 수 있음)
            SELECT SYSDATE 오늘,
                TO_CHAR(SYSDATE,'D') 숫자요일,
                TO_CHAR(TRUNC(SYSDATE,'D'),'YYYY-MM-DD') 이번주일요일,
                TO_CHAR(SYSDATE,'w') 월기준주차,
                TO_CHAR(SYSDATE,'ww') 년기준주차1,
                TO_CHAR(SYSDATE,'iw') 년기준주차2
            FROM dual;
            
          -- emp 테이블
            -- 회사의 정년은 60세이다. 만약 나이가 60을 초과하면  "정년초과", 올해 정년이면 "올해정년", 
                -- 그렇지 않으면 남은 기간(예 : 20)을 출력한다.
            -- name, birth, age, 정년까지 남은 기간
           -- HINT: TO_CHAR, CASE
            WITH tb AS(
                    SELECT empNo,name,rrn,
                        CASE
                            WHEN SUBSTR(rrn,8,1) IN(1,2,5,6) THEN TO_DATE('19'||SUBSTR(rrn,1,6),'YYYYMMDD')
                            WHEN SUBSTR(rrn,8,1) IN(3,4,7,8) THEN TO_DATE('20'||SUBSTR(rrn,1,6),'YYYYMMDD')
                            ELSE TO_DATE('18'||SUBSTR(rrn,1,6),'YYYYMMDD')
                        END birth  
                    FROM emp 
               )  
               SELECT empNo, name, rrn, TO_CHAR(birth,'YYYY-MM-DD') birth,
                        TRUNC(MONTHS_BETWEEN(SYSDATE, birth)/12) age, 
                        CASE
                            WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, birth)/12) > 60 THEN '정년초과'
                            WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, birth)/12) = 60 THEN '올해정년'
                            ELSE TO_CHAR(60 - TRUNC(MONTHS_BETWEEN(SYSDATE, birth)/12)) --> 위에 문자로 리턴해줘서 이 부분도 문자로!
                        END 정년
                FROM tb;
            
            
          
       -- TO_NUMBER(expr [ DEFAULT return_value ON CONVERSION ERROR ] [, fmt [, 'nlsparam' ] ])
            SELECT '23' + 12, TO_NUMBER('23') + 12 FROM dual;
            
            SELECT '1,234' + 12 FROM dual;  -- 에러
            
            SELECT REPLACE ('1,234',',') +12 FROM dual;
            SELECT TO_NUMBER('1,234','99,999') + 12 FROM dual;
            
    
       -- TO_DATE(char [ DEFAULT return_value ON CONVERSION ERROR ] [, fmt [, 'nlsparam' ] ])
        -- 문자를 날짜로 반환
            
            -- YY : 시스템 날짜 기준
            SELECT TO_CHAR(TO_DATE('95-10-10','YY-MM-DD'),'YYYY-MM-DD') FROM dual;
                -- 2095-10-10   --> Y 1,2,3개써서는 안됨
             
             -- RR 
            SELECT TO_CHAR(TO_DATE('95-10-10','RR-MM-DD'),'YYYY-MM-DD') FROM dual;   
                -- 1995-10-10
            SELECT TO_CHAR(TO_DATE('48-10-10','RR-MM-DD'),'YYYY-MM-DD') FROM dual;
                -- 2048-10-10   --> 조심...... RR도 쉽지 않네....  그냥 YYYY 가 제일 안전
                
            SELECT TO_DATE('901010','RRMMDD') FROM dual;
            SELECT TO_DATE('991010') FROM dual; -- 시스템의 환경이 따라 에러가 발생할 수 있다.
            
            SELECT TO_DATE('1999-10-10','YYYY-MM-DD') FROM dual;
            SELECT TO_DATE('1999-10-10') FROM dual;
            
            -- '01-7월-08' (2008년 7월 1일)을 날짜 형식으로 변환
            SELECT TO_DATE('01-7월-08','DD-MON-RR') FROM dual;

                
       -- TO_TIMESTAMP(char [ DEFAULT return_value ON CONVERSION ERROR ] [, fmt [, 'nlsparam' ] ])
           -- 문자를 TIMESTAMP로 변환
            SELECT SYSDATE, SYSTIMESTAMP
            FROM dual;
            
            SELECT TO_CHAR(SYSTIMESTAMP,'YYYY-MM-DD HH24:MI:SS.FF3')
            FROM dual;          
            
            SELECT TO_TIMESTAMP('2023-03-02 15:26:10.600','YYYY-MM-DD HH24:MI:SS.FF3') 
            FROM dual;
            

 -- ※ NULL 관련 함수
    -- ο 개요
        -- 길이가 0인 문자도 null
        -- null이 포함된 연산의 경우 null이 된다.
           SELECT 10+NULL FROM dual;
        -- exrp IS [NOT] NULL : null인지 확인

    -- ο NULL 관련 함수
       -- NVL(expr1, expr2) : expr1이 null이 아니면 expr1를 반환하고 null이면 expr2를 반환
       -- 이건 알아야해!!!!!!!!!!!!!!!!!!!!!!
            
            SELECT name, NVL(tel,',전화없다. 사줘') FROM emp;
            SELECT name, NVL(tel,',전화없다. 사줘') tel
            FROM emp
            WHERE tel IS NULL;

       -- userEx 테이블
            CREATE TABLE userEx (
                 empNo  VARCHAR2(10) PRIMARY KEY,
                 name    VARCHAR2(30) NOT NULL,
                 sal        NUMBER(10)   NOT  NULL,
                 bonus   NUMBER(10)
            );
            INSERT INTO userEx(empNo, name, sal, bonus) VALUES ('1001', '오라클', 2200000, 300000);
            INSERT INTO userEx(empNo, name, sal, bonus) VALUES ('1002', '스프링', 2300000, 200000);
            INSERT INTO userEx(empNo, name, sal, bonus) VALUES ('1003', '이자바', 2300000, NULL);
            INSERT INTO userEx(empNo, name, sal, bonus) VALUES ('1004', '서블릿', 1900000, 200000);
            INSERT INTO userEx(empNo, name, sal, bonus) VALUES ('1005', '스파크', 1700000, NULL);
            COMMIT;

            SELECT * FROM tab;
            SELECT empNo, name, sal, bonus FROM userEx;
            
            -- userEx : empNo, name, sal, bonus, sal+bonus pay
             SELECT empNo, name, sal, bonus, sal+bonus pay FROM userEx;
            
             SELECT empNo, name, sal, bonus, sal+NVL(bonus,0) pay FROM userEx;
       
       
       -- NVL2(expr1, expr2, expr3)
            SELECT name, tel, NVL2(tel,'있다', '없다') FROM emp;
            SELECT name, tel, NVL2(tel,tel, '없다') FROM emp;
            
       -- NULLIF(expr1, expr2) : expr1과 expr2이 같으면 null
            SELECT NULLIF(1,1), NULLIF(1,2) FROM dual; -- null 1

       -- COALESCE(expr [, expr ]...) : null이 아닌 첫번째 값
            SELECT COALESCE(null,1,2) FROM dual;    -- 1 

