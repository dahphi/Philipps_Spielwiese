alter table awh_main.awh_massnahme
    add constraint awh_massnahme_fk_sys
        foreign key ( asy_lfd_nr )
            references awh_main.awh_system ( asy_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"4778339ccf87cbf0c3f3889a9583ab760d30a42d","type":"REF_CONSTRAINT","name":"AWH_MASSNAHME_FK_SYS","schemaName":"AWH_MAIN","sxml":""}