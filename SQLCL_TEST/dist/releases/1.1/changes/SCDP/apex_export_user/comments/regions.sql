-- liquibase formatted sql
-- changeset apex_export_user:1774559729183 stripComments:false logicalFilePath:SCDP/apex_export_user/comments/regions.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/comments/regions.sql:null:ca48293813ed439b99f5f7a1304912ff396f3f54:create

comment on table apex_export_user.regions is
    'Regions table that contains region numbers and names. references with the Countries table.';

comment on column apex_export_user.regions.region_id is
    'Primary key of regions table.';

comment on column apex_export_user.regions.region_name is
    'Names of regions. Locations are in the countries of these regions.';

