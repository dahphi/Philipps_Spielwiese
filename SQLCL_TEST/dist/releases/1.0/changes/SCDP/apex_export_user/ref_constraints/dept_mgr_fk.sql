-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774560974933 stripComments:false logicalFilePath:SCDP/apex_export_user/ref_constraints/dept_mgr_fk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/ref_constraints/dept_mgr_fk.sql:null:c65e222abd010a7ee4873e61bb6e911a3afe8c06:create

alter table apex_export_user.departments
    add constraint dept_mgr_fk
        foreign key ( manager_id )
            references apex_export_user.employees ( employee_id )
        enable;

