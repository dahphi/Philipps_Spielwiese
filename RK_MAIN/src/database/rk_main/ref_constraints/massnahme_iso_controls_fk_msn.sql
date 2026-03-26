alter table rk_main.isr_massnahme_iso_27001
    add constraint massnahme_iso_controls_fk_msn
        foreign key ( msn_uid )
            references rk_main.isr_oam_massnahme ( msn_uid )
        enable;


-- sqlcl_snapshot {"hash":"450bffd3c9aab29010d13eba98267d9b16dd8eb2","type":"REF_CONSTRAINT","name":"MASSNAHME_ISO_CONTROLS_FK_MSN","schemaName":"RK_MAIN","sxml":""}