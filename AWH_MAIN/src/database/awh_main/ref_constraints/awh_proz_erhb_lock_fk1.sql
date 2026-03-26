alter table awh_main.awh_proz_erhb_lock
    add constraint awh_proz_erhb_lock_fk1
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"b6c02dea2b53438819fe3043bf44d4eb577fae53","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHB_LOCK_FK1","schemaName":"AWH_MAIN","sxml":""}