alter table am_main.hwas_prozess_system
    add constraint fk_przp_asy_przp
        foreign key ( przp_uid_fk )
            references am_main.hwas_prozess ( przp_uid )
        enable;


-- sqlcl_snapshot {"hash":"db6976397ec0eed9bab6efe4ef08097818a0b903","type":"REF_CONSTRAINT","name":"FK_PRZP_ASY_PRZP","schemaName":"AM_MAIN","sxml":""}