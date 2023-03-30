-- [과제] - ORACLE

CREATE TABLE student(
    std_id  VARCHAR2(30) PRIMARY KEY,
    name VARCHAR2(30) NOT NULL,
    birth DATE NOT NULL,
    tel VARCHAR2(30),
    email VARCHAR2(50) UNIQUE,
    reg_date DATE DEFAULT SYSDATE
);

CREATE TABLE score(
    std_id VARCHAR2(30) NOT NULL,
    code NUMBER(1) NOT NULL,
    com NUMBER(3) NOT NULL,
    excel NUMBER(3) NOT NULL,
    word NUMBER(3) NOT NULL,
    reg_date DATE NOT NULL,
    PRIMARY KEY(std_id,code)
);

--(2) score 테이블에 다음의 제약 조건을 추가하세요.

 ALTER TABLE score ADD CHECK (code IN(1,2));
 
 ALTER TABLE score ADD FOREIGN KEY(std_id) REFERENCES student(std_id); 
 
--(3)
    CREATE VIEW ZIYOON
    AS
    SELECT st.std_id, DECODE(code,1,'중간',2,'기말') 구분,
           com, excel, word, com+excel+word tot,
           TRUNC((com+excel+word)/3,1) ave, RANK() OVER(PARTITION BY code ORDER BY com+excel+word DESC) 석차
    FROM student st JOIN score sc ON st.std_id = sc.std_id;
    
--(4)    
    SELECT st.std_id, name, DECODE(code,1,'중간',2,'기말') 구분, 
           com+excel+word tot, TRUNC((com+excel+word)/3,2) ave, 
           CASE 
                WHEN com>=40 AND excel>=40 AND word>=40 AND (com+excel+word)/3 >=60 THEN '합격'
                WHEN (com+excel+word)/3 >=60 THEN '과락'
                ELSE '불합격'
            END 판정
    FROM student st JOIN score sc ON st.std_id = sc.std_id
    ORDER BY code ASC, st.std_id ASC;
    
 
--(5)      
    SELECT NVL(DECODE(code,1,'중간',2,'기말'),'과목별 전체 평균') 구분, ROUND(AVG(com),1) com평균, ROUND(AVG(excel),1) excel평균, ROUND(AVG(word),1) word평균
    FROM student st JOIN score sc ON st.std_id = sc.std_id
    GROUP BY ROLLUP(DECODE(code,1,'중간',2,'기말'));
    
--------------------------------------------------
-- 데이터 추가
INSERT INTO student(std_id, name, birth, tel, email)
VALUES('1000', '김자바', '2000-05-07', '010-3926-4292', 'wnasves@daum.net');
INSERT INTO student(std_id, name, birth, tel, email)
VALUES('1001', '스프링', '2000-10-17', '010-3424-1234', 'kfpf@naver.com');
INSERT INTO student(std_id, name, birth, tel, email)
VALUES('1002', '오라클', '2000-07-01', '010-4435-4545', 'nases@daum.net');
INSERT INTO student(std_id, name, birth, tel, email)
VALUES('1003', '이순신', '2000-10-02', '010-3423-1123', 'plo43@naver.com');
INSERT INTO student(std_id, name, birth, tel, email)
VALUES('1004', '너자바', '2001-01-02', '010-7567-1114', '34pkof@daum.net');
INSERT INTO student(std_id, name, birth, tel, email)
VALUES('1005', '감자바', '2000-12-23', '010-3542-9570', 'klmb3@google.com');
INSERT INTO student(std_id, name, birth, tel, email)
VALUES('1006', '이하늘', '2001-01-20', '010-8756-0504', 'kkfo@daum.net');
INSERT INTO student(std_id, name, birth, tel, email)
VALUES('1007', '강산애', '2000-03-14', '010-4556-3460', 'jofe03@naver.com');
INSERT INTO student(std_id, name, birth, tel, email)
VALUES('1008', '이상해', '2000-03-15', '010-4445-4903', 'skjof@daum.net');
INSERT INTO student(std_id, name, birth, tel, email)
VALUES('1009', '심심해', '2000-03-16', '010-6543-3445', 'fjoe23@naver.com');
INSERT INTO student(std_id, name, birth, tel, email)
VALUES('1010', '사랑해', '2000-04-24', '010-5043-4328', 'eoirf@daum.net');


INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES( '1000', 1, 100, 90, 97, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1000', 2, 90, 94, 97, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1001', 1, 90, 5, 45, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1001', 2, 85, 45, 67, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1002', 1, 66, 76, 34, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1002', 2, 70, 76, 55, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1003', 1, 10, 90, 95, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1003', 2, 30, 70, 95, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1004', 1, 90, 94, 97, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1004', 2, 55, 100, 100, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1005', 1, 100, 50, 66, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1005', 2, 80, 70, 66, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1006', 1, 80, 55, 87, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1006', 2, 99, 65, 97, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1007', 1, 90, 91, 87, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1007', 2, 90, 91, 67, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1008', 1, 40, 54, 65, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1008', 2, 70, 74, 75, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1009', 1, 56, 54, 77, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1009', 2, 66, 64, 77, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1010', 1, 77, 76, 88, SYSDATE);
INSERT INTO score (std_id, code, com, excel, word, reg_date)
VALUES('1010', 2, 87, 96, 88, SYSDATE);

COMMIT;
    
    
    
    
    
    
    
    