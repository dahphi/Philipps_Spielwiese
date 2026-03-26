alter table awh_main.awh_proz_erhb_kap_beurt
    add constraint awh_proz_erhb_kap_beurt_fk4
        foreign key ( ebu_lfd_nr_kap_2 )
            references awh_main.awh_tab_erh_beurteilung_delete ( ebu_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"7eaa69008e2cdd83bfa9143883002b8170f0ca2e","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHB_KAP_BEURT_FK4","schemaName":"AWH_MAIN","sxml":""}