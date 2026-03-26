alter table am_main.hwas_vertrag_produkt
    add constraint fk_hvp_vertrag
        foreign key ( vert_uid_fk )
            references am_main.hwas_vertrag ( vert_uid )
        enable;


-- sqlcl_snapshot {"hash":"7daacc2a7c43f69564f20ed3191580018713a77b","type":"REF_CONSTRAINT","name":"FK_HVP_VERTRAG","schemaName":"AM_MAIN","sxml":""}