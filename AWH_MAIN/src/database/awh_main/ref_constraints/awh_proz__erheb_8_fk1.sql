alter table awh_main.awh_proz_erheb_8
    add constraint awh_proz__erheb_8_fk1
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"725574e516a4dfa7d536fcd184a2c2f68e5c0080","type":"REF_CONSTRAINT","name":"AWH_PROZ__ERHEB_8_FK1","schemaName":"AWH_MAIN","sxml":""}