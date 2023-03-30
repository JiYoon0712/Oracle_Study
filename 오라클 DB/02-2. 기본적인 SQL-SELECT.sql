-- ■ EMP 테이블 : 임플로이(EMPLOYEE, 사원) 정보를 가진 테이블
 -- ※ 컬럼 정보
     empNo : 사원번호
     name : 이름
     rrn : 주민번호
     hireDate : 입사일
     city : 출신도
     tel : 전화번호
     dept : 부서명
     pos : 직위
     sal : 급여
     bonus : 보너스


-- ■ SELECT 문을 이용한 조회
 -- ※ SELECT 문
   -- ο 테이블 또는 뷰의 전체 레코드(행) 출력
     -- 간단한 연산
           SELECT 10*5 FROM dual;
           SELECT 10*5, 10/5 FROM emp;

           SELECT '결과 : ' || 10*5 FROM dual;

     -- 특정 컬럼 만 출력(emp 테이블 : empNo, name, sal 컬럼)
           SELECT 컬럼명, 컬럼명 FROM 테이블명;

     -- 컬럼확인
           SELECT * FROM col WHERE tname = 'EMP';
           DESC emp;

     --  emp 테이블
          SELECT empNo, name, sal FROM emp;          
          
          SELCET sal, name FROM emp;		

          SELCET no, name FROM emp;	--  에러 : ORA-00904  
        -- ????????????????????????????????????????????????????
        
        
     -- 수식 사용
          SELECT empNo, name, sal+bonus From emp;
          SELECT name || '님', sal FROM emp;


     -- 모든 컬럼 출력(emp 테이블 : 모든 컬럼 출력)
          SELCET * FROM emp;


     -- 컬럼명을 변경하여 출력(emp 테이블 : empNo, name, sal 컬럼)
          SELECT empNo AS 사번, name AS 이름, sal AS 기본급 FROM emp;
          SELECT empNo 사번, name 이름, sal 기본급 FROM emp;
          SELECT empNo "사  번", name "이  름", sal "기본급" FROM emp;
	     -- 컬럼명의 별명을 부여할 때 AS는 생략 가능하다.
	     -- 컬럼명의 별명을 부여할 때 "(큰따옴표)를 사용할 수 있다.
	     -- 컬럼명의 별명을 부여할 때 '(작은따옴표)는 사용할 수 없다.
	     -- 컬럼명의 별명을 부여할때 공백, 특수문자 등을 포함하는 경우에는 "(큰따옴표)를 사용해야 한다.
        
          -- 일반적으로 수식을 사용한 컬럼은 별명을 부여한다. 별명을 부여해야 자바 등에서 쉽게 값을 넘겨 받을 수 있다.
	SELECT empNo, name, sal, bonus, sal+bonus FROM emp;
 	SELECT empNo, name, sal, bonus, sal+bonus pay FROM emp;

     -- 테이블 명에 별명 부여(emp 테이블 : ROWNUM과 모든 컬럼 출력)
          -- ROWNUM : 쿼리의 결과로 나오는 각각의 행에 대한 순서 값을 나타내는 의사 컬럼

 	SELECT ROWNUM, empNo, name, sal FROM emp;
 	
 	SELECT ROWNUM, * FROM emp;    -- 에러 : *와 다른 컬럼은 같이 사용할 수 없다.


 	SELECT ROWNUM, emp.* FROM emp e;		-- ????????????????????????????????????????
 	SELECT ROWNUM, e.* FROM emp e;
	        -- 테이블에 별명 부여
	        -- 테이블에 별명을 부여할 때는 AS를 사용할 수 없음


 -- ※ 조건식과 표현식	
   -- SELECT 컬럼명, 컬럼명 FROM 테이블명 WHERE 조건;

   -- ο 비교 연산자 : =, >, <, <=, >=, <>, !=, ^=
     -- emp 테이블 : city가 서울인 자료 중 name, city 컬럼 출력
