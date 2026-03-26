-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559152865 stripComments:false logicalFilePath:SCDP/apex_export_user/tables/countries.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/tables/countries.sql:null:72f0e25ea672e5b64d24aabe8797dea2b2b446bf:create

create table apex_export_user.countries (
    country_id   char(2 byte)
        constraint country_id_nn not null enable,
    country_name varchar2(60 byte),
    region_id    number,
    constraint country_c_id_pk primary key ( country_id ) enable
)
organization index nocompress;

