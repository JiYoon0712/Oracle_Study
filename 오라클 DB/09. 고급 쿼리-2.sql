-- ¡á °í±Þ Äõ¸®
 -- ¡Ø Á¤±Ô½Ä(Regular Expression) - ÁÖ¿ä ÇÔ¼ö
    -- 1) REGEXP_LIKE(source_char, pattern [, match_parameter ] )
       -- : ÆÐÅÏÀÌ Æ÷ÇÔµÈ ¹®ÀÚ¿­ °Ë»ö
       ---------------------------------------
       -- 
       SELECT * FROM reg;
       
       -- ÀÌ¸§ÀÌ ÇÑ ¶Ç´Â ¹éÀ¸·Î ½ÃÀÛÇÏ´Â ·¹ÄÚµå
       SELECT * FROM reg
       WHERE REGEXP_LIKE(name,'^[ÇÑ¹é]');
       
       -- ÀÌ¸§ÀÌ °­»êÀ¸·Î ³¡ÇÏ´Â ·¹ÄÚµå
       SELECT * FROM reg
       WHERE REGEXP_LIKE(name,'°­»ê$');   
       
       -- ÀÌ¸ÞÀÏÀÌ comÀ¸·Î ³¡³ª´Â ·¹ÄÚµå
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'com$'); -- ´ë¼Ò¹®ÀÚ ±¸ºÐ
       
       -- ÀÌ¸ÞÀÏÀÌ comÀ¸·Î ³¡³ª´Â ·¹ÄÚµå
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'com$','i'); -- ´ë¼Ò¹®ÀÚ ±¸ºÐ ¾ÈÇÔ
       
       -- ÀÌ¸ÞÀÏ¿¡ kim ÀÌ Æ÷ÇÔµÈ ·¹ÄÚµå
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'kim');

       SELECT * FROM reg
       WHERE email LIKE('%kim%');

       -- ÀÌ¸ÞÀÏÀÌ "kim3" ´ÙÀ½¿¡ ÇÏ³ª ¶Ç´Â 0°³ÀÇ 3°ú ´ÙÀ½¿¡ 3À» Æ÷ÇÔÇÏ´Â ·¹ÄÚµå 
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'kim3?3');    
       
       --  ÀÌ¸ÞÀÏÀÌ "kim" ´ÙÀ½¿¡ 0~3 »çÀÌÀÇ ¹®ÀÚ°¡ 2¹øÀÌ»ó ¹Ýº¹ÇÏ´Â ·¹ÄÚµå
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'kim[0-3]{2}');       
        
       --  ÀÌ¸ÞÀÏÀÌ "kim" ´ÙÀ½¿¡ 2~3 »çÀÌÀÇ ¹®ÀÚ°¡ 3~4¹ø ¹Ýº¹ÇÏ´Â ·¹ÄÚµå
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'kim[2-3]{3,4}');        
       
       -- ºÎÁ¤
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'kim[^1]');  -- kim ´ÙÀ½¿¡ 1ÀÌ ¾Æ´Ñ
       
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email,'^[^k]'); -- k·Î ½ÃÀÛÇÏÁö ¾Ê´Â
       
       -- ÇÑ±Û
       SELECT * FROM reg
       WHERE REGEXP_LIKE(name, '^[°¡-ÆR]{1,10}$');
       
       -- ¼ýÀÚ°¡ ÀÖ´Â ÀÌ¸ÞÀÏ
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email, '[[:digit:]]');
       
       SELECT * FROM reg
       WHERE REGEXP_LIKE(email, '[0-9]');
       
       -- ¿µ¹®ÀÚ
       SELECT * FROM reg
       WHERE REGEXP_LIKE(name, '[a-z|A-Z]');       
       
       
    -- 2) REGEXP_REPLACE(source_char, pattern [, replace_string [, position [, occurrence[, match_parameter ] ] ] ])
       -- : ÆÐÅÏÀÌ Æ÷ÇÔµÈ ¹®ÀÚ¿­À» ´Ù¸¥ ¹®ÀÚ¿­·Î Ä¡È¯
       ---------------------------------------
       --
       SELECT REGEXP_REPLACE('!1234^{}<>~12¼ýÀÚ,.Æ¯¼ö¹®ÀÚ_Test','[0-9]','')
       FROM dual;

       SELECT REGEXP_REPLACE('!1234^{}<>~12¼ýÀÚ,.Æ¯¼ö¹®ÀÚ_Test','[[:digit:]|[:punct:]]','')
       FROM dual;
            -- [:digit:] : ¼ýÀÚ, [:punct:] : Æ¯¼ö¹®ÀÚ
        
        SELECT name, rrn FROM emp;
        SELECT name, REGEXP_REPLACE(rrn,'[0-9]','*',9) rrn FROM emp;
                -- 9¹øÂ° ¹®ÀÚºÎÅÍ [0-9]¹®ÀÚ¸¦ *·Î Ä¡È¯
        



    -- 3) REGEXP_INSTR (source_char, pattern [, position [, occurrence [, return_option [, match_parameter ] ] ] ] )
       -- : ÆÐÅÏÀÌ Æ÷ÇÔµÈ ¹®ÀÚ¿­ÀÇ À§Ä¡ ¹ÝÈ¯
       ---------------------------------------
       --
       SELECT name, tel,REGEXP_INSTR(tel,'[-]') À§Ä¡ FROM emp;
       SELECT name, tel,REGEXP_INSTR(tel,'[\-]') À§Ä¡ FROM emp;

       SELECT name, tel
       FROM emp
       WHERE regexp_instr(name,'^[^ÀÌ±è]')=1;  -- ÀÌ¾¾ ±è¾¾ Á¦¿Ü
        
        
        
    -- 4) REGEXP_SUBSTR(source_char, pattern [, position [, occurrence [, match_parameter ] ] ] )
       -- : ¹®ÀÚ¿­¿¡ Á¸ÀçÇÏ´Â ÆÐÅÏ¹®ÀÚ¿­À» ¹ÝÈ¯
       ---------------------------------------
       --


    -- 5) REGEXP_COUNT (source_char, pattern [, position [, match_param]])
       -- : ¹®ÀÚ¿­¿¡ Á¸ÀçÇÏ´Â ÆÐÅÏ¹®ÀÚ¿­ÀÇ °³¼ö ¹ÝÈ¯
       ---------------------------------------
       --
       -- email ¿¡¼­ a °³¼ö
       SELECT email, REGEXP_COUNT(email,'a') FROM reg;

