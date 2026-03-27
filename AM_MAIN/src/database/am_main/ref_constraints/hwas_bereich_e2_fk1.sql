alter table am_main.hwas_bereich_e2
    add constraint hwas_bereich_e2_fk1
        foreign key ( kd1_uid )
            references am_main.hwas_krit_dienstlstg_e1 ( kd1_uid )
        enable;


-- sqlcl_snapshot {"hash":"67cf1074200c57cb70a114361314ae1a36bbc1d8","type":"REF_CONSTRAINT","name":"HWAS_BEREICH_E2_FK1","schemaName":"AM_MAIN","sxml":""}