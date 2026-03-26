alter table awh_main.awh_proz_erheb_4
    add constraint awh_proz_erheb_4_fk1
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"9ed567cab1b4ce1bb00a2cb451bb95e99b7097ac","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHEB_4_FK1","schemaName":"AWH_MAIN","sxml":""}