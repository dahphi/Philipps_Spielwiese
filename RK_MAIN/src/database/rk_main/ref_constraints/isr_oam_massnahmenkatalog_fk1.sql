alter table rk_main.isr_oam_massnahmenkatalog
    add constraint isr_oam_massnahmenkatalog_fk1
        foreign key ( rsk_uid )
            references rk_main.isr_oam_risikoinventar ( rsk_uid )
        enable;


-- sqlcl_snapshot {"hash":"e7f56a991120c514024c978fbaa42dfda9e23fe5","type":"REF_CONSTRAINT","name":"ISR_OAM_MASSNAHMENKATALOG_FK1","schemaName":"RK_MAIN","sxml":""}