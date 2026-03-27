alter table am_main.hwas_modell
    add constraint hwas_modell_fk7
        foreign key ( fkl_uid )
            references am_main.hwas_funktionsklasse ( fkl_uid )
        disable;


-- sqlcl_snapshot {"hash":"137c62e4554bbc091da35be1cdb801ae95d089e6","type":"REF_CONSTRAINT","name":"HWAS_MODELL_FK7","schemaName":"AM_MAIN","sxml":""}