SELECT name, city
FROM emp 
WHERE city = '서울'



     -- emp 테이블: city가 서울이 아닌 자료 중 name, city 컬럼 출력(<>, !=, ^=)
SELECT name, city
FROM emp 
WHERE city <> '서울';

SELECT name, city
FROM emp 
WHERE city !='서울';

SELECT name, city
FROM emp 
WHERE city ^='서울';

     -- emp 테이블 : sal+bonus 가 2500000원 이상인 자료 중 name, sal, bonus 컬럼 출력
SELECT name, sal, bonus
FROM emp 
WHERE sal+bonus >=2500000;

     -- emp 테이블 : sal+bonus 가 2500000원 이상인 자료 중 name, sal, bonus, sal+bonus 컬럼 출력
	     -- sal+bonus 결과는 pay라는 이름으로 출력
SELECT name, sal, bonus, sal+bonus pay
FROM emp 
WHERE pay >=2500000;	-- 에러 : ORA-00904
    -- 1) FROM 구문분석
    -- 2) WHERE 구문분석 -> emp 테이블에는 pay컬럼이 없으므로 에러
    -- 3) SELECT 구문분석

SELECT name, sal, bonus, sal+bonus pay
FROM emp 
WHERE sal+bonus >=2500000;




   -- ο 논리 연산자 : AND, OR, NOT
     -- emp 테이블 : city가 서울이고 sal가 2000000원 이상인 자료 중 empNo, name, city, sal 컬럼 출력
SELECT empNo, name, city, sal 
FROM emp 
WHERE city='서울' and sal >=2000000;

     -- emp 테이블 : city가 서울, 경기, 인천인 자료 중 empNo, name, city, sal 컬럼 출력
SELECT empNo, name, city, sal 
FROM emp 
WHERE city='서울' OR city='경기' OR city='인천';         

     -- emp 테이블 : sal가 2000000~3000000을 제외한 자료 중 empNo, name, sal 컬럼 출력
SELECT empNo, name, sal 
FROM emp          
WHERE (sal < 2000000) OR (sal >3000000);

SELECT empNo, name, sal 
FROM emp          
WHERE NOT(sal >=2000000 AND sal <=3000000);

 ---------------------------------------------------------------------------
     -- emp 테이블 : 성씨가 'ㄱ'씨인 empNo, name, sal 컬럼 출력
SELECT empNo, name, city, sal 
FROM emp 
WHERE name > '가' AND name<'나';

     -- emp 테이블 : dept가 '개발부' 이고 pos가 '과장'인 empNo, name, dept, pos, sal 컬럼
SELECT empNo, name, dept, pos, sal 
FROM emp 
WHERE dept='개발부' AND pos='과장'

     -- emp 테이블 : sal이 2000000~3000000 인 사람 중 city가 서울 또는 경기인 empNo, name, city, sal 컬럼
SELECT empNo, name, city, sal 
FROM emp 
WHERE sal >=2000000 AND sal <=3000000 AND (city='서울' or city='경기')
					-- 반드시 괄호 AND연산자가 우선순위라서!

     -- emp 테이블 : dept가 '개발부' 사람중 pos가 '대리' 또는 '과장'인 empNo, name, dept, pos, sal 컬럼
SELECT empNo, name, city, sal 
FROM emp 
WHERE dept='개발부' and (pos = '대리' OR  pos = '과장');



   -- ο 그룹 비교 연산자 : ANY(SOME), ALL
        -- ANY(SOME) : OR과 유사, ALL : AND 유사

     -- emp 테이블 : city가 '서울', '경기', '인천' 인 자료 중 empNo, name, city 컬럼 출력
SELECT empNo, name, city
FROM emp 
WHERE city = ANY('서울', '경기', '인천'); 

     -- emp 테이블 : sal가 2000000원 이상인 자료 중 empNo, name, sal 컬럼 출력
