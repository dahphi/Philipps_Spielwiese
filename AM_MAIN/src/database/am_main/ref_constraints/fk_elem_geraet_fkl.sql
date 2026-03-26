alter table am_main.hwas_elem_geraet
    add constraint fk_elem_geraet_fkl
        foreign key ( fkl_uid )
            references am_main.hwas_funktionsklasse ( fkl_uid )
        enable;


-- sqlcl_snapshot {"hash":"bbc5015b43b6b59ff17cefe2f8dd5a0378b351d1","type":"REF_CONSTRAINT","name":"FK_ELEM_GERAET_FKL","schemaName":"AM_MAIN","sxml":""}