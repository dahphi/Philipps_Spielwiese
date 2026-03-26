alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risikoinventar_fk7
        foreign key ( ska_uid )
            references rk_main.isr_brm_schwachstellenkat ( ska_uid )
        enable;


-- sqlcl_snapshot {"hash":"47ad96142788145f55ee343b6f14ed7574c6d4b0","type":"REF_CONSTRAINT","name":"ISR_OAM_RISIKOINVENTAR_FK7","schemaName":"RK_MAIN","sxml":""}