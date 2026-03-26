alter table rk_main.isr_massnahme_kontext
    add constraint massnahme_kontext_fk_mkt
        foreign key ( mkt_uid )
            references rk_main.isr_oam_massnahmenkontext ( mkt_uid )
        enable;


-- sqlcl_snapshot {"hash":"858758d6e8bcfe59408b4dddff986c6fc7843fb1","type":"REF_CONSTRAINT","name":"MASSNAHME_KONTEXT_FK_MKT","schemaName":"RK_MAIN","sxml":""}