comment on table apex_export_user.departments is
    'Departments table that shows details of departments where employees 
work. references with locations, employees, and job_history tables.';

comment on column apex_export_user.departments.department_id is
    'Primary key column of departments table.';

comment on column apex_export_user.departments.department_name is
    'A not null column that shows name of a department. Administration, 
Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public 
Relations, Sales, Finance, and Accounting. ';

comment on column apex_export_user.departments.location_id is
    'Location id where a department is located. Foreign key to location_id column of locations table.';

comment on column apex_export_user.departments.manager_id is
    'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.'
    ;


-- sqlcl_snapshot {"hash":"ee6e7ba1d0d5dbb0edd2fbbd8301aa0c9f87f524","type":"COMMENT","name":"departments","schemaName":"apex_export_user","sxml":""}