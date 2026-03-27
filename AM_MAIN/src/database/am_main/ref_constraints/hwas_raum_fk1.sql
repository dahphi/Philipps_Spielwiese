alter table am_main.hwas_raum
    add constraint hwas_raum_fk1
        foreign key ( geb_uid )
            references am_main.hwas_gebaeude ( geb_uid )
        enable;


-- sqlcl_snapshot {"hash":"95e404d21db4d832d4d16cd7bbf93c92cfd1e091","type":"REF_CONSTRAINT","name":"HWAS_RAUM_FK1","schemaName":"AM_MAIN","sxml":""}