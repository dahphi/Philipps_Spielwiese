alter table awh_main.awh_proz_erhb_anhang
    add constraint awh_proz_erhb_anhang_fk1
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"9d7288977c6fa316b526d4c03d2d82cd29d0bf19","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHB_ANHANG_FK1","schemaName":"AWH_MAIN","sxml":""}