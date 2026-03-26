alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risikoinventar_fk4
        foreign key ( netto2_ews_uid )
            references rk_main.isr_eintrittswahrscheinlichkeit ( ews_uid )
        enable;


-- sqlcl_snapshot {"hash":"1436f31da8157db0553f4079d5547bcfdf8b84ba","type":"REF_CONSTRAINT","name":"ISR_OAM_RISIKOINVENTAR_FK4","schemaName":"RK_MAIN","sxml":""}