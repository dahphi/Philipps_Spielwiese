-- liquibase formatted sql
-- changeset AM_MAIN:1774557220987 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_hwas_prozessstufe_prozesstyp.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hwas_prozessstufe_prozesstyp.sql:null:a6a17c2386c46223a2f15f7d2b9dc6491cb0c3fe:create

alter table am_main.hwas_prozessstufe
    add constraint fk_hwas_prozessstufe_prozesstyp
        foreign key ( prz_uid )
            references am_main.hwas_prozesstyp ( prz_uid )
        enable;

