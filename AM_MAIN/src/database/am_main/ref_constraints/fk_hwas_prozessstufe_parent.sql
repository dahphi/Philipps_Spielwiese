alter table am_main.hwas_prozessstufe
    add constraint fk_hwas_prozessstufe_parent
        foreign key ( parent_przs_uid )
            references am_main.hwas_prozessstufe ( przs_uid )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"8abfc9b59b7f457169b9566b213bdb1d63760299","type":"REF_CONSTRAINT","name":"FK_HWAS_PROZESSSTUFE_PARENT","schemaName":"AM_MAIN","sxml":""}