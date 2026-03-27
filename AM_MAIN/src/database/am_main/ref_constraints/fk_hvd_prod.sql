alter table am_main.hwas_vertragsdetails
    add constraint fk_hvd_prod
        foreign key ( prod_uid_fk )
            references am_main.hwas_produkt ( prod_uid )
        enable;


-- sqlcl_snapshot {"hash":"177697ae4f3e3027668540c27cb92b11b309ad52","type":"REF_CONSTRAINT","name":"FK_HVD_PROD","schemaName":"AM_MAIN","sxml":""}