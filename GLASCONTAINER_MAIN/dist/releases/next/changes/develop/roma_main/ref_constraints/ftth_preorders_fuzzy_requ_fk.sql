-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480991164 stripComments:false logicalFilePath:develop/roma_main/ref_constraints/ftth_preorders_fuzzy_requ_fk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/ref_constraints/ftth_preorders_fuzzy_requ_fk.sql:null:83a907d606a6980c8471e7eeefea7b2851e9d6bc:create

alter table roma_main.ftth_preorders_fuzzydouble
    add constraint ftth_preorders_fuzzy_requ_fk
        foreign key ( request_id )
            references roma_main.ftth_fuzzy_requests ( id )
                on delete cascade
        enable;

