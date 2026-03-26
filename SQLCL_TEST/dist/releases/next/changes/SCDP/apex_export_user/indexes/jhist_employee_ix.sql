-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559729231 stripComments:false logicalFilePath:SCDP/apex_export_user/indexes/jhist_employee_ix.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/indexes/jhist_employee_ix.sql:null:0c773583792d8221b257d900bf567e07758b2fa6:create

create index apex_export_user.jhist_employee_ix on
    apex_export_user.job_history (
        employee_id
    );

