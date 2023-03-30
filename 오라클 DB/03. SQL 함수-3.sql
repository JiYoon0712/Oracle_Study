-- ■ SQL 함수
 -- ※ 분석 함수(analytic functions) 와 윈도우 함수(window functions)
    -- ο 순위 관련 함수
      -- 1) RANK() OVER() 함수
              -- "100,100,80" 순위는 "1,1,3"
            -- 전체를 대상으로 순위 계산
               SELECT name, sal, RANK() OVER(ORDER BY sal) 순위
               FROM emp; -- 급여 오름차순 순위

               SELECT name, sal, RANK() OVER(ORDER BY sal DESC) 순위
               FROM emp; -- 급여 내림차순 순위
               
               SELECT name, sal, RANK() OVER(ORDER BY sal DESC, bonus DESC) 순위
               FROM emp; -- 급여내림차순, 급여가 같으면 보너스 내림차순 순위
               
               -- 그룹을 대상으로 순위 계산 : 부서별 순위
               SELECT name, dept, sal, RANK() OVER(PARTITION BY dept ORDER BY sal DESC) 순위
               FROM emp; -- 부서별 급여내림차순 순위
               
               -- 그룹을 대상으로 순위 계산 : 부서별 순위, 부서의 직위별 순위
               SELECT name, dept, pos, sal,
                    RANK() OVER(PARTITION BY dept ORDER BY sal DESC) 부서순위,
                    RANK() OVER(PARTITION BY dept,pos ORDER BY sal DESC) 부서직위순위
               FROM emp; -- 부서별 급여내림차순 순위
               
               -- 급여 순위 : 1~10등까지만 출력
               SELECT name, sal, 
                    RANK() OVER(ORDER BY sal DESC) 순위
               FROM emp;
               
               SELECT name, sal, 
                    RANK() OVER(ORDER BY sal DESC) 순위
               FROM emp
               WHERE RANK() OVER(ORDER BY sal DESC) <=10; -- 에러.
               
               SELECT * FROM (
                    SELECT name, sal,
                    RANK() OVER(ORDER BY sal DESC) 순위
                    FROM emp
               ) WHERE 순위 <=10;  -- 서브쿼리 이용
               
               -- 급여 상위 10% 출력(name, sal)
                SELECT name, sal FROM(
                    SELECT name, sal,
                    RANK() OVER(ORDER BY sal DESC) 순위
                    FROM emp
                )WHERE 순위 <= (SELECT COUNT(*) FROM emp)*0.1;
                
                -- dept별 급여(sal+bonus)가 가장 높은 name, dept, pos, sal, bonus 출력
                SELECT name, dept, sal, bonus FROM(
                    SELECT name, dept, sal, bonus,
                    RANK() OVER(PARTITION BY dept ORDER BY sal+bonus DESC) 순위
                    FROM emp
                ) WHERE 순위 = 1;
                
                -- dept별 여자인원수가 가장 많은 부서명 및 인원수 출력
                SELECT dept, 인원수 FROM(
                    SELECT dept, COUNT(*) 인원수,
                          RANK() OVER(ORDER BY COUNT(*) DESC) 순위
                    FROM emp
                    WHERE MOD(SUBSTR(rrn,8,1),2)=0 
                    GROUP BY dept
                ) WHERE 순위 = 1 ;
                
                      
      -- 2) DENSE_RANK() OVER() 함수
        -- "100,100,80" 순위는 "1,1,2"
        
        SELECT name, sal, RANK() OVER(ORDER BY sal DESC) rank순위
        FROM emp;
        
        SELECT name, sal, DENSE_RANK() OVER(ORDER BY sal DESC) densc_rank순위
        FROM emp;

      -- 3) ROW_NUMBER() OVER( ) 함수
        -- "100,100,80" 순위는 "1,2,3"
        SELECT name, sal, ROW_NUMBER() OVER(ORDER BY sal DESC) ROW_NUMBER순위
        FROM emp;

     -- 4) RANK() WITHIN GROUP() 함수 : 조건값의 순위
        -- sal가 3000000이면 몇등?
        SELECT RANK(3000000) WITHIN GROUP(ORDER BY sal DESC) 순위
        FROM emp;

