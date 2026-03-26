alter table awh_main.awh_eudsgvo_benutzer
    add constraint awh_eudsgvo_benutzer_fk2
        foreign key ( bka_lfd_nr )
            references awh_main.awh_eudsgvo_tab_benkat ( bka_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"4b7eff2ec9d6c96ec4e70b9c2baaf5dd3dbe2fe4","type":"REF_CONSTRAINT","name":"AWH_EUDSGVO_BENUTZER_FK2","schemaName":"AWH_MAIN","sxml":""}