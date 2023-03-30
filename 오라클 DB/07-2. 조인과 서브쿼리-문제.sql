-- ■ 조인과 서브 쿼리
 -- ※ 조인(joins)
   -- 비회원의 판매 현황
     -- 출력컬럼 : cNum, cName, bCode, bName, sDate, bPrice, qty
     -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, sDate, cNum), cus(cNum, cName), member(cNum, userId)
        
        -- 회원/비회원 판매현황
        SELECT s.cNum, cName, b.bCode, bName, sDate, bPrice, qty, userId
        FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            JOIN sale s ON d.sNum = s.sNum
            JOIN cus c ON c.cNum = s.cNum
        LEFT OUTER JOIN member m ON c.cNum = m.cNum
        ORDER BY s.cNum ;
        
        -- 비회원 판매현황
        SELECT s.cNum, cName, b.bCode, bName, sDate, bPrice, qty
        FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            JOIN sale s ON d.sNum = s.sNum
            JOIN cus c ON c.cNum = s.cNum
        LEFT OUTER JOIN member m ON c.cNum = m.cNum
        WHERE userId IS NULL;
        
        
        -- 회원 판매현황
        SELECT s.cNum, cName, b.bCode, bName, sDate, bPrice, qty, userId
        FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            JOIN sale s ON d.sNum = s.sNum
            JOIN cus c ON c.cNum = s.cNum
        LEFT OUTER JOIN member m ON c.cNum = m.cNum
        WHERE userId IS NOT NULL;
        
        -- 회원 판매현황(2)
        SELECT s.cNum, cName, b.bCode, bName, sDate, bPrice, qty, userId
        FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            JOIN sale s ON d.sNum = s.sNum
            JOIN cus c ON c.cNum = s.cNum
            JOIN member m ON c.cNum = m.cNum;
        
        -- 책을 구매하지 않은 회원도 출력
        SELECT s.cNum, cName, b.bCode, bName, sDate, bPrice, qty, userId
        FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            JOIN sale s ON d.sNum = s.sNum
            JOIN cus c ON c.cNum = s.cNum
            RIGHT OUTER JOIN member m ON c.cNum = m.cNum;
        
        -- 내가
        SELECT s.cNum, cName, b.bCode, bName, sDate, bPrice, qty
        FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            JOIN sale s ON d.sNum = s.sNum
            JOIN cus c ON c.cNum = s.cNum
        WHERE c.cNum NOT IN (SELECT cNum FROM member) 
        ORDER BY c.cNum;
            

   -- 고객별 누적판매금액 출력
     -- 출력컬럼 : cNum, cName, 판매금액합(qty*bPrice)
     -- 한권도 책을 구매하지 않은 고객도 출력
     -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, cNum), cus(cNum, cName)
     SELECT c.cNum, cName, NVL(SUM(qty*bPrice),0) amt
     FROM book b
        JOIN dsale d ON b.bCode=d.bCode
        JOIN sale s ON s.sNum = d.sNum
        RIGHT OUTER JOIN cus c ON c.cNum = s.cNum
     GROUP BY c.cNum, cName
     ORDER BY cNum;
     
     
     SELECT c.cNum, cName, NVL(SUM(qty*bPrice),0) amt
     FROM cus c
        LEFT OUTER JOIN sale s ON c.cNum = s.cNum
        LEFT OUTER JOIN dsale d ON s.sNum = d.sNum
        LEFT OUTER JOIN book b ON b.bCode = d.bCode
     GROUP BY c.cNum, cName
     ORDER BY cNum;
     
     

   -- 고객별 누적판매 금액 및 비율(%)
     -- 출력컬럼 : cNum, cName, 판매금액합(qty*bPrice), 비율(전체판매금액에 대한 고객판매금액)
     -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, cNum), cus(cNum, cName)
       
        SELECT c.cNum, cName, SUM(qty*bPrice) amt
        FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            JOIN sale s ON d.sNum = s.sNum
            JOIN cus c ON c.cNum = s.cNum
        GROUP BY c.cNum, cName
        ORDER BY cNum;
       
       -- 강사님
       SELECT c.cNum, cName, (qty*bPrice) amt,
               ROUND(RATIO_TO_REPORT(SUM(qty*bPrice)) OVER() *100,1)||'%' 비율
        FROM book b
            JOIN dsale d ON b.bCode = d.bCode 
            JOIN sale s ON d.sNum = s.sNum  
            JOIN cus c ON s.cNum = c.cNum
        GROUP BY c.cNum, cName,(qty*bPrice);
       
       
       -- 내가
        SELECT c.cNum, cName, (qty*bPrice) 판매금액합,
               ROUND((qty*bPrice)/(SELECT SUM(qty*bPrice) FROM book b JOIN dsale d ON b.bCode = d.bCode)*100, 1)||'%' 비율
        FROM book b
            JOIN dsale d ON b.bCode = d.bCode 
            JOIN sale s ON d.sNum = s.sNum  
            JOIN cus c ON s.cNum = c.cNum
        GROUP BY c.cNum, cName,(qty*bPrice);
        
        

   -- 년도별로 누적 판매금액이 가장 많은 고객출력
     -- 출력컬럼 : 판매년도, cNum, cName, 년도별판매금액합(qty*bPrice)
     -- 판매년도 오름차순 출력
     -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, sDate, cNum), cus(cNum, cName)
       
       -- 강사님
         SELECT TO_CHAR(sDate,'YYYY') 년도, c.cNum, cName, SUM(qty*bPrice) amt
         FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            JOIN sale s ON d.sNum = s.sNum
            JOIN cus c ON s.cNum = c.cNum
            GROUP BY TO_CHAR(sDate,'YYYY'),c.cNum, cName
         ORDER BY 년도;
         
         SELECT TO_CHAR(sDate,'YYYY') 년도, c.cNum, cName, SUM(qty*bPrice) amt,
            RANK() OVER (PARTITION BY TO_CHAR(sDate,'YYYY') ORDER BY SUM(qty*bPrice) DESC) 순위
         FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            JOIN sale s ON d.sNum = s.sNum
            JOIN cus c ON s.cNum = c.cNum
            GROUP BY TO_CHAR(sDate,'YYYY'),c.cNum, cName
         ORDER BY 년도;
       
         SELECT 년도, cNum, cName, amt FROM(
             SELECT TO_CHAR(sDate,'YYYY') 년도, c.cNum, cName, SUM(qty*bPrice) amt,
                RANK() OVER (PARTITION BY TO_CHAR(sDate,'YYYY') ORDER BY SUM(qty*bPrice) DESC) 순위
             FROM book b
             JOIN dsale d ON b.bCode = d.bCode
             JOIN sale s ON d.sNum = s.sNum
             JOIN cus c ON s.cNum = c.cNum
             GROUP BY TO_CHAR(sDate,'YYYY'),c.cNum, cName
         )WHERE 순위 = 1
          ORDER BY 년도;



   -- 년도의 월별 서적 판매 수량 합
     -- 출력컬럼 : 년도, 책코드, 책이름, M01, M02, ... M12
     -- 년도 오름차순, 책코드 오름차순 정렬
     -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, sDate)
        
        SELECT TO_CHAR(sDate,'YYYY') 년도, b.bCode, bName, qty
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum
        ORDER BY 년도, b.bCode;
        
        SELECT TO_CHAR(sDate,'YYYY') 년도, b.bCode, bName, SUM(qty),
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'01',qty,0)) M01,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'02',qty,0)) M02,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'03',qty,0)) M03,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'04',qty,0)) M04,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'05',qty,0)) M05,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'06',qty,0)) M06,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'07',qty,0)) M07,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'08',qty,0)) M08,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'09',qty,0)) M09,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'10',qty,0)) M10,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'11',qty,0)) M11,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'12',qty,0)) M12            
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum
        GROUP BY TO_CHAR(sDate,'YYYY'), b.bCode, bName
        ORDER BY 년도, b.bCode;
        
            
   -- 년도의 월별 서적 판매 수량 합을 출력하고 년도별 소계 및 마지막에 전체 총계 출력
     -- 출력컬럼 : 년도, 책코드, 책이름, M01, M02, ... M12
     -- 년도 오름차순, 책코드 오름차순 정렬
     
     SELECT TO_CHAR(sDate,'YYYY') 년도, b.bCode, bName, SUM(qty),
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'01',qty,0)) M01,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'02',qty,0)) M02,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'03',qty,0)) M03,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'04',qty,0)) M04,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'05',qty,0)) M05,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'06',qty,0)) M06,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'07',qty,0)) M07,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'08',qty,0)) M08,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'09',qty,0)) M09,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'10',qty,0)) M10,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'11',qty,0)) M11,
                   SUM(DECODE( TO_CHAR(sDate,'MM'),'12',qty,0)) M12            
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum
        GROUP BY ROLLUP(TO_CHAR(sDate,'YYYY'),(b.bCode, bName))
        ORDER BY 년도, b.bCode;

