alter table am_main.hwas_tk_technologie
    add constraint hwas_tk_technologie_fk3
        foreign key ( krk_uid )
            references am_main.hwas_kritikalitaet ( krk_uid )
        enable;


-- sqlcl_snapshot {"hash":"49f6774eee1a7da790e8e573f509d5cad7dc61ac","type":"REF_CONSTRAINT","name":"HWAS_TK_TECHNOLOGIE_FK3","schemaName":"AM_MAIN","sxml":""}