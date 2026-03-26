alter table rk_main.isr_oam_massnahmenkatalog
    add constraint isr_oam_massnahmenkatalog_fk2
        foreign key ( msn_uid )
            references rk_main.isr_oam_massnahme ( msn_uid )
        enable;


-- sqlcl_snapshot {"hash":"e268ba41a66b01ddabcaebe587ae884fd7dc1b2b","type":"REF_CONSTRAINT","name":"ISR_OAM_MASSNAHMENKATALOG_FK2","schemaName":"RK_MAIN","sxml":""}