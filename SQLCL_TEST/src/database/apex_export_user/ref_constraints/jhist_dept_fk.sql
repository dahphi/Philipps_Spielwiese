alter table apex_export_user.job_history
    add constraint jhist_dept_fk
        foreign key ( department_id )
            references apex_export_user.departments ( department_id )
        enable;


-- sqlcl_snapshot {"hash":"01773c4b0a0cf1f355e6868ac8ac3ccebaa6d0f8","type":"REF_CONSTRAINT","name":"JHIST_DEPT_FK","schemaName":"APEX_EXPORT_USER","sxml":""}