-- Copying table with dynamic SQL

CREATE OR REPLACE PROCEDURE prc_copy_table (p_table_name IN VARCHAR2, p_new_table_name IN VARCHAR2) IS
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE ' || p_new_table_name || ' AS SELECT * FROM ' || p_table_name;
END;
/
    
EXEC prc_copy_table('hr.employees','employees_copy');
/
  
SELECT * FROM employees_copy;
/

-- Updating and droping with dynamic SQL   

CREATE OR REPLACE PROCEDURE prc_generic (p_dynamic_sql IN VARCHAR2) IS
BEGIN
    EXECUTE IMMEDIATE p_dynamic_sql;
END;
/
EXEC prc_generic ('update employees_copy set salary = 26000 where employee_id = 100');
EXEC prc_generic('drop table employees_copy');
/ 

-- EXECUTE IMMEDIATE STATEMENT with the USING and INTO Clauses

CREATE OR REPLACE FUNCTION get_count (table_name IN varchar2) RETURN 
    PLS_INTEGER IS
    v_count PLS_INTEGER;
BEGIN 
    EXECUTE IMMEDIATE 'SELECT COUNT (*) FROM ' || table_name  INTO v_count;
RETURN v_count;
END;
/

SELECT  get_count('hr.employees') FROM dual;
/

CREATE OR REPLACE FUNCTION get_avg_sal (p_table_name IN VARCHAR2, p_dept_id IN NUMBER) RETURN
PLS_INTEGER IS 
v_avg_sal PLS_INTEGER;
BEGIN
    EXECUTE IMMEDIATE 'SELECT AVG(salary) FROM ' || p_table_name || ' WHERE department_id = :2' INTO v_avg_sal USING p_dept_id;
RETURN v_avg_sal;
END;
/

SELECT get_avg_sal('hr.employees',50) FROM dual;