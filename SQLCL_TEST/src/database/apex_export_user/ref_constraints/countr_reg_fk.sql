alter table apex_export_user.countries
    add constraint countr_reg_fk
        foreign key ( region_id )
            references apex_export_user.regions ( region_id )
        enable;


-- sqlcl_snapshot {"hash":"b7ba2f4c38fdc02b263c0d9c5bec02cd611ea2c1","type":"REF_CONSTRAINT","name":"COUNTR_REG_FK","schemaName":"APEX_EXPORT_USER","sxml":""}