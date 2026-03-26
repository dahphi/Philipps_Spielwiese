alter table awh_main.awh_proz_erhb_kap_beurt
    add constraint awh_proz_erhb_kap_beurt_fk10
        foreign key ( ebu_lfd_nr_kap_8 )
            references awh_main.awh_tab_erh_beurteilung_delete ( ebu_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"d3521ece978fee13f9cedcef52e3f7c27de9b9a1","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHB_KAP_BEURT_FK10","schemaName":"AWH_MAIN","sxml":""}