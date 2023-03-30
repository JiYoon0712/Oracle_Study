-- sal+bonus 의 총합, 평균, 최대, 최소값 출력 : emp 테이블
    -- 총합  평균  최대  최소
    SELECT SUM(sal+bonus) 총합, AVG(sal+bonus) 평균, MAX(sal+bonus) 최대, MIN(sal+bonus)최소
    FROM emp;


-- 출신도(city)별 남자와 여자 인원수 출력 : emp 테이블
    -- city   성별   인원수
    
    SELECT city, 
        CASE 
            WHEN MOD(SUBSTR(rrn,8,1),2)=1 THEN '남자'
            WHEN MOD(SUBSTR(rrn,8,1),2)=0 THEN '여자'
        END 성별,
        COUNT(*) 인원수
    FROM emp
    GROUP BY city,MOD(SUBSTR(rrn,8,1),2)
    ORDER BY city,MOD(SUBSTR(rrn,8,1),2) ;

-- 출신도(city)별 남자와 여자 인원수 출력 : emp 테이블
    -- city   남자인원수  여자인원수
        SELECT city,
            COUNT(DECODE(MOD(SUBSTR(rrn,8,1),2),1,1)) "남자 인원수",
            COUNT(DECODE(MOD(SUBSTR(rrn,8,1),2),0,1)) "여자 인원수"
        FROM emp
        GROUP BY city, MOD(SUBSTR(rrn,8,1),2);


-- 부서(dept)별 남자 인원수가 7명 이상인 부서명과 인원수 출력 : emp 테이블
    -- dept  인원수
        SELECT dept, COUNT(*) 인원수
        FROM emp
        WHERE  MOD(SUBSTR(rrn,8,1),2)=1
        GROUP BY dept
        HAVING COUNT(*) >=7 ;

-- 부서(dept)별 인원수와 부서의 월별로 생일인 사람의 인원수 출력 : emp 테이블
    -- dept  인원수 M01  M02  M03 .... M12

       SELECT dept, COUNT(*) 인원수,
           COUNT(DECODE(SUBSTR(rrn,3,2),01,1)) "M01",
           COUNT(DECODE(SUBSTR(rrn,3,2),02,1)) "M02",
           COUNT(DECODE(SUBSTR(rrn,3,2),03,1)) "M03",
           COUNT(DECODE(SUBSTR(rrn,3,2),04,1)) "M04",
           COUNT(DECODE(SUBSTR(rrn,3,2),05,1)) "M05",
           COUNT(DECODE(SUBSTR(rrn,3,2),06,1)) "M06",
           COUNT(DECODE(SUBSTR(rrn,3,2),07,1)) "M07",
           COUNT(DECODE(SUBSTR(rrn,3,2),08,1)) "M08",
           COUNT(DECODE(SUBSTR(rrn,3,2),09,1)) "M09",
           COUNT(DECODE(SUBSTR(rrn,3,2),10,1)) "M10",
           COUNT(DECODE(SUBSTR(rrn,3,2),11,1)) "M11",
           COUNT(DECODE(SUBSTR(rrn,3,2),12,1)) "M12"
       FROM emp
       GROUP BY dept ;
  

-- sal를 가장 많이 받는 사람의 name, sal 출력 : emp 테이블
    -- name   sal
        SELECT name, sal
        FROM emp
        WHERE sal = ( SELECT MAX(sal) FROM emp );



-- 출신도(city)별 여자 인원수가 가장 많은 출신도 및 여자 인원수를 출력 : emp 테이블
    -- city   인원수

            SELECT city, COUNT(*) 여자인원수
            FROM emp
            WHERE MOD(SUBSTR(rrn,8,1),2)=0
            GROUP BY city
            HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM emp WHERE MOD(SUBSTR(rrn,8,1),2)=0 GROUP BY city);

-- 부서(dept)별 인원수 및 부서별 인원수가 전체 인원수의 몇 %인지 출력 : emp
    -- dept  인원수  백분율
    SELECT dept, COUNT(*) 인원수, TRUNC(COUNT(*)/( SELECT COUNT(*) FROM emp)*100) "백분율(%)"
    FROM emp
    GROUP BY dept;
    
-- 부서(dept) 직위(pos)별 인원수를 출력하며, 마지막에는 직위별 전체 인원수 출력 : emp 테이블
   -- ROLLUP을 사용하며, 부서별 오름차순 정렬
   -- 출력 예
    dept     pos    인원수
    개발부    과장     2
    개발부    사원     9
    개발부    부장     1
    개발부    대리     2
    기획부    사원     2
         :
             사원    32
             부장    7
             과장    8
             대리    13
    
    SELECT NVL(dept,'(전체)'),NVL(pos,'(전체)'), COUNT(*) 인원수
    FROM emp
    GROUP BY ROLLUP(dept, pos) ;


-- 부서(dept) 직위(pos)별 인원수를 출력 : emp 테이블
    -- 출력 예
dept       부장  과장  대리  사원
총무부    1       2      0      4
개발부    1       2      2      9
            :

    SELECT dept,
            COUNT(DECODE(pos,'부장',1)) 부장,
            COUNT(DECODE(pos,'과장',1)) 과장,
            COUNT(DECODE(pos,'대리',1)) 대리,
            COUNT(DECODE(pos,'사원',1)) 사원
    FROM emp
    GROUP BY dept
    ORDER BY dept;
    


-- 부서(dept) 직위(pos)별 인원수를 출력하고 마지막에 직위별 인원수 출력 : emp 테이블
    -- 출력 예
dept       부장  과장  대리  사원
개발부    1       2      2      9
기획부    2       0      3      2
            :
            7        8     13     32



