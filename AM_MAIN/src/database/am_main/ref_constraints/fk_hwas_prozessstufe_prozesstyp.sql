alter table am_main.hwas_prozessstufe
    add constraint fk_hwas_prozessstufe_prozesstyp
        foreign key ( prz_uid )
            references am_main.hwas_prozesstyp ( prz_uid )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"f07dcfac26aa85c1f13e2e32870044814cbf99e0","type":"REF_CONSTRAINT","name":"FK_HWAS_PROZESSSTUFE_PROZESSTYP","schemaName":"AM_MAIN","sxml":""}