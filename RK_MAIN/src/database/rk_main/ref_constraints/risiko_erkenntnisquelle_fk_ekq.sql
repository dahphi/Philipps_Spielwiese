alter table rk_main.isr_risiko_erkenntnisquelle
    add constraint risiko_erkenntnisquelle_fk_ekq
        foreign key ( ekq_uid )
            references rk_main.asm_am_erkenntnisquellen ( ekq_uid )
        enable;


-- sqlcl_snapshot {"hash":"cea7821e60ab869f71321edb860a04e53cd07ad8","type":"REF_CONSTRAINT","name":"RISIKO_ERKENNTNISQUELLE_FK_EKQ","schemaName":"RK_MAIN","sxml":""}