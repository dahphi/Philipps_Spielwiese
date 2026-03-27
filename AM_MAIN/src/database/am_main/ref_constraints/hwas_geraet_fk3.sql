alter table am_main.hwas_geraet
    add constraint hwas_geraet_fk3
        foreign key ( geb_uid )
            references am_main.hwas_gebaeude ( geb_uid )
        enable;


-- sqlcl_snapshot {"hash":"569780de242901fbd6c41edf71715f555d51a2aa","type":"REF_CONSTRAINT","name":"HWAS_GERAET_FK3","schemaName":"AM_MAIN","sxml":""}