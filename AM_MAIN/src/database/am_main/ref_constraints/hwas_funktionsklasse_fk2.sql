alter table am_main.hwas_funktionsklasse
    add constraint hwas_funktionsklasse_fk2
        foreign key ( tkt_uid )
            references am_main.hwas_tk_technologie ( tkt_uid )
        enable;


-- sqlcl_snapshot {"hash":"7480e51b6dcfb49c3f2abe29c6e1b2c26b86747a","type":"REF_CONSTRAINT","name":"HWAS_FUNKTIONSKLASSE_FK2","schemaName":"AM_MAIN","sxml":""}