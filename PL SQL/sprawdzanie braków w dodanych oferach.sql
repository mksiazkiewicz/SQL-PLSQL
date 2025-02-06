declare
type tab_num is table of number;
v_tabela_offe tab_num;
v_tab_brakujacych tab_num;
v_tabela_numerow tab_num;
v_pierwsza number := 78958;
v_ostatnia number := 80000;

begin

SELECT LEVEL + v_pierwsza - 1 BULK COLLECT INTO v_tabela_numerow
 FROM dual
 CONNECT BY LEVEL <= (v_ostatnia - v_pierwsza + 1);

select offe_id bulk collect into v_tabela_offe
from offers where offe_id >= v_pierwsza and offe_id <= v_ostatnia;

 v_tab_brakujacych := v_tabela_numerow MULTISET EXCEPT v_tabela_offe;

  for i in 1..v_tab_brakujacych.count loop
    dbms_output.put_line(v_tab_brakujacych(i));
    end loop;
 end;
/

-- wersja wolniejsza ale krótsza
declare
v_pierwsza number := 78958;
v_ostatnia number := 80000;
v_num number;

begin
for i in v_pierwsza..v_ostatnia loop
	select count(offe_id) into v_num from offers where offe_id = i;
	if v_num = 0 then
   dbms_output.put_line(i);
  end if;
end loop;

end;