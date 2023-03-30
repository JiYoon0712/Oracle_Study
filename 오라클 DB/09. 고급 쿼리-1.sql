-- ■ 고급 쿼리
 -- ※ 계층형 질의(Hierarchical Query)
   -- ο 계층적 쿼리 : 계층적 구조로 결과를 반환
     -------------------------------------------------------
     -- 상위에서 하위로 출력  --> LEVEL : 예약어
     SELECT num, subject, LEVEL, parent
     FROM soft
     START WITH num = 1
     CONNECT BY PRIOR num = parent; -- 계층 관계 지정
                -- 컬럼(num) = 상위정보를 가진 컬럼(parent)

     SELECT num, LPAD(' ',(LEVEL-1)*4) || subject subject, LEVEL, parent
     FROM soft
     START WITH num = 1
     CONNECT BY PRIOR num = parent; 
     
     SELECT num, LPAD(' ',(LEVEL-1)*4) || subject subject, LEVEL, parent
     FROM soft
     START WITH num = 1
     CONNECT BY parent= PRIOR num ;  

     SELECT num, subject, LEVEL, parent
     FROM soft
     START WITH num = 10
     CONNECT BY PRIOR num = parent;
     -------------------------------------------------------
     -- 하위에서 상위로 출력
     SELECT num, LPAD(' ',(LEVEL-1)*4) || subject subject, LEVEL, parent
     FROM soft
     START WITH num = 15
     CONNECT BY PRIOR parent=  num ;     
     
     -------------------------------------------------------
     -- 정렬
     SELECT num, subject, LEVEL, parent
     FROM soft
     START WITH num = 1
     CONNECT BY PRIOR num = parent
     ORDER BY subject;  -- 계층 구조가 깨짐

     -- 같은 레벨에 있는 항목만 정렬
     SELECT num, subject, LEVEL, parent
     FROM soft
     START WITH num = 1
     CONNECT BY PRIOR num = parent
     ORDER SIBLINGS BY subject; 

     -------------------------------------------------------
     -- 조건
     SELECT num, subject, LEVEL, parent
     FROM soft
     WHERE num !=3
     START WITH num = 1
     CONNECT BY PRIOR num = parent; 
        -- 데이터베이스만 출력 안됨(데이터베이스 하위는 출력)
        -- WHERE 절이 마지막에 평가
        
     SELECT num, subject, LEVEL, parent
     FROM soft
     START WITH num = 1
     CONNECT BY PRIOR num = parent AND num !=3;
        -- 데이터베이스와 데이터베이스하위도 출력되지 않는다.
        
     -------------------------------------------------------
     -- LEVEL : 계층적 질의에서 검색된 결과에 대한 레벨번호(1부터 시작). CONNECT BY 절이 있는 경우만 사용 가능     
     SELECT LEVEL v FROM dual CONNECT BY LEVEL <=20;
        -- 1 ~ 20 까지 출력
        
     -- 2023-03-01 ~ 2023-03-07
     SELECT TO_DATE('20230301','YYYYMMDD') + LEVEL-1 FROM dual CONNECT BY LEVEL <=7;
     
     
     
 -- ※ PIVOT과 UNPIVOT
   -- ο PIVOT 절
     -------------------------------------------------------
     -- 예제
      WITH temp_table AS (
         SELECT 1 cnt, 1000 price FROM DUAL UNION ALL
         SELECT 2 cnt, 1050 price FROM DUAL UNION ALL
         SELECT 3 cnt, 2100 price FROM DUAL UNION ALL
         SELECT 1 cnt, 5500 price FROM DUAL UNION ALL
         SELECT 2 cnt, 7000 price FROM DUAL UNION ALL
         SELECT 3 cnt, 7000 price FROM DUAL
     )
     SELECT cnt, SUM(price) price
     FROM temp_table
     GROUP BY cnt;

    -- 행열 변환
      WITH temp_table AS (
         SELECT 1 cnt, 1000 price FROM DUAL UNION ALL
         SELECT 2 cnt, 1050 price FROM DUAL UNION ALL
         SELECT 3 cnt, 2100 price FROM DUAL UNION ALL
         SELECT 1 cnt, 5500 price FROM DUAL UNION ALL
         SELECT 2 cnt, 7000 price FROM DUAL UNION ALL
         SELECT 3 cnt, 7000 price FROM DUAL
     )
     SELECT SUM(DECODE(cnt,1,price,0))"1",
            SUM(DECODE(cnt,2,price,0))"2",
            SUM(DECODE(cnt,3,price,0))"3"
     FROM temp_table;
     
    -- PIVOT : 서브쿼리만 가능  
       WITH temp_table AS (
         SELECT 1 cnt, 1000 price FROM DUAL UNION ALL
         SELECT 2 cnt, 1050 price FROM DUAL UNION ALL
         SELECT 3 cnt, 2100 price FROM DUAL UNION ALL
         SELECT 1 cnt, 5500 price FROM DUAL UNION ALL
         SELECT 2 cnt, 7000 price FROM DUAL UNION ALL
         SELECT 3 cnt, 7000 price FROM DUAL
     )
     SELECT *
     FROM(
        SELECT cnt, price FROM temp_table
     )
     PIVOT (
        SUM(price) FOR cnt IN (1,2,3)
     );
   
   ----------------------------------------------------------  
   -- 부서별 출신도 인원수
      SELECT dept, city, COUNT(*)
      FROM emp
      GROUP BY dept, city
      ORDER BY dept;
     
    -- PIVOT
       SELECT * FROM (
          SELECT city, dept
          FROM emp  
       )
       PIVOT(
          COUNT(dept) FOR dept IN (
            '개발부' AS 개발부 ,
            '기획부' AS 기획부 ,
            '영업부' AS 영업부 ,
            '인사부' AS 인사부 ,
            '자재부' AS 자재부 ,
            '총무부' AS 총무부 ,
            '홍보부' AS 홍보부
          )
       );
     
      -- 년도에 대한 월별 판매현황
         SELECT TO_CHAR(sDate, 'YYYY')년도, TO_CHAR(sDate, 'MM') 월,
                SUM(bPrice *qty) amt
         FROM book b
         JOIN dsale d ON b.bCode = d.bCode
         JOIN sale s ON d.sNum = s.sNum
         GROUP BY TO_CHAR(sDate,'YYYY'), TO_CHAR(sDate,'MM')
         ORDER BY 년도, 월;
         
         --
         SELECT * FROM(
            SELECT TO_CHAR(sDate, 'YYYY')년도, TO_NUMBER(TO_CHAR(sDate, 'MM')) 월, (bPrice *qty) amt
             FROM book b
             JOIN dsale d ON b.bCode = d.bCode
             JOIN sale s ON d.sNum = s.sNum
         )
         PIVOT(
             SUM(amt) FOR 월 IN (1,2,3,4,5,6,7,8,9,10,11,12)
         );
        
        -- 
        SELECT NVL(m01,0) m01, NVL(mo2,0) mo2, NVL(mo3,0) mo3, NVL(mo4,0) mo4, NVL(m05,0) m05, NVL(mo6,0) mo6, 
                NVL(mo7,0) mo7, NVL(mo8,0) mo8, NVL(mo9,0) mo9, NVL(m10,0) m10, NVL(m11,0) m11, NVL(m12,0) m12
        FROM(
            SELECT TO_CHAR(sDate, 'YYYY')년도, TO_NUMBER(TO_CHAR(sDate, 'MM')) 월, (bPrice *qty) amt
             FROM book b
             JOIN dsale d ON b.bCode = d.bCode
             JOIN sale s ON d.sNum = s.sNum
         )
         PIVOT(
             SUM(amt) FOR 월 IN (1 m01, 2 mo2, 3 mo3, 4 mo4, 5 m05, 6 mo6,
                                 7 mo7, 8 mo8, 9 mo9, 10 m10, 11 m11, 12 m12 )
         );     
     
     
      -- 요일별 판매건수
         일 월 ... 토
         
         SELECT * FROM (
            SELECT TO_CHAR(sDate, 'D')요일
             FROM sale
         )
         PIVOT(
            COUNT(*) 
            FOR 요일 IN (1 일, 2 월, 3 화, 4 수, 5 목, 6 금, 7 토)
         );
         
     
     
   -- ο UNPIVOT 절
     -------------------------------------------------------
     --
       CREATE TABLE tcity AS 
       SELECT * FROM (
          SELECT city, dept
          FROM emp  
       )
       PIVOT(
          COUNT(dept) FOR dept IN (
            '개발부' AS 개발부 ,
            '기획부' AS 기획부 ,
            '영업부' AS 영업부 ,
            '인사부' AS 인사부 ,
            '자재부' AS 자재부 ,
            '총무부' AS 총무부 ,
            '홍보부' AS 홍보부
          )
       );     
       
       SELECT * FROM tcity;
        
    ---------------------------------------------------
    -- UNPIVOT : 컬럼 단위를 행 단위로 변경
    SELECT * FROM tcity
    UNPIVOT
    (
        인원수
        FOR 부서 IN (개발부, 기획부, 영업부, 인사부, 자재부, 총무부, 홍보부)
    );
    

    
    