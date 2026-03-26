-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774560228857 stripComments:false logicalFilePath:SCDP/apex_export_user/tables/departments.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/tables/departments.sql:null:6d9f3899b08d474ec6884c3a516d152cfc80298a:create

create table apex_export_user.departments (
    department_id   number(4, 0),
    department_name varchar2(30 byte)
        constraint dept_name_nn not null enable,
    manager_id      number(6, 0),
    location_id     number(4, 0)
);

create unique index apex_export_user.dept_id_pk on
    apex_export_user.departments (
        department_id
    );

alter table apex_export_user.departments
    add constraint dept_id_pk
        primary key ( department_id )
            using index apex_export_user.dept_id_pk enable;

