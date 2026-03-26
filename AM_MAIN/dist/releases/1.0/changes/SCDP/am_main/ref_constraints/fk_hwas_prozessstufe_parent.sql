-- liquibase formatted sql
-- changeset AM_MAIN:1774556572295 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_hwas_prozessstufe_parent.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hwas_prozessstufe_parent.sql:null:8abfc9b59b7f457169b9566b213bdb1d63760299:create

alter table am_main.hwas_prozessstufe
    add constraint fk_hwas_prozessstufe_parent
        foreign key ( parent_przs_uid )
            references am_main.hwas_prozessstufe ( przs_uid )
                on delete cascade
        enable;

