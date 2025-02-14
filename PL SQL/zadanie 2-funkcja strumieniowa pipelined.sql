/* Proszę przygotować funkcję strumieniową (pipelined) zwracającą tablicę obiektów. 
Obiekt powinien składać się z dwóch elementów ID (number) oraz JSON (clob). 
JSON to wiersz z  EMPLOYEES przekonwertowany do postaci JSON’a a ID to nr wiersza. 
1 wiersz z tabeli to 1 obiekt/wiersz zwracany przez funkcję.*/

-- typ obiektu 
create or replace type row_object as object (
    id number,
    json_data clob
);

-- typ rabeli
create or replace type tab_json is table of row_object;

-- funkcja
create or replace function data_to_json return tab_json pipelined as
    v_id number :=1;
begin 
    for n in (select json_object(*) as data from hr.employees) loop
    pipe row(row_object(v_id,n.data));
    v_id:=v_id+1;
end loop;
return ;
end data_to_json;

-- wywołanie funkcji
select * from (data_to_json());