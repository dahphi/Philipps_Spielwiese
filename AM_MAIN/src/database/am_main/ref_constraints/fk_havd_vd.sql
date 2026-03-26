alter table am_main.hwas_asset_vertragsdetails
    add constraint fk_havd_vd
        foreign key ( vd_uid_fk )
            references am_main.hwas_vertragsdetails ( vd_uid )
        enable;


-- sqlcl_snapshot {"hash":"19cd621fc8141ca907dc86442eb103889257a5e5","type":"REF_CONSTRAINT","name":"FK_HAVD_VD","schemaName":"AM_MAIN","sxml":""}