alter table awh_main.awh_proz_erhb_kap_beurt
    add constraint awh_proz_erhb_kap_beurt_fk9
        foreign key ( ebu_lfd_nr_kap_7 )
            references awh_main.awh_tab_erh_beurteilung_delete ( ebu_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"b03b18d43f4dd0cfd0a683e470b19092d01e9ffb","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHB_KAP_BEURT_FK9","schemaName":"AWH_MAIN","sxml":""}