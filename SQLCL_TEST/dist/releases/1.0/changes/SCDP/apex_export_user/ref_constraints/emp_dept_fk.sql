-- liquibase formatted sql
-- changeset APEX_EXPORT_USER:1774560974942 stripComments:false logicalFilePath:SCDP/apex_export_user/ref_constraints/emp_dept_fk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot SQLCL_TEST/src/database/apex_export_user/ref_constraints/emp_dept_fk.sql:null:35e0f143f77f0fe28d2077804bbb4e332eef58e1:create

alter table apex_export_user.employees
    add constraint emp_dept_fk
        foreign key ( department_id )
            references apex_export_user.departments ( department_id )
        enable;

