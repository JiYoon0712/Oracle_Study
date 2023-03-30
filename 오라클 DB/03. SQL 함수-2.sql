-- ■ SQL 함수
 -- ※ 집계 함수(Aggregate Function)와 GROUP BY 절
    -- ο 집계 함수(Aggregate Function) 종류
       -- COUNT( * ) : 개수 
       -- COUNT( DISTINCT | ALL ] expr )
          
          SELECT COUNT(*) FROM emp; -- 전체행수, 60
          SELECT COUNT(empNo) FROM emp;  -- 60
                -- empNo : 기본키, NOT NULL 속성의 컬럼                
          SELECT COUNT(tel) FROM emp;      -- 57. NULL은 카운트하지 않는다.
            -- 전체 행수를 구하기 위해서는 COUNT에 *를 사용하거나 NOT NULL 속성의 컬럼을 사용하여 계산한다.
          
          SELECT empNo, COUNT(empNo) FROM emp; -- 에러. 일반컬럼과 집계함수는 함께 사용할 수 없다.
          
          SELECT * FROM emp WHERE 1=2;  -- 한줄도 출력되지 않음
          SELECT COUNT(*) FROM emp WHERE 1=2;  -- 0, 데이터가 없어도 COUNT는 0을 반환
          
          -- 서울사람 인원수
          SELECT COUNT(*) FROM emp 
          WHERE city='서울'; 
          
          -- 전체 부서수
          SELECT dept FROM emp;
          SELECT DISTINCT dept FROM emp;
          
          SELECT COUNT(DISTINCT dept) FROM emp ;  -- 중복을 배제하여 COUNT
          
          -- 전체인원수, 남자인원수, 여자인원수
          SELECT name, rrn, 
            DECODE(MOD(SUBSTR(rrn,8,1),2),1,'남'),
            DECODE(MOD(SUBSTR(rrn,8,1),2),0,'여')
          FROM emp;
          
          SELECT COUNT(*) 전체,
          COUNT(DECODE(MOD(SUBSTR(rrn,8,1),2),1,'남')) 남,
          COUNT(DECODE(MOD(SUBSTR(rrn,8,1),2),0,'여')) 여
          FROM emp;
          
          SELECT COUNT(*) 전체,
          COUNT(DECODE(MOD(SUBSTR(rrn,8,1),2),1,1)) 남,
          COUNT(DECODE(MOD(SUBSTR(rrn,8,1),2),0,1)) 여
          FROM emp;
          
          -- NULLIF(a,b) : a=b 이면 NULL, 그렇지 않으면 b
          SELECT name, rrn, MOD(SUBSTR(rrn,8,1),2),
                NULLIF(MOD(SUBSTR(rrn,8,1),2),1),
                NULLIF(MOD(SUBSTR(rrn,8,1),2),0)
          FROM emp;
          
          SELECT COUNT(*) 전체,
                COUNT(NULLIF(MOD(SUBSTR(rrn,8,1),2),1)) 여,
                COUNT(NULLIF(MOD(SUBSTR(rrn,8,1),2),0)) 남
          FROM emp;
          
          -- 서울사람중 남자인원수
          --(1) WHERE에서 다 쳐내고 뽑아내고 하는게 부하 줄임
          SELECT COUNT(*) 서울남자수
          FROM emp
          WHERE city='서울' AND (MOD(SUBSTR(rrn,8,1),2))=1;
          
          --(2)
          SELECT COUNT(DECODE(MOD(SUBSTR(rrn,8,1),2),1,1)) 서울남자수
          FROM emp
          WHERE city='서울';


          -- 전체인원수, 남자인원수, 여자인원수
             구분    인원
             전체    60
             남자    31
             여자    29
             
             SELECT '전체' 구분, COUNT(*)인원 FROM emp
                UNION ALL
             SELECT '남자' 구분, COUNT(*) 인원 FROM emp WHERE MOD(SUBSTR(rrn,8,1),2)=1
                UNION ALL
             SELECT '여자' 구분, COUNT(*) 인원 FROM emp WHERE MOD(SUBSTR(rrn,8,1),2)=0
             ORDER BY 인원 DESC;
             
          
       -- MAX([ DISTINCT | ALL ] expr) : 최대값
       -- MIN([ DISTINCT | ALL ] expr) : 최소값
        
        SELECT MAX(sal), MIN(sal) FROM emp;
        
        SELECT empNo, name, sal
        FROM emp
        WHERE sal = MAX(sal);   -- 에러. 집계함수는 WHERE절에서 사용할 수 없다.
        
        SELECT MAX(sal) FROM emp;
        
        SELECT empNo, name, sal
        FROM emp
        WHERE sal = (SELECT MAX(sal) FROM emp);    -- 서브쿼리
    

       -- AVG([ DISTINCT | ALL ] expr) : 평균
       -- SUM([ DISTINCT | ALL ] expr): 합

            SELECT COUNT(sal),AVG(sal), SUM(sal), MAX(sal), MIN(sal) FROM emp;
            
            SELECT sal FROM emp WHERE 2 = 1; -- 한 줄도 출력안됨
            
            SELECT COUNT(*) FROM emp WHERE 2 = 1;   -- 0
            SELECT SUM(sal) FROM emp WHERE 2 = 1;   -- NULL
            SELECT AVG(sal) FROM emp WHERE 2 = 1;   -- NULL
            
            SELECT NVL(AVG(sal),0) FROM emp WHERE 2=1; -- 0
            
            -- 전체, 남자, 여자 급여합
            SELECT SUM(sal) 전체,    
                SUM(DECODE(MOD(SUBSTR(rrn,8,1),2),1,sal)) 남,
                SUM(DECODE(MOD(SUBSTR(rrn,8,1),2),0,sal)) 여
            FROM emp;
            
            SELECT AVG(sal) 전체,    
                SUM(DECODE(MOD(SUBSTR(rrn,8,1),2),1,sal)) 남,
                SUM(DECODE(MOD(SUBSTR(rrn,8,1),2),0,sal)) 여
            FROM emp;
            
            -- 아래와 같이 평균출력. 단, 평균은 1의자리 절삭
