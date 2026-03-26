alter table awh_main.awh_eudsgvo_proz_bef
    add constraint awh_eudsgvo_proz_bef_fk1
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"45cfa54e76fb9258f81b1b60a2f746e2f1d9e1d3","type":"REF_CONSTRAINT","name":"AWH_EUDSGVO_PROZ_BEF_FK1","schemaName":"AWH_MAIN","sxml":""}