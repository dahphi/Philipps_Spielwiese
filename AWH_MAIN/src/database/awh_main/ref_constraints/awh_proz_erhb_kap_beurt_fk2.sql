alter table awh_main.awh_proz_erhb_kap_beurt
    add constraint awh_proz_erhb_kap_beurt_fk2
        foreign key ( ebu_lfd_nr_kap_alg )
            references awh_main.awh_tab_erh_beurteilung_delete ( ebu_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"70dfa0d4c01abbd301f1783748085872a9c0fef5","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHB_KAP_BEURT_FK2","schemaName":"AWH_MAIN","sxml":""}