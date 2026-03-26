alter table awh_main.awh_proz_erheb_1
    add constraint awh_proz_erheb_1_fk4
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"14d5cad81005e7450cd91ece7ffe3c44f1280789","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHEB_1_FK4","schemaName":"AWH_MAIN","sxml":""}