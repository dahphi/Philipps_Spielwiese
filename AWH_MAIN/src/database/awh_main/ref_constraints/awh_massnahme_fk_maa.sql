alter table awh_main.awh_massnahme
    add constraint awh_massnahme_fk_maa
        foreign key ( maa_lfd_nr )
            references awh_main.awh_tab_mass_art ( maa_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"571691600ad4a003bd66ae2ab4d3ab2d8d5e4138","type":"REF_CONSTRAINT","name":"AWH_MASSNAHME_FK_MAA","schemaName":"AWH_MAIN","sxml":""}