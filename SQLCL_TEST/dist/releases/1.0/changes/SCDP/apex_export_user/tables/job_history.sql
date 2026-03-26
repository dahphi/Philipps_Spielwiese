-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774560038681 stripComments:false logicalFilePath:SCDP/apex_export_user/tables/job_history.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/tables/job_history.sql:null:db5d7e72365c2a7d012d1b0a74a7a4357eceb78f:create

create table apex_export_user.job_history (
    employee_id   number(6, 0)
        constraint jhist_employee_nn not null enable,
    start_date    date
        constraint jhist_start_date_nn not null enable,
    end_date      date
        constraint jhist_end_date_nn not null enable,
    job_id        varchar2(10 byte)
        constraint jhist_job_nn not null enable,
    department_id number(4, 0)
);

create unique index apex_export_user.jhist_emp_id_st_date_pk on
    apex_export_user.job_history (
        employee_id,
        start_date
    );

alter table apex_export_user.job_history add constraint jhist_date_interval check ( end_date > start_date ) enable;

alter table apex_export_user.job_history
    add constraint jhist_emp_id_st_date_pk
        primary key ( employee_id,
                      start_date )
            using index apex_export_user.jhist_emp_id_st_date_pk enable;

