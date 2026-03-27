alter table am_main.hwas_vertragsdetails
    add constraint fk_hvd_prod_bes
        foreign key ( prod_bes_uid_fk )
            references am_main.hwas_produktbestandteil ( prod_bes_uid )
        enable;


-- sqlcl_snapshot {"hash":"f59f943c67c7e1676229c68a8e6e1f6147bdaa3d","type":"REF_CONSTRAINT","name":"FK_HVD_PROD_BES","schemaName":"AM_MAIN","sxml":""}