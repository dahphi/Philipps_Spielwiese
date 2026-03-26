-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559152813 stripComments:false logicalFilePath:SCDP/apex_export_user/ref_constraints/jhist_emp_fk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/ref_constraints/jhist_emp_fk.sql:null:bcb16472213d48643f88f28d4c63f7a90dfbab35:create

alter table apex_export_user.job_history
    add constraint jhist_emp_fk
        foreign key ( employee_id )
            references apex_export_user.employees ( employee_id )
        enable;

