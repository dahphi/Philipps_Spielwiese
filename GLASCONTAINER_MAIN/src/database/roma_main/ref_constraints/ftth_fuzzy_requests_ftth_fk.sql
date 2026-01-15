alter table roma_main.ftth_fuzzy_requests
    add constraint ftth_fuzzy_requests_ftth_fk
        foreign key ( ftth_id )
            references roma_main.ftth_ws_sync_preorders ( id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"f289cac56465fb8e9b2de2d5c4756d87cac43f0d","type":"REF_CONSTRAINT","name":"FTTH_FUZZY_REQUESTS_FTTH_FK","schemaName":"ROMA_MAIN","sxml":""}