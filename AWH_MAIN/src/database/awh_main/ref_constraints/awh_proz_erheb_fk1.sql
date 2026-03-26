alter table awh_main.awh_proz_erheb
    add constraint awh_proz_erheb_fk1
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"7a60133b4e3050b40a0df381f0d83f6e97088f1f","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHEB_FK1","schemaName":"AWH_MAIN","sxml":""}