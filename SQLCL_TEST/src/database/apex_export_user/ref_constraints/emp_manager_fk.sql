alter table apex_export_user.employees
    add constraint emp_manager_fk
        foreign key ( manager_id )
            references apex_export_user.employees ( employee_id )
        enable;


-- sqlcl_snapshot {"hash":"e6f29d31d15dbb33af398ce11731b792e70b9408","type":"REF_CONSTRAINT","name":"EMP_MANAGER_FK","schemaName":"APEX_EXPORT_USER","sxml":""}