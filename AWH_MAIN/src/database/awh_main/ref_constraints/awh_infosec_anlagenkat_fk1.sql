alter table awh_main.awh_infosec_anlagenkat
    add constraint awh_infosec_anlagenkat_fk1
        foreign key ( asy_lfd_nr )
            references awh_main.awh_system ( asy_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"2cdc153aebcc5c15f17cc440b4546ee33b0865f7","type":"REF_CONSTRAINT","name":"AWH_INFOSEC_ANLAGENKAT_FK1","schemaName":"AWH_MAIN","sxml":""}