SELECT empNo, name, sal
FROM emp 
WHERE sal >= ANY(2000000, 25000000, 300000);  -- > 굳이?

SELECT empNo, name, sal
FROM emp 
WHERE sal >= 2000000; 

     -- emp 테이블 : sal가 3000000원 이상인 자료 중 empNo, name, sal 컬럼 출력
SELECT empNo, name, sal
FROM emp 
WHERE sal >= ALL(2000000,2500000,3000000);          

SELECT empNo, name, sal
FROM emp 
WHERE sal >= 3000000; 


   -- ο SQL 연산자
     -- 1) BETWEEN 조건식
         -- emp 테이블 : sal가 2000000~3000000 사이 인 자료 중 name, sal 컬럼 출력
SELECT name, sal
FROM emp
WHERE sal >=2000000 AND sal <=3000000;

SELECT name, sal
FROM emp
WHERE sal BETWEEN 2000000 AND 3000000;

         -- emp 테이블 : sal가 2000000~3000000을 제외한 자료 중 name, sal 컬럼 출력
SELECT name, sal
FROM emp
WHERE NOT sal BETWEEN 2000000 AND 3000000;	// > 부하가 진짜 심하다.

SELECT name, sal
FROM emp
WHERE sal < 2000000 OR sal > 3000000;

         -- emp 테이블 : hireDate가 2022년도인 자료중 name, hireDate 컬럼 출력
SELECT name, hireDate
FROM emp
WHERE hireDate BETWEEN '2022-01-01' AND '2022-12-31';

-- 이건 아직 배우지 않은 것.
SELECT name, hireDate
FROM emp
WHERE TO_CHAR(hireDate, 'YYYY') = 2022;


     -- 2) IN 조건식 : list에 있는 값 중 하나라도 일치하면 TRUE

         -- emp 테이블 : city가 '서울', '인천', '경기' 인  자료 중 name, city 컬럼 출력
SELECT empNo, name, city
FROM emp 
WHERE city = '서울' OR city = '인천' OR city = '경기';

SELECT name, city
FROM emp 
WHERE city IN('서울', '경기', '인천'); 

         -- emp 테이블 : city가 '서울', '인천', '경기' 를 제외한  자료 중 name, city 컬럼 출력
SELECT name, city
FROM emp 
WHERE city NOT IN('서울', '경기', '인천');  

         -- emp 테이블 : city와 pos가 '서울  이면서 '부장'이거나 '경기' 이면서 '과장' 인 자료 중 name, city, pos 컬럼 출력
SELECT name, city, pos
FROM emp 
WHERE (city ='서울' AND pos = '부장') OR (city ='경기' AND pos = '과장');

SELECT name, city, pos
FROM emp 
WHERE (city, pos) IN (('서울','부장'),('경기','과장'));


         -- emp 테이블 : city와 pos가 '서울' 이면서 '부장' 인 자료 중 name, city, pos 컬럼 출력(subquery)
