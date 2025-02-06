/*   Wykorzystując zaimplementowany w Oracle JSON_OBJECT_T, proszę przygotować funkcję wykonującą uproszczoną anonimizację danych JSON  {"Imie" : "Jan", "Nazwisko" : "Kowalski", "PESEL" : "1234567812345"} w dwóch wersjach
a.       Pseudoanonimizacja atrybutu PESEL – używając np. funkcji hash’ujacej (dowolny zaimplementowany bezpośrednio w Oracle algorytm np. MD5)
b.       Kasując atrybut PESEL */

CREATE OR REPLACE FUNCTION anonim (p_json clob) return clob as
v_obj_json JSON_OBJECT_T;
v_pesel varchar2(100);
v_hashed_pesel varchar2(100);

BEGIN 
    v_obj_json := JSON_OBJECT_T(p_json);
	
	v_pesel := v_obj_json.get('pesel').to_string;

	v_hashed_pesel := RAWTOHEX(DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW(v_pesel, 'AL32UTF8'), DBMS_CRYPTO.HASH_MD5));

	v_obj_json.put('pesel', v_hashed_pesel);

	return v_obj_json.to_clob;

END;
/
 
DECLARE
    v_input_json CLOB := '{"imie":"Jan","nazwisko":"Kowalski","pesel":"12345678901"}';
    v_output_json CLOB;

BEGIN
    -- Wywołanie funkcji
    v_output_json := anonim(v_input_json);

    -- Wyświetlenie zanonimizowanego JSON
    DBMS_OUTPUT.PUT_LINE('Zanonimizowany JSON: ' || v_output_json);

END;