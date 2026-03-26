alter table awh_main.awh_proz_erheb_7
    add constraint awh_proz_erheb_7_fk1
        foreign key ( exs_lfd_nr )
            references awh_main.awh_tab_ext_stelle ( exs_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"9429828b94e0f04b323269a2685c5463b4271d4d","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHEB_7_FK1","schemaName":"AWH_MAIN","sxml":""}