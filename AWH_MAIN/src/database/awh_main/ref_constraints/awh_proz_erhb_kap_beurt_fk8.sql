alter table awh_main.awh_proz_erhb_kap_beurt
    add constraint awh_proz_erhb_kap_beurt_fk8
        foreign key ( ebu_lfd_nr_kap_6 )
            references awh_main.awh_tab_erh_beurteilung_delete ( ebu_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"94534f7c5a9372246a5d884c84875678f5fa5db9","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHB_KAP_BEURT_FK8","schemaName":"AWH_MAIN","sxml":""}