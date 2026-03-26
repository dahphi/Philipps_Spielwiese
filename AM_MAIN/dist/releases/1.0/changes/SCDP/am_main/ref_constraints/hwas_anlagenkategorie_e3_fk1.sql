-- liquibase formatted sql
-- changeset AM_MAIN:1774556572347 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/hwas_anlagenkategorie_e3_fk1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_anlagenkategorie_e3_fk1.sql:null:98a923611cda26fcf378154b3cd1bc7acbd86fc0:create

alter table am_main.hwas_anlagenkategorie_e3
    add constraint hwas_anlagenkategorie_e3_fk1
        foreign key ( be2_uid )
            references am_main.hwas_bereich_e2 ( be2_uid )
        enable;

