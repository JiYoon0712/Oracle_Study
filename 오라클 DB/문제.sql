----- [ 문제풀이 - 김지윤 ] ---

---- ※ SELECT문과 단일행 함수
----Q] sky 계정의 모든 테이블의 목록 출력
        SELECT * FROM TAB;
        
        SELECT * FROM USER_TABLES;
        SELECT * FROM TABS;

--Q] emp 테이블의 컬럼명과 각 컬럼의 타입등 테이블의 구조 출력
        SELECT * FROM COL WHERE TNAME = 'EMP';

--Q] emp 테이블의 모든 자료 출력
        SELECT * FROM emp;

--Q] emp 테이블
--    ㅇ 출력 컬럼 : empNo, name, city, dept, pos, sal, bonus, pay(sal+bonus)
--    ㅇ 조건
--      - pay가 3500000원 이상인 사람만 출력
--      - pay 내림차순으로 정렬하고 pay가 동일하면 sal 내림차순 정렬
        SELECT empNo, name, city, dept, pos, sal, bonus, sal+bonus AS pay
        FROM emp
        WHERE sal+bonus >=3500000
        ORDER BY pay DESC, sal DESC;

--Q] emp 테이블
--    ㅇ 출력 컬럼 : empNo, name, city, dept, pos, sal, bonus
--    ㅇ 조건
--        - city가 서울 사람중에서 name이 김씨와 이씨인 사람만 출력
        SELECT empNo, name, city, dept, pos, sal, bonus
        FROM emp
        WHERE city='서울' AND (name LIKE'김%' OR name LIKE '이%');  -- LIKE 사용 지양

--Q] emp 테이블
--    ㅇ 출력 컬럼 : empNo, name, hireDate
--    ㅇ 조건
--        - 입사년도(hireDate)가 홀수년도인 사람만 출력
        SELECT empNo, name, hireDate
        FROM emp
        WHERE MOD(SUBSTR(hireDate,1,2),2)=1;
    
--Q] emp 테이블
--    ㅇ 출력 컬럼 : empNo, name, hireDate
--    ㅇ 조건
--        - 입사년도(hireDate)가 월요일인 사람만 출력
--        - 입사년도(hireDate)는 "년도4자리-월-일 요일" 형식으로 출력
        --(1)
        SELECT empNo, name, TO_CHAR(hireDate,'YYYY-MM-DD DAY')
        FROM emp
        WHERE SUBSTR(TO_CHAR(hireDate,'YYYY-MM-DD DAY'),12,14)='월요일';
        
        --(2)
        SELECT empNo, name, TO_CHAR(hireDate,'YYYY-MM-DD DAY')
        FROM emp
        WHERE TO_CHAR(hireDate,'DAY')='월요일';
        
        --(강사님)
        SELECT empNo, name, TO_CHAR(hireDate,'YYYY-MM-DD DAY')
        FROM emp
        WHERE TO_CHAR(hireDate,'D')=2;

--Q] emp 테이블 990712-2
--    ㅇ 출력 컬럼 : empNo, name, rrn, birth, age, 근속년수
--    ㅇ 조건
--        - 근속년수가 10년 이상인 사람만 출력
--        - birth는 rrn을 이용하며 년도4자리-월-일 출력
--        - age는 rrn을 이용
--        - 근속년수 내림차순 출력
--        - 근속년수는 hireDate을 이용
           
           WITH tb AS(
            SELECT empNo, name, rrn,
                CASE 
                    WHEN SUBSTR(rrn,8,1) IN(1,2,5,6) THEN TO_DATE('19'||SUBSTR(rrn,1,6),'YYYYMMDD')
                    WHEN SUBSTR(rrn,8,1) IN(3,4,7,8) THEN TO_DATE('20'||SUBSTR(rrn,1,6),'YYYYMMDD')
                    ELSE TO_DATE('18'||SUBSTR(rrn,1,6),'YYYYMMDD')
                END birth
                , TRUNC(MONTHS_BETWEEN(SYSDATE,hireDate)/12) 근속년수
            FROM emp
            )SELECT empNo, name, rrn, TO_CHAR(birth,'YYYY-MM-DD') birth,
                TRUNC(MONTHS_BETWEEN(SYSDATE,birth)/12) age
                , 근속년수
            FROM tb
            ORDER BY 근속년수 DESC;


