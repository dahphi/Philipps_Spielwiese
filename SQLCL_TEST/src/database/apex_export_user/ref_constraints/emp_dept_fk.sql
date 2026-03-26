alter table apex_export_user.employees
    add constraint emp_dept_fk
        foreign key ( department_id )
            references apex_export_user.departments ( department_id )
        enable;


-- sqlcl_snapshot {"hash":"35e0f143f77f0fe28d2077804bbb4e332eef58e1","type":"REF_CONSTRAINT","name":"EMP_DEPT_FK","schemaName":"APEX_EXPORT_USER","sxml":""}