-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559729199 stripComments:false logicalFilePath:SCDP/apex_export_user/indexes/emp_department_ix.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/indexes/emp_department_ix.sql:null:7bb54c9305166ea07610e5a50ba12ca89f50ea24:create

create index apex_export_user.emp_department_ix on
    apex_export_user.employees (
        department_id
    );

