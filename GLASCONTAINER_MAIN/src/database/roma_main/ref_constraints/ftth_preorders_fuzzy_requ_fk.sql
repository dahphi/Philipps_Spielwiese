alter table ftth_preorders_fuzzydouble
    add constraint ftth_preorders_fuzzy_requ_fk
        foreign key ( request_id )
            references ftth_fuzzy_requests ( id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"cd42cd55fb1207db51cbf1a1778d466e0e85b6f5","type":"REF_CONSTRAINT","name":"FTTH_PREORDERS_FUZZY_REQU_FK","schemaName":"ROMA_MAIN","sxml":""}