--                구분  평균
--                전체  ...
--                남자  ...
--                여자  ...
                
            SELECT '전체' 구분, TRUNC(AVG(sal),-1) 평균 FROM emp
                UNION ALL
            SELECT '남자' 구분, TRUNC(AVG(sal),-1) 평균 FROM emp WHERE MOD(SUBSTR(rrn,8,1),2)=1
                UNION ALL
            SELECT '여자' 구분, TRUNC(AVG(sal),-1) 평균 FROM emp WHERE MOD(SUBSTR(rrn,8,1),2)=0;
            
            
            -- 월별 입사인원수 구하기
--                전체 1월 2월 ... 12월
--                ..  ..  ..      ..
                SELECT COUNT(*) 전체,
                    COUNT(DECODE(TO_CHAR(hireDate,'MM'),1,1)) "1월" ,
                    COUNT(DECODE(TO_CHAR(hireDate,'MM'),2,1)) "2월" ,
                    COUNT(DECODE(TO_CHAR(hireDate,'MM'),3,1)) "3월" ,
                    COUNT(DECODE(TO_CHAR(hireDate,'MM'),4,1)) "4월" ,
                    COUNT(DECODE(TO_CHAR(hireDate,'MM'),5,1)) "5월" ,
                    COUNT(DECODE(TO_CHAR(hireDate,'MM'),6,1)) "6월" ,
                    COUNT(DECODE(TO_CHAR(hireDate,'MM'),7,1)) "7월" ,
                    COUNT(DECODE(TO_CHAR(hireDate,'MM'),8,1)) "8월" ,
                    COUNT(DECODE(TO_CHAR(hireDate,'MM'),9,1)) "9월" ,
                    COUNT(DECODE(TO_CHAR(hireDate,'MM'),10,1)) "10월" ,
                    COUNT(DECODE(TO_CHAR(hireDate,'MM'),11,1)) "11월" ,
                    COUNT(DECODE(TO_CHAR(hireDate,'MM'),12,1)) "12월"  
                FROM emp;

                
            -- 평균급여보다 적게 받는 사원의 empNo, name, sal 컬럼 출력
                SELECT empNo, name, sal
                FROM emp
                WHERE sal< ( SELECT AVG(sal) FROM emp );
            
            -- 서울 사람 인원수 및 급여평균 출력
                SELECT COUNT(*) 서울사람인원수, AVG(sal) 급여평균
                FROM emp
                WHERE city='서울';


       -- VARIANCE([ DISTINCT | ALL ] expr) : 분산
       -- STDDEV([ DISTINCT | ALL ] expr) : 표준편차

