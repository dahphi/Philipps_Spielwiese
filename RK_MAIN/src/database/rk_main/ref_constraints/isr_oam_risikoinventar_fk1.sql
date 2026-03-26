alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risikoinventar_fk1
        foreign key ( gef_uid )
            references rk_main.isr_brm_gefaehrdung ( gef_uid )
        enable;


-- sqlcl_snapshot {"hash":"eea6ab51474b8fa68b3d38379ffc93c9ce233fd9","type":"REF_CONSTRAINT","name":"ISR_OAM_RISIKOINVENTAR_FK1","schemaName":"RK_MAIN","sxml":""}