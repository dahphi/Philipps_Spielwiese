alter table am_main.hwas_prozessstufe
    add constraint fk_hwas_prozessstufe_parent
        foreign key ( parent_przs_uid )
            references am_main.hwas_prozessstufe ( przs_uid )
        enable;


-- sqlcl_snapshot {"hash":"c34e3f4f584a8c4c39872e920ca56eb6a9d5de8e","type":"REF_CONSTRAINT","name":"FK_HWAS_PROZESSSTUFE_PARENT","schemaName":"AM_MAIN","sxml":""}