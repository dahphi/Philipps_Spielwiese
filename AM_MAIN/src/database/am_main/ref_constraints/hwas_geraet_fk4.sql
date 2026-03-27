alter table am_main.hwas_geraet
    add constraint hwas_geraet_fk4
        foreign key ( hst_uid )
            references am_main.hwas_hersteller ( hst_uid )
        enable;


-- sqlcl_snapshot {"hash":"e1bd35522a3f8119dbe376600ea99634e2bdd8a2","type":"REF_CONSTRAINT","name":"HWAS_GERAET_FK4","schemaName":"AM_MAIN","sxml":""}