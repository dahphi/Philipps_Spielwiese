alter table am_main.hwas_prozesse_bsi_bausteine
    add constraint fk_przpbsi_przp
        foreign key ( przp_uid_fk )
            references am_main.hwas_prozess ( przp_uid )
        enable;


-- sqlcl_snapshot {"hash":"ef419323569d4e82b5758c2363bd95f671434afc","type":"REF_CONSTRAINT","name":"FK_PRZPBSI_PRZP","schemaName":"AM_MAIN","sxml":""}