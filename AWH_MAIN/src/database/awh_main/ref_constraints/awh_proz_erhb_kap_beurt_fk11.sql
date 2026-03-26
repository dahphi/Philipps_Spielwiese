alter table awh_main.awh_proz_erhb_kap_beurt
    add constraint awh_proz_erhb_kap_beurt_fk11
        foreign key ( ebu_lfd_nr_kap_9 )
            references awh_main.awh_tab_erh_beurteilung_delete ( ebu_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"4eafeeeb1a9f0a3440d629893103b1e0c533dd76","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHB_KAP_BEURT_FK11","schemaName":"AWH_MAIN","sxml":""}