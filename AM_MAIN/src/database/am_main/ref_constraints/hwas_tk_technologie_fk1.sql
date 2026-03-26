alter table am_main.hwas_tk_technologie
    add constraint hwas_tk_technologie_fk1
        foreign key ( bip_uid )
            references am_main.hwas_betriebsinterner_prozess ( bip_uid )
        enable;


-- sqlcl_snapshot {"hash":"d19f9745b97867a2b4fb5edf8ab0754668e52aa6","type":"REF_CONSTRAINT","name":"HWAS_TK_TECHNOLOGIE_FK1","schemaName":"AM_MAIN","sxml":""}