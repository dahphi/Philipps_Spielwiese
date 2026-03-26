-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559573144 stripComments:false logicalFilePath:SCDP/apex_export_user/indexes/jhist_job_ix.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/indexes/jhist_job_ix.sql:null:ce54c6dee38f855dd98670a4225f8679932477e8:create

create index apex_export_user.jhist_job_ix on
    apex_export_user.job_history (
        job_id
    );

