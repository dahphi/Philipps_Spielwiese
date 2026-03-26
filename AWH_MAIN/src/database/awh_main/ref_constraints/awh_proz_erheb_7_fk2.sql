alter table awh_main.awh_proz_erheb_7
    add constraint awh_proz_erheb_7_fk2
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"ae0d318e77b2040a4ef71daeda06286e35d11043","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHEB_7_FK2","schemaName":"AWH_MAIN","sxml":""}