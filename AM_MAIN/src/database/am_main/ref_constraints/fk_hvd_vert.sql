alter table am_main.hwas_vertragsdetails
    add constraint fk_hvd_vert
        foreign key ( vert_uid_fk )
            references am_main.hwas_vertrag ( vert_uid )
        enable;


-- sqlcl_snapshot {"hash":"0f3df0e39728b938dd46c14c5be96ed7635813d9","type":"REF_CONSTRAINT","name":"FK_HVD_VERT","schemaName":"AM_MAIN","sxml":""}