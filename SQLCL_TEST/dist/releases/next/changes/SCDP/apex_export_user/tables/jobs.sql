-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774560228930 stripComments:false logicalFilePath:SCDP/apex_export_user/tables/jobs.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/tables/jobs.sql:null:2429c69894eef03fc92e6febcab54637a0f3dc9f:create

create table apex_export_user.jobs (
    job_id     varchar2(10 byte),
    job_title  varchar2(35 byte)
        constraint job_title_nn not null enable,
    min_salary number(6, 0),
    max_salary number(6, 0)
);

create unique index apex_export_user.job_id_pk on
    apex_export_user.jobs (
        job_id
    );

alter table apex_export_user.jobs
    add constraint job_id_pk
        primary key ( job_id )
            using index apex_export_user.job_id_pk enable;