------ 정리 필수----------
 -- ※ GROUP BY 절과 HAVING 절
        -- FROM 절 -> WHERE 절 -> GROUP BY 절 -> HAVING 절 -> SELECT 절-> ORDER BY 절
   
    -- ο GROUP BY 절 사용 예
        -- 예 
            SELECT SUM(sal) FROM emp;  -- 전체 급여 합
            
        -- 부서별 급여 합
            SELECT dept, SUM(sal) FROM emp; -- 에러
            
            SELECT dept, SUM(sal)
            FROM emp
            GROUP BY dept;  -- 그룹별 합계. GROUP BY절에 사용한 컬럼은 집계함수와 함께 사용 가능
   
   

      -- dept의 pos별 급여 총합			
            SELECT dept, pos, SUM(sal)
            FROM emp
            GROUP BY dept,pos
            ORDER BY dept,pos;
            
        -- 부서별 인원수
            SELECT dept, COUNT(*) "부서별 인원수"
            FROM emp
            GROUP BY dept;
        
        -- 부서별 여자 인원수 : 여자 인원수가 없는 부서는 출력되지 않음.
            SELECT dept, COUNT(*) "부서별 여자 인원수"
            FROM emp
            WHERE MOD(SUBSTR(rrn,8,1),2)=0 
            GROUP BY dept;
            
            SELECT DISTINCT dept FROM emp;
            
        -- 부서별 여자 인원수 : 여자 인원수가 없는 부서도 출력
            SELECT dept, COUNT(DECODE(MOD(SUBSTR(rrn,8,1),2),0,1))여자인원수
            FROM emp
            GROUP BY dept;
            
        -- 부서별 전체인원수, 남자, 여자 인원수
            -- 부서명 전체 남자 여자
            SELECT dept, COUNT(*)전체, 
                   COUNT(DECODE(MOD(SUBSTR(rrn,8,1),2),1,1)) 남자, 
                   COUNT(DECODE(MOD(SUBSTR(rrn,8,1),2),0,1)) 여자
            FROM emp
            GROUP BY dept;
        
        
        -- 부서별 남자와 여자 비율(부서대비)
            -- 부서명 남자비율 여자비율    
            SELECT dept, ROUND(COUNT(DECODE(MOD(SUBSTR(rrn,8,1),2),1,1))*100/COUNT(*)) 남자비율,
                         ROUND(COUNT(DECODE(MOD(SUBSTR(rrn,8,1),2),0,1))*100/COUNT(*)) 여자비율
            FROM emp
            GROUP BY dept;

        -- 부서의 남자와 여자별 급여 합과 평균 : 부서오름차순, 부서 같으면 성별 내림차순
            --부서명  성별  합
            --개발부  여자  ...
            --개발부  남자  ...
            
            SELECT dept,DECODE(MOD(SUBSTR(rrn,8,1),2),1,'남자','여자')성별
            FROM emp;
            
            SELECT dept, DECODE(MOD(SUBSTR(rrn,8,1),2),1,'남자','여자')성별, 
                   SUM(sal) 합,ROUND(AVG(sal)) 평균
            FROM emp
            GROUP BY dept,MOD(SUBSTR(rrn,8,1),2)    -- > decode 안쓰고 이 부분만 가져와도 성별 컬럼 사용 가능
            ORDER BY dept, 성별 DESC;
            
        
    -- ο HAVING 절 사용 예
        -- 부서별 인원수
            SELECT dept, COUNT(*)"부서별 인원수"
            FROM emp
            GROUP BY dept;
            
        -- 부서별 인원수가 7명 이상만
            -- HAVING : GROUP BY한 결과에 대한 조건
            SELECT dept, COUNT(*)
            FROM emp
            GROUP BY dept
            HAVING COUNT(*) >=7;
            
        -- 부서별 여자 인원수가 5명이상
            SELECT dept, COUNT(*)
            FROM emp
            WHERE MOD(SUBSTR(rrn,8,1),2)=0
            GROUP BY dept
            HAVING COUNT(*) >=5;
        
        ---------------------------------------
        -- subquery
            -- SELECT 문, INSERT 문, UPDATE 문, DELETE 문 등에서 사용되는 SELECT 문
            -- SELECT 문의 SELECT 절, FROM 절, WHERE 절에서 사용 가능
                -- SELECT절에서 사용하는 경우 하나의 컬럼과 하나의 행의 결과만 가능
                -- WHERE 절에서 사용하는 경우 IN 절에서는 여러행이 출력되어도 가능하지만, =,<,> 등의 연산에서는 하나의 행만 가능
            -- subquery는 단독 실행 가능
            
        -- empNo, name, sal, 최대급여-sal
            SELECT MAX(sal) FROM emp;   -- 한줄 한 컬럼
            
            SELECT empNo, name, sal, (SELECT MAX(sal) FROM emp) - sal 차이
            FROM emp;
            
        -- 잘못 사용된 예
            SELECT empNo, name, sal
            FROM emp
            WHERE sal >( SELECT MAX(sal), MIN(sal) FROM emp); -- 에러. 서브쿼리에 컬럼이 두개 있음

            SELECT empNo, name, sal
            FROM emp
            WHERE sal >( SELECT sal FROM emp WHERE city='서울');  -- 에러. 서브쿼리 결과가 여러행

        -- IN에서의 서브쿼리
            SELECT sal FROM emp WHERE city='인천';
            
            SELECT empNo, name, sal
            FROM emp
            WHERE sal IN (SELECT sal FROM emp WHERE city='인천'); -- IN과 비교할때는 서브쿼리 결과가 여러행이어도 가능
            
            SELECT empNo, name, sal
            FROM emp
            WHERE sal IN(4550000,3365000,1500000);
        
        -- empNo, name, sal, sal-평균급여 
            SELECT empNo, name, sal ,sal-(SELECT AVG(sal) FROM emp) "sal-평균급여"
            FROM emp;
            
        -- sal+bonus가 가장 많이 받는 사람 : empNo, name, sal, bonus, sal+bonus
            SELECT empNo,name,sal, bonus, sal+bonus
            FROM emp
            WHERE sal+bonus = (SELECT MAX(sal+bonus) FROM emp);
                     
                        
        -- 여자중 급여(sal)를 가장 많이 받는 사람 : empNo, name, sal
             SELECT empNo, name, sal
             FROM emp
             WHERE MOD(SUBSTR(rrn,8,1),2)=0 AND 
                sal = (SELECT MAX(sal) FROM emp WHERE MOD(SUBSTR(rrn,8,1),2)=0);      
        
        -- 평균급여(sal)보다 많이 받는 사람 : empNo, name, sal
            SELECT empNo, name, sal
            FROM emp
            WHERE sal > (SELECT AVG(sal) FROM emp);
        
    
        -- 부서별 인원수가 가장 많은 부서명 및 인원수
            SELECT dept, COUNT(*)
            FROM emp
            GROUP BY dept
            HAVING COUNT(*)=(SELECT MAX(COUNT(*))
            FROM emp
            GROUP BY dept);
            
              --(2)
            WITH tb AS(
                SELECT dept, COUNT(*) cnt FROM emp GROUP BY dept
            )SELECT dept, cnt
             FROM tb
             WHERE cnt = (SELECT MAX(cnt) FROM tb);
            
        -- 입사년도별 입사인원수가 가장 많은 년도 및 인원
            -- 입사년도별 인원수
            SELECT TO_CHAR(hireDate,'YYYY') 년도 , COUNT(*)인원수
            FROM emp
            GROUP BY TO_CHAR(hireDate,'YYYY')
            HAVING COUNT(*) = (SELECT MAX (COUNT(*))
                               FROM emp
                               GROUP BY TO_CHAR(hireDate,'YYYY'));
          
          --(2)
            WITH tb AS(
                SELECT TO_CHAR(hireDate,'YYYY') 년도, COUNT(*) cnt 
                FROM emp 
                GROUP BY TO_CHAR(hireDate,'YYYY')
            )SELECT 년도, cnt
             FROM tb
             WHERE cnt = (SELECT MAX(cnt) FROM tb);
            
            
        -- 생일이 동일한 사람이 2명 이상인 경우의 name,birth 출력. 단, birth는 rrn을 이용하고 날짜형식은 RRMMDD 이용
            SELECT name, TO_DATE(SUBSTR(rrn,1,6),'RRMMDD')birth
            FROM emp
            WHERE SUBSTR(rrn,3,4) IN(
                        SELECT SUBSTR(rrn,3,4)
                        FROM emp
                        GROUP BY SUBSTR(rrn,3,4)
                        HAVING COUNT(*)>=2
            )
            ORDER BY TO_CHAR(birth,'MMDD');
            
            

 -- ※ ROLLUP 절과 CUBE 절
    -- ο ROLLUP 절 예
         -- GROUP BY ROLLUP(a, b)
            a+b    => a 별 b의 소계 : GROUP BY a, b 의 결과
            a       => a 별 소계
            전체   => 마지막에 한번

         -- GROUP BY x, ROLLUP(a, b)
            x+a+b
            x+a
            x

         -- GROUP BY x, ROLLUP(a)
            x+a
            x

       -- dept별 pos의 sal 소계, dept별소계, 마지막에 총계 출력
            SELECT dept, pos, SUM(sal)
            FROM emp
            GROUP BY dept, pos; -- 부서에 대한 직위별 합계
            
            
            SELECT dept, pos, SUM(sal)
            FROM emp
            GROUP BY ROLLUP(dept, pos);
                -- 표현식 2개 -> 3레벨까지 표현
                -- 3레벨 : 부서의 직위별 소계, 2레벨 : 부서별 소계, 1레벨 : 전체소계
           
           -- 전체 어쩌구..... 16:16 (14:00)
            SELECT dept, pos, SUM(sal)
            FROM emp
            GROUP BY dept, ROLLUP( pos );
                -- 표현식 1개 -> 2레벨
                -- 2레벨 : 부서의 직위별 소계, 1레벨 : 부서의 소계
           
            -- dept별 인원수 및 마지막에 전체 인원수 출력
                SELECT dept, COUNT(*)
                FROM emp
                GROUP BY dept;  -- 부서별 인원수
                
                SELECT dept, COUNT(*)
                FROM emp
                GROUP BY ROLLUP(dept);  -- 부서별 인원수 및 마지막에 전체 인원수
                
             -- 
                SELECT city, dept, pos, SUM(sal)
                FROM emp
                GROUP BY city, ROLLUP(dept,pos);
                

       -- dept별 pos의 sal 소계, dept별 소계 출력하며 마지막에 총계는 출력하지 않는다.


    ο CUBE 절 예
       -- dept별 pos의 sal 소계, dept별 소계, pos별 소계, 마지막에 총계 출력
            SELECT dept, pos, SUM(sal)
            FROM emp
            GROUP BY CUBE(dept,pos)
            ORDER BY dept,pos;

            SELECT dept, pos, SUM(sal)
            FROM emp
            GROUP BY CUBE(pos, dept)
            ORDER BY dept,pos;
            
         --
            SELECT city, dept, pos, SUM(sal)
            FROM emp
            GROUP BY CUBE(city,dept,pos)
            ORDER BY city,dept,pos;

            SELECT city, dept, pos, SUM(sal)
            FROM emp
            GROUP BY city, CUBE(dept,pos)
            ORDER BY city,dept,pos;
            
 -- ※ GROUPING 함수와 GROUP_ID 함수
    -- ο GROUPING 함수
        -- GROUPING(컬럼) : 결과가 0이면 해당 컬럼은 ROLLUP 연산에 사용된 것이며, 1이면 사용되지 않음
            SELECT dept, pos, GROUPING(dept), GROUPING(pos), TRUNC(AVG(sal))
            FROM emp
            GROUP BY ROLLUP(dept, pos);
            
            SELECT dept, pos, TRUNC(AVG(sal))
            FROM emp
            GROUP BY ROLLUP(dept, pos)
            HAVING GROUPING(pos)=1; 

            -- 부서별 평균 및 전체 평균
            SELECT dept, TRUNC(AVG(sal))
            FROM emp
            GROUP BY ROLLUP(dept, pos)
            HAVING GROUPING(pos)=1;
            
            SELECT dept, TRUNC(AVG(sal))
            FROM emp
            GROUP BY ROLLUP(dept);
            
            
    -- ο GROUP_ID 함수
        -- empNo name dept sal : 개인 급여 및 부서별 급여합, 전체합
            SELECT empNo, name, dept, SUM(sal) sal
            FROM emp 
            GROUP BY ROLLUP(dept, (empNo, name));
        
            SELECT empNo, name, dept, GROUP_ID(), SUM(sal) sal
            FROM emp
            GROUP BY dept, ROLLUP(dept, (empNo, name));
            
            SELECT empNo, name, dept, GROUP_ID(), SUM(sal) sal
            FROM emp
            GROUP BY dept, ROLLUP(dept, (empNo, name))
            ORDER BY dept, GROUP_ID(),empNo;
            
            -- 사번, 이름, 부서, 급여출력
            -- 부서별 오름차순, 부서가 변경되면 부서별 합계, 부서별 평균 출력
            SELECT empNo,
                DECODE(GROUP_ID(), 0, NVL(name, '--합계--'),'--평균--') name,
                dept,
                DECODE(GROUP_ID(),0,SUM(sal), ROUND(AVG(sal))) sal
            FROM emp
            GROUP BY dept, ROLLUP(dept, (empNo,name))
            ORDER BY dept, GROUP_ID(),empNo;


 -- ※ GROUPING SETS - - 안 해


