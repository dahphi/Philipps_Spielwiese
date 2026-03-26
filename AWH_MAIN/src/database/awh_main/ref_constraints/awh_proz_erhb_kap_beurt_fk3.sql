alter table awh_main.awh_proz_erhb_kap_beurt
    add constraint awh_proz_erhb_kap_beurt_fk3
        foreign key ( ebu_lfd_nr_kap_1 )
            references awh_main.awh_tab_erh_beurteilung_delete ( ebu_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"2813cd66fb1931a138ca1b1175b72371e92c0478","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHB_KAP_BEURT_FK3","schemaName":"AWH_MAIN","sxml":""}