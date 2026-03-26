alter table am_main.hwas_prozesse_vertragsdetails
    add constraint fk_przp_przp
        foreign key ( przp_uid_fk )
            references am_main.hwas_prozess ( przp_uid )
        enable;


-- sqlcl_snapshot {"hash":"9c8123042c32c5aa63639366ab3b74bcec2ca1da","type":"REF_CONSTRAINT","name":"FK_PRZP_PRZP","schemaName":"AM_MAIN","sxml":""}