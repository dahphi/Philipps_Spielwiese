alter table apex_export_user.departments
    add constraint dept_mgr_fk
        foreign key ( manager_id )
            references apex_export_user.employees ( employee_id )
        enable;


-- sqlcl_snapshot {"hash":"c65e222abd010a7ee4873e61bb6e911a3afe8c06","type":"REF_CONSTRAINT","name":"DEPT_MGR_FK","schemaName":"APEX_EXPORT_USER","sxml":""}