--Q] emp 테이블
--    ㅇ 출력 컬럼 : empNo, name, city
--    ㅇ 조건 
--       - name이 이씨가 아닌 자료만 출력
        SELECT empNo, name, city
        FROM emp
        WHERE SUBSTR(name,1,1) != '이';
        
        --(강사님)
        SELECT empNo, name, city
        FROM emp
        WHERE INSTR(name,'이') != 1;


--Q] emp 테이블
--    ㅇ 출력 컬럼 : empNo, name, dept, pos
--    ㅇ 조건
--       - 부서(dept)별 오름차순으로 출력하고 부서가 같으면 직위(pos)는 다음순서로 출력
--         부장, 과장, 대리, 사원
        SELECT empNo, name, dept, pos
        FROM emp
        ORDER BY dept,
            CASE pos
                WHEN '부장' THEN 0
                WHEN '과장' THEN 1
                WHEN '대리' THEN 2
                ELSE 3
            END ;
    
--Q] emp 테이블
--    ㅇ 출력 컬럼 :  name, dept, sal, bonus, tot_pay, tax, pay
--    ㅇ 조건
--       - tot_pay = sal+bonus
--       - tax
--         tot_pay가 300만원 이상이면 tot_pay의 3%
--         tot_pay가 250만원 이상이면 tot_pay의 2%
--         그렇지 않으면 0
--         tax는 소수점 첫째자리에서 반올림 한다.
--       - pay = tot_pay - tax
--       - pay는 원화기호를 붙인다.
--       - pay는 일의자리에서 1원 이상이면 무조건 올린다. --  4를 더해서
--         예를 들어 1000002이면 1000010 출력
        WITH tb AS(
            SELECT name, dept, sal, bonus, sal+bonus tot_pay, 
                CASE
                    WHEN sal+bonus >= 3000000 THEN ROUND((sal+bonus)*0.03)
                    WHEN sal+bonus >= 2500000 THEN ROUND((sal+bonus)*0.02)
                    ELSE 0
                END AS tax
            FROM emp
            )
            SELECT name, dept, sal, bonus, tot_pay, tax, 
            TO_CHAR(ROUND((tot_pay-tax)+4,-1), 'L9,999,999') pay
            FROM tb;
    

--Q] emp 테이블
--    ㅇ 출력 컬럼 : empNo, name, dept, pos, 성별
--    ㅇ 조건
--       - dept가 개발부이고 pos가 부장이거나 dept가 총무부이고 pos가 과장인 사람 출력
--       - 성별은 rrn을 이용한다.
        --(1)
        SELECT empNo, name, dept, pos,
            CASE 
                WHEN MOD(SUBSTR(rrn,8,1),2)=1  THEN '남자'
                ELSE '여자'
            END 성별
        FROM emp
        WHERE (dept='개발부' AND pos = '부장') OR (dept='총무부' AND pos = '과장');
      
        --(2)
        SELECT empNo, name, dept, pos,
            CASE 
                WHEN MOD(SUBSTR(rrn,8,1),2)=1  THEN '남자'
                ELSE '여자'
            END 성별
        FROM emp
        WHERE (dept, pos) IN(('개발부','부장'),('총무부','과장'));  


--Q] emp 테이블
--    ㅇ 출력 컬럼 : empNo, name, sal
--    ㅇ 조건
--       - sal가 2500000~3000000은 제외
        
        --(강사님)
        SELECT empNo, name, sal
        FROM emp
        WHERE NOT(sal < 2500000 OR sal > 3000000);

        SELECT empNo, name, sal
        FROM emp
        WHERE NOT(sal >= 2500000 AND sal <= 3000000);   --NOT 부하


--Q] emp 테이블
--    ㅇ 출력 컬럼 :  empNo, name, city
--    ㅇ 조건
--       - city가 '서울', '인천', '경기' 는 제외
--       - city 오름차순
        SELECT empNo, name, city
        FROM emp
        WHERE city NOT IN ('서울', '인천', '경기')
        ORDER BY city;
        
        
