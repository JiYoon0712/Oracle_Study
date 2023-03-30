---------------------------------------------------------------
-- 상품 테이블 작성
CREATE TABLE 상품 (
   상품코드    VARCHAR2(6) NOT NULL PRIMARY KEY
  ,상품명      VARCHAR2(30)  NOT NULL
  ,제조사      VARCHAR2(30)  NOT NULL
  ,소비자가격  NUMBER
  ,재고수량    NUMBER DEFAULT 0
);

-- 입고 테이블 작성
CREATE TABLE 입고 (
   입고번호   NUMBER PRIMARY KEY
  ,상품코드   VARCHAR2(6) NOT NULL
                  CONSTRAINT fk_ibgo_no REFERENCES 상품(상품코드)
  ,입고일자   DATE
  ,입고수량   NUMBER
  ,입고단가   NUMBER
);

-- 판매 테이블 작성
CREATE TABLE 판매 (
   판매번호   NUMBER  PRIMARY KEY
  ,상품코드   VARCHAR2(6) NOT NULL
        CONSTRAINT fk_pan_no REFERENCES 상품(상품코드)
  ,판매일자   DATE
  ,판매수량   NUMBER
  ,판매단가   NUMBER
);

-- 상품 테이블에 자료 추가
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('AAAAAA', '디카', '삼싱', 100000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('BBBBBB', '컴퓨터', '엘디', 1500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('CCCCCC', '모니터', '삼싱', 600000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('DDDDDD', '핸드폰', '다우', 500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
         ('EEEEEE', '프린터', '삼싱', 200000);
COMMIT;
SELECT * FROM 상품;


---------------------------------------------------------------
-- 3. 트리거 작성
 -- 1) 입고 테이블에 INSERT 트리거를 작성 한다.
   -- [입고] 테이블에 자료가 추가 되는 경우 [상품] 테이블의 [재고수량]이 변경 되도록 트리거를 작성한다.

CREATE OR REPLACE TRIGGER insTrg_Ipgo
AFTER INSERT ON 입고
FOR EACH ROW

BEGIN
     UPDATE 상품 SET 재고수량 = 재고수량 + :NEW.입고수량 
           WHERE 상품코드 = :NEW.상품코드;
END;
/

-- 입고 테이블에 데이터 입력
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (1, 'AAAAAA', '2004-10-10', 5,   50000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (2, 'BBBBBB', '2004-10-10', 15, 700000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (3, 'AAAAAA', '2004-10-11', 15, 52000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (4, 'CCCCCC', '2004-10-14', 15,  250000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (5, 'BBBBBB', '2004-10-16', 25, 700000);
COMMIT;

SELECT * FROM 상품;
SELECT * FROM 입고;


 -- 2) 입고 테이블에 UPDATE 트리거를 작성 한다.
--  [입고] 테이블의 자료가 변경 되는 경우 [상품] 테이블의 [재고수량]이 변경 되도록 트리거를 작성한다.

CREATE OR REPLACE TRIGGER upTrg_Ipgo
AFTER UPDATE ON 입고
FOR EACH ROW
BEGIN
     UPDATE 상품 SET 재고수량 = 재고수량 - :OLD.입고수량 + :NEW.입고수량
            WHERE 상품코드 = :NEW.상품코드;
END;
/

-- UPDATE 테스트
UPDATE 입고 SET 입고수량 = 30 WHERE 입고번호 = 5;
COMMIT;
SELECT * FROM 상품;
SELECT * FROM 입고;


 -- 3) 입고 테이블에 DELETE 트리거를 작성 한다.
 -- [입고] 테이블의 자료가 삭제되는 경우 [상품] 테이블의 [재고수량]이 변경 되도록 트리거를 작성한다.

CREATE OR REPLACE TRIGGER delTrg_Ipgo
AFTER DELETE ON 입고
FOR EACH ROW
BEGIN
     UPDATE 상품 SET 재고수량 = 재고수량 - :OLD.입고수량
           WHERE 상품코드 = :OLD.상품코드;
END;
/

-- DELETE 테스트
DELETE FROM 입고 WHERE 입고번호 = 5;
COMMIT;
SELECT * FROM 상품;
SELECT * FROM 입고;

  -- 입고 테이블의 재고 수량 수정 및 삭제는 상품 테이블의 재고 수량이 적거나 없으면 할 수 없으므로 UPDATE 및 DELETE 트리거를 BEFORE 트리거로 수정하여 상품 테이블의 재고 수량에 따라 수정 또는 삭제를 할수 없도록 수정한다.


 -- 4) 판매 테이블에 INSERT 트리거를 작성한다.(BEFORE 트리거로 작성)
 -- [판매] 테이블에 자료가 추가 되는 경우 [상품] 테이블의 [재고수량]이 변경 되도록 트리거를 작성한다.

CREATE OR REPLACE TRIGGER insTrg_Pan
BEFORE INSERT ON 판매
FOR EACH ROW

DECLARE
  j_qty NUMBER;

BEGIN

   SELECT 재고수량 INTO j_qty FROM 상품 WHERE 상품코드 = :NEW.상품코드;
   IF :NEW.판매수량 > j_qty THEN
      RAISE_APPLICATION_ERROR(-20007, '판매 오류');
   ELSE
      UPDATE 상품 SET 재고수량 = 재고수량 - :NEW.판매수량 
          WHERE 상품코드 = :NEW.상품코드;
   END IF;
END;
/

-- 판매 테이블에 데이터 입력
INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
         (1, 'AAAAAA', '2004-11-10', 5, 1000000);
COMMIT;
SELECT * FROM 상품;
SELECT * FROM 판매;

INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
         (1, 'AAAAAA', '2004-11-10', 50, 1000000);
COMMIT;
SELECT * FROM 상품;
SELECT * FROM 판매;


 -- 5) 판매 테이블에 UPDATE 트리거를 작성한다.(BEFORE 트리거로 작성)
 -- [판매] 테이블의 자료가 변경 되는 경우 [상품] 테이블의 [재고수량]이 변경 되도록 트리거를 작성한다.

CREATE OR REPLACE TRIGGER upTrg_Pan
BEFORE UPDATE ON 판매
FOR EACH ROW

DECLARE
  j_qty NUMBER;

BEGIN

   SELECT 재고수량 INTO j_qty FROM 상품 WHERE 상품코드 = :NEW.상품코드;
   IF :NEW.판매수량  > (j_qty + :OLD.판매수량) THEN
     raise_application_error(-20007, '판매량이 재고량보다 많을 수 없습니다.');
   ELSE
        UPDATE 상품 SET 재고수량 = 재고수량 + :OLD.판매수량 - :NEW.판매수량 
                WHERE 상품코드 = :NEW.상품코드;
   END IF;
END;
/

-- UPDATE 테스트
UPDATE 판매 SET 판매수량 = 200 WHERE 판매번호 = 1;
UPDATE 판매 SET 판매수량 = 10 WHERE 판매번호 = 1;
COMMIT;
SELECT * FROM 상품;
SELECT * FROM 판매;


 -- 6) 판매 테이블에 DELETE 트리거를 작성 한다.
 -- [판매] 테이블에 자료가 삭제되는 경우 [상품] 테이블의 [재고수량]이 변경 되도록 트리거를 작성한다.

CREATE OR REPLACE TRIGGER delTrg_Pan
AFTER DELETE ON 판매
FOR EACH ROW

BEGIN
     UPDATE 상품 SET 재고수량 = 재고수량 + :OLD.판매수량
        WHERE 상품코드 = :OLD.상품코드;
END;
/

-- DELETE 테스트
DELETE 판매 WHERE 판매번호 = 1;
COMMIT;
SELECT * FROM 상품;
SELECT * FROM 판매;


---------------------------------------------------------------
--  다음과 같은 방법을 이용하여 관련된 트리거는 하나의 트리거로 작성 할 수 있다.
 -- IF INSERTING THEN 
 --    추가할 때 
 -- ELSIF UPDATING THEN
 --    수정할 때 
 -- ELSIF DELETING THEN
 --    삭제할 때 
--   END IF;

