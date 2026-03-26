alter table awh_main.awh_erhb_lock
    add constraint awh_erhb_lock_fk1
        foreign key ( asy_lfd_nr )
            references awh_main.awh_system ( asy_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"b58d89de9b959aa4fb8cbfc7bdf69ed8e11a796c","type":"REF_CONSTRAINT","name":"AWH_ERHB_LOCK_FK1","schemaName":"AWH_MAIN","sxml":""}