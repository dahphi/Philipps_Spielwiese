alter table rk_main.asm_isr_assets_risiken
    add constraint asm_isr_assets_risken_fk2
        foreign key ( rsk_uid )
            references rk_main.isr_oam_risikoinventar ( rsk_uid )
        enable;


-- sqlcl_snapshot {"hash":"b134f6d67445f140c1cde853637bfd0c40199243","type":"REF_CONSTRAINT","name":"ASM_ISR_ASSETS_RISKEN_FK2","schemaName":"RK_MAIN","sxml":""}