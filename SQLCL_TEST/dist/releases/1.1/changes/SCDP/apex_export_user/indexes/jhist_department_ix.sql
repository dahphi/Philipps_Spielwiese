-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774560228719 stripComments:false logicalFilePath:SCDP/apex_export_user/indexes/jhist_department_ix.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/indexes/jhist_department_ix.sql:null:dc666f01bef1f9cd8824f469081d42efcf8bad02:create

create index apex_export_user.jhist_department_ix on
    apex_export_user.job_history (
        department_id
    );

