alter table apex_export_user.job_history
    add constraint jhist_job_fk
        foreign key ( job_id )
            references apex_export_user.jobs ( job_id )
        enable;


-- sqlcl_snapshot {"hash":"b6773cc89a67d2b5a706942e1d6c7893d013695e","type":"REF_CONSTRAINT","name":"JHIST_JOB_FK","schemaName":"APEX_EXPORT_USER","sxml":""}