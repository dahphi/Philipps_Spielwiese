-- liquibase formatted sql
-- changeset apex_export_user:1774559572988 stripComments:false logicalFilePath:SCDP/apex_export_user/comments/departments.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/comments/departments.sql:null:1e4cde9ae419cfb7d37e1ffe5b837948f093c4b8:create

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

