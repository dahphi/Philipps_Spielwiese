alter table am_main.sap_lieferanten_kreditoren_nr
    add constraint fk_sap_liefkred_lie
        foreign key ( lie_uid_fk )
            references am_main.sap_lieferanten ( lie_uid )
        enable;


-- sqlcl_snapshot {"hash":"d7d91b6d49553dfaf7e466166cf725d0f67c49ba","type":"REF_CONSTRAINT","name":"FK_SAP_LIEFKRED_LIE","schemaName":"AM_MAIN","sxml":""}