SELECT name, city, pos
FROM emp
WHERE (city,pos) IN (('서울','부장'))


     -- 3) LIKE 조건식
             -- 주어진 문자열이 패턴과 일치하는지 여부 확인
             -- '%' : 여러문자 공통(0~N),  '_' : 한문자 공통
             -- 문자열 처리시 오라클 내부 알고리즘상 LIKE 보다는 INSTR()이 더 빠르게 처리


         -- emp 테이블 : name이 '김'씨인  자료 중 empNo, name 컬럼 출력
                SELECT empNo, name
                FROM emp
                WHERE name LIKE '김%';

         -- emp 테이블 : LIKE 예           
                SELECT empNo, name,tel
                FROM emp
                WHERE tel LIKE '%3%';	-- 3 이 존재하는 전화번호

                SELECT empNo, name,tel
                FROM emp
                WHERE tel LIKE '%3';		-- 3으로 끝나는 전화번호

                SELECT empNo, name, rrn
                FROM emp
                WHERE rrn LIKE '_0%';	-- 생년월일에서 년도가 10의 배수인 사람

                SELECT empNo, name, tel
                FROM emp
                WHERE tel LIKE '%3%' OR tel LIKE '%5%';	-- 3또는 5가 있는 전화번호


         -- 주민번호(rrn)을 이용하여 3월에 출생한 서울, 경기 사람(name, rrn, city)
                SELECT name, rrn, city
                FROM emp
                WHERE rrn LIKE'__03%' AND (city IN('서울','경기'));
            

         -- ESCAPE
               --  '%' 나 '_'가 포함된 데이터를 검색할 때 사용
              
              SELECT 컬럼명, 컬럼명
              FROM 테이블명
              WHERE 컬럼명 LIKE '%_%';	// 1글자는 반드시 있어야함.

              SELECT 컬럼명, 컬럼명
              FROM 테이블명
              WHERE 컬럼명 LIKE '%#_%' ESCAPE '#'  	-- _는 패턴이 아님.     -- WHERE 컬럼명 LIKE '%@_%' ESCAPE '@'도 같은 의미
	-- ESCAPE로 지정한 '#' 뒤에 오는 패턴문자를 일반 문자로 해석한다.				
	-- '%#_%'에서 _는 패턴이 아닌 검색할 문자
	-- ESCAPE로 사용할 문자는 1byte 아무거나 상관 없음
   
         -- WITH : 반복적으로 사용되는 쿼리를 블럭화 할 경우 사용
            WITH tb AS (
                SELECT '가가가' name, '우리_나라' content  FROM dual
                UNION ALL
                SELECT '나나나' name, '자바%스프링' content  FROM dual
                UNION ALL
                SELECT '다다다' name, '우리나라' content  FROM dual
                UNION ALL
                SELECT '라라라' name, '모바일' content  FROM dual
                UNION ALL
                SELECT '마마마' name, '안드로이드%모바일' content  FROM dual
            ) 
            SELECT * FROM  tb;

         --  content에 '바%'가 있는 레코드 검색
            WITH tb AS (
                SELECT '가가가' name, '우리_나라' content  FROM dual
                UNION ALL
                SELECT '나나나' name, '자바%스프링' content  FROM dual
                UNION ALL
                SELECT '다다다' name, '우리나라' content  FROM dual
                UNION ALL
                SELECT '라라라' name, '모바일' content  FROM dual
                UNION ALL
                SELECT '마마마' name, '안드로이드%모바일' content  FROM dual
            ) 
            SELECT * FROM  tb
            WHERE  content LIKE '%바#%%' ESCAPE '#' ;


            WITH tb AS (
                SELECT '가가가' name, '우리_나라' content  FROM dual
                UNION ALL
                SELECT '나나나' name, '자바%스프링' content  FROM dual
                UNION ALL
                SELECT '다다다' name, '우리나라' content  FROM dual
                UNION ALL
                SELECT '라라라' name, '모바일' content  FROM dual
                UNION ALL
                SELECT '마마마' name, '안드로이드%모바일' content  FROM dual
            ) 
            SELECT * FROM  tb
            WHERE  INSTR (content,'바%') >=1 ;	-- 오라클 인덱스는 1부터 시작



