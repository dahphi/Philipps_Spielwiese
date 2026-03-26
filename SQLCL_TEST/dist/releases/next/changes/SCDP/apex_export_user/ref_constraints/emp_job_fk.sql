-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774560974950 stripComments:false logicalFilePath:SCDP/apex_export_user/ref_constraints/emp_job_fk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/ref_constraints/emp_job_fk.sql:null:b2ca143c45634bd83cf9da15b1ba69d86cd17887:create

alter table apex_export_user.employees
    add constraint emp_job_fk
        foreign key ( job_id )
            references apex_export_user.jobs ( job_id )
        enable;

