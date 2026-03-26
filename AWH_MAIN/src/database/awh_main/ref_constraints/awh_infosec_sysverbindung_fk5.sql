alter table awh_main.awh_infosec_sysverbindung
    add constraint awh_infosec_sysverbindung_fk5
        foreign key ( int_lfd_nr )
            references awh_main.awh_tab_schutz_integritaet ( int_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"4c13291f2f77dcdc75b48e4354728437bb96e9ba","type":"REF_CONSTRAINT","name":"AWH_INFOSEC_SYSVERBINDUNG_FK5","schemaName":"AWH_MAIN","sxml":""}