alter table awh_main.awh_proz_erheb_2
    add constraint awh_proz_erheb_2_fk1
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"4127970792c86d0a87f5c81b14e6305ac44affc4","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHEB_2_FK1","schemaName":"AWH_MAIN","sxml":""}