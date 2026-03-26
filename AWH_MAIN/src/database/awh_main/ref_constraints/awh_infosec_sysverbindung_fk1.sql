alter table awh_main.awh_infosec_sysverbindung
    add constraint awh_infosec_sysverbindung_fk1
        foreign key ( asy_lfd_nr_out )
            references awh_main.awh_system ( asy_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"76192cfdd741986365398720c9f9c1a7c1eff9bf","type":"REF_CONSTRAINT","name":"AWH_INFOSEC_SYSVERBINDUNG_FK1","schemaName":"AWH_MAIN","sxml":""}