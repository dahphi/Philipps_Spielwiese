alter table am_main.hwas_virtuelle_maschinen
    add constraint hwas_virtuelle_maschinen_fk1
        foreign key ( nzone_uid )
            references am_main.hwas_netzwerkzone ( nzone_uid )
        enable;


-- sqlcl_snapshot {"hash":"e2447d68c7746f1b6fdcb53cbabd39fb7565dd58","type":"REF_CONSTRAINT","name":"HWAS_VIRTUELLE_MASCHINEN_FK1","schemaName":"AM_MAIN","sxml":""}