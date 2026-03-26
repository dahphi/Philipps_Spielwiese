alter table am_main.hwas_geraet
    add constraint hwas_geraet_fk1
        foreign key ( mdl_uid )
            references am_main.hwas_modell ( mdl_uid )
        enable;


-- sqlcl_snapshot {"hash":"c1525e46fb04071a44dad9f9b2277fef75672873","type":"REF_CONSTRAINT","name":"HWAS_GERAET_FK1","schemaName":"AM_MAIN","sxml":""}