-- ■ 조인과 서브 쿼리
 -- ※ 조인(joins)
   -- ο INNER JOIN
       -- 실습 테이블
         -- 분류 테이블(분류코드, 분류명, 상위분류코드)
            SELECT bcCode, bcSubject, pcCode FROM bclass;

         -- 출판사 테이블(출판사번호, 출판사명, 전화번호)
            SELECT pNum, pName, pTel FROM pub;

         -- 책 테이블(서적코드, 서적명, 가격, 분류코드, 출판사번호)
            SELECT bCode, bName, bPrice, bcCode, pNum FROM book;

         -- 저자 테이블(저자번호, 서적코드, 저자명)
            SELECT aNum, bCode, aName FROM author;

         -- 고객 테이블(고객번호, 고객명, 전화번호)
            SELECT cNum, cName, cTel FROM cus;

         -- 회원 테이블(고객번호, 회원아이디, 회원패스워드, 이메일)
            SELECT cNum, userId, userPwd, userEmail FROM member;
    
         -- 판매 테이블(판매번호, 판매일자, 고객번호)
            SELECT sNum, sDate, cNum FROM sale;

         -- 판매 상세 테이블(판매상세번호, 판매번호, 서적코드, 판매수량)
            SELECT dNum, sNum, bCode, qty FROM dsale;
            
            
      -------------------------------------------------------
     -- 1) EQUI JOIN  >> 다 = 으로 표시해서!
        -- 형식 1
           SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명 ....
           FROM 테이블명1, 테이블명2
           WHERE 테이블명1.컬럼명 = 테이블명2.컬럼명  [AND 조건]
        ------------------------------------------------------
        -- 판매현황 : 책코드(bCode), 책이름(bName), 책가격(bPrice), 출판사번호(pNum),
                    출판사이름(pName), 판매일자(sDate), 구매고객번호(cNum),
                    구매고객이름(cName), 판매수량(qty), 금액(bPrice * qty)

            book  : bCode, bName, bPrice, pNum
            pub   : pNum, pName 
            dsale : sNum, bCOde, qty
            sale  : sNum, sDate, cNum
            cus   : cNum, cName
        
            SELECT b.bCode, bName, bPrice, pNum, pName, sDate, c.cNum, cName, qty, bPrice*qty amt
            FROM book b, pub p, dsale d, sale s, cus c
            WHERE b.pNum = p.pNum AND b.bCode = d.bCode AND d.sNum = s.sNum AND s.cNum=c.cNum; 
                -- 에러 : ORA-00918: 열의 정의가 애매합니다. >> pNum -> p.pNum으로 변경해야 함.

            SELECT b.bCode, bName, bPrice, p.pNum, pName, sDate, c.cNum, cName, qty, bPrice*qty amt
            FROM book b, pub p, dsale d, sale s, cus c
            WHERE b.pNum = p.pNum AND b.bCode = d.bCode AND d.sNum = s.sNum AND s.cNum=c.cNum; 
         
  

        -- 형식 2
           SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명 ....
           FROM 테이블명1
           [ INNER ] JOIN 테이블명2 ON 테이블명1.컬럼명 = 테이블명2.컬럼명
        -------------------------------------------------------
        -- 
        SELECT b.bCode, bName, bPrice, p.pNum, pName, sDate, c.cNum, cName, qty, bPrice*qty amt
        FROM book b
        JOIN pub p ON b.pNum = p.pNum
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum
        JOIN cus c ON s.cNum = c.cNum;
 

        -- 형식 3
           SELECT 컬럼명, 컬럼명
           FROM 테이블명1
           JOIN 테이블명2 USING (컬럼명1)
           JOIN 테이블명3 USING (컬럼명2);

        -------------------------------------------------------
        --
          SELECT bCode, bName, bPrice, pNum, pName, sDate, cNum, cName, qty, bPrice*qty amt
          FROM book
          JOIN pub USING(pNum)
          JOIN dsale USING(bCode)
          JOIN sale USING(sNum)
          JOIN cus USING(cNum);

     ----------------------------------------------------------
     -- 서울 서점(cNum=2)의 판매 현황
         SELECT b.bCode, bName, bPrice, p.pNum, pName, sDate, c.cNum, cName, qty, bPrice*qty amt
         FROM book b, pub p, dsale d, sale s, cus c
         WHERE b.pNum = p.pNum AND b.bCode = d.bCode AND d.sNum = s.sNum AND s.cNum=c.cNum
               AND c.cNum=2; 
            
     
         SELECT b.bCode, bName, bPrice, p.pNum, pName, sDate, c.cNum, cName, qty, bPrice*qty amt
         FROM book b
         JOIN pub p ON b.pNum = p.pNum
         JOIN dsale d ON b.bCode = d.bCode
         JOIN sale s ON d.sNum = s.sNum
         JOIN cus c ON s.cNum = c.cNum
         WHERE c.cNum=2;
     
     -- 판매된 책코드(bCode), 책이름(bName), 판매권수의 합 : 책코드 오름차순 출력
        -- book(bCode, bName), dsale(bCode, qty)
         SELECT b.bCode, bName, SUM(qty)
         FROM book b
              JOIN dsale d ON b.bCode = d.bCode
         GROUP BY b.bCode, bName
         ORDER BY b.bcode;
     
     -- 판매된 책코드(bCode), 책이름(bName), 판매권수의 합, 판매금액의 합 : 책코드 오름차순 출력
        -- book(bCode, bName, bPrice) , dsale(bCode, qty)
        
        SELECT b.bCode, bName, SUM(qty) 수량, SUM(qty*bPrice) 금액
        FROM book b
              JOIN dsale d ON b.bCode = d.bCode
        GROUP BY b.bCode, bName, bPrice
        ORDER BY b.bcode;
        
     
      -- 판매된 책코드(bCode), 책이름(bName), 판매권수의 합, 판매금액의 합 : 판매권수의 합이 80권 이상인 책만 출력
          
        SELECT b.bCode, bName, SUM(qty) 수량, SUM(qty*bPrice) 금액
        FROM book b
              JOIN dsale d ON b.bCode = d.bCode
        GROUP BY b.bCode, bName, bPrice
        HAVING SUM(qty) >=80;
     
     
      -- 판매된 책코드(bCode), 책이름(bName):중복 배제
        --(1)
         SELECT DISTINCT b.bCode, bName
         FROM book b
            JOIN dsale d ON b.bCode = d.bCode 
         ORDER BY b.bCode;
        
        --(2) 
         SELECT bCode, bName
         FROM book
         WHERE bCode IN (SELECT bCode FROM dsale);
         
     
      -- 판매된 책코드(bCode), 책이름(bName), 판매권수의 합 : 판매권수의 합이 가장 큰 책 출력
            -- book(bCode, bName, bPrice) , dsale(bCode, qty)
            SELECT b.bCode, bName, SUM(qty)
            FROM book b
                  JOIN dsale d ON b.bCode = d.bCode
            GROUP BY b.bCode, bName
            ORDER BY b.bcode;
                   
            
            SELECT b.bCode, bName, SUM(qty) 판매권수,
                RANK() OVER(ORDER BY SUM(qty) DESC) 순위
            FROM book b
                  JOIN dsale d ON b.bCode = d.bCode
            GROUP BY b.bCode, bName;
        
        -- 방법 1        
            SELECT bCode, bName, 판매권수 FROM(
                SELECT b.bCode, bName, SUM(qty) 판매권수,
                    RANK() OVER(ORDER BY SUM(qty) DESC) 순위
                FROM book b
                      JOIN dsale d ON b.bCode = d.bCode
                GROUP BY b.bCode, bName
            ) WHERE 순위 =1;
           
          -- 방법 2
            SELECT b.bCode, bName, SUM(qty) 판매권수
            FROM book b
                  JOIN dsale d ON b.bCode = d.bCode
            GROUP BY b.bCode, bName
            HAVING SUM(qty) = (
                SELECT MAX(SUM(qty))
                FROM book b1
                  JOIN dsale d1 ON b1.bCode = d1.bCode
                GROUP BY b1.bCode, bName
            );
                
      
      -- 올해의 판매현황 출력
        -- 책코드(bCode), 책이름(bName), 책가격(bPrice), 출판사번호(pName),
        -- 출판사이름(pName), 판매일자(sDate), 구매고객번호(cNum),
        -- 구매고객이름(cName), 판매수량(qty), 금액(bPrice*qty)
            SELECT b.bCode, bName, bPrice, p.pNum, pName, sDate, c.cNum, cName, qty, bPrice*qty amt
            FROM book b
                JOIN pub p ON b.pNum = p.pNum
                JOIN dsale d ON b.bCode = d.bCode
                JOIN sale s ON d.sNum = s.sNum
                JOIN cus c ON s.cNum = c.cNum
            WHERE TO_CHAR(sDate,'YYYY') = TO_CHAR(SYSDATE,'YYYY');
            
      
            SELECT b.bCode, bName, bPrice, p.pNum, pName, sDate, c.cNum, cName, qty, bPrice*qty amt
            FROM book b
                JOIN pub p ON b.pNum = p.pNum
                JOIN dsale d ON b.bCode = d.bCode
                JOIN sale s ON d.sNum = s.sNum
                JOIN cus c ON s.cNum = c.cNum
            WHERE EXTRACT(YEAR FROM sDate) = EXTRACT(YEAR FROM SYSDATE);
      
      -- 작년의 판매현황 출력
        -- 책코드(bCode), 책이름(bName), 책가격(bPrice), 출판사번호(pName),
        -- 출판사이름(pName), 판매일자(sDate), 구매고객번호(cNum),
        -- 구매고객이름(cName), 판매수량(qty), 금액(bPrice*qty)
            
            SELECT b.bCode, bName, bPrice, p.pNum, pName, sDate, c.cNum, cName, qty, bPrice*qty amt
            FROM book b
                JOIN pub p ON b.pNum = p.pNum
                JOIN dsale d ON b.bCode = d.bCode
                JOIN sale s ON d.sNum = s.sNum
                JOIN cus c ON s.cNum = c.cNum
            WHERE TO_CHAR(sDate,'YYYY') = TO_CHAR(SYSDATE,'YYYY')-1;
      
      -- 년도별 판매금액의 합 : 년도, 판매금액합(년도 오름차순 출력)
         SELECT EXTRACT(YEAR FROM sDate) 년도, SUM(qty*bPrice) 금액합
         FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            JOIN sale s ON d.sNum = s.sNum
         GROUP BY EXTRACT(YEAR FROM sDate)  -- >  GROUP BY sDate로 하면 안됨!!!!!!!!!!
         ORDER BY 년도;
         
         SELECT TO_CHAR(sDate,'YYYY') 년도, SUM(qty*bPrice) 금액합
         FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            JOIN sale s ON d.sNum = s.sNum
         GROUP BY TO_CHAR(sDate,'YYYY')
         ORDER BY 년도;


      -- 고객번호(cNum), 고객명(cName), 년도, 판매금액합 :고객의 판매현황(고객번호 오름차순, 년도 오름차순)
        SELECT s.cNum, cName, TO_CHAR(sdate,'YYYY') 년도 , SUM(qty* bPrice) amt
        FROM book b
             JOIN pub p ON b.pNum = p.pNum
             JOIN dsale d ON b.bCode = d.bCode
             JOIN sale s ON d.sNum = s.sNum
             JOIN cus c ON s.cNum = c.cNum
        GROUP BY s.cNum, cName, TO_CHAR(sdate,'YYYY')
        ORDER BY s.cNum, 년도;
      
     
      -- 고객번호(cNum), 고객명(cName), 년도, 판매금액합 :고객의 작년과 올해의 판매현황
        SELECT s.cNum, cName, TO_CHAR(sdate,'YYYY') 년도 , SUM(qty* bPrice) amt
        FROM book b
             JOIN pub p ON b.pNum = p.pNum
             JOIN dsale d ON b.bCode = d.bCode
             JOIN sale s ON d.sNum = s.sNum
             JOIN cus c ON s.cNum = c.cNum
        WHERE TO_CHAR(SYSDATE,'YYYY') - TO_CHAR(sdate,'YYYY') <=1
        GROUP BY s.cNum, cName, TO_CHAR(sdate,'YYYY')
        ORDER BY s.cNum, 년도;

     
      -- 고객번호(cNum), 고객명(cName), 날짜(YYYYMM), 판매금액합 : 고객의 이번달 판매현황
        SELECT s.cNum, cName, TO_CHAR(sdate,'YYYYMM') 년월 , SUM(qty* bPrice) amt
        FROM book b
             JOIN pub p ON b.pNum = p.pNum
             JOIN dsale d ON b.bCode = d.bCode
             JOIN sale s ON d.sNum = s.sNum
             JOIN cus c ON s.cNum = c.cNum
        WHERE TO_CHAR(SYSDATE,'YYYYMM') = TO_CHAR(sdate,'YYYYMM')
        GROUP BY s.cNum, cName, TO_CHAR(sdate,'YYYYMM')
        ORDER BY s.cNum, 년월;


      
      -- 고객번호(cNum), 고객명(cName), 날짜(YYYYMM), 판매금액합 : 고객의 전달 판매현황
      -- > INTERVAL 쓰면 안됨
        SELECT TO_DATE('20230320','YYYYMMDD') - (INTERVAL '1' MONTH) FROM dual;
                -- 2023-02-20
                
        SELECT TO_DATE('20230331','YYYYMMDD') - (INTERVAL '1' MONTH) FROM dual;
                -- 에러. > 2월31일은 없음
                
        SELECT  ADD_MONTHS(TO_DATE('20230331','YYYYMMDD'),-1) FROM dual;
                -- 2023-02-28         
        
        SELECT s.cNum, cName, TO_CHAR(sdate,'YYYYMM') 년월 , SUM(qty* bPrice) amt
        FROM book b
             JOIN pub p ON b.pNum = p.pNum
             JOIN dsale d ON b.bCode = d.bCode
             JOIN sale s ON d.sNum = s.sNum
             JOIN cus c ON s.cNum = c.cNum
        WHERE TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM') = TO_CHAR(sdate,'YYYYMM')
        GROUP BY s.cNum, cName, TO_CHAR(sdate,'YYYYMM')
        ORDER BY s.cNum, 년월;
         -- >  TO_CHAR(SYSDATE,'YYYYMM')-1 = TO_CHAR(sdate,'YYYYMM') 절대 안돼. 202301이면 202300으로 됨
     
        
        -- 고객번호(cNum), 고객이름(cName) : 작년 누적판매금액이 가장 많은 고객 출력
            
            SELECT cNum, cName, 판매금액 FROM (
                SELECT s.cNum, c.cName,SUM(qty*bPrice)판매금액, RANK() OVER(ORDER BY SUM(qty*bPrice) DESC) 순위
                FROM  book b
                     JOIN dsale d ON b.bCode = d.bCode
                     JOIN sale s ON d.sNum = s.sNum
                     JOIN cus c ON s.cNum = c.cNum
                 WHERE TO_CHAR(sDate, 'YYYY') = TO_CHAR(SYSDATE,'YYYY')-1
                 GROUP BY s.cNum, c.cName
            ) WHERE 순위 = 1;
        
 

     -- 2) NATURAL JOIN :  두 테이블의 동일한 이름을 가진 컬럼을 모두 조인. 동일한 컬럼을 내부적으로 찾으므로 별명주면 에러
        -- 형식
           SELECT 컬럼명, 컬럼명 ....
           FROM 테이블명1
           NATURAL JOIN  테이블명2

        -------------------------------------------------------
        --
            SELECT bCode, bName, bPrice, pNum, pName, sDate, cNum, cName, qty, bPrice*qty amt
            FROM book
            NATURAL JOIN pub
            NATURAL JOIN dsale
            NATURAL JOIN sale
            NATURAL JOIN cus;
            

     -- 3) CROSS JOIN : 상호 조인. 카티션 곱
        -------------------------------------------------------
        -- 
        SELECT p.pNum, pName, bCode, bName
        FROM pub p
        CROSS JOIN book b;


     -- 4) SELF JOIN
        -------------------------------------------------------
        -- bcalss : 대분류명, 중분류명
            -- bcCode, bcSubject, pcCode
        SELECT * FROM bclass;
        
        SELECT b1.bcCode, b1.bcSubject, b1.pcCode, b2.bcCode, b2.bcSubject, b2.pcCode
        FROM bclass b1
        JOIN bclass b2 ON b1.bcCode = b2.pcCode;
        
        SELECT b1.bcCode, b1.bcSubject, b2.bcCode, b2.bcSubject
        FROM bclass b1
        JOIN bclass b2 ON b1.bcCode = b2.pcCode;

        -- author 테이블
        SELECT a1.bCode, a1.aName, a2.aName
        FROM author a1
        JOIN author a2 ON a1.bCode = a2.bCode
        ORDER BY a1.bCode;
        
        -- author 테이블 : 저자가 두명 이상인 경우
        SELECT a1.bCode, a1.aName, a2.aName
        FROM author a1
        JOIN author a2 ON a1.bCode = a2.bCode AND a1.aName > a2.aName
        ORDER BY a1.bCode;
        
        -- 저자가 두명 이상인 책 목록
            SELECT bCode, bName
            FROM book
            WHERE bCode IN (
                SELECT a1.bCode
                FROM author a1
                JOIN author a2 ON a1.bCode = a2.bCode AND a1.aName > a2.aName
            );
        

     -- 5) NON-EQUI JOIN            >> 사용빈도 낮음 필요없어 퉤
        -- 형식
            SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명 ....
            FROM 테이블명1, 테이블명2..
            WHERE (non-equi-join 조건)

        -------------------------------------------------------
        -- EQUI JOIN
            SELECT s.sNum, bCode, cNum, sDate, qty
            FROM sale s
            JOIN dsale d ON s.sNum = d.sNum;
        
        -- NON-EQUI JOIN  >> = 을 안써
            SELECT s.sNum, bCode, cNum, sDate, qty
            FROM sale s
            JOIN dsale d ON s.sNum > 10;



