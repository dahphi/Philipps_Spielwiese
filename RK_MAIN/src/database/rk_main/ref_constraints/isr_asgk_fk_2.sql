alter table rk_main.isr_assettypen_gefaehrdungkat
    add constraint isr_asgk_fk_2
        foreign key ( gfk_uid )
            references rk_main.isr_brm_gefaehrdungkat ( gfk_uid )
        enable;


-- sqlcl_snapshot {"hash":"45aa50ab0e87a9c1840dd040a46431294d388f55","type":"REF_CONSTRAINT","name":"ISR_ASGK_FK_2","schemaName":"RK_MAIN","sxml":""}