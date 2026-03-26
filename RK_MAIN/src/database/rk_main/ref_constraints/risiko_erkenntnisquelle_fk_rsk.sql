alter table rk_main.isr_risiko_erkenntnisquelle
    add constraint risiko_erkenntnisquelle_fk_rsk
        foreign key ( rsk_uid )
            references rk_main.isr_oam_risikoinventar ( rsk_uid )
        enable;


-- sqlcl_snapshot {"hash":"809e5b716e524110f08b46ebb16ab23d91d92fdc","type":"REF_CONSTRAINT","name":"RISIKO_ERKENNTNISQUELLE_FK_RSK","schemaName":"RK_MAIN","sxml":""}