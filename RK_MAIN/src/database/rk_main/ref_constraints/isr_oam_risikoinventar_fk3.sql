alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risikoinventar_fk3
        foreign key ( netto1_ews_uid )
            references rk_main.isr_eintrittswahrscheinlichkeit ( ews_uid )
        enable;


-- sqlcl_snapshot {"hash":"e9c3ca1517f97d538507634c1539a17e1fc72a03","type":"REF_CONSTRAINT","name":"ISR_OAM_RISIKOINVENTAR_FK3","schemaName":"RK_MAIN","sxml":""}