-- 중요해.
   -- ο OUTER JOIN
     -- 1) LEFT OUTER JOIN
       -- 형식1
           SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명
           FROM 테이블명1, 테이블명2
           WHERE 테이블명1.컬럼명=테이블명2.컬럼명(+);
           
        -------------------------------------------------------
        -- book(bCode, bName), dsale(bCode, sNum, qty)
        -- EQUI JOIN
            SELECT b.bCode, bName, sNum, qty
            FROM book b, dsale d
            WHERE b.bCode = d.bCode;
            
            
        -- LEFT OUTER JOIN
            SELECT b.bCode, bName, sNum, qty
            FROM book b, dsale d
            WHERE b.bCode = d.bCode(+);
        
     
       -- 형식2
          SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명
          FROM 테이블명1
          LEFT OUTER JOIN 테이블명2 ON 테이블명1.컬럼명=테이블명2.컬럼명;

        ------------------------------------------------------- 
        -- book(bCode, bName), dsale(bCode, sNum, qty)
        -- EQUI JOIN
            SELECT b.bCode, bName, sNum, qty
            FROM book b
            JOIN dsale d ON b.bCode = d.bCode;  
            
        -- LEFT OUTER JOIN
            SELECT b.bCode, bName, sNum, qty
            FROM book b
            LEFT OUTER JOIN dsale d ON b.bCode = d.bCode;
            
            
