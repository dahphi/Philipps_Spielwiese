-- liquibase formatted sql
-- changeset AM_MAIN:1774556572370 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/hwas_geraet_fk1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_geraet_fk1.sql:null:c1525e46fb04071a44dad9f9b2277fef75672873:create

alter table am_main.hwas_geraet
    add constraint hwas_geraet_fk1
        foreign key ( mdl_uid )
            references am_main.hwas_modell ( mdl_uid )
        enable;

