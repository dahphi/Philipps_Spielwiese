alter table rk_main.ad_abteilungsaccount
    add constraint ad_abteilungsaccount_fk1
        foreign key ( aa_uid )
            references rk_main.ad_abteilung ( aa_uid )
        enable;


-- sqlcl_snapshot {"hash":"6f7d5d11be99e8481c374c226e2584ca2f8f1ef8","type":"REF_CONSTRAINT","name":"AD_ABTEILUNGSACCOUNT_FK1","schemaName":"RK_MAIN","sxml":""}