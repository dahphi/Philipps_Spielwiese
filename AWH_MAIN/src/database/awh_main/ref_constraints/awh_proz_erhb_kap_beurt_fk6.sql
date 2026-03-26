alter table awh_main.awh_proz_erhb_kap_beurt
    add constraint awh_proz_erhb_kap_beurt_fk6
        foreign key ( ebu_lfd_nr_kap_4 )
            references awh_main.awh_tab_erh_beurteilung_delete ( ebu_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"5449fc657c3c314b746f13a1eebb53da17ba6fb0","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHB_KAP_BEURT_FK6","schemaName":"AWH_MAIN","sxml":""}