alter table am_main.hwas_lieferant_vertragsdetail
    add constraint fk_hlv_vd
        foreign key ( vd_uid_fk )
            references am_main.hwas_vertragsdetails ( vd_uid )
        enable;


-- sqlcl_snapshot {"hash":"4d836c0f97f5fc79cafc4ea38a3b0f13eb974e41","type":"REF_CONSTRAINT","name":"FK_HLV_VD","schemaName":"AM_MAIN","sxml":""}