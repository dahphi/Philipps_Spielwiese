-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774560974777 stripComments:false logicalFilePath:SCDP/apex_export_user/indexes/emp_job_ix.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/indexes/emp_job_ix.sql:null:8762fe9b3d07261752a55d61d754de627c84b05f:create

create index apex_export_user.emp_job_ix on
    apex_export_user.employees (
        job_id
    );

