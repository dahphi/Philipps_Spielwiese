-- liquibase formatted sql
-- changeset AM_MAIN:1774557120438 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_hwas_prozessstufe_prozesstyp.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hwas_prozessstufe_prozesstyp.sql:null:f07dcfac26aa85c1f13e2e32870044814cbf99e0:create

alter table am_main.hwas_prozessstufe
    add constraint fk_hwas_prozessstufe_prozesstyp
        foreign key ( prz_uid )
            references am_main.hwas_prozesstyp ( prz_uid )
                on delete cascade
        enable;

