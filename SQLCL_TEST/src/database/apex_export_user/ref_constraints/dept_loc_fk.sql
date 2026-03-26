alter table apex_export_user.departments
    add constraint dept_loc_fk
        foreign key ( location_id )
            references apex_export_user.locations ( location_id )
        enable;


-- sqlcl_snapshot {"hash":"e29854218e6f5130fe50628daf64cb27c337aa77","type":"REF_CONSTRAINT","name":"DEPT_LOC_FK","schemaName":"APEX_EXPORT_USER","sxml":""}