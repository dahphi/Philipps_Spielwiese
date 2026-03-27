alter table am_main.hwas_geraet
    add constraint hwas_geraet_fk2
        foreign key ( rm_uid )
            references am_main.hwas_raum ( rm_uid )
        enable;


-- sqlcl_snapshot {"hash":"af1a08442fcf1dc04e8ab0c70951f34bf8e6129a","type":"REF_CONSTRAINT","name":"HWAS_GERAET_FK2","schemaName":"AM_MAIN","sxml":""}