--Q] emp 테이블
--    ㅇ 출력 컬럼 :  empNo, name, sal
--    ㅇ 조건
--       - sal 내림차순 정렬하여 11번째에서 20번째 레코드만 출력
        
        SELECT empNo, name, sal FROM(
            SELECT ROWNUM rnum, tb.* FROM(
                SELECT empNo, name, sal
                FROM emp
                ORDER BY sal DESC
            )tb WHERE ROWNUM <=20
        )WHERE rnum >=11;
   
    --> ROWNUM : WHERE 절에서 크다로 비교 X , 1이상의 값과 같다 비교 X

--Q] emp 테이블
--    ㅇ 출력 컬럼 :  empNo, name, sal
--    ㅇ 조건
--       - 이름(성포함)에 '한' 이라는 단어가 포함되어 있는 모든 사람 출력
      SELECT empNo, name, sal
      FROM emp
      WHERE INSTR(name, '한') > 0;


--Q] emp 테이블
--    ㅇ 출력 컬럼 :  dept, pos
--    ㅇ dept, pos를 중복을 배제하여 출력
        SELECT DISTINCT dept, pos
        FROM emp;
        
--Q] emp 테이블
--    ㅇ 출력 컬럼 : name, city
--    ㅇ LIKE를 이용하여 이씨가 아닌 자료만 출력
        SELECT name, city
        FROM emp
        WHERE name NOT LIKE ('이%');
        
--Q] emp 테이블
--    ㅇ 출력 컬럼 : name, city
--    ㅇ INSTR를 이용하여 이씨가 아닌 자료만 출력
        SELECT name, city
        FROM emp
        WHERE INSTR(name,'이') != 1;


--Q] emp 테이블
--    ㅇ 출력 컬럼 : name, rrn, dept, sal
--    ㅇ 남자를 먼저 출력하고 여자를 출력하며 성별이 같으면 sal 오름차순으로 출력
        SELECT name, rrn, dept, sal
        FROM emp
        ORDER BY MOD(SUBSTR(rrn,8,1),2) DESC, sal;
        
        
--Q] emp 테이블
--    ㅇ 출력 컬럼 : name, hireDate
--    ㅇ city가 서울인 사람 중 근무 개월 수가 60개월 이상인 사람만 출력
        SELECT name,hireDate
        FROM emp
        WHERE city = '서울' AND MONTHS_BETWEEN(SYSDATE, hireDate)>=60;
        
--Q] emp 테이블
--    ㅇ 출력 컬럼 : name, city, tel
--    ㅇ tel이 NULL인 자료만 출력
        SELECT name, city, tel
        FROM emp
        WHERE tel IS NULL;
    
    
--Q] emp 테이블
--    ㅇ 출력 컬럼 : name, city, tel
--    ㅇ tel이 NULL인 경우 '000-0000-0000' 으로 출력
        SELECT name,city, NVL(tel,'000-0000-0000') tel
        FROM emp;     
        
--Q] emp 테이블
--    ㅇ 출력 컬럼 : name, city, tel
--    ㅇ tel이 NULL이 아닌 자료만 출력
        SELECT name, city, tel
        FROM emp
        WHERE tel IS NOT NULL;
        
--Q] emp 테이블
--    ㅇ 출력 컬럼 : name, city, tel
--    ㅇ tel이 null인 자료를 먼저 출력
        SELECT name, city, tel
        FROM emp
        ORDER BY tel NULLS FIRST;
        
--Q] emp 테이블
--    ㅇ 출력 컬럼 : name, hireDate
--    ㅇ 입사일자가 월요일인 사람만 출력
        SELECT name, TO_CHAR(hireDate,'YYYY-MM-DD DAY')
        FROM emp
        WHERE TO_CHAR(hireDate,'DAY') = '월요일'; 
         
        --(2)        
        SELECT name, TO_CHAR(hireDate,'YYYY-MM-DD DAY')
        FROM emp
        WHERE TO_CHAR(hireDate,'D') = 2;
        
        --(3)
        SELECT name, TO_CHAR(hireDate,'YYYY-MM-DD DAY')
        FROM emp
        WHERE TO_CHAR(hireDate,'DY') = '월';
        
--Q] emp 테이블
--    ㅇ 출력 컬럼 : name, hireDate
--    ㅇ 입사일자의 일자가 1일~5일인 사람만 출력
        SELECT name, hireDate
        FROM emp
        WHERE TO_CHAR(hireDate,'DD')<=5;
        
        
