CREATE TABLE roomReservation
(
     reservationNum  NUMBER PRIMARY KEY
     ,roomNum        NUMBER  NOT NULL
     ,checkIn        VARCHAR2(8) NOT NULL
     ,checkOut        VARCHAR2(8) NOT NULL
);

CREATE SEQUENCE roomReservation_seq;

INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 1, '20200722', '20200725');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 2, '20200721', '20200724');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 3, '20200727', '20200801');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 1, '20200727', '20200730');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 5, '20200726', '20200729');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 8, '20200724', '20200726');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 9, '20200723', '20200726');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 8, '20200727', '20200728');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 10, '20200729', '20200730');

COMMIT;

SELECT reservationNum, roomNum, checkIn, checkOut FROM roomReservation
ORDER BY checkIn ASC;

-- 20200724 ~ 20200729 예약 된 룸. 0729에 checkOut 되면 0729에 checkIn 가능
SELECT reservationNum, roomNum, checkIn, checkOut FROM roomReservation
        -- (1)포함된 경우
WHERE   (TO_DATE(checkIn) <= TO_DATE('20200724') AND TO_DATE(checkOut) >= TO_DATE('20200729')) OR
        -- (2) checkOut 걸쳐있는 경우
        (TO_DATE(checkOut) > TO_DATE('20200724') AND TO_DATE(checkOut) < TO_DATE('20200729')) OR
        -- (3) checkIn걸쳐있는 경우
        (TO_DATE(checkIn) >= TO_DATE('20200724') AND TO_DATE(checkIn) < TO_DATE('20200729')) 
ORDER BY checkIn ASC;


-- 20200727 ~ 20200728 예약 된 룸.
SELECT reservationNum, roomNum, checkIn, checkOut FROM roomReservation
        -- (1)포함된 경우
WHERE   (TO_DATE(checkIn) <= TO_DATE('20200727') AND TO_DATE(checkOut) >= TO_DATE('20200728')) OR
        -- (2) checkOut 걸쳐있는 경우
        (TO_DATE(checkOut) > TO_DATE('20200727') AND TO_DATE(checkOut) < TO_DATE('20200728')) OR
        -- (3) checkIn걸쳐있는 경우
        (TO_DATE(checkIn) >= TO_DATE('20200727') AND TO_DATE(checkIn) < TO_DATE('20200728')) 
ORDER BY checkIn ASC;


-- 20200730 ~ 20200801 예약 된 룸.
SELECT reservationNum, roomNum, checkIn, checkOut FROM roomReservation
        -- (1)포함된 경우
WHERE   (TO_DATE(checkIn) <= TO_DATE('20200730') AND TO_DATE(checkOut) >= TO_DATE('20200801')) OR
        -- (2) checkOut 걸쳐있는 경우
        (TO_DATE(checkOut) > TO_DATE('20200730') AND TO_DATE(checkOut) < TO_DATE('20200801')) OR
        -- (3) checkIn걸쳐있는 경우
        (TO_DATE(checkIn) >= TO_DATE('20200730') AND TO_DATE(checkIn) < TO_DATE('20200801')) 
ORDER BY checkIn ASC;