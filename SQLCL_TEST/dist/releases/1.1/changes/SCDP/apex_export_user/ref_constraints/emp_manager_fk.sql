-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774559152798 stripComments:false logicalFilePath:SCDP/apex_export_user/ref_constraints/emp_manager_fk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/ref_constraints/emp_manager_fk.sql:null:e6f29d31d15dbb33af398ce11731b792e70b9408:create

alter table apex_export_user.employees
    add constraint emp_manager_fk
        foreign key ( manager_id )
            references apex_export_user.employees ( employee_id )
        enable;

