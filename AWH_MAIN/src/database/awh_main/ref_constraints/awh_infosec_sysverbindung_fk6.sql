alter table awh_main.awh_infosec_sysverbindung
    add constraint awh_infosec_sysverbindung_fk6
        foreign key ( vef_lfd_nr )
            references awh_main.awh_tab_schutz_verfuegbar ( vef_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"dee05823e6acb5b5d109b0016a0449ffcfe70c25","type":"REF_CONSTRAINT","name":"AWH_INFOSEC_SYSVERBINDUNG_FK6","schemaName":"AWH_MAIN","sxml":""}