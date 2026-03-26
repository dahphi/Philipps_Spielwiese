-- liquibase formatted sql
-- changeset AM_MAIN:1774556572382 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/hwas_geraet_fk3.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_geraet_fk3.sql:null:569780de242901fbd6c41edf71715f555d51a2aa:create

alter table am_main.hwas_geraet
    add constraint hwas_geraet_fk3
        foreign key ( geb_uid )
            references am_main.hwas_gebaeude ( geb_uid )
        enable;

