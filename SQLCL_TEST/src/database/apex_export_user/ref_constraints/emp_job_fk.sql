alter table apex_export_user.employees
    add constraint emp_job_fk
        foreign key ( job_id )
            references apex_export_user.jobs ( job_id )
        enable;


-- sqlcl_snapshot {"hash":"b2ca143c45634bd83cf9da15b1ba69d86cd17887","type":"REF_CONSTRAINT","name":"EMP_JOB_FK","schemaName":"APEX_EXPORT_USER","sxml":""}