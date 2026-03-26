-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559729220 stripComments:false logicalFilePath:SCDP/apex_export_user/indexes/emp_name_ix.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/indexes/emp_name_ix.sql:null:d5a862ed94aa5ddc7c14cde1aa50b04e45f588b7:create

create index apex_export_user.emp_name_ix on
    apex_export_user.employees (
        last_name,
        first_name
    );

