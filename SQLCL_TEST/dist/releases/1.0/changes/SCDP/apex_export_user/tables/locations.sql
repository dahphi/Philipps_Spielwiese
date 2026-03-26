-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559573384 stripComments:false logicalFilePath:SCDP/apex_export_user/tables/locations.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/tables/locations.sql:null:59a12ae2e43fe027b0f9bcdf1fa8d7ea49ff9ec9:create

create table apex_export_user.locations (
    location_id    number(4, 0),
    street_address varchar2(40 byte),
    postal_code    varchar2(12 byte),
    city           varchar2(30 byte)
        constraint loc_city_nn not null enable,
    state_province varchar2(25 byte),
    country_id     char(2 byte)
);

create unique index apex_export_user.loc_id_pk on
    apex_export_user.locations (
        location_id
    );

alter table apex_export_user.locations
    add constraint loc_id_pk
        primary key ( location_id )
            using index apex_export_user.loc_id_pk enable;

