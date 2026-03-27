alter table am_main.hwas_vertrag
    add constraint fk_hwas_vertrag_geschaeftskunde
        foreign key ( gesku_uid_fk )
            references am_main.hwas_geschaeftskunden ( gesku_uid )
        enable;


-- sqlcl_snapshot {"hash":"1be1eea664256a32059467557c260df7fe1a2f9a","type":"REF_CONSTRAINT","name":"FK_HWAS_VERTRAG_GESCHAEFTSKUNDE","schemaName":"AM_MAIN","sxml":""}