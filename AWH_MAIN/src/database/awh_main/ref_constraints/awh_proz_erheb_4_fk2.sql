alter table awh_main.awh_proz_erheb_4
    add constraint awh_proz_erheb_4_fk2
        foreign key ( bpg_lfd_nr )
            references awh_main.awh_tab_betrof_persgrup ( bpg_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"a04714b57917896eb9aaf1ebaf0086bcb2ac728d","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHEB_4_FK2","schemaName":"AWH_MAIN","sxml":""}