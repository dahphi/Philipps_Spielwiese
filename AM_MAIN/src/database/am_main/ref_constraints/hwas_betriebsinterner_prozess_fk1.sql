alter table am_main.hwas_betriebsinterner_prozess
    add constraint hwas_betriebsinterner_prozess_fk1
        foreign key ( ak3_uid )
            references am_main.hwas_anlagenkategorie_e3 ( ak3_uid )
        enable;


-- sqlcl_snapshot {"hash":"6745d5e07d9e6aa7f1c700ed7f097c3ae24e8843","type":"REF_CONSTRAINT","name":"HWAS_BETRIEBSINTERNER_PROZESS_FK1","schemaName":"AM_MAIN","sxml":""}