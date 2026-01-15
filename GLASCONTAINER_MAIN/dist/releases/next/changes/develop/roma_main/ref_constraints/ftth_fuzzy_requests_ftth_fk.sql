-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480991142 stripComments:false logicalFilePath:develop/roma_main/ref_constraints/ftth_fuzzy_requests_ftth_fk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/ref_constraints/ftth_fuzzy_requests_ftth_fk.sql:null:f289cac56465fb8e9b2de2d5c4756d87cac43f0d:create

alter table roma_main.ftth_fuzzy_requests
    add constraint ftth_fuzzy_requests_ftth_fk
        foreign key ( ftth_id )
            references roma_main.ftth_ws_sync_preorders ( id )
                on delete cascade
        enable;

