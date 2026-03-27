alter table am_main.hwas_vertragsdetails
    add constraint fk_hvd_ver_ti
        foreign key ( ver_ti_uid_fk )
            references am_main.hwas_vertrag_titel ( ver_ti_uid )
        enable;


-- sqlcl_snapshot {"hash":"7597e427ffe7eec5f7b92a4e33959c54fbd58d9e","type":"REF_CONSTRAINT","name":"FK_HVD_VER_TI","schemaName":"AM_MAIN","sxml":""}