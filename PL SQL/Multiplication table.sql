-- Nested loop

begin
	for x in 1..10 loop
    		for y in 1..10 loop
    		dbms_output.put(x*y|| ' ');
    		end loop;
	dbms_output.put_line(' ');
	end loop;
end;
/

