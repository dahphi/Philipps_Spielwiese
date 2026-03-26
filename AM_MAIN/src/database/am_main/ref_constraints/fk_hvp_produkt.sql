alter table am_main.hwas_vertrag_produkt
    add constraint fk_hvp_produkt
        foreign key ( prod_uid_fk )
            references am_main.hwas_produkt ( prod_uid )
        enable;


-- sqlcl_snapshot {"hash":"1b2a0e513a18157beabe5e4c03e59cf7ffefc9c8","type":"REF_CONSTRAINT","name":"FK_HVP_PRODUKT","schemaName":"AM_MAIN","sxml":""}