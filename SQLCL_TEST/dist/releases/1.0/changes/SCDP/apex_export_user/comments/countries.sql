-- liquibase formatted sql
-- changeset apex_export_user:1774560038354 stripComments:false logicalFilePath:SCDP/apex_export_user/comments/countries.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/comments/countries.sql:null:3d3de65d0b1f88e98b6c3943705afa516a0c5473:create

comment on table apex_export_user.countries is
    'country table. References with locations table.';

comment on column apex_export_user.countries.country_id is
    'Primary key of countries table.';

comment on column apex_export_user.countries.country_name is
    'Country name';

comment on column apex_export_user.countries.region_id is
    'Region ID for the country. Foreign key to region_id column in the departments table.';

