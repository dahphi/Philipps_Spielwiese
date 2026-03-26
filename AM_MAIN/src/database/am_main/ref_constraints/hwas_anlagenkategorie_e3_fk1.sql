alter table am_main.hwas_anlagenkategorie_e3
    add constraint hwas_anlagenkategorie_e3_fk1
        foreign key ( be2_uid )
            references am_main.hwas_bereich_e2 ( be2_uid )
        enable;


-- sqlcl_snapshot {"hash":"98a923611cda26fcf378154b3cd1bc7acbd86fc0","type":"REF_CONSTRAINT","name":"HWAS_ANLAGENKATEGORIE_E3_FK1","schemaName":"AM_MAIN","sxml":""}