--?????????????????????????????????????????????????????????????????
            SELECT b.bCode, bName, d.sNum, sDate, qty
            FROM book b
            LEFT OUTER JOIN dsale d ON b.bCode = d.bCode
            LEFT OUTER JOIN sale s ON d.sNum = s.sNum;




     -- 2) RIGHT OUTER JOIN
       -- 형식1
           SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명
           FROM 테이블명1, 테이블명2
           WHERE 테이블명1.컬럼명(+)=테이블명2.컬럼명;
           
        -------------------------------------------------------   
        -- book(bCode, bName), dsale(bCode, sNum, qty)    
        -- RIGHT OUTER JOIN
            SELECT b.bCode, bName, sNum, qty
            FROM book b, dsale d
            WHERE d.bCode(+) = b.bCode;
           

       -- 형식2
          SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명
          FROM 테이블명1
          RIGHT OUTER JOIN 테이블명2 ON 테이블명1.컬럼명=테이블명2.컬럼명;

        -------------------------------------------------------
        -- book(bCode, bName), dsale(bCode, sNum, qty)    
        -- RIGHT OUTER JOIN
            SELECT b.bCode, bName, sNum, qty
            FROM dsale d
            RIGHT OUTER JOIN book b ON b.bCode = d.bCode;
            
        --------------------------------------------------------
        -- bCode, bName, qty 출력
          -- 판매가 되지 않은 bCode, bName도 출력
          -- qty가 NULL인 경우 0으로 출력
            SELECT b.bCode, bName, NVL(qty,0) qty
            FROM book b
            LEFT OUTER JOIN dsale d ON b.bCode = d.bCode;
            
        --------------------------------------------------------
        -- 판매된 bCode, bName 출력
            SELECT bCode, bName
            FROM book 
            WHERE bCode IN (SELECT bCode FROM dsale);
            
            SELECT DISTINCT b.bCode, bName
            FROM book b
            JOIN dsale d ON b.bCode = d.bCode;
            
            SELECT DISTINCT b.bCode, bName
            FROM book b
            LEFT OUTER JOIN dsale d ON b.bCode = d.bCode
            WHERE d.bCode IS NOT NULL;
    
        --------------------------------------------------------
        -- 한권도 판매되지 않은 bCode, bName 출력     
            SELECT DISTINCT b.bCode, bName
            FROM book b
            LEFT OUTER JOIN dsale d ON b.bCode = d.bCode
            WHERE d.bCode IS NULL;
        



