alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risikoinventar_fk6
        foreign key ( netto2_auw_uid )
            references rk_main.isr_auswirkung ( auw_uid )
        enable;


-- sqlcl_snapshot {"hash":"56df554f42cd36d129dd2d240dc6811237142448","type":"REF_CONSTRAINT","name":"ISR_OAM_RISIKOINVENTAR_FK6","schemaName":"RK_MAIN","sxml":""}