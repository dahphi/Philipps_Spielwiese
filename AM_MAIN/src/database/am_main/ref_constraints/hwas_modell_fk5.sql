alter table am_main.hwas_modell
    add constraint hwas_modell_fk5
        foreign key ( hst_uid )
            references am_main.hwas_hersteller ( hst_uid )
        enable;


-- sqlcl_snapshot {"hash":"3118a2fb54940a2399c117b07f3f9baa59d89947","type":"REF_CONSTRAINT","name":"HWAS_MODELL_FK5","schemaName":"AM_MAIN","sxml":""}