-- 03/09

     -- 3) FULL OUTER JOIN
       -- 형식
          SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명
          FROM 테이블명1 FULL OUTER JOIN 테이블명2 ON 테이블명1.컬럼명=테이블명2.컬럼명;

        -------------------------------------------------------
        --
        SELECT sNum, sDate, s.cNum, m.cNum, userId
        FROM sale s
        LEFT OUTER JOIN member m ON s.cNum = m.cNum;
        
        SELECT sNum, sDate, s.cNum, m.cNum, userId
        FROM sale s
        RIGHT OUTER JOIN member m ON s.cNum = m.cNum;

        SELECT sNum, sDate, s.cNum, m.cNum, userId
        FROM sale s
        FULL OUTER JOIN member m ON s.cNum = m.cNum;
        
        SELECT sNum, sDate, s.cNum, m.cNum, cName, userId
        FROM sale s         -- > sale 다 출력됨
        FULL OUTER JOIN member m ON s.cNum = m.cNum
        FULL OUTER JOIN cus c ON c.cNum = s.cNum;

        SELECT sNum, sDate, s.cNum, m.cNum, cName, userId
        FROM cus c          --> cus 다 출력됨
        FULL OUTER JOIN member m ON c.cNum = m.cNum
        FULL OUTER JOIN sale s ON c.cNum = s.cNum;





   -- ο UPDATE JOIN VIEW 이용하여 빠른 업데이트(서브쿼리 보다 훨씬 빠르다.)
      -- 테이블을 조인하여 UPDATE
      -- tb_a 테이블의 내용(new_addr1, new_addr2)을 tb_b에 존재하는 내용(n_addr1, n_addr2)으로 수정
      -- 조인 조건의 컬럼이 UNIQUE 속성이어야 가능하며(관계가 1:1) 그렇지 않으면 ORA-01779 오류가 발생한다.

     -------------------------------------------------------
     -- 예제
        CREATE TABLE tb_a (
             num  NUMBER PRIMARY KEY
            ,addr1  VARCHAR2(255)
            ,addr2 VARCHAR2(255)
            ,new_addr1 VARCHAR2(255)
            ,new_addr2 VARCHAR2(255)
       );

      CREATE TABLE tb_b (
           num  NUMBER PRIMARY KEY
          ,n_addr1 VARCHAR2(255)
          ,n_addr2 VARCHAR2(255)
      );

      INSERT INTO tb_a VALUES(1,'서울1-1', '서울1-2','도로1-1', '도로1-2');
      INSERT INTO tb_a VALUES(2,'서울2-1', '서울2-2','도로2-1', '도로2-2');
      INSERT INTO tb_a VALUES(3,'서울3-1', '서울3-2','도로3-1', '도로3-2');
      INSERT INTO tb_a VALUES(4,'서울4-1', '서울4-2','도로4-1', '도로4-2');
      INSERT INTO tb_a VALUES(5,'서울5-1', '서울5-2','도로5-1', '도로5-2');

      INSERT INTO tb_b VALUES(1,'세종1-1', '세종1-2');
      INSERT INTO tb_b VALUES(3,'세종3-1', '세종3-2');
      INSERT INTO tb_b VALUES(5,'세종5-1', '세종5-2');
      COMMIT;

     -------------------------------------------------------
     -- 관계가 1:1인 경우만 가능
     SELECT a.new_addr1, a.new_addr2, b.n_addr1, b.n_addr2
     FROM tb_a a, tb_b b
     WHERE a.num = b.num;
     
     UPDATE 
     (
         SELECT a.new_addr1, a.new_addr2, b.n_addr1, b.n_addr2
         FROM tb_a a, tb_b b
         WHERE a.num = b.num
     )
     SET new_addr1 = n_addr1, new_addr2 = n_addr2;
     COMMIT;

    SELECT * FROM tb_a;




 -- ※ subquery
   -- ο WITH
     -------------------------------------------------------
     --
     WITH tmp AS(
            SELECT b.bCode, bName, bPrice, p.pNum, pName, sDate, c.cNum, cName, qty, bPrice*qty amt
            FROM book b
            JOIN pub p ON b.pNum = p.pNum
            JOIN dsale d ON b.bCode = d.bCode
            JOIN sale s ON d.sNum = s.sNum
            JOIN cus c ON s.cNum = c.cNum
     )
     SELECT SUM(amt)
     FROM tmp;


   -- ο 단일 행 서브 쿼리
     -------------------------------------------------------
     --
     SELECT empNo, name, sal
     FROM emp
     WHERE sal < (SELECT AVG(sal) FROM emp);


   -- ο 다중 행 서브 쿼리
      -- IN
       -------------------------------------------------------
       --
        SELECT bCode, bName
        FROM book
        WHERE bCode In ( SELECT bCode FROM dsale );


      -- ANY(SOME) : 하나 이상만 일치하면 참
       -------------------------------------------------------
       -- 200만원보다 더 받는 사원 
       SELECT empNo, name, sal
       FROM emp
       WHERE sal > ANY(2000000,3000000,4000000);


      -- ALL : 모두 일치
       -------------------------------------------------------
       -- 400만원보다 더 받는 사원
       SELECT empNo, name, sal
       FROM emp
       WHERE sal > ALL(2000000,3000000,4000000);


      -- EXISTS : 만족하는 것이 하나라도 존재하면 참
       -------------------------------------------------------
       --
       SELECT bName 
       FROM book
       WHERE EXISTS (SELECT * FROM dsale WHERE qty >=10);
            -- qty가 10이상인 레코드가 존재하므로
            -- SELECT bName FROM book; 와 동일
       
       SELECT bName 
       FROM book
       WHERE EXISTS (SELECT * FROM dsale WHERE qty >=1000);     
            
       
