alter table awh_main.awh_proz_freigaben
    add constraint awh_proz_erheb_11_fk1
        foreign key ( pro_lfd_nr )
            references awh_main.awh_tab_prozess ( pro_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"c6e162fa238bc276fb0845a52b04513e424830c5","type":"REF_CONSTRAINT","name":"AWH_PROZ_ERHEB_11_FK1","schemaName":"AWH_MAIN","sxml":""}