alter table am_main.hwas_beauftragungen
    add constraint fk_beauftragungen_dienstleister
        foreign key ( dtl_uid_fk )
            references am_main.hwas_dienstleister ( dtl_uid )
        enable;


-- sqlcl_snapshot {"hash":"fd52dce2792294a5f5c1be436e2b60d17cb5e68c","type":"REF_CONSTRAINT","name":"FK_BEAUFTRAGUNGEN_DIENSTLEISTER","schemaName":"AM_MAIN","sxml":""}