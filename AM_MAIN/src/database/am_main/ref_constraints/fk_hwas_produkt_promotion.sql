alter table am_main.hwas_produkt
    add constraint fk_hwas_produkt_promotion
        foreign key ( prom_uid_fk )
            references am_main.hwas_promotion ( prom_uid )
        enable;


-- sqlcl_snapshot {"hash":"9260d5f18c138b3de012e33ec7158ba209e658e7","type":"REF_CONSTRAINT","name":"FK_HWAS_PRODUKT_PROMOTION","schemaName":"AM_MAIN","sxml":""}