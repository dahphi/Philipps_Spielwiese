alter table awh_main.awh_proz_erheb_2_1
    add constraint awh_proz_erheb_2_1_fk1
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"4bc862e63f3b64a6d1119c6274a3f4e9e5afd341","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHEB_2_1_FK1","schemaName":"AWH_MAIN","sxml":""}