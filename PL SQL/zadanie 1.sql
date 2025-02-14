/* 4.    Proszę o stworzenie procedury, która jest w stanie przyjąć przez parametr listę pracowników 
z tabeli hr.employees ( lista np. 10 losowych EMPLOYEE_ID), a następnie po wywołaniu procedura powinna wypisać na ekran:
a.       Imię, nazwisko, adres email dla wszystkich osób z listy
b.       Nazwisko managera dla pierwszego elementu z listy
c.       Nazwę departamentu dla ostatniego elementu z listy */

--typ tabeli przechowywującej id pracowników
create or replace type typ_tab is table of number;

-- funkcja zwracająca listę losowych id pracowników z parametrem p_count dla liczby pracowników
create or replace function get_emp (p_count number) return typ_tab as
    id_list typ_tab;
              begin
                            select employee_id bulk collect into id_list
        from (select employee_id from hr.employees
                            order by DBMS_RANDOM.value)
        where rownum <= p_count;
       
              return id_list;
end get_emp;
 
 
 --procedura
create or replace procedure proc1 (id_list in typ_tab) as
dane_prac hr.employees%rowtype; -- Zmienna na pojedynczy rekord pracownika
manager_name varchar(50); --zmienna na nazwisko managera
department_name varchar(50); --zmienna na nazwę departamentu
begin
    for n in 1..id_list.count loop
        -- Pobranie danych pracownika
        select *
        into dane_prac
        from hr.employees
        where employee_id = id_list(n);
		
        -- Wyświetlanie danych pracowników 
        DBMS_OUTPUT.PUT_LINE('Pracownik: ' || dane_prac.first_name || ' ' || dane_prac.last_name ||
                             ' Email: ' || dane_prac.email);
    end loop;
	
	-- Pobranie nazwy departamentu
	select d.department_name into department_name from hr.employees e
    left join hr.departments d on e.department_id = d.department_id
    where e.employee_id = id_list(1);
	
	-- pobranie nazwiska managera
    select nvl(m.last_name, 'pracownik nie ma managera') into manager_name from hr.employees e
    left join hr.employees m on e.manager_id=m.employee_id
    where e.employee_id = id_list(id_list.count);
	
     --wyświetlenie danych o pierwszym i ostatnim pracowniku       
    dbms_output.put_line('departament pierwszego pracownika z listy to: '||department_name);
    dbms_output.put_line('nazwisko managera ostatniego pracownika z listy to: '||manager_name);
             
end proc1;
 
 -- przykładowe wywołanie funkcji i procedury
declare
    random_ids typ_tab;
begin
    random_ids:=get_emp(5);
    proc1(random_ids);
end;