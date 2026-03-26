alter table apex_export_user.job_history
    add constraint jhist_emp_fk
        foreign key ( employee_id )
            references apex_export_user.employees ( employee_id )
        enable;


-- sqlcl_snapshot {"hash":"bcb16472213d48643f88f28d4c63f7a90dfbab35","type":"REF_CONSTRAINT","name":"JHIST_EMP_FK","schemaName":"APEX_EXPORT_USER","sxml":""}