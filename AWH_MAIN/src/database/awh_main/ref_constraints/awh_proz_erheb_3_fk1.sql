alter table awh_main.awh_proz_erheb_3
    add constraint awh_proz_erheb_3_fk1
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"d67a7fa4016dc215c8c5efffe9f2b3cf11d9736b","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHEB_3_FK1","schemaName":"AWH_MAIN","sxml":""}