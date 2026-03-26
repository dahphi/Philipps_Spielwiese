alter table rk_main.isr_assettypen_gefaehrdungkat
    add constraint isr_asgk_fk_1
        foreign key ( ast_uid )
            references rk_main.asm_am_assettypen ( ast_uid )
        enable;


-- sqlcl_snapshot {"hash":"583a7933c7ba664a7389a87410e7ce7558386612","type":"REF_CONSTRAINT","name":"ISR_ASGK_FK_1","schemaName":"RK_MAIN","sxml":""}