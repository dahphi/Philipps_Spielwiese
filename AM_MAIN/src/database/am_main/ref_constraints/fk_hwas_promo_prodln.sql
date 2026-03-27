alter table am_main.hwas_promotion
    add constraint fk_hwas_promo_prodln
        foreign key ( prod_ln_uid_fk )
            references am_main.hwas_produktlinie ( prod_ln_uid )
        enable;


-- sqlcl_snapshot {"hash":"5b47f0d444a88bd66d8169fb4b3c157ca907fac0","type":"REF_CONSTRAINT","name":"FK_HWAS_PROMO_PRODLN","schemaName":"AM_MAIN","sxml":""}