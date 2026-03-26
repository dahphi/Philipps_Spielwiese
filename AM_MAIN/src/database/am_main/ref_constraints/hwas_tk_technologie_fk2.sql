alter table am_main.hwas_tk_technologie
    add constraint hwas_tk_technologie_fk2
        foreign key ( ak3_uid )
            references am_main.hwas_anlagenkategorie_e3 ( ak3_uid )
        enable;


-- sqlcl_snapshot {"hash":"70e347a18de028eee7af8a64816556468c533fc9","type":"REF_CONSTRAINT","name":"HWAS_TK_TECHNOLOGIE_FK2","schemaName":"AM_MAIN","sxml":""}