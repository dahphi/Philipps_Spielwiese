-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559358261 stripComments:false logicalFilePath:SCDP/apex_export_user/tables/employees.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/tables/employees.sql:null:3018185bbb7fa89dbe83869b9c853ee20457e465:create

create table apex_export_user.employees (
    employee_id    number(6, 0),
    first_name     varchar2(20 byte),
    last_name      varchar2(25 byte)
        constraint emp_last_name_nn not null enable,
    email          varchar2(25 byte)
        constraint emp_email_nn not null enable,
    phone_number   varchar2(20 byte),
    hire_date      date
        constraint emp_hire_date_nn not null enable,
    job_id         varchar2(10 byte)
        constraint emp_job_nn not null enable,
    salary         number(8, 2),
    commission_pct number(2, 2),
    manager_id     number(6, 0),
    department_id  number(4, 0)
);

create unique index apex_export_user.emp_emp_id_pk on
    apex_export_user.employees (
        employee_id
    );

alter table apex_export_user.employees add constraint emp_email_uk unique ( email )
    using index enable;

alter table apex_export_user.employees
    add constraint emp_emp_id_pk
        primary key ( employee_id )
            using index apex_export_user.emp_emp_id_pk enable;

alter table apex_export_user.employees add constraint emp_salary_min check ( salary > 0 ) enable;

