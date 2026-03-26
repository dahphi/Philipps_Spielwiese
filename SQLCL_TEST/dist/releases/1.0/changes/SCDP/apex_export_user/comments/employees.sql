-- liquibase formatted sql
-- changeset apex_export_user:1774560038382 stripComments:false logicalFilePath:SCDP/apex_export_user/comments/employees.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/comments/employees.sql:null:93baa12177f8438dcbcdc53c07f4945a2317bacc:create

comment on table apex_export_user.employees is
    'employees table. References with departments,
jobs, job_history tables. Contains a self reference.';

comment on column apex_export_user.employees.commission_pct is
    'Commission percentage of the employee; Only employees in sales 
department elgible for commission percentage';

comment on column apex_export_user.employees.department_id is
    'Department id where employee works; foreign key to department_id 
column of the departments table';

comment on column apex_export_user.employees.email is
    'Email id of the employee';

comment on column apex_export_user.employees.employee_id is
    'Primary key of employees table.';

comment on column apex_export_user.employees.first_name is
    'First name of the employee. A not null column.';

comment on column apex_export_user.employees.hire_date is
    'Date when the employee started on this job. A not null column.';

comment on column apex_export_user.employees.job_id is
    'Current job of the employee; foreign key to job_id column of the 
jobs table. A not null column.';

comment on column apex_export_user.employees.last_name is
    'Last name of the employee. A not null column.';

comment on column apex_export_user.employees.manager_id is
    'Manager id of the employee; has same domain as manager_id in 
departments table. Foreign key to employee_id column of employees table. 
(useful for reflexive joins and CONNECT BY query)';

comment on column apex_export_user.employees.phone_number is
    'Phone number of the employee; includes country code and area code';

comment on column apex_export_user.employees.salary is
    'Monthly salary of the employee. Must be greater 
than zero (enforced by constraint emp_salary_min)';

