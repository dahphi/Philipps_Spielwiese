-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559573214 stripComments:false logicalFilePath:SCDP/apex_export_user/ref_constraints/jhist_dept_fk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/ref_constraints/jhist_dept_fk.sql:null:01773c4b0a0cf1f355e6868ac8ac3ccebaa6d0f8:create

alter table apex_export_user.job_history
    add constraint jhist_dept_fk
        foreign key ( department_id )
            references apex_export_user.departments ( department_id )
        enable;

