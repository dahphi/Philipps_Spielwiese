alter table am_main.hwas_prozessstufe
    add constraint fk_hwas_prozessstufe_prozesstyp
        foreign key ( prz_uid )
            references am_main.hwas_prozesstyp ( prz_uid )
        enable;


-- sqlcl_snapshot {"hash":"a6a17c2386c46223a2f15f7d2b9dc6491cb0c3fe","type":"REF_CONSTRAINT","name":"FK_HWAS_PROZESSSTUFE_PROZESSTYP","schemaName":"AM_MAIN","sxml":""}