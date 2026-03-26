alter table am_main.hwas_vertrag_titel
    add constraint fk_hwas_vertrag_titel_vert
        foreign key ( vert_uid_fk )
            references am_main.hwas_vertrag ( vert_uid )
        enable;


-- sqlcl_snapshot {"hash":"8ccc3eb3a33f42872de16fd5ab17a558e9e2b95e","type":"REF_CONSTRAINT","name":"FK_HWAS_VERTRAG_TITEL_VERT","schemaName":"AM_MAIN","sxml":""}