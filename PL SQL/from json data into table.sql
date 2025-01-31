DECLARE
	-- Declare a CLOB variable to hold the JSON output
    l_json CLOB;  
BEGIN
    -- Create a JSON array of departments, each containing an array of employees
    SELECT json_arrayagg(
               json_object(
                   'job' VALUE NVL(department_name, 'Employee without department'),  -- Use 'Employee without department' if department_name is NULL
                   'employee' VALUE json_arrayagg(
                       json_object(
                           'id' VALUE employee_id,
                           'name' VALUE first_name
                       )
                   )
               )
           ) INTO l_json
    FROM hr.employees e
    LEFT JOIN hr.departments d ON e.department_id = d.department_id
    GROUP BY department_name;


    -- Loop through the JSON data using json_table to extract department and employee information
    FOR n IN (
        SELECT * 
        FROM json_table(
            l_json, 
            '$[*]' 
            COLUMNS (
                job VARCHAR2(50) PATH '$.job',
                nested PATH '$.employee[*]' 
                COLUMNS (
                    id NUMBER PATH '$.id',
                    name VARCHAR2(50) PATH '$.name'
                )
            )
        )
    ) LOOP
        -- Output each department and its employees
        DBMS_OUTPUT.PUT_LINE('Department: ' || n.job || ' Employee: ' || n.id || ' Name: ' || n.name);
    END LOOP;

END;
/