--> 엄청난 부하를 준다. 되도록 사용 자제
   -- ο 상호 연관 서브 쿼리(correlated subquery, 상관 하위 부질의): 서브쿼리 단독 실행 불가
     -------------------------------------------------------
     --
     SELECT name, sal,
        ( SELECT COUNT(e2.sal) + 1 FROM emp e2 WHERE e2.sal > e1.sal ) 순위
     FROM emp e1;


        -------------------------------------------------------
        -- 학점 구하기
        CREATE TABLE grade_table
        (
              grade  VARCHAR2(10) PRIMARY KEY
              ,score NUMBER(3)
        );
        INSERT INTO grade_table(grade, score) VALUES ('A', 90);
        INSERT INTO grade_table(grade, score) VALUES ('B', 80);
        INSERT INTO grade_table(grade, score) VALUES ('C', 70);
        INSERT INTO grade_table(grade, score) VALUES ('D', 60);
        INSERT INTO grade_table(grade, score) VALUES ('F', 0);
        COMMIT;

        CREATE TABLE score_table
        (
              hak  VARCHAR2(30) PRIMARY KEY
              ,score NUMBER(3) NOT NULL
        );

       INSERT INTO score_table(hak, score) VALUES ('1', 75);
       INSERT INTO score_table(hak, score) VALUES ('2', 50);
       INSERT INTO score_table(hak, score) VALUES ('3', 65);
       INSERT INTO score_table(hak, score) VALUES ('4', 80);
       INSERT INTO score_table(hak, score) VALUES ('5', 65);
       COMMIT;

       SELECT * FROM grade_table;
       SELECT * FROM score_table;
       
       SELECT hak,score,
        (SELECT MAX(score) FROM grade_table WHERE score <= score_table.score) gscore
        FROM score_table;
    
        SELECT hak, s1.score, grade FROM (
            SELECT hak,score,
            (SELECT MAX(score) FROM grade_table WHERE score <= score_table.score) gscore
            FROM score_table
        )S1
        JOIN grade_table s2 ON s1.gscore = s2.score;
        -- > 부하 쩔어 그냥 자바에서 하는게 더 효율적
    
    
    
    
    
    
    
