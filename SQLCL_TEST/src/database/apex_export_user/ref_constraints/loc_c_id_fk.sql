alter table apex_export_user.locations
    add constraint loc_c_id_fk
        foreign key ( country_id )
            references apex_export_user.countries ( country_id )
        enable;


-- sqlcl_snapshot {"hash":"b967f05f08a2d095f0b4e9d43426668a8e274de7","type":"REF_CONSTRAINT","name":"LOC_C_ID_FK","schemaName":"APEX_EXPORT_USER","sxml":""}