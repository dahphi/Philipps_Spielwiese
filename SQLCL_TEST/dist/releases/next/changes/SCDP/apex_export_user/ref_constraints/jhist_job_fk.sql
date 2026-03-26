-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559358175 stripComments:false logicalFilePath:SCDP/apex_export_user/ref_constraints/jhist_job_fk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/ref_constraints/jhist_job_fk.sql:null:b6773cc89a67d2b5a706942e1d6c7893d013695e:create

alter table apex_export_user.job_history
    add constraint jhist_job_fk
        foreign key ( job_id )
            references apex_export_user.jobs ( job_id )
        enable;

