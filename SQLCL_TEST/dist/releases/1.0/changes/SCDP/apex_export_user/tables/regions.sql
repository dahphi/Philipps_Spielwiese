-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774560975178 stripComments:false logicalFilePath:SCDP/apex_export_user/tables/regions.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/tables/regions.sql:null:051ec40b7cbefab9fd6e927fe18efd5788f37448:create

create table apex_export_user.regions (
    region_id   number
        constraint region_id_nn not null enable,
    region_name varchar2(25 byte)
);

create unique index apex_export_user.reg_id_pk on
    apex_export_user.regions (
        region_id
    );

alter table apex_export_user.regions
    add constraint reg_id_pk
        primary key ( region_id )
            using index apex_export_user.reg_id_pk enable;

