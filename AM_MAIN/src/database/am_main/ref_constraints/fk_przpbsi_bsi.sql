alter table am_main.hwas_prozesse_bsi_bausteine
    add constraint fk_przpbsi_bsi
        foreign key ( bsi_uid_fk )
            references am_main.bsi_grundschutzbausteine ( bsi_uid )
        enable;


-- sqlcl_snapshot {"hash":"78754d3e81ac1f20a7de9cbb887af1c2f2e68479","type":"REF_CONSTRAINT","name":"FK_PRZPBSI_BSI","schemaName":"AM_MAIN","sxml":""}