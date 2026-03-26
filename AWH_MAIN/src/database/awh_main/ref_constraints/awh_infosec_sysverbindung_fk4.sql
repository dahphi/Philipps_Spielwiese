alter table awh_main.awh_infosec_sysverbindung
    add constraint awh_infosec_sysverbindung_fk4
        foreign key ( vet_lfd_nr )
            references awh_main.awh_tab_schutz_vertraulich ( vet_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"be39acd10d0f96d1713ae174ff4ff415f61a340b","type":"REF_CONSTRAINT","name":"AWH_INFOSEC_SYSVERBINDUNG_FK4","schemaName":"AWH_MAIN","sxml":""}