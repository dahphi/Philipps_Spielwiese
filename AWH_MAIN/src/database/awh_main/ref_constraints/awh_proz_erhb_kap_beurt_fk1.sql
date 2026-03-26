alter table awh_main.awh_proz_erhb_kap_beurt
    add constraint awh_proz_erhb_kap_beurt_fk1
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"f10bb6b7b089f1f24721fe05e8a13e5cb5d3da45","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHB_KAP_BEURT_FK1","schemaName":"AWH_MAIN","sxml":""}