-- (2023-02-28)  --
   -- ο NULL
	   -- '' 는 null
       -- emp 테이블 : tel이 NULL 인 자료 중 name, tel 컬럼 출력
		   SELECT name, tel FROM emp WHERE tel = NULL; (X)
		   
		   SELECT name, tel FROM emp WHERE tel IS NULL;
	
       -- emp 테이블 : tel이 NULL 아닌 자료 중 name, tel 컬럼 출력
		   SELECT name, tel FROM emp WHERE tel IS NOT NULL;
		
	   -- 주의사항
			SELECT 10+NULL FROM dual ;
			  -- null

   -- ο CASE 표현식(Expressions) 과 DECODE 함수
      -- 1) CASE 표현식
	        -- 조건에 따라 다른 결과를 반환.
			-- DECODE 보다 성능이 우수  

      -- 2) 형식1 : 간단한 CASE 표현식
          SELECT name, rrn, SUBSTR(rrn, 8, 1) FROM emp;
		  SELECT MOD(14,8) FROM dual; -- 나머지

		  SELECT name, rrn, 
		    CASE SUBSTR(rrn, 8, 1)   -- > 자바의 switch 문과 유사
			   WHEN '1' THEN '남자'		 -- WHEN 1은 오류(타입이 일치해야 함)  > 숫자로 표현 못함
			   WHEN '2' THEN '여자'		
			   WHEN '3' THEN '남자'
			   WHEN '4' THEN '여자'
			END AS 성별
		  FROM emp;
		
		SELECT name, rrn,		
		CASE MOD(SUBSTR(rrn, 8, 1),2)   
			   WHEN 0 THEN '여자'	
			   WHEN 1 THEN '남자'		
			END AS 성별
		  FROM emp;
		  
      -- 3) 형식2 : 조건 CASE 표현식
          -- 사번(empNo), name, sal+bonus, tax
		     -- 세금 : 총 급여가 3000000 이상이면 3%, 총 급여가 2500000 이상이면 2%, 나머지 0
			
			SELECT empNo, name, sal+bonus 전체급여, 
				CASE
					WHEN  sal+bonus >= 3000000 THEN (sal+bonus) *0.03
					WHEN  sal+bonus >= 2500000 THEN (sal+bonus) *0.02
					ELSE 0
				END "세금"
			FROM emp;
			 
		  
     -- 4) DECODE 함수
			-- DECODE(a, 'b', 1)
				- a 항목 값이 'b' 이면 1을 반환하고 'b'가 아니면 NULL을 반환
			-- DECODE(a, 'b', 1, 2)
				- a 항목 값이 'b' 이면 1을 반환하고 'b'가 아니면 2을 반환
			-- DECODE(a, 'b', 1, 'c', 2)
				- a 항목 값이 'b' 이면 1을 반환하고 'c'이면 2를 반환하며 'b'또는 'c'가 아니면 NULL을 반환
			-- DECODE(a, 'b', 1, 'c', 2, 3)
				- a 항목 값이 'b' 이면 1을 반환하고 'c'이면 2를 반환하며 'b'또는 'c'가 아니면 3을 반환
	
			SELECT name, rrn, DECODE(SUBSTR(rrn,8,1),1,'남자') 성별 FROM emp;
					-- 성별이 1이면 남자, 그렇지 않으면 NULL
			
			SELECT name, rrn, DECODE(SUBSTR(rrn,8,1),1,'남자','여자') 성별 FROM emp;
					-- 성별이 1이면 '남자', 그렇지 않으면 '여자' , 성별 3도 '여자'
					
			SELECT name, rrn, DECODE(SUBSTR(rrn,8,1),1,'남자',2,'여자',3,'남자',4,'여자') 성별 FROM emp;
					-- 성별 5,6,7,8은 null		
						
			SELECT name, rrn, DECODE(MOD(SUBSTR(rrn,8,1),2),1,'남자','여자') 성별 FROM emp;		
					
 -- ※ SELECT 구문의 ALL 과 DISTINCT 옵션
   -- ο ALL 옵션 : 선택된 모든 행 반환, 생략 가능
		SELECT ALL dept FROM emp;
		SELECT dept FROM emp;

   -- ο DISTINCT | UNIQUE 옵션 : 선택된 행 중에서 중복적인 행은 하나만 반환
		SELECT DISTINCT dept FROM emp;
		SELECT UNIQUE dept FROM emp;

		SELECT DISTINCT dept,pos FROM emp;

 -- ※ SELECT 구문의 ORDER BY 절
	 -- ASC : 오름차순(생략 가능), DESC : 내림차순

     -- 정렬 예
		SELECT name, dept, sal FROM emp;
		
		SELECT name, dept, sal FROM emp ORDER BY sal; -- 오름차순
		SELECT name, dept, sal FROM emp ORDER BY sal ASC; -- sal 오름차순
		SELECT name, dept, sal FROM emp ORDER BY sal DESC;  -- sal 내림차순
		
     -- dept 오름차순 정렬하고 dept가 같으면 sal 내림차순 출력 : name, rrn, dept, sal
	 		SELECT name, rrn, dept, sal FROM emp ORDER BY dept,sal DESC;
	 
	 -- dept 내림차순 정렬하고 dept가 같으면 sal 내림차순 출력 : name, rrn, dept, sal
	 		SELECT name, rrn, dept, sal FROM emp ORDER BY dept DESC,sal DESC;
	
	 -- dept 내림차순 정렬하고 dept가 같으면 sal 오름차순 출력 : name, rrn, dept, sal
	 		SELECT name, rrn, dept, sal FROM emp ORDER BY dept DESC,sal;		
			
	 -- sal+bonus 오름차순 출력 : name, rrn, dept, sal, bonus, sal+bonus pay
			SELECT name, rrn, dept, sal, bonus, sal+bonus pay
			FROM emp
			ORDER BY sal+bonus ASC;
			
			SELECT name, rrn, dept, sal, bonus, sal+bonus pay
			FROM emp
			ORDER BY pay DESC;
				-- FROM -> WHERE -> SELECT -> ORDER BY 구문 순으로 실행하므로 별명으로 정렬 가능
				-- > ORDER BY는 뒤니까 ! WHERE은 별명 사용 안됨.
		
			SELECT name, rrn, dept, sal, bonus, sal+bonus pay
			FROM emp
			ORDER BY 6 DESC;	--> 숫자 써도 가능. (6번째 : sal+bonus)
			
	 -- 남자 중 city 오름차순, city가 같으면 sal 내림차순 : name, rrn, city, dept, sal, bonus
			SELECT name, rrn, city, dept, sal, bonus
			FROM emp
			WHERE MOD(SUBSTR(rrn, 8, 1), 2) =1
			ORDER BY city, sal DESC;
	
	 -- dept 오름차순 정렬하고 dept가 같으면 남자를 먼저 출력 : name, rrn, dept, sal	
			SELECT name, rrn, dept, sal
			FROM emp
			ORDER BY dept, MOD(SUBSTR(rrn, 8, 1), 2) DESC;
	
	 -- dept는 영업부를 먼저 출력 : name, dept
			SELECT name, dept, CASE WHEN dept = '영업부' THEN 0 END
			FROM emp
			ORDER BY dept;
	 
			SELECT name, dept
			FROM emp
			ORDER BY CASE WHEN dept = '영업부' THEN 0 END;
				-- 오름차순 정렬에서 NULL은 아래 출력
	
     -- pos 가 부장, 과장, 대리, 사원순으로 출력 : name, dept, pos
			SELECT name, dept, pos
			FROM emp
			ORDER BY
				CASE  
					WHEN pos ='부장' THEN 1
					WHEN pos ='과장' THEN 2
					WHEN pos ='대리' THEN 3
					WHEN pos ='사원' THEN 4
				END;
				
			SELECT name, dept, pos
			FROM emp
			ORDER BY DECODE(pos,'부장',0,'과장',1,'대리',2,'사원',3);

     -- 여자를 먼저 출력하고 성별이 동일하면 sal 내림차순 : name, rrn, sal
			SELECT name, rrn, sal
			FROM emp
			ORDER BY MOD(SUBSTR(rrn,8,1),2), sal DESC;

     -- 서울 사람만 출력하며, 기본급+수당 내림차순으로 정렬 : name, city, sal+bonus
			SELECT name, city, sal+bonus pay
			FROM emp
			WHERE city = '서울'
			ORDER BY pay DESC;

     -- 여자만 출력하며, 부서오름차순으로 정렬하고 부서가 같으면 기본급 내림차순 정렬 : name, rrn, dept, sal
			SELECT name, rrn, dept, sal
			FROM emp
			WHERE MOD(SUBSTR(rrn, 8,1),2) =0
			ORDER BY dept, sal DESC;

		
     -- 전화번호가 NULL 인 데이터를 먼저 출력
			SELECT name, tel FROM emp;
			SELECT name, tel FROM emp ORDER BY tel NULLS FIRST;

     -- 전화번호가 NULL 인 데이터를 나중에 출력
			SELECT name, tel FROM emp ORDER BY tel NULLS LAST;

	 -- 영업부를 가장 마지막에 출력 : name, dept, pos
			SELECT name, dept, pos
			FROM emp
			ORDER BY CASE WHEN dept='영업부' THEN 0 END DESC;
			
			SELECT name, dept, pos
			FROM emp
			ORDER BY CASE WHEN dept='영업부' THEN 0 END NULLS FIRST;

			SELECT name, dept, pos
			FROM emp
			ORDER BY DECODE(dept,'영업부',0) NULLS FIRST;
                      -- dept가 영업부면 0 반환
			
	--------------------------------------------------------------
	 -- 난수 발생
		SELECT DBMS_RANDOM.VALUE FROM dual;
			
	 -- 실행할 때마다 다른 결과
		SELECT empNo, name, dept, pos 
		FROM emp 
		ORDER BY DBMS_RANDOM.VALUE;
	 
	 -- 랜덤하게 5개만 추출하기 : 이벤트 당첨
		SELECT * FROM(
			SELECT empNo,name,dept,pos 
			FROM emp 
			ORDER BY DBMS_RANDOM.VALUE
		)WHERE ROWNUM<=5;--오라클 11G방식

		SELECT empNo,name,dept,pos 
		FROM emp 
		ORDER BY DBMS_RANDOM.VALUE
		FETCH FIRST 5 ROWS ONLY;--오라클12C이상
	 
	 
 -- ※ 집합 연산자(Set Operators)
     -- UNION : 합집합, 교집합은 한 번만 출력
		SELECT name, city, dept FROM emp WHERE dept='개발부'
			UNION 
		SELECT name, city, dept FROM emp WHERE city = '인천';
        
     -- UNION ALL
		SELECT name, city, dept FROM emp WHERE dept='개발부'
			UNION ALL
		SELECT name, city, dept FROM emp WHERE city = '인천'
		ORDER BY city;
		
		-- 컬럼의 개수, 각 컬럼의 자료형이 일치하면 가능
		SELECT name, city, dept, sal FROM emp WHERE dept='개발부'
			UNION ALL
		SELECT name, city, dept, bonus FROM emp WHERE city = '인천'
		ORDER BY city;
				-- >  위에 컬럼명 맞춰주고 sal 부분에 아래는 bonus 값 들어감

     -- MINUS : 차집합
		SELECT name, city, dept FROM emp WHERE dept='개발부'
			MINUS
		SELECT name, city, dept FROM emp WHERE city = '인천';
	 

     -- INTERSECT
		SELECT name, city, dept FROM emp WHERE dept='개발부'
			INTERSECT
		SELECT name, city, dept FROM emp WHERE city = '인천';

 -- ※ pseudo 컬럼(의사 컬럼) : 오라클 내부적으로 사용되는 컬럼
   -- ο ROWID : 행에 대한 주소, 행을 고유하게 식별
		SELECT ROWID, name FROM emp;

   -- ο ROWNUM : 쿼리의 결과로 나오는 행들에 대한 순서 값. 가상 컬럼 -> 잘 기억
            --> 앞에 1,2,3,4 나오는거
		
	-- 쿼리의 행수를 제한
		SELECT empNo, name, sal FROM emp;
		
		SELECT empNo, name, sal FROM emp WHERE ROWNUM < 11;
					-- 앞에 10개만 출력
		
	--양의 정수보다 큰 ROWNUM은 항상 거짓이다.
		SELECT empNO, name, sal FROM emp WHERE ROWNUM > 1; 	-- 아무것도 출력되지 않는다.
																			--> ROWNUM은 크다로 비교해서는 안됨. 데이터를 가지고 난 후에 생성되기 때문
	-- ORDER BY 절이 있는 쿼리에서 ROWNUM을 조건에 사용하면 의도하는 결과가 나오지 않는다.
		SELECT empNo, name, sal FROM emp
		WHERE ROWNUM < 11
		ORDER BY sal;	-- 이렇게 하면 안됨
		
	-- 서브쿼리에서 ORDER BY 절을 적용시키고 ROWNUM 조건을 최상위 쿼리에서 지정하면 가능
		SELECT * FROM (
			SELECT empNo, name, sal FROM emp
			ORDER BY sal
		) WHERE ROWNUM < 11;
										
	-- 실행순서
		FROM절 -> WHERE 절 -> ROWNUM 할당 -> GROUP BY 절 -> HAVING 절 -> SELECT 절 -> ORDER BY 절
		
		SELECT empNo,name, sal FROM emp;
		
		SELECT empNo,name, sal FROM emp WHERE ROWNUM > 10;	-- 하나도 출력 안됨
		SELECT empNo,name, sal FROM emp WHERE ROWNUM = 10;	-- 하나도 출력 안됨
        -- ????????????????????????????? 아래랑  뭐가 달라 ???????????????????????????????
        
		SELECT empNo,name, sal FROM emp WHERE ROWNUM =1;	-- 가능
		SELECT empNo,name, sal FROM emp WHERE ROWNUM <=10;	-- 가능
		
	-- sal 내림차순 정렬해서 10개만 가져오기
		SELECT * FROM(
			SELECT empNo, name, sal FROM emp
			ORDER BY sal DESC
		)WHERE ROWNUM <=10;
		
	-- sal 내림차순 정렬해서 11~20번째 레코드 가져오기
		SELECT empNo,name, sal FROM emp
		ORDER BY sal DESC;
		
		SELECT * FROM (
			SELECT empNo, name, sal FROM emp
			ORDER BY sal DESC
		) WHERE ROWNUM >=11 AND ROWNUM <=20;  -- 하나도 출력 안됨
		
		SELECT ROWNUM rnum, tb.* FROM (
			SELECT empNo, name, sal FROM emp
			ORDER BY sal DESC
		) tb;
		
		SELECT ROWNUM rnum, tb.* FROM (
			SELECT empNo, name, sal FROM emp
			ORDER BY sal DESC
		) tb WHERE ROWNUM <=20;	-- 가능
		
		
		=> 반드시 암기!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		=> ORDER BY절과 ROWNUM 같이 사용 X
		SELECT * FROM (				
			SELECT ROWNUM rnum, tb.* FROM(
				SELECT empNo, name, sal
				FROM emp
				ORDER BY sal DESC
			)tb WHERE ROWNUM <=20
		)WHERE rnum >=11;		--> rrum으로 나와서 >= 가능
			-- 오라클 페이징 처리 방법, 성능이 우수
--------------------------------

-- > 2/27
SELECT 10*5 FROM emp;
SELECT 10*5 FROM dual;
SELECT 10*5, 10/5 FROM emp;

SELECT '결과 : ' || 10*5 FROM dual;

SELECT * FROM col WHERE tname = 'EMP';
DESC emp;

SELECT empNo, name, sal FROM emp;     
SELECT sal, name FROM emp;
SELECT no, name FROM emp;

