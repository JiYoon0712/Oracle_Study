■ PL/SQL
 ※ 예외처리
     -------------------------------------------------------
     --
     DECLARE
        vName VARCHAR2(30);
        vSal  NUMBER;
     BEGIN
        --SELECT name, sal INTO vName, vSal FROM emp WHERE empNo = '1001';
        --SELECT name, sal INTO vName, vSal FROM emp WHERE empNo = '8001';
        SELECT name, sal INTO vName, vSal FROM emp;
        
        DBMS_OUTPUT.PUT_LINE(vName || '  ' || vSal);
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('데이터가 없습니다.');
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('두개 이상 존재합니다.');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('기타 에러가 발생합니다.');
     END;
     /
     
     
     -------------------------------------------------------
     --
     DECLARE
        vName VARCHAR2(30);
        vSal  NUMBER;
        
        emp_sal_check EXCEPTION;
     BEGIN
        SELECT name, sal INTO vName, vSal FROM emp WHERE empNo = '1001';
        IF vSal >= 3000000 THEN
            RAISE emp_sal_check; -- 예외 발생
        END IF;
        
        DBMS_OUTPUT.PUT_LINE(vName || '  ' || vSal);
        
        EXCEPTION
            WHEN emp_sal_check THEN
                DBMS_OUTPUT.PUT_LINE('급여가 300만원 이상입니다.');
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('데이터가 없습니다.');
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('두개 이상 존재합니다.');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('기타 에러가 발생합니다.');
     END;
     /
       
