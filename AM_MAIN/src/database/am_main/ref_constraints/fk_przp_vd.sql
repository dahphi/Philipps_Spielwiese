alter table am_main.hwas_prozesse_vertragsdetails
    add constraint fk_przp_vd
        foreign key ( vd_uid_fk )
            references am_main.hwas_vertragsdetails ( vd_uid )
        enable;


-- sqlcl_snapshot {"hash":"a97d04c56de9b0b3da340ed786a8930bce86236f","type":"REF_CONSTRAINT","name":"FK_PRZP_VD","schemaName":"AM_MAIN","sxml":""}