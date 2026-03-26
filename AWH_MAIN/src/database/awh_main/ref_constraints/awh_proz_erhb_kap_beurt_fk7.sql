alter table awh_main.awh_proz_erhb_kap_beurt
    add constraint awh_proz_erhb_kap_beurt_fk7
        foreign key ( ebu_lfd_nr_kap_5 )
            references awh_main.awh_tab_erh_beurteilung_delete ( ebu_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"a2cd27891021d7911192402aae8ab0a03d8afbb9","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHB_KAP_BEURT_FK7","schemaName":"AWH_MAIN","sxml":""}