alter table am_main.hwas_modell
    add constraint hwas_modell_fk6
        foreign key ( gkl_uid )
            references am_main.hwas_geraeteklasse ( gkl_uid )
        enable;


-- sqlcl_snapshot {"hash":"ccf8ba263073ff7c90937f21dd8a7a1fa305818a","type":"REF_CONSTRAINT","name":"HWAS_MODELL_FK6","schemaName":"AM_MAIN","sxml":""}