--Q] dual 테이블
--    ㅇ 출력 컬럼 : 차이
--    ㅇ 현재시간에서 '2023-04-12 09:00:00' 까지의 차이를 분으로 환산하여 출력
        SELECT TRUNC((TO_DATE('2023-04-12 09:00:00','YYYY-MM-DD HH24:MI:SS')-SYSDATE)*24*60)||'분' 차이
        FROM dual;
        
--Q] dual 테이블
--    ㅇ 출력 컬럼 : 시작날짜
--    ㅇ 다음달 시작날자 출력(다음달 1일 0시 0분 0초)
--    ㅇ 출력 예 : 2023/04/01 00:00:00
        SELECT TO_CHAR(TRUNC((SYSDATE+(INTERVAL '1'MONTH)),'MONTH'),'YYYY-MM-DD HH24:MI:SS') 시작날짜
        FROM dual;
   
        --(강사님)
        SELECT TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE,1),'MM'),'YYYY-MM-DD HH24:MI:SS') 시작날짜
        FROM dual;    
--Q] tbs 테이블
--    ㅇ 출력 컬럼 : name, tel
--    ㅇ 다음 쿼리에서 name은 첫글자와 마지막 글자를 제외한 나머지 글자는 *로 치환하여 출력하도록 쿼리를 수정
--       : "김호" 처럼 이름이 두자인 경우는 "김*호" 처럼 출력하고 나머지는 해당 글자만큼 *로 치환한다.
--       : "김호호김"은 "김**김"처럼 출력한다.
           
           
     -- NVL 사용해서 다시 풀어보기 --       
WITH tbs AS (
   SELECT '김호' name, '010-1234-4125' tel FROM dual UNION ALL
   SELECT '나대한민국' name, '010-1234-6524' tel FROM dual UNION ALL
   SELECT '스프링' name, '010-485-8574' tel FROM dual UNION ALL
   SELECT '홍길동' name, '02-235-4125' tel FROM dual UNION ALL
   SELECT '미미' name, '031-4582-4125' tel FROM dual
)
SELECT
CASE 
    WHEN LENGTH(name)<=2 THEN SUBSTR(name,1,1)||'*'||SUBSTR(name,LENGTH(name),1)
    WHEN LENGTH(name)>2 THEN SUBSTR(name,1,1)||LPAD('*',LENGTH(name)-2,'*')||SUBSTR(name,LENGTH(name),1)
END 이름

, tel FROM tbs;




--Q] tbs 테이블
--    ㅇ 출력 컬럼 : name, tel
--    ㅇ 다음 쿼리에서 tel의 국번을 자리수 만큼 *로 치환하여 출력하도록 쿼리를 수정한다.
--    ㅇ 예를 들어 "010-1111-1111"는 "010-****-1111"로 출력한다.       

WITH tbs AS (
   SELECT '김호' name, '010-1234-4125' tel FROM dual UNION ALL
   SELECT '나대한민국' name, '010-1234-6524' tel FROM dual UNION ALL
   SELECT '스프링' name, '011-485-8574' tel FROM dual UNION ALL
   SELECT '홍길동' name, '02-235-4125' tel FROM dual UNION ALL
   SELECT '미미' name, '031-4582-4125' tel FROM dual
)
SELECT name, 
SUBSTR(tel,1,INSTR(tel,'-'))||TRANSLATE(SUBSTR(tel,INSTR(tel,'-',1,1)+1,INSTR(tel,'-',1,2)- INSTR(tel,'-',1,1)-1),'0123456789','**********')
|| SUBSTR(tel,INSTR(tel,'-',1,2)) "국번을 *로 치환한 번호"
FROM tbs;

--Q] emp 테이블
--    ㅇ 출력 컬럼 : name, rrn
--    ㅇ rrn은 성별 다음부터는 *로 출력
--       SUBSTR(), LPAD() 함수를 이용
--    ㅇ rrn은 성별 다음부터는 *로 출력. 예를 들어 "010101-1111111" 은 "010101-1******"      
        SELECT name,
            RPAD(SUBSTR(rrn,1,8),14,'*')
        FROM emp;

--Q] emp 테이블
--    ㅇ 출력 컬럼 : name, tel
--    ㅇ tel 의 전화번호 구분자(-)는 출력하지 않는다.
        SELECT name, REPLACE(tel,'-')
        FROM emp;