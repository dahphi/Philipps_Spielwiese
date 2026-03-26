-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774560038468 stripComments:false logicalFilePath:SCDP/apex_export_user/indexes/dept_location_ix.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/indexes/dept_location_ix.sql:null:6ad76aa926f07771566c41f9752eb9ade0478d75:create

create index apex_export_user.dept_location_ix on
    apex_export_user.departments (
        location_id
    );

