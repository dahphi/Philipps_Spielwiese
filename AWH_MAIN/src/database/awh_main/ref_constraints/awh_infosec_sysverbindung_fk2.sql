alter table awh_main.awh_infosec_sysverbindung
    add constraint awh_infosec_sysverbindung_fk2
        foreign key ( asy_lfd_nr_in )
            references awh_main.awh_system ( asy_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"2341f5b91a57055bdb1e3df3fdde75d9f7977a32","type":"REF_CONSTRAINT","name":"AWH_INFOSEC_SYSVERBINDUNG_FK2","schemaName":"AWH_MAIN","sxml":""}