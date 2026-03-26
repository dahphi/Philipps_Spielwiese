alter table rk_main.isr_massnahme_kontext
    add constraint massnahme_kontext_fk_msn
        foreign key ( msn_uid )
            references rk_main.isr_oam_massnahme ( msn_uid )
        enable;


-- sqlcl_snapshot {"hash":"d1e488899f6444acfc461ef3a1160eb12a8bcbac","type":"REF_CONSTRAINT","name":"MASSNAHME_KONTEXT_FK_MSN","schemaName":"RK_MAIN","sxml":""}