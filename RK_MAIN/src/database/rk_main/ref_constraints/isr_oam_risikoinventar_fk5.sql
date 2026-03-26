alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risikoinventar_fk5
        foreign key ( netto1_auw_uid )
            references rk_main.isr_auswirkung ( auw_uid )
        enable;


-- sqlcl_snapshot {"hash":"21066caac720fea94cfcf6146ff8a2bb76133fa9","type":"REF_CONSTRAINT","name":"ISR_OAM_RISIKOINVENTAR_FK5","schemaName":"RK_MAIN","sxml":""}