--------------------------------------

    -- ο COUNT() OVER(), SUM() OVER(), AVG() OVER(), MAX() OVER(), MIN() OVER() 함수 : 여러행 출력
      -- 1) COUNT() OVER() 함수
            SELECT name, dept, sal, COUNT(*)
            FROM emp; -- 에러
      
            SELECT name, dept, sal,
                COUNT(*) OVER(ORDER BY empNo) cnt
            FROM emp; 
                  -- 각 행까지의 개수
                  -- 1 2 3 4 ... 으로 출력
                  -- 앞 인원수 누적(empNo가 모두 다른 값이기 때문에 1 2 3 4 ... 로 출력)
            
            SELECT name, dept, sal,
                COUNT(*) OVER(ORDER BY dept) cnt
            FROM emp;      
                -- 동일한 부서는 동일한 인원수
                -- 다음 부서는 앞 부서의 인원수를 누적
                -- 14 14 ... 14 21 21  ... 21 37...

        -- OVER()에 아무것도 기술하지 않으면 전체 인원수가 출력
            SELECT name, dept, sal,
                COUNT(*) OVER() cnt
            FROM emp;  
            
        -- 그룹별 : 부서별 인원수
            SELECT name, dept, sal,
                COUNT(*) OVER(PARTITION BY dept) cnt
            FROM emp; 
                -- 14 14 .. 14 7 7 ... 16..
                -- 앞 부서 인원수를 누적하지 않음
                
            SELECT name, dept, pos, sal,
                COUNT(*) OVER(PARTITION BY dept) cnt,
                COUNT(*) OVER(PARTITION BY dept ORDER BY empNo) cnt2
            FROM emp; 
            
            SELECT name, dept, pos, sal,
                COUNT(*) OVER(PARTITION BY dept) cnt,
                COUNT(*) OVER(PARTITION BY dept ORDER BY sal) cnt2
            FROM emp; 
            
            SELECT name, dept, pos, sal,
                COUNT(*) OVER(ORDER BY empNo) cnt
            FROM emp
            WHERE dept='개발부'; 
        
        
      -- 2) SUM() OVER() 함수
            -- name, dept, sal, sal전체합
                SELECT name, dept, sal, SUM(sal) 합 FROM emp; --에러
                
                SELECT name, dept, sal, (SELECT SUM(sal)FROM emp) 합 FROM emp; 
                SELECT name, dept, sal, SUM(sal) OVER() FROM emp;
                            -- OVER()에 아무것도 기술하지 않으면 전체 합
                
                SELECT name, dept, sal, SUM(sal) OVER(ORDER BY empNo) FROM emp;
                            -- 앞 sal 합을 누적
                            -- empNo가 동일한 것이 없으므로 동일한 값은 출력되지 않음
                            
                SELECT name, dept, sal, SUM(sal) OVER(ORDER BY dept) FROM emp;
                            -- 동일 부서는 동일한 합
                            -- 다음 부서는 앞부서 합을 누적
                 
            -- 그룹별 합
                SELECT name, dept, sal, SUM(sal) OVER(PARTITION BY dept) FROM emp;

                SELECT name, dept, sal, SUM(sal) OVER(PARTITION BY dept ORDER BY empNo) FROM emp;
            
            -- 부서명  성별  인원수 부서별성별백분율
               개발부  남자  5      50%
               개발부  여자  5      50%
                    :
                SELECT dept, DECODE(MOD(SUBSTR(rrn,8,1),2),1,'남자','여자') 성별,
                        COUNT(*) 인원수
                FROM emp
                GROUP BY dept, MOD(SUBSTR(rrn,8,1),2);                
                -----
                SELECT dept, DECODE(MOD(SUBSTR(rrn,8,1),2),1,'남자','여자') 성별,
                        COUNT(*) 인원수,
                        SUM(COUNT(*)) OVER(PARTITION BY dept) 부서인원
                FROM emp
                GROUP BY dept, MOD(SUBSTR(rrn,8,1),2);
                -----
                SELECT dept, DECODE(MOD(SUBSTR(rrn,8,1),2),1,'남자','여자') 성별,
                        COUNT(*) 인원수,
                        SUM(COUNT(*)) OVER(PARTITION BY dept) 부서인원,
                        ROUND(COUNT(*)/SUM(COUNT(*)) OVER(PARTITION BY dept) *100) ||'%' 백분율
                FROM emp
                GROUP BY dept, MOD(SUBSTR(rrn,8,1),2);
                
                -- 서브쿼리 이용
                  SELECT dept, 성별, 인원수
                  FROM(
                    SELECT dept, DECODE(MOD(SUBSTR(rrn,8,1),2),1,'남자','여자') 성별,
                            COUNT(*) 인원수,
                            SUM(COUNT(*)) OVER(PARTITION BY dept) 부서인원
                    FROM emp
                    GROUP BY dept, MOD(SUBSTR(rrn,8,1),2)
                    );
                    
                  SELECT dept, 성별, 인원수, SUM(인원수) OVER(PARTITION BY dept) 부서인원
                  FROM(
                    SELECT dept, DECODE(MOD(SUBSTR(rrn,8,1),2),1,'남자','여자') 성별,
                            COUNT(*) 인원수,
                            SUM(COUNT(*)) OVER(PARTITION BY dept) 부서인원
                    FROM emp
                    GROUP BY dept, MOD(SUBSTR(rrn,8,1),2)
                    );
                    
                    
      -- 3) AVG() OVER() 함수 >  쓸만할지도
            -- name, dept, sal, 전체평균급여
            SELECT name, dept, sal,
                ROUND(AVG(sal) OVER()) 평균
            FROM emp;
            
            -- name, dept, sal, 전체평균급여와 차이
            SELECT name, dept, sal,
                sal - ROUND(AVG(sal) OVER())
            FROM emp;
            
            -- name, dept, sal, 부서별평균급여
            SELECT name, dept, sal,
                ROUND(AVG(sal) OVER(PARTITION BY dept)) 부서평균
            FROM emp;

      -- 4) MAX() OVER()와 MIN() OVER() 함수
            -- name, dept, sal, 최대급여와 차이
                SELECT name, dept, sal, 
                    ROUND(MAX(sal)OVER())-sal 차이
                FROM emp;
                
            -- name, dept, sal, 최소급여와 차이
                SELECT name, dept, sal, 
                    sal-ROUND(MIN(sal)OVER()) 차이
                FROM emp;    

    -- ο RATIO_TO_REPORT() OVER() 함수
        SELECT dept, COUNT(*)
        FROM emp
        GROUP BY dept;

        SELECT dept, ROUND(COUNT(*)/(SELECT COUNT(*) FROM emp) *100) 비율
        FROM emp
        GROUP BY dept;
 
        SELECT dept, ROUND(RATIO_TO_REPORT(COUNT(*)) OVER()*100) 비율
        FROM emp
        GROUP BY dept;        
        
    -- ο LISTAGG () WITHIN GROUP() 함수 : 컬럼값을 연결 > 기억
        -- 부서별 사원 이름을 ,로 구분하여 결합
        -- 부서명 사원명
            SELECT dept,
                    LISTAGG(name,',') WITHIN GROUP(ORDER BY empNo) 부서사원명
            FROM emp
            GROUP BY dept;      -- GROUP BY 생략 불가


    -- ο LAG () OVER() 함수와  LEAD() OVER()  함수 : 성능이 아주 좋지 않음
        -- LAG () OVER() : 이전 데이터
        -- LEAD() OVER() : 이후 데이터
            
            SELECT name, sal,
                    LAG(sal,1,0) OVER(ORDER BY sal DESC) lag
            FROM emp;
                -- LAG(sal,1,0) -> sal : 출력컬럼, 1:1줄씩 밀려서 출력(3을 주면 3줄씩 밀림), 0:밀린자리에 출력할 값

            SELECT name, sal,
                    LEAD(sal,1,0) OVER(ORDER BY sal DESC) lead
            FROM emp;

    ο NTILE() OVER() 함수 : 그룹 나누기
        SELECT name, sal,
            NTILE(6) OVER(ORDER BY sal DESC) 그룹
        FROM emp;
        
        SELECT name, sal,
            NTILE(7) OVER(ORDER BY sal DESC) 그룹
        FROM emp;
    


    -- ο 윈도우 절(window clause) : 부분 집합을 만드는 역할
      -- 형식
--       { ROWS | RANGE }
--         { BETWEEN
--               { UNBOUNDED PRECEDING  | CURRENT ROW | value_expr { PRECEDING | FOLLOWING } } 
--              AND
--              { UNBOUNDED FOLLOWING | CURRENT ROW | value_expr { PRECEDING | FOLLOWING } }
--         | { UNBOUNDED PRECEDING | CURRENT ROW | value_expr PRECEDING }
--        }


    -- ο FIRST_VALUE() OVER()
        -- 이름, 기본급, 각부서의 최대급여
        SELECT name, sal, FIRST_VALUE(sal) OVER(PARTITION BY dept ORDER BY sal DESC)
        FROM emp;
        
        SELECT name, dept, sal, MAX(sal) OVER(PARTITION BY dept)
        FROM emp;
        
        -- 이름, 기본급, 최대급여와 차이
        SELECT name, sal, FIRST_VALUE(sal) OVER(PARTITION BY dept ORDER BY sal DESC)-sal 차이
        FROM emp;

        
        
    -- ο LAST_VALUE() OVER() 함수
       -- 예
         -- LAST_VALUE 함수는 윈도우절을 지정하지 않으면 디폴트로
            RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 가 적용되어
            끝값으로 고정되어 있지 않으므로 예기치 않는 결과가 출력 되므로 반드시 윈도우절을 지정해야 한다.
        
         -- 적은순에서 큰 순으로
            SELECT name, dept, sal, LAST_VALUE(sal) OVER(ORDER BY sal)
            FROM emp;
            
            SELECT name, dept, sal, LAST_VALUE(sal) OVER(ORDER BY sal
                  RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) 크기순
            FROM emp;
         
         -- 결과가 매번 달라질 수 있으며, 옆사람과도 다를 수 있음
            SELECT name, dept, sal, LAST_VALUE(sal) OVER()
            FROM emp;
            
         -- 가장 큰값만 출력 : FOLLOWING 옵션을 사용
            SELECT name, dept, sal, 
                LAST_VALUE(sal) OVER(ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 최고
            FROM emp;
         