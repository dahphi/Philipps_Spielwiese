alter table roma_main.ftth_preorders_fuzzydouble
    add constraint ftth_preorders_fuzzy_requ_fk
        foreign key ( request_id )
            references roma_main.ftth_fuzzy_requests ( id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"83a907d606a6980c8471e7eeefea7b2851e9d6bc","type":"REF_CONSTRAINT","name":"FTTH_PREORDERS_FUZZY_REQU_FK","schemaName":"ROMA_MAIN","sxml":""}