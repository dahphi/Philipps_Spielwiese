alter table awh_main.awh_proz_erheb_5
    add constraint awh_proz_erheb_5_fk1
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"54be530a03f863d2155da06c02885eee6fabf02c","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHEB_5_FK1","schemaName":"AWH_MAIN","sxml":""}