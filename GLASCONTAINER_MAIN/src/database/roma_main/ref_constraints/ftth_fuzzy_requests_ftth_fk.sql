alter table ftth_fuzzy_requests
    add constraint ftth_fuzzy_requests_ftth_fk
        foreign key ( ftth_id )
            references ftth_ws_sync_preorders ( id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"57cd2e3945219647bf309ea3ee14cb6f372520fb","type":"REF_CONSTRAINT","name":"FTTH_FUZZY_REQUESTS_FTTH_FK","schemaName":"ROMA_MAIN","sxml":""}