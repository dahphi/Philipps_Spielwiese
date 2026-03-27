alter table am_main.hwas_prozess_system
    add constraint fk_przp_asy_system
        foreign key ( asy_lfd_nr_fk )
            references awh_main.awh_system ( asy_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"267930730505581d406cbe8a0584caaaed72cf55","type":"REF_CONSTRAINT","name":"FK_PRZP_ASY_SYSTEM","schemaName":"AM_MAIN","sxml":""}