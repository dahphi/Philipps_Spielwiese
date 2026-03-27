alter table am_main.hwas_bean_funktionsklassen
    add constraint fk_fkl_uid
        foreign key ( fkl_uid_fk )
            references am_main.hwas_funktionsklasse ( fkl_uid )
        enable;


-- sqlcl_snapshot {"hash":"b07f19ebf263691926a27bbc2e82c99aab1faa0a","type":"REF_CONSTRAINT","name":"FK_FKL_UID","schemaName":"AM_MAIN","sxml":""}