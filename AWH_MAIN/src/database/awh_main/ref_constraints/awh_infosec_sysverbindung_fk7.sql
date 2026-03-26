alter table awh_main.awh_infosec_sysverbindung
    add constraint awh_infosec_sysverbindung_fk7
        foreign key ( aut_lfd_nr )
            references awh_main.awh_tab_schutz_authentizitaet ( aut_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"18b16f42e20e99f2a9d4fde0d66173573874fdd0","type":"REF_CONSTRAINT","name":"AWH_INFOSEC_SYSVERBINDUNG_FK7","schemaName":"AWH_MAIN","sxml":""}