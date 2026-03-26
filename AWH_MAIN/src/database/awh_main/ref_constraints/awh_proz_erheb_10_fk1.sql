alter table awh_main.awh_proz_erheb_10
    add constraint awh_proz_erheb_10_fk1
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"4e212bd3f2fac9006e3826bbad908510a759d76a","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHEB_10_FK1","schemaName":"AWH_MAIN","sxml":""}