alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risikoinventar_fk2
        foreign key ( rkt_uid )
            references rk_main.isr_oam_risikokategorie_oa ( rkt_uid )
        enable;


-- sqlcl_snapshot {"hash":"372667466435dffeb5e009f0813675d8a22b4028","type":"REF_CONSTRAINT","name":"ISR_OAM_RISIKOINVENTAR_FK2","schemaName":"RK_MAIN","sxml":""}