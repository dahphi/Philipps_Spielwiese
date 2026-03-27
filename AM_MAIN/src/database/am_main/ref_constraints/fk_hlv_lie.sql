alter table am_main.hwas_lieferant_vertragsdetail
    add constraint fk_hlv_lie
        foreign key ( lie_uid_fk )
            references am_main.sap_lieferanten ( lie_uid )
        enable;


-- sqlcl_snapshot {"hash":"888597dad1385cecd91f009990bf92cdc4b2a098","type":"REF_CONSTRAINT","name":"FK_HLV_LIE","schemaName":"AM_MAIN","sxml":""}