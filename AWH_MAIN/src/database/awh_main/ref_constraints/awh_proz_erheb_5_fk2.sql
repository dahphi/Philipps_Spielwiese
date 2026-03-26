alter table awh_main.awh_proz_erheb_5
    add constraint awh_proz_erheb_5_fk2
        foreign key ( kpd_lfd_nr )
            references awh_main.awh_tab_kat_persdaten ( kpd_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"a5976707a0829818e53c3d03fefdbe8e0eb711c4","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHEB_5_FK2","schemaName":"AWH_MAIN","sxml":""}