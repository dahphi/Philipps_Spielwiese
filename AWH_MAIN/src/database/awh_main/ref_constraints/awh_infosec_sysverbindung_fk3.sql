alter table awh_main.awh_infosec_sysverbindung
    add constraint awh_infosec_sysverbindung_fk3
        foreign key ( trv_lfd_nr )
            references awh_main.awh_tab_infosec_transitv ( trv_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"3fdae0ac86036bd37ce65df1d426b3eb87033879","type":"REF_CONSTRAINT","name":"AWH_INFOSEC_SYSVERBINDUNG_FK3","schemaName":"AWH_MAIN","sxml":""}