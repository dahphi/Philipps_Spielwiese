alter table awh_main.awh_proz_erhb_kap_beurt
    add constraint awh_proz_erhb_kap_beurt_fk5
        foreign key ( ebu_lfd_nr_kap_3 )
            references awh_main.awh_tab_erh_beurteilung_delete ( ebu_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"89cc12c75ca2df0365bae1f2cb55636662eccceb","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHB_KAP_BEURT_FK5","schemaName":"AWH_MAIN","sxml":""}