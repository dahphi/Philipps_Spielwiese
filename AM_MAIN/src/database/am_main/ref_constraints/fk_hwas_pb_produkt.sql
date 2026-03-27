alter table am_main.hwas_produktbestandteil
    add constraint fk_hwas_pb_produkt
        foreign key ( prod_uid_fk )
            references am_main.hwas_produkt ( prod_uid )
        enable;


-- sqlcl_snapshot {"hash":"df248cbc01cd42f0f9dc99b02005f8ca6420696e","type":"REF_CONSTRAINT","name":"FK_HWAS_PB_PRODUKT","schemaName":"AM